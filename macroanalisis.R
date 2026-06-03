# ==============================================================================
# SCRIPT: 1_extraccion_gramatical_base.R
# DESCRIPCIÓN: Fase 1. Segmentación algorítmica de diálogos e incisos del narrador.
#              Genera simultáneamente la Matriz A (análisis estructural) y la
#              Matriz B (preparación para etiquetado POS Tagging).
# OBJETO DE ESTUDIO: Novela popular seriada (Corpus: Corín Tellado).
# ==============================================================================

# ------------------------------------------------------------------------------
# 0. CONTROL DE ENTORNO Y REQUISITOS PREVIOS
# ------------------------------------------------------------------------------
library(tidyverse)
library(stringr)
library(fs)

# CONFIGURACIÓN: Carpeta que contiene los archivos de texto plano (.txt)
ruta_corpus <- "./corpus" 

if (!dir_exists(ruta_corpus)) {
  stop(paste("Error: No se encuentra la carpeta de origen:", ruta_corpus))
}

# ------------------------------------------------------------------------------
# 1. LECTURA MASIVA Y EXTRACCIÓN DE METADATOS DIACRÓNICOS
# ------------------------------------------------------------------------------
print("Iniciando la lectura masiva de ficheros planos...")

corpus_raw <- dir_info(ruta_corpus, glob = "*.txt") %>%
  select(path) %>%
  mutate(
    nombre_archivo = path_file(path),
    # Forzamos codificación UTF-8 para proteger caracteres especiales y tildes
    parrafo = map(path, read_lines, locale = locale(encoding = "UTF-8"))
  ) %>%
  unnest(parrafo) %>%
  mutate(parrafo = str_trim(parrafo)) %>%
  filter(parrafo != "") %>%
  
  # MINERÍA DE METADATOS: Trazabilidad cronológica a través del nombre del archivo
  mutate(
    anio      = as.numeric(str_extract(nombre_archivo, "^\\d{4}")),
    id_novela = str_extract(nombre_archivo, "(?<=_)[A-Z0-9]+(?=_)")
  ) %>%
  select(anio, id_novela, parrafo)

print(paste("Lectura completada.", nrow(corpus_raw), "párrafos importados."))

# ------------------------------------------------------------------------------
# 2. PARSEO TIPOGRÁFICO Y TAXONOMÍA ESTRUCTURAL DEL DIÁLOGO
# ------------------------------------------------------------------------------
corpus_segmentado <- corpus_raw %>%
  # Estandarizamos variantes tipográficas convirtiéndolas en rayas de diálogo oficiales
  mutate(parrafo = str_replace_all(parrafo, "^[-–-]", "—")) %>%
  
  # Clasificación metodológica según el comportamiento de la raya
  mutate(
    tipo_inciso = case_when(
      str_detect(parrafo, "^—") & str_count(parrafo, "—") == 1 ~ "Sin inciso",
      str_detect(parrafo, "^—") & str_count(parrafo, "—") == 2 & str_detect(parrafo, "—$") ~ "Inciso final",
      str_detect(parrafo, "^—") & str_count(parrafo, "—") == 2 & !str_detect(parrafo, "—$") ~ "Inciso medial",
      str_count(parrafo, "—") > 2 ~ "Inciso múltiple",
      TRUE ~ "Otros/No dialogal"
    )
  ) %>%
  filter(tipo_inciso != "Otros/No dialogal")

# ------------------------------------------------------------------------------
# 3. ALGORITMO DE SEGMENTACIÓN QUIRÚRGICA (MÍMESIS VS. DIÉGESIS)
# ------------------------------------------------------------------------------
extraer_fragmentos <- function(texto, tipo = "habla") {
  partes <- str_split(texto, "—")[[1]]
  partes <- partes[str_trim(partes) != ""]
  
  if (length(partes) == 0) return(character(0))
  
  if (tipo == "habla") {
    # Secuencia impar: Voces de los personajes (posiciones 1, 3, 5...)
    return(partes[seq(1, length(partes), by = 2)])
  } else {
    # Secuencia par: Voz del narrador / Acotación (posiciones 2, 4, 6...)
    if (length(partes) < 2) return(character(0))
    return(partes[seq(2, length(partes), by = 2)])
  }
}

corpus_listas <- corpus_segmentado %>%
  rowwise() %>%
  mutate(
    lista_habla   = list(extraer_fragmentos(parrafo, "habla")),
    lista_incisos = list(extraer_fragmentos(parrafo, "inciso"))
  ) %>%
  ungroup()

# ------------------------------------------------------------------------------
# 4. EXPORTACIÓN MATRIZ A: Para Gráficos Estructurales (Formato Vertical)
# ------------------------------------------------------------------------------
print("Generando Matriz A: 'incisos_corin_tellado.tsv' para análisis macro...")

incisos_corin_tellado <- corpus_listas %>%
  rowwise() %>%
  mutate(
    partes = list(str_split(parrafo, "—")[[1]]),
    original = parrafo,
    # Aislamos las secciones básicas manteniendo compatibilidad con el Script 02
    inciso = ifelse(length(partes) >= 2, str_trim(partes[2]), NA_character_),
    dicho_antes = ifelse(length(partes) >= 1, str_trim(partes[1]), NA_character_),
    dicho_despues = ifelse(length(partes) >= 3, str_trim(partes[3]), NA_character_),
    num_inciso = str_count(parrafo, "—")
  ) %>%
  ungroup() %>%
  mutate(
    archivo = id_novela,
    codigo = id_novela,
    tipo_parrafo = tipo_inciso
  ) %>%
  select(archivo, anio, codigo, id_novela, tipo_parrafo, num_inciso, original, dicho_antes, inciso, dicho_despues)

# Guardamos el archivo para el script de las gráficas (53,9 MB esperado)
write_tsv(incisos_corin_tellado, "incisos_corin_tellado.tsv")

# ------------------------------------------------------------------------------
# 5. EXPORTACIÓN MATRIZ B: Para Etiquetado NLP / UDpipe (Formato Horizontal)
# ------------------------------------------------------------------------------
print("Generando Matriz B: 'tabla_preparada_pos_tagging.tsv' para análisis micro...")

max_habla   <- max(lengths(corpus_listas$lista_habla))
max_incisos <- max(lengths(corpus_listas$lista_incisos))

# Expandimos horizontalmente el habla de los personajes
df_habla <- corpus_listas$lista_habla %>% 
  map(~ c(.x, rep(NA, max_habla - length(.x)))) %>% 
  do.call(rbind, .) %>% 
  as_tibble(.name_repair = "minimal")
names(df_habla) <- paste0("texto_habla_", 1:max_habla)

# Expandimos horizontalmente los incisos del narrador
df_incisos <- corpus_listas$lista_incisos %>% 
  map(~ c(.x, rep(NA, max_incisos - length(.x)))) %>% 
  do.call(rbind, .) %>% 
  as_tibble(.name_repair = "minimal")
names(df_incisos) <- paste0("texto_inciso_", 1:max_incisos)

# Consolidamos la tabla final expandida
tabla_gramatical_final <- corpus_listas %>%
  select(anio, id_novela, tipo_inciso) %>% 
  bind_cols(df_habla, df_incisos)

# Guardamos el archivo para el script de anotación morfológica (92,1 MB esperado)
write_tsv(tabla_gramatical_final, "tabla_preparada_pos_tagging.tsv")

print("=========================================================================")
print("=== ¡ÉXITO ROTUNDO! Los dos archivos base se han salvado correctamente ===")
print("=========================================================================")