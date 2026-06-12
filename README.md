[![DOI](https://zenodo.org/badge/latestdoi/20671293)](https://doi.org/10.5281/zenodo.20671293)


# FOLLETIN
Material adicional de *Estilometría y cultura de masas: análisis de la obra de Corín Tellado desde las Humanidades Digitales*


Este repositorio contiene el aparato empírico y el entorno metodológico automatizado desarrollado para el análisis diacrónico de estructuras dialogales en prosa de las novelas de Corín Tellado que se expone en el artículo «Estilometría y cultura de masas: análisis de la obra de Corín Tellado desde las Humanidades Digitales», *Anuari de Filologia. Estudis de Lingüística*, 16 (2026). Diseñado bajo principios de ciencia abierta y replicabilidad, este paquete de scripts en R permite aislar de forma cuantitativa la mímesis (el habla del personaje) de la diégesis (la acotación del narrador) y generar visualizaciones del tempo dramático y densidad rítmica del relato.

Este repositorio también incluye la relación provisional de novelas de Corín Tellado identificadas para este estudio. Se trata de una tabla `tsv` titulada `tellado_corpus.txt` en el que se recogen cronológicamente las novelas de Corín Tellado. La tercera columna indica si el texto fue incorporado al corpus estilométrico utilizado en los análisis descritos en el artículo de referencia.

## ⚠️ ADVERTENCIA DE USO: Adaptación del Corpus

Este entorno de software **fue concebido y parametrizado originalmente para el análisis del "Corpus Corín Tellado"** (un ecosistema de 627 novelas seriadas). 

Por motivos de propiedad intelectual y restricciones vigentes de derechos de autor (Copyright), los textos originales de la autora no se pueden hacer públicos. En su lugar, y con el fin de demostrar la viabilidad técnica y replicabilidad del flujo de trabajo (*pipeline*), se han incluido en la carpeta `corpus/` cuatro obras de dominio público de Benito Pérez Galdós (*Episodios Nacionales*) adaptadas a la nomenclatura requerida.

> 📌 **Nota para investigadores:** Si desea aplicar esta metodología en su propio objeto de estudio, recuerde revisar los comentarios internos de los scripts `macroanalisis.R` y `microanalisis.R` para sustituir las cadenas de texto, títulos de gráficas y variables de salida (como el nombre por defecto del archivo unificado `incisos_corin_tellado.tsv`) por las etiquetas correspondientes a su propio corpus de investigación.

---

## 📁 Estructura del Repositorio

El espacio de trabajo de este análisis se organiza de la siguiente manera:

```text
📁 FOLLETIN/
│
├── 📁 corpus/                             <-- Carpeta de entrada de textos planos (UTF-8)
│     ├── 📄 1873_NP0001_Trafalgar.txt     <-- Estructura obligatoria: aaaa_ID_titulo.txt
│     ├── 📄 1874_NP0002_Napoleon-en-Chamartin.txt
│     ├── 📄 1875_NP0003_La-Batalla-de-los-Arapiles.txt
│     └── 📄 1876_NP0004_La-Segunda-Casaca.txt
│
├── 📜 macroanalisis.R                     <-- Script 1: Lectura masiva, metadatos y extracción básica
└── 📜 microanalisis.R                     <-- Script 2: Segmentación sintáctica y generación de gráficas
```
## ✍️ Cómo citar / Citation

Si utiliza estos scripts, el diseño metodológico o el modelo de segmentación en su propia investigación, le agradecemos que cite tanto el artículo de fondo como el software alojado en este repositorio:

### 1. Referencia del artículo principal (Metodología y resultados)
> **Fradejas Rueda, José Manuel. (2026).** «Estilometría y cultura de masas: análisis de la obra de Corín Tellado desde las Humanidades Digitales». *Anuari De Filologia. Estudis De Lingüística*, *16, pp. xx-xx. https://doi.org/[Insertar_DOI_del_artículo]

### 2. Referencia del software y entorno computacional (Zenodo/GitHub)
> **Fradejas Rueda, [JM]. (2026). **Material adicional de *Estilometría y cultura de masas: análisis de la obra de Corín Tellado desde las Humanidades Digitales* (Versión 1.0.0) [Software]. Zenodo. https://doi.org/[Insertar_DOI_de_Zenodo]

---
