# ==============================================================================
# SCRIPT: 2_analisis_densidad_estructura_dialogos.R
# DESCRIPCIÓN: Paso 2. Análisis estructural macro y diseño de cartografía visual.
#              Genera las 4 grandes gráficas analíticas para la memoria.
# ENTRADA: incisos_corin_tellado.tsv (Generado automáticamente por el Script 1)
# REQUISITOS: Librería 'tidyverse' instalada.
# ==============================================================================

library(tidyverse)

# 1. CARGA DEL CORPUS CRUDO Y VERIFICACIÓN DE CONTROL
# ------------------------------------------------------------------------------
archivo_entrada <- "incisos_corin_tellado.tsv"

if(!file.exists(archivo_entrada)) {
  stop(paste("Error crítico: No se encuentra la base de datos base. Ejecuta primero el Script 1 para generar:", archivo_entrada))
}

print("=== INICIANDO PASO 2: Cargando corpus y calculando métricas macro ===")
corpus_raw <- read_tsv(archivo_entrada, show_col_types = FALSE)

# Procesamos las métricas generales por novela utilizando tus columnas reales
metricas_novelas <- corpus_raw %>%
  group_by(codigo, anio) %>%
  summarise(
    # Extensión aproximada de las acotaciones (columna 'inciso')
    extension_obra_char = sum(str_length(inciso), na.rm = TRUE),
    # Número total de diálogos/intervenciones registradas en la obra
    total_dialogos = n(),
    # Densidad rítmica: intervenciones por unidad de extensión
    densidad_dialogos = total_dialogos / (extension_obra_char / 10000),
    .groups = "drop"
  )


# ==============================================================================
# 📊 GRÁFICA 1: Evolución del volumen de diálogos (Scatter Plot + Ajuste LOESS)
# ------------------------------------------------------------------------------
print("Generando Gráfica 1: Tendencia diacrónica global de los diálogos...")

grafica_loess <- ggplot(metricas_novelas, aes(x = anio, y = total_dialogos)) +
  geom_point(alpha = 0.4, color = "steelblue", size = 2) +
  geom_smooth(method = "loess", color = "darkred", se = TRUE, linewidth = 1.2) + # Corrección moderna de grosor
  theme_minimal() +
  labs(
    title = "Evolución diacrónica del volumen de diálogos",
    subtitle = "Tendencia calculada mediante ajuste local (LOESS)",
    x = "Año de publicación",
    y = "Número total de intervenciones por novela"
  ) +
  theme(plot.title = element_text(face = "bold", size = 14)) # Corrección de tamaño tipográfico (size)

ggsave("01_evolucion_dialogos_loess.png", grafica_loess, width = 8, height = 5, dpi = 300)


# ==============================================================================
# 📊 GRÁFICA 2: Distribución del Tipo de Incisos (¡CURVAS DE DENSIDAD ORIGINALES!)
# ------------------------------------------------------------------------------
print("Generando Gráfica 2: Curvas de densidad de tipos de incisos (Montañitas)...")

# 1. Calculamos el % de uso de cada tipo de inciso DENTRO de cada novela autónoma
distribucion_por_novela <- corpus_raw %>%
  filter(!is.na(tipo_parrafo)) %>%
  group_by(codigo, tipo_parrafo) %>%
  tally(name = "conteo") %>%
  group_by(codigo) %>%
  mutate(porcentaje_uso = (conteo / sum(conteo)) * 100) %>%
  ungroup()

# 2. Renderizamos el gráfico de densidad global (geom_density) idéntico a tu FIG_8300
grafica_tipos <- ggplot(distribucion_por_novela, aes(x = porcentaje_uso, fill = tipo_parrafo)) +
  geom_density(alpha = 0.6, color = "black", linewidth = 0.8) +
  scale_fill_brewer(palette = "Set1") + 
  theme_minimal() +
  labs(
    title = "Distribución del Tipo de Incisos en el Corpus",
    x = "% de uso dentro de los diálogos de cada novela",
    y = "Densidad de novelas",
    fill = "Tipo de Inciso"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "right",
    panel.grid.minor = element_blank()
  )

ggsave("02_densidad_tipos_incisos.png", grafica_tipos, width = 8, height = 5, dpi = 300)


