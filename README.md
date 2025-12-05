# Shiny App – Volcano Plot Interactivo (Bioinformática)

![R Shiny](https://img.shields.io/badge/R-Shiny-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/version-3.2-brightgreen)

---

## 📖 Descripción

Aplicación **interactiva desarrollada en R Shiny** para generar **Volcano Plots** a partir de **resultados de análisis diferencial** (por ejemplo, RNA-seq, proteómica o cualquier tipo de datos ómicos tabulares).

Permite explorar los genes significativos, ajustar los thresholds de log2 fold change y p-value, elegir paletas de colores, mostrar etiquetas de genes y exportar figuras de alta resolución para publicaciones científicas.

---

## ⚙️ Funcionalidades

- 📂 Carga de archivos `.csv` con columnas `gene`, `log2FC` y `pvalue`.
- 📊 Visualización interactiva con `plotly`.
- ⚖️ Ajuste de thresholds: |log2FC| mínimo y p-value máximo.
- 🏷️ Mostrar u ocultar etiquetas de genes significativos.
- 🎨 Selección de paleta de colores (Sunset, Viridis, Magma, Pastel).
- 💾 Descarga de gráficos en **PNG**, **JPG** o **PDF**.
- 🔍 Tabla interactiva de genes significativos con `DT`.

---

## 🧩 Estructura del proyecto
volcano_app_r/
│
├── app.R # Código principal de la app
├── example_volcano.csv # Datos de prueba para Volcano Plot
└── README.md # Descripción del proyecto


---

## 🚀 Ejecución

### 1️⃣ Instala los paquetes necesarios:

```r
install.packages(c("shiny", "ggplot2", "plotly", "DT", "bslib", "shinycssloaders"))

```

### 2️⃣ Ejecuta la app:

Ejecuta la app:

```r
shiny::runApp("app.R")
```

### 3️⃣ Uso

Sube el archivo de ejemplo example_volcano.csv.

Ajusta los thresholds de log2FC y p-value.

Explora el Volcano Plot interactivo y la tabla de genes significativos.

Descarga tus gráficos en el formato deseado.

---

## 🧠 Datos de ejemplo

Incluye un archivo example_volcano.csv con 100 genes, log2 fold changes y p-values simulados para mostrar la funcionalidad de la app.

---

 ## 👤 Autor

Desarrollado por Oriol Chiva Hidalgo

## 📧 Contacto
oriolchiva8@gmail.com / oriol.chiva.hidalgo@gmail.com

© 2025 – Proyecto educativo y de investigación bajo licencia MIT
