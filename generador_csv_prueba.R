# ===============================
# Generar CSV de prueba para Volcano Plot
# ===============================

# Semilla para reproducibilidad
set.seed(123)

# Número de genes
n <- 100

# Nombres de genes
genes <- paste0("Gene", sprintf("%03d", 1:n))

# Simular log2 fold change (centrado en 0, sd=2)
log2FC <- rnorm(n, mean = 0, sd = 2)

# Simular p-values
pvalue <- runif(n, min = 0, max = 1)

# Hacer algunos genes muy significativos
pvalue[sample(1:n, 10)] <- runif(10, min = 0, max = 0.0001)

# Crear data frame
df <- data.frame(
  gene = genes,
  log2FC = log2FC,
  pvalue = pvalue
)

# Ruta donde guardar el CSV, cambia la ruta a tu ruta propia
ruta <- "C:/Users/Chiva/Dropbox/PC/Desktop/Colegio/Aplicaciones Web 2025-26/FTC/volcano/volcano_100genes_test.csv"

# Guardar CSV
write.csv(df, ruta, row.names = FALSE)

# Mensaje de confirmación
cat("Archivo CSV generado en:\n", ruta, "\n")

