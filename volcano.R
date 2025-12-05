library(shiny)
library(ggplot2)
library(plotly)
library(DT)
library(bslib)
library(shinycssloaders)

# =======================
# VOLCANO
# =======================
sunset_theme <- bs_theme(
  version = 5,
  bg = "#FFF4E6",           # crema cálido
  fg = "#5A3E36",           # marrón suave
  primary = "#FF8A5B",      # naranja suave
  secondary = "#FFB199",    # rosado coral
  base_font = font_google("Nunito"),
  heading_font = font_google("Lora")
)

# =======================
# UI
# =======================
ui <- fluidPage(
  theme = sunset_theme,
  
  titlePanel(
    div(style="display:flex; align-items:center; gap:10px;",
        tags$span("Volcano Plot Explorer")
    )
  ),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("archivo", "📂 Sube tu tabla (.CSV):", accept = ".csv"),
      hr(),
      sliderInput("lfc_cutoff", "|Log2FC| mínimo:", min = 0, max = 5, value = 1, step = 0.1),
      sliderInput("p_cutoff", "P-value máximo:", min = 0, max = 0.1, value = 0.05, step = 0.001),
      checkboxInput("mostrar_labels", "Mostrar etiquetas de genes significativos", FALSE),
      selectInput("palette", "🎨 Paleta de colores",
                  choices = c("Sunset"="sunset",
                              "Viridis"="viridis",
                              "Magma"="magma",
                              "Pastel"="pastel")),
      hr(),
      downloadButton("descargar_png", "💾 Descargar PNG"),
      downloadButton("descargar_jpg", "🖼 Descargar JPG"),
      downloadButton("descargar_pdf", "📄 Descargar PDF"),
      width = 3
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Volcano Plot",
                 br(),
                 withSpinner(plotlyOutput("volcano", height = "650px"))
        ),
        
        tabPanel("Genes Significativos",
                 br(),
                 DTOutput("tabla_sig")
        ),
        
        tabPanel("Acerca de",
                 br(),
                 HTML("<h4>🧬 Acerca de esta app</h4>
                      <p>Esta aplicación permite explorar y visualizar resultados de análisis diferencial 
                      mediante Volcano Plot interactivo. Es ideal para transcriptómica, proteómica o cualquier tipo de datos ómicos tabulares.</p>
                      <p><b>Autor original:</b> Oriol Chiva Hidalgo<br>
                      <b>Versión modificada:</b> 3.2<br>
                      <b>Licencia:</b> MIT</p>")
        )
      )
    )
  )
)