# ==============================================================================
# 📊 GRÁFICA 3: Análisis de Burbujas (Constelación Verde Foresta Corregida)
# ------------------------------------------------------------------------------
print("Generando Gráfica 3: Renderizando constelación de burbujas real...")

# 1. Calculamos las métricas basándonos en las columnas estructurales nativas
metricas_burbujas <- corpus_raw %>%
  mutate(
    # Medimos la extensión real sumando palabras sobre el texto completo ('original')
    palabras_parrafo = str_count(original, "\\S+")
  ) %>%
  group_by(codigo) %>%
  summarise(
    # Tamaño total acumulado de las secciones dialogadas por obra
    total_palabras_novela = sum(palabras_parrafo, na.rm = TRUE),
    # Detección matemática robusta de párrafos múltiples mediante contador numérico
    parrafos_multiples = sum(num_inciso > 1, na.rm = TRUE),
    # Volumen absoluto de réplicas
    total_dialogos = n(),
    .groups = "drop"
  ) %>%
  # Estandarizamos el ritmo dinámico en base a la escala filológica (cada 10.000 palabras)
  mutate(densidad_por_10k = (total_dialogos / total_palabras_novela) * 10000)

# 2. Pintamos el gráfico permitiendo auto-ajuste de escalas orgánicas sin recortes
grafica_burbujas <- ggplot(metricas_burbujas, aes(x = total_palabras_novela, y = densidad_por_10k)) +
  # Puntos con tu verde foresta original (#4A7c59), transparencia y tamaño dinámico real
  geom_point(aes(size = parrafos_multiples), color = "#4A7c59", alpha = 0.5) + 
  # Forzamos que la leyenda muestre los saltos lógicos (0, 10, 20, 30) escalando bien las burbujas
  scale_size_continuous(range = c(1.5, 7), name = "Cantidad de Párrafos Múltiples") +
  theme_minimal() +
  labs(
    title = "Densidad de Diálogos según la Extensión de la Obra",
    x = "Tamaño total de la novela (palabras en párrafos con diálogo)",
    y = "Número de diálogos por cada 10,000 palabras"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "right",
    panel.grid.minor = element_blank()
  )

ggsave("03_analisis_burbujas_extension.png", grafica_burbujas, width = 9, height = 6, dpi = 300)


# ==============================================================================
# 📊 GRÁFICA 4: El Tempo Dramático Telladiano (Línea de Puntos LOESS de fondo)
# ------------------------------------------------------------------------------
print("Generando Gráfica 4: Análisis del tempo dramático diacrónico...")

tempo_dramatico_anual <- corpus_raw %>%
  filter(anio >= 1947 & anio <= 1990) %>%
  # Reconstruimos la longitud de intervención pegando las mitades de habla de los personajes
  mutate(discurso_personaje = paste(coalesce(dicho_antes, ""), coalesce(dicho_despues, ""))) %>%
  filter(str_length(str_squish(discurso_personaje)) > 0) %>%
  mutate(palabras_por_intervencion = str_count(discurso_personaje, "\\S+")) %>%
  group_by(anio) %>%
  summarise(
    promedio_palabras = mean(palabras_por_intervencion, na.rm = TRUE),
    .groups = "drop"
  )

grafica_tempo <- ggplot(tempo_dramatico_anual, aes(x = anio, y = promedio_palabras)) +
  geom_line(color = "darkred", linewidth = 1, alpha = 0.7) +                  # Línea de promedio continuo
  geom_point(color = "darkred", size = 2, alpha = 0.8) +                     # Puntos de año puntual
  geom_smooth(method = "loess", color = "black", linetype = "dashed",        # Tu magnífica línea de tendencia
              se = FALSE, linewidth = 0.8) + 
  theme_minimal() +
  scale_x_continuous(breaks = seq(1947, 1990, by = 5)) +
  labs(
    title = "Evolución diacrónica del tempo dramático telladiano",
    subtitle = "Promedio anual de palabras por intervención en el discurso de los personajes (1947-1990)",
    x = "Año de publicación",
    y = "Promedio de palabras por intervención"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
    plot.subtitle = element_text(size = 10, face = "italic", hjust = 0.5)
  )

ggsave("04_tempo_dramatico_telladiano.png", grafica_tempo, width = 9, height = 5, dpi = 300)

print("=========================================================================")
print("=== ¡PASO 2 COMPLETADO! Las 4 gráficas definitivas ya están en tu carpeta ===")
print("=========================================================================")