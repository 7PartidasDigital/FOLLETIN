# FOLLETIN
*Laboratorio de Estilística Computacional: Entorno automatizado para la segmentación sintáctica de estructuras dialogales en prosa hispánica*


Este repositorio contiene el aparato empírico y el entorno metodológico automatizado desarrollado para el análisis diacrónico de estructuras dialogales en prosa hispánica. Diseñado bajo principios de ciencia abierta y replicabilidad, este paquete de scripts en R permite aislar de forma cuantitativa la mímesis (el habla del personaje) de la diégesis (la acotación del narrador) y generar visualizaciones del tempo dramático y densidad rítmica del relato.

## ⚠️ ADVERTENCIA DE USO: Adaptación del Corpus

Este entorno de software **fue concebido y parametrizado originalmente para el análisis del "Corpus Corín Tellado"** (un ecosistema de 627 novelas seriadas). 

Por motivos de propiedad intelectual y restricciones vigentes de derechos de autor (Copyright), los textos originales de la autora no se pueden hacer públicos. En su lugar, y con el fin de demostrar la viabilidad técnica y replicabilidad del pipeline, se han incluido en la carpeta `corpus/` cuatro obras de dominio público de Benito Pérez Galdós (*Episodios Nacionales*) adaptadas a la nomenclatura requerida.

> 📌 **Nota para investigadores:** Si desea aplicar esta metodología en su propio objeto de estudio, recuerde revisar los comentarios internos de los scripts `macroanalisis.R` y `microanalisis.R` para sustituir las cadenas de texto, títulos de gráficas y variables de salida (como el nombre por defecto del archivo unificado `incisos_corin_tellado.tsv`) por las etiquetas correspondientes a su propio corpus de investigación.

---

## 📁 Estructura del Repositorio

De acuerdo con la arquitectura del laboratorio (véase `Captura de pantalla 2026-06-03 a las 11.17.53.png`), el espacio de trabajo se organiza de la siguiente manera:

```text
📁 Proyecto_Estilistica/
│
├── 📁 corpus/                                 <-- Carpeta de entrada de textos planos (UTF-8)
│     ├── 📄 1873_NP0001_Trafalgar.txt          <-- Estructura obligatoria: aaaa_ID_titulo.txt
│     ├── 📄 1874_NP0002_Napoleon-en-Chamartin.txt
│     ├── 📄 1875_NP0003_La-Batalla-de-los-Arapiles.txt
│     └── 📄 1876_NP0004_La-Segunda-Casaca.txt
│
├── 📜 macroanalisis.R                         <-- Script 1: Lectura masiva, metadatos y extracción basal
└── 📜 microanalisis.R                         <-- Script 2: Segmentación sintáctica y generación de gráficas

## ✍️ Cómo citar / Citation

Si utiliza estos scripts, el diseño metodológico o el modelo de segmentación en su propia investigación, le agradecemos que cite tanto el artículo de fondo como el software alojado en este repositorio:

### 1. Referencia del artículo principal (Metodología y resultados)
> **Fradejas Rueda, [JM]. (2026).** La mecanización del folletín: Análisis macroestructural y tempo dramático en el corpus de novela popular de Corín Tellado. *[Nombre de la Revista]*, *[Volumen]*(Número), pp. xx-xx. https://doi.org/[Insertar_DOI_del_artículo]

### 2. Referencia del software y entorno computacional (Zenodo/GitHub)
> **Fradejas Rueda, [JM]. (2026).** *Laboratorio de Estilística Computacional: Entorno automatizado para la segmentación sintáctica de estructuras dialogales en prosa hispánica* (Versión 1.0.0) [Software]. Zenodo. https://doi.org/[Insertar_DOI_de_Zenodo]

---