# =======================
# SERVER
# =======================
server <- function(input, output, session){
  
  # ================== CARGA DATOS ======================
  df_reactive <- reactive({
    req(input$archivo)
    
    df <- read.csv(input$archivo$datapath)
    
    validate(
      need("log2FC" %in% colnames(df), "⚠ Falta columna 'log2FC'"),
      need("pvalue" %in% colnames(df), "⚠ Falta columna 'pvalue'")
    )
    
    if(!"gene" %in% colnames(df)){
      df$gene <- paste0("Gene_", seq_len(nrow(df)))
    }
    
    df$negLogP <- -log10(df$pvalue)
    df
  })
  
  # ================== PALETAS ===========================
  paleta_volcano <- function(name){
    switch(name,
           "sunset" = c("DOWN"="#5B8FF9", "NS"="#CFC7C3", "UP"="#FF6F61"),
           "viridis" = c("DOWN"="#21918c", "NS"="#bdbdbd", "UP"="#440154"),
           "magma" = c("DOWN"="#FCFDBF", "NS"="#BDBDBD", "UP"="#B52103"),
           "pastel" = c("DOWN"="#7FB3D5", "NS"="#EAECEE", "UP"="#F1948A")
    )
  }
  
  # ================== VOLCANO ===========================
  output$volcano <- renderPlotly({
    
    df <- df_reactive()
    
    # Clasificación
    df$regulation <- "NS"
    df$regulation[df$log2FC >= input$lfc_cutoff & df$pvalue <= input$p_cutoff] <- "UP"
    df$regulation[df$log2FC <= -input$lfc_cutoff & df$pvalue <= input$p_cutoff] <- "DOWN"
    
    # Etiquetas opcionales
    df$label <- ifelse(df$regulation != "NS" & input$mostrar_labels, df$gene, "")
    
    colors <- paleta_volcano(input$palette)
    
    p <- ggplot(df, aes(x = log2FC, y = negLogP,
                        color = regulation, text = paste("GENE:", gene))) +
      geom_point(alpha = 0.8, size = 2.5) +
      scale_color_manual(values = colors) +
      geom_hline(yintercept = -log10(input$p_cutoff), linetype="dashed", color="#5A3E36") +
      geom_vline(xintercept = c(-input$lfc_cutoff, input$lfc_cutoff), linetype="dashed", color="#5A3E36") +
      labs(title = "Volcano Plot Interactivo",
           x = "Log2 Fold Change",
           y = "-Log10(P-value)") +
      theme_minimal(base_size = 16) +
      theme(plot.background = element_rect(fill = "#FFF4E6", color = NA),
            panel.background = element_rect(fill = "#FFF4E6"),
            legend.title = element_blank(),
            plot.title = element_text(face="bold", color="#5A3E36"))
    
    ggplotly(p, tooltip = c("text", "x", "y"))
  })
  
  # ================ TABLA SIGNIFICATIVOS =================
  output$tabla_sig <- renderDT({
    df <- df_reactive()
    
    sig <- df[df$pvalue <= input$p_cutoff & abs(df$log2FC) >= input$lfc_cutoff, ]
    
    datatable(sig, options = list(pageLength = 10))
  })
  
  # ================= DESCARGAS ===========================
  output$descargar_png <- downloadHandler(
    filename = function(){ "volcano_plot.png" },
    content = function(file){
      df <- df_reactive()
      png(file, width = 2000, height = 1600, res = 200)
      print(
        ggplot(df, aes(log2FC, negLogP, color = regulation)) +
          geom_point(alpha = 0.8, size = 2.5) +
          scale_color_manual(values = paleta_volcano(input$palette)) +
          geom_hline(yintercept = -log10(input$p_cutoff), linetype="dashed") +
          geom_vline(xintercept = c(-input$lfc_cutoff, input$lfc_cutoff), linetype="dashed") +
          labs(title = "Volcano Plot", x = "Log2 Fold Change", y = "-Log10(P-value)") +
          theme_minimal()
      )
      dev.off()
    }
  )
  
  output$descargar_jpg <- downloadHandler(
    filename = function(){ "volcano_plot.jpg" },
    content = function(file){
      df <- df_reactive()
      jpeg(file, width = 2000, height = 1600, res = 200)
      print(
        ggplot(df, aes(log2FC, negLogP, color = regulation)) +
          geom_point(alpha = 0.8, size = 2.5) +
          scale_color_manual(values = paleta_volcano(input$palette)) +
          geom_hline(yintercept = -log10(input$p_cutoff), linetype="dashed") +
          geom_vline(xintercept = c(-input$lfc_cutoff, input$lfc_cutoff), linetype="dashed") +
          labs(title = "Volcano Plot", x = "Log2 Fold Change", y = "-Log10(P-value)") +
          theme_minimal()
      )
      dev.off()
    }
  )
  
  output$descargar_pdf <- downloadHandler(
    filename = function(){ "volcano_plot.pdf" },
    content = function(file){
      df <- df_reactive()
      pdf(file, width = 10, height = 8)
      print(
        ggplot(df, aes(log2FC, negLogP, color = regulation)) +
          geom_point(alpha = 0.8, size = 2.5) +
          scale_color_manual(values = paleta_volcano(input$palette)) +
          geom_hline(yintercept = -log10(input$p_cutoff), linetype="dashed") +
          geom_vline(xintercept = c(-input$lfc_cutoff, input$lfc_cutoff), linetype="dashed") +
          labs(title = "Volcano Plot", x = "Log2 Fold Change", y = "-Log10(P-value)") +
          theme_minimal()
      )
      dev.off()
    }
  )
}

# =======================
# EJECUTAR APP
# =======================
shinyApp(ui, server)
