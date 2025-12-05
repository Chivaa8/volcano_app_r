# Volcano App - R Shiny

**Autor:** Oriol Chiva Hidalgo 
**Versión:** 3.2  
**Licencia:** MIT  

## Descripción

Esta aplicación permite explorar y visualizar resultados de análisis diferencial mediante **Volcano Plot interactivo**.  
Ideal para datos de transcriptómica, proteómica o cualquier tipo de datos ómicos tabulares.

## Características

- Subida de tabla `.csv` con columnas `log2FC` y `pvalue`.
- Visualización interactiva del Volcano Plot usando **Plotly**.
- Resaltar genes significativos según umbrales de log2FC y p-value.
- Descargar gráficos en PNG, JPG y PDF.
- Tabla de genes significativos.
- Pestaña "Acerca de" con información de la app.

## Uso

1. Ejecuta la aplicación en RStudio con:

```r
shiny::runApp("ruta/a/tu/carpeta/volcano")
