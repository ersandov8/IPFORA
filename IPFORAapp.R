# packages needed

library(shiny)
library(shinyjs)
library(ggplot2)
library(dplyr)
library(shinydashboard)
library(svglite)


#shapes for points

shape_choices <- c(
  "Circle" = 16,
  "Triangle" = 17,
  "Square" = 15,
  "Diamond" = 18,
  "Plus" = 3,
  "Cross" = 4,
  "Star" = 8,
  "Circle Open" = 1,
  "Square Open" = 0,
  "Triangle Open" = 2,
  "Diamond Open" = 5
)


#pull colors from base R colors

all_colors <- colors()

# name the colors and shapes
site_colors <- all_colors
period_colors <- all_colors
site_shapes <- shape_choices
period_shapes <- shape_choices








ui <- dashboardPage(
  dashboardHeader(title = "IPFORA"),
  dashboardSidebar(disable = TRUE),
  
  dashboardBody(
    fluidRow(
      
      #left column
      
      column(
        width = 4,
        
        box(
          title = "Step 1: Upload CSV Files",
          status = "primary",
          solidHeader = TRUE,
          width = NULL,
          
          fileInput("upload", "Upload Isotope CSV File", accept = ".csv"),
          br(),
          fileInput("upload_reffats", "Upload Reference Fats CSV", accept = ".csv")
        ),
        
        box(
          title = "Step 2: Small Delta Baseplot",
          width = NULL,
          solidHeader = TRUE,
          
          checkboxInput("smallDelta_SDP", "Show Small Delta Plot", value = FALSE),
          checkboxInput("showMixingLines_SDP", "Show Mixing Lines", value = FALSE),
          
          div(
            style = "padding-left: 20px;",conditionalPanel(
              condition = "input.showMixingLines_SDP == true", uiOutput("mixingControls_SDP")
            )),
          
          
          checkboxInput("showFatLegend_SDP", "Show Fat Legend", value = FALSE),
          checkboxInput("enableFatStyling_SDP", "Custom Fat Ellipse Styling", value = FALSE),
          
          
          
          
          conditionalPanel(
            condition = "input.enableFatStyling_SDP == true",
            uiOutput("fatTypeControls_SDP")
          ),
          
          checkboxInput("manual_axis_SDP", "Manually adjust axis", value = FALSE),
          
          
          conditionalPanel(
            condition = "input.manual_axis_SDP == true",
            fluidRow(
              column(6,
                     numericInput("x_min_SDP", "X min", value = -34),
                     numericInput("x_max_SDP", "X max", value = -22)
              ),
              column(6,
                     numericInput("y_min_SDP", "Y min", value = -36),
                     numericInput("y_max_SDP", "Y max", value = -22)
              )
            )
          )
        ),
        
        box(
          title = "Step 3: Small Delta Options",
          width = NULL,
          solidHeader = TRUE,
          
          checkboxInput("show_sites_SDP", "Show Site Points", value = FALSE),
          
          conditionalPanel(
            condition = "input.show_sites_SDP == true",
            numericInput("nSites_SDP", "Number of Sites to Show", value = 0, min = 0, max = 25, step = 1),
            uiOutput("siteControlsGrouped_SDP")
          ),
          
          sliderInput("pointSize_SDP", "Point Size", min = 0, max = 5, value = 1, step = 0.5),
          
          checkboxInput("show_period_SDP", "Show Period Points", value = FALSE),
          
          conditionalPanel(
            condition = "input.show_period_SDP == true",
            numericInput("nPeriod_SDP", "Number of Periods to Show", value = 0, min = 0, max = 25, step = 1),
            uiOutput("periodControlsGrouped_SDP")
          ),
          
          sliderInput("size_period_SDP_", "Size", min = 0, max = 5, value = 1, step = 0.5),
          
          checkboxInput("showTitle_SDP", "Show Plot Title", value = FALSE),
          
          conditionalPanel(
            condition = "input.showTitle_SDP == true",
            textInput("plotTitle_SDP", "Plot Title", value = "Baseline Plot with Sites")
          ),
          
          radioButtons(
            "mapping_choice_SDP",
            "Aesthetic Mapping",
            choices = c(
              "site=color, period=shape",
              "site=shape, period=color",
              "site only",
              "period only"
            ),
            selected = "site=color, period=shape"
          )
        ),
        
        box(
          title = "Step 4: Save Small Delta Plot",
          width = NULL,
          solidHeader = TRUE,
          
          textInput("download_filename_SDP", "File name", value = "SmallDeltaPlot"),
          selectInput("download_format_SDP", "File format", choices = c("png", "jpg", "svg"), selected = "png"),
          numericInput("download_width_SDP", "Width (inches)", value = 10, min = 1),
          numericInput("download_height_SDP", "Height (inches)", value = 7, min = 1),
          downloadButton("download_plot_SDP", "Save Plot")
        )
      ),
      
      #right column
      
      column(
        width = 8,
        
        box(
          title = "Small Delta Plot",
          status = "primary",
          solidHeader = TRUE,
          width = NULL,
          
          conditionalPanel(
            condition = "input.smallDelta_SDP == true",
            plotOutput("combinedPlot_SDP", height = "500px")
          )
        ),
        
        box(
          title = "Big Delta Plot",
          status = "primary",
          solidHeader = TRUE,
          width = NULL,
          
          conditionalPanel(
            condition = "input.BigDelta_BD == true",
            plotOutput("combinedPlot_BD", height = "500px")
          )
        ),
        
        
        fluidRow(
          
          column(
            width = 6,
            
            box(
              title = "Step 5: Big Delta Options",
              width = NULL,
              solidHeader = TRUE,
              
              checkboxInput("BigDelta_BD", "Show Big Delta Plot", value = FALSE),
              tags$hr(),
              
              
              
              tags$hr(),
              uiOutput("fatTypeSelectors_BD"),
              tags$hr(),
              
              checkboxInput("show_sites_BD", "Show Site Points", value = FALSE),
              
              conditionalPanel(
                condition = "input.show_sites_BD == true",
                numericInput("nSites_BD", "Number of Sites to Show", value = 0, min = 0, max = 25, step = 1),
                uiOutput("siteControlsGrouped_BD")
              ),
              
              sliderInput("pointSize_BD", "Point Size", min = 0, max = 5, value = 1, step = 0.5),
              
              checkboxInput("show_period_BD", "Show Period Points", value = FALSE),
              
              conditionalPanel(
                condition = "input.show_period_BD == true",
                numericInput("nPeriod_BD", "Number of Periods to Show", value = 0, min = 0, max = 25, step = 1),
                uiOutput("periodControlsGrouped_BD")
              ),
              
              sliderInput("pointSize_period_BD", "Period Point Size", min = 0, max = 5, value = 2, step = 0.5),
              
              checkboxInput("showTitle_BD", "Show Plot Title", value = FALSE),
              
              conditionalPanel(
                condition = "input.showTitle_BD == true",
                textInput("plotTitle_BD", "Plot Title", value = "Baseline Plot with Sites")
              ),
              
              radioButtons(
                "mapping_choice_BD",
                "Aesthetic Mapping",
                choices = c(
                  "site=color, period=shape",
                  "site=shape, period=color",
                  "site only",
                  "period only"
                ),
                selected = "site=color, period=shape"
              )
            )
          ),
          
          column(
            width = 6,
            
            box(
              title = "Step 6: Save Big Delta Plot",
              width = NULL,
              solidHeader = TRUE,
              
              textInput("download_filename_BD", "File name", value = "BigDeltaPlot"),
              selectInput("download_format_BD", "File format", choices = c("png", "jpg", "svg"), selected = "png"),
              numericInput("download_width_BD", "Width (inches)", value = 10, min = 1),
              numericInput("download_height_BD", "Height (inches)", value = 7, min = 1),
              downloadButton("download_plot_BD", "Save Plot")
            )
          )
        )
      ))))



server <- function(input, output, session) {
  
  uploaded_data <- reactive({
    req(input$upload)
    
    tryCatch({
      df <- read.csv(input$upload$datapath, stringsAsFactors = FALSE)
      
      validate(
        need(all(c("Site", "Period", "d13C16", "d13C18") %in% colnames(df)),
             "CSV must contain: Site, Period, d13C16, d13C18")
      )
      
      df
    }, error = function(e) NULL)
  })
  
  reffats <- reactive({
    req(input$upload_reffats)
    
    read.csv(
      input$upload_reffats$datapath,
      stringsAsFactors = FALSE
    )
  })
  
  output$fatTypeControls_SDP <- renderUI({
    
    req(reffats())
    
    ref <- reffats()
    
    
    fat_counts <- table(ref$fatType)
    valid_fats <- names(fat_counts[fat_counts >= 3])
    
    ref <- ref[ref$fatType %in% valid_fats, ]
    
    fats <- sort(unique(ref$fatType))
    
    req(length(fats) > 0)
    
    tagList(
      lapply(seq_along(fats), function(i) {
        
        fat <- fats[i]
        
        tags$div(
          style = "margin-bottom:15px; padding:8px; border:1px solid #ccc;",
          
          tags$b(fat),
          
          checkboxInput(
            paste0("show_fat_", i),
            "Show ellipse",
            value = TRUE
          ),
          
          selectInput(
            paste0("fat_color_", i),
            "Line colour",
            choices = colors(),
            selected = "black"
          ),
          
          selectInput(
            paste0("fat_linetype_", i),
            "Line type",
            choices = c("solid", "dashed", "dotted", "dotdash", "longdash", "twodash"),
            selected = "solid"
          )
        )
      })
    )
  })
  
  output$mixingControls_SDP <- renderUI({
    
    ref <- reffats()
    req(ref)
    
    fats <- unique(ref$fatType)
    fats <- fats[!is.na(fats)]
    
    if (length(fats) < 2) {
      return(div("Not enough fat types for mixing"))
    }
    
    pairs <- combn(sort(fats), 2, simplify = FALSE)
    
    tagList(
      lapply(seq_along(pairs), function(i) {
        
        pair <- pairs[[i]]
        
        checkboxInput(
          paste0("mix_pair_", i),
          paste(pair, collapse = " × "),
          value = FALSE
        )
        
      })
    )
  })
  
  output$siteControlsGrouped_SDP <- renderUI({
    req(input$nSites_SDP > 0)
    sites <- unique(uploaded_data()$Site)
    tagList(
      lapply(1:input$nSites_SDP, function(i) {
        tagList(
          fluidRow(
            column(12,
                   selectInput(paste0("siteSelect_SDP_", i),
                               label = paste("Select Site", i),
                               choices = sites,
                               selected = NULL)
            )
          ),
          fluidRow(
            column(6,
                   selectInput(paste0("color_site_SDP_", i),
                               label = "Color",
                               choices = all_colors,
                               selected = "black")
            ),
            column(6,
                   selectInput(paste0("shape_site_SDP_", i),
                               label = "Shape",
                               choices = shape_choices,
                               selected = "Circle (open)")
            )
          )
        )
      })
    )
  })
  
  
  
  output$periodControlsGrouped_SDP <- renderUI({
    
    req(input$nPeriod_SDP > 0)
    df <- uploaded_data()
    req(df)
    
    periods <- sort(unique(df$Period))
    
    tagList(
      lapply(seq_len(input$nPeriod_SDP), function(i) {
        
        tagList(
          
          fluidRow(
            column(
              12,
              selectInput(
                paste0("periodSelect_SDP_", i),
                label = paste("Select Period", i),
                choices = periods,
                selected = NULL
              )
            )
          ),
          
          fluidRow(
            column(
              6,
              selectInput(
                paste0("color_period_SDP_", i),
                label = "Color",
                choices = all_colors,
                selected = "black"
              )
            ),
            column(
              6,
              selectInput(
                paste0("shape_period_SDP_", i),
                label = "Shape",
                choices = shape_choices,
                selected = 16
              )
            )
          )
          
        )
        
      })
    )
  })
  output$combinedPlot_SDP <- renderPlot({
    
    req(uploaded_data(), reffats())
    
    df <- uploaded_data()
    ref <- reffats()
    
    mix_data <- NULL
    
    if (isTRUE(input$showMixingLines_SDP)) {
      
      ref_mix <- reffats()
      req(ref_mix)
      
      required_cols <- c(
        "fatType",
        "d13C16",
        "d13C18",
        "C16Percent",
        "C18Percent"
      )
      
      if (all(required_cols %in% names(ref_mix))) {
        
        ref_mix <- ref_mix %>%
          group_by(fatType) %>%
          summarise(
            d13C16 = mean(d13C16, na.rm = TRUE),
            d13C18 = mean(d13C18, na.rm = TRUE),
            C16Percent = mean(C16Percent, na.rm = TRUE),
            C18Percent = mean(C18Percent, na.rm = TRUE),
            .groups = "drop"
          )
        
        fats_mix <- unique(ref_mix$fatType)
        
        if (length(fats_mix) >= 2) {
          
          pairs <- combn(sort(fats_mix), 2, simplify = FALSE)
          
          selected_pairs <- pairs[
            sapply(seq_along(pairs), function(i) {
              isTRUE(input[[paste0("mix_pair_", i)]])
            })
          ]
          
          sequencedf <- data.frame(
            x = seq(0, 100, 1),
            y = seq(100, 0, -1)
          )
          
          mix_model <- function(a, b, means, seqdf) {
            
            A <- means[means$fatType == a, , drop = FALSE]
            M <- means[means$fatType == b, , drop = FALSE]
            
            if (nrow(A) == 0 || nrow(M) == 0) return(NULL)
            
            if (
              any(is.na(c(
                A$d13C16, A$d13C18,
                A$C16Percent, A$C18Percent,
                M$d13C16, M$d13C18,
                M$C16Percent, M$C18Percent
              )))
            ) {
              return(NULL)
            }
            
            wA16 <- seqdf$x * A$C16Percent
            wM16 <- seqdf$y * M$C16Percent
            
            denom16 <- wA16 + wM16
            
            x <- A$d13C16 * (wA16 / denom16) +
              M$d13C16 * (wM16 / denom16)
            
            wA18 <- seqdf$x * A$C18Percent
            wM18 <- seqdf$y * M$C18Percent
            
            denom18 <- wA18 + wM18
            
            y <- A$d13C18 * (wA18 / denom18) +
              M$d13C18 * (wM18 / denom18)
            
            data.frame(x = x, y = y)
          }
          
          mix_list <- lapply(selected_pairs, function(p) {
            
            tryCatch({
              
              df <- mix_model(p[1], p[2], ref_mix, sequencedf)
              
              if (is.null(df)) return(NULL)
              
              df$pair <- paste(p[1], p[2], sep = "_")
              
              df
              
            }, error = function(e) NULL)
            
          })
          
          mix_list <- Filter(Negate(is.null), mix_list)
          
          if (length(mix_list) > 0) {
            mix_data <- do.call(rbind, mix_list)
          }
        }
      }
    }
    
    
    fat_counts_global <- table(ref$fatType)
    valid_fats <- names(fat_counts_global[fat_counts_global >= 3])
    
    req(length(valid_fats) > 0)
    
    ref <- ref[ref$fatType %in% valid_fats, ]
    
    
    fats <- sort(unique(valid_fats))
    
    
    fat_map <- data.frame(
      fatType = fats,
      color = sapply(seq_along(fats), function(i)
        input[[paste0("fat_color_", i)]] %||% "black"),
      linetype = sapply(seq_along(fats), function(i)
        input[[paste0("fat_linetype_", i)]] %||% "solid"),
      stringsAsFactors = FALSE
    )
    
    
    if (isTRUE(input$enableFatStyling_SDP)) {
      
      selected_fats <- fats[
        sapply(seq_along(fats), function(i)
          isTRUE(input[[paste0("show_fat_", i)]])
        )
      ]
      
    } else {
      selected_fats <- fats
    }
    
    
    plot_fats <- selected_fats
    
    ref <- ref[ref$fatType %in% plot_fats, ]
    
    ellipse_data <- ref
    
    
    p <- ggplot(ref, aes(x = d13C16, y = d13C18))
    
    #make ellipses
    
    if (length(plot_fats) > 0) {
      
      p <- p +
        stat_ellipse(
          aes(group = fatType, colour = fatType, linetype = fatType),
          level = 0.684,
          linewidth = 0.5
        )
    }
    
    
    fat_map <- fat_map[fat_map$fatType %in% plot_fats, ]
    fat_map <- fat_map[match(plot_fats, fat_map$fatType), ]
    
    p <- p +
      scale_color_manual(
        values = setNames(fat_map$color, fat_map$fatType),
        breaks = plot_fats,
        drop = FALSE,
        name = "Fat type"
      ) +
      scale_linetype_manual(
        values = setNames(fat_map$linetype, fat_map$fatType),
        breaks = plot_fats,
        drop = FALSE,
        name = "Fat type"
      ) +
      labs(
        title = if (isTRUE(input$showTitle_SDP)) input$plotTitle_SDP else NULL,
        x = expression(delta^{13} * "C"[16:0] * " (‰)"),
        y = expression(delta^{13} * "C"[18:0] * " (‰)")
      ) +
      theme(
        panel.border = element_rect(colour = "black", fill = NA, linewidth = 1),
        panel.background = element_blank(),
        panel.grid = element_blank()
      )
    
    if (!is.null(mix_data) && nrow(mix_data) > 0) {
      
      p <- p +
        geom_path(
          data = mix_data,
          aes(x = x, y = y, group = pair),
          color = "black",
          linewidth = .5
        )
    }
    
    
    if (isTRUE(input$manual_axis_SDP)) {
      p <- p +
        scale_x_continuous(
          breaks = seq(input$x_min_SDP, input$x_max_SDP, by = 2),
          limits = c(input$x_min_SDP, input$x_max_SDP),
          expand = c(0, 0)
        ) +
        scale_y_continuous(
          breaks = seq(input$y_min_SDP, input$y_max_SDP, by = 2),
          limits = c(input$y_min_SDP, input$y_max_SDP),
          expand = c(0, 0)
        )
    } else {
      p <- p +
        scale_x_continuous(
          breaks = seq(-34, -22, by = 2),
          limits = c(-34, -22),
          expand = c(0, 0)
        ) +
        scale_y_continuous(
          breaks = seq(-36, -22, by = 2),
          limits = c(-36, -22),
          expand = c(0, 0)
        )
    }
    
    #make points
    
    # selected sites and periods
    selected_sites <- if (isTRUE(input$show_sites_SDP) && input$nSites_SDP > 0) {
      sapply(seq_len(input$nSites_SDP), function(i) input[[paste0("siteSelect_SDP_", i)]]) %>%
        na.omit() %>% unique()
    } else character(0)
    
    selected_periods <- if (isTRUE(input$show_period_SDP) && input$nPeriod_SDP > 0) {
      sapply(seq_len(input$nPeriod_SDP), function(i) input[[paste0("periodSelect_SDP_", i)]]) %>%
        na.omit() %>% unique()
    } else character(0)
    
    # Filter data
    if (length(selected_sites) > 0 && length(selected_periods) > 0) {
      df_filtered <- df %>% filter(Site %in% selected_sites, Period %in% selected_periods)
    } else if (length(selected_sites) > 0) {
      df_filtered <- df %>% filter(Site %in% selected_sites)
    } else if (length(selected_periods) > 0) {
      df_filtered <- df %>% filter(Period %in% selected_periods)
    } else {
      df_filtered <- df
    }
    
    if (nrow(df_filtered) > 0) {
      
      df_unique <- df_filtered %>%
        select(Site, Period, d13C16, d13C18) %>%
        distinct()
      
      df_unique$Color <- NA_character_
      df_unique$Shape <- NA_integer_
      
      map_choice <- input$mapping_choice_SDP
      
      site_colors_map <- setNames(
        sapply(seq_len(input$nSites_SDP), function(i)
          input[[paste0("color_site_SDP_", i)]]),
        sapply(seq_len(input$nSites_SDP), function(i)
          input[[paste0("siteSelect_SDP_", i)]])
      )
      
      site_shapes_map <- setNames(
        as.numeric(sapply(seq_len(input$nSites_SDP), function(i)
          input[[paste0("shape_site_SDP_", i)]])),
        sapply(seq_len(input$nSites_SDP), function(i)
          input[[paste0("siteSelect_SDP_", i)]])
      )
      
      period_colors_map <- setNames(
        sapply(seq_len(input$nPeriod_SDP), function(i)
          input[[paste0("color_period_SDP_", i)]]),
        sapply(seq_len(input$nPeriod_SDP), function(i)
          input[[paste0("periodSelect_SDP_", i)]])
      )
      
      period_shapes_map <- setNames(
        as.numeric(sapply(seq_len(input$nPeriod_SDP), function(i)
          input[[paste0("shape_period_SDP_", i)]])),
        sapply(seq_len(input$nPeriod_SDP), function(i)
          input[[paste0("periodSelect_SDP_", i)]])
      )
      
      # Assign colors and shapes based on choices
      if (map_choice == "site=color, period=shape") {
        
        df_unique$Color <- site_colors_map[df_unique$Site]
        df_unique$Shape <- period_shapes_map[df_unique$Period]
        
      } else if (map_choice == "site=shape, period=color") {
        
        df_unique$Color <- period_colors_map[df_unique$Period]
        df_unique$Shape <- site_shapes_map[df_unique$Site]
        
      } else if (map_choice == "site only") {
        
        df_unique$Color <- site_colors_map[df_unique$Site]
        df_unique$Shape <- site_shapes_map[df_unique$Site]
        
      } else if (map_choice == "period only") {
        
        df_unique$Color <- period_colors_map[df_unique$Period]
        df_unique$Shape <- period_shapes_map[df_unique$Period]
        
      } else {
        
        df_unique$Color <- rep("black", nrow(df_unique))
        df_unique$Shape <- rep(16, nrow(df_unique))
      }
      
      df_unique$Shape <- as.numeric(df_unique$Shape)
      df_unique$Shape[is.na(df_unique$Shape)] <- 16
      df_unique$Color[is.na(df_unique$Color)] <- "black"
      
      p <- p +
        geom_point(
          data = df_unique,
          aes(x = d13C16, y = d13C18),
          color = df_unique$Color,
          shape = df_unique$Shape,
          size = input$pointSize_SDP
        )
    }
    
    #make legend
    
    if (isTRUE(input$showFatLegend_SDP)) {
      p <- p +
        theme(
          legend.position = c(0.02, 0.98),
          legend.justification = c(0, 1),
          legend.background = element_rect(fill = "white", colour = "black")
        )
    } else {
      p <- p + theme(legend.position = "none")
    }
    
    print(p)
  })
  
  output$download_plot_SDP <- downloadHandler(
    
    filename = function() {
      fname <- input$download_filename_SDP
      if (is.null(fname) || fname == "") fname <- "SDP_plot"
      paste0(fname, ".", input$download_format_SDP)
    },
    
    content = function(file) {
      
      req(uploaded_data(), reffats())
      
      df <- uploaded_data()
      ref <- reffats()
      
      
      
      p <- ggplot(ref, aes(x = d13C16, y = d13C18))
      
      
      p <- p +
        stat_ellipse(
          aes(group = fatType, colour = fatType, linetype = fatType),
          level = 0.684,
          linewidth = 0.5
        )
      
      
      p <- p +
        theme(
          panel.border = element_rect(colour = "black", fill = NA, linewidth = 1),
          panel.background = element_blank(),
          panel.grid = element_blank()
        )
      
      
      selected_sites <- if (isTRUE(input$show_sites_SDP) && input$nSites_SDP > 0) {
        sapply(seq_len(input$nSites_SDP), function(i)
          input[[paste0("siteSelect_SDP_", i)]]) %>% unique() %>% na.omit()
      } else character(0)
      
      selected_periods <- if (isTRUE(input$show_period_SDP) && input$nPeriod_SDP > 0) {
        sapply(seq_len(input$nPeriod_SDP), function(i)
          input[[paste0("periodSelect_SDP_", i)]]) %>% unique() %>% na.omit()
      } else character(0)
      
      if (length(selected_sites) > 0 && length(selected_periods) > 0) {
        df_filtered <- df[df$Site %in% selected_sites & df$Period %in% selected_periods, ]
      } else if (length(selected_sites) > 0) {
        df_filtered <- df[df$Site %in% selected_sites, ]
      } else if (length(selected_periods) > 0) {
        df_filtered <- df[df$Period %in% selected_periods, ]
      } else {
        df_filtered <- df
      }
      
      
      if (nrow(df_filtered) > 0) {
        
        df_unique <- unique(df_filtered[, c("Site", "Period", "d13C16", "d13C18")])
        
        df_unique$Color <- "black"
        df_unique$Shape <- 16
        
        p <- p +
          geom_point(
            data = df_unique,
            aes(x = d13C16, y = d13C18),
            colour = df_unique$Color,
            shape = df_unique$Shape,
            size = input$pointSize_SDP
          )
      }
      
      ggsave(
        filename = file,
        plot = p,
        width = input$download_width_SDP,
        height = input$download_height_SDP
      )
    }
  )
  
  #Big Delta Plot
  
  
  get_prev <- function(input, id, default = NULL) {
    if (!is.null(input[[id]])) {
      input[[id]]
    } else {
      default
    }
  }
  
  
  
  
  output$fatTypeSelectors_BD <- renderUI({
    
    rf <- reffats()
    
    fat_choices <- sort(unique(rf$fatType))
    
    tagList(
      
      selectInput(
        "assign_ruminant_adipose_BD",
        "Ruminant adipose",
        choices = fat_choices,
        multiple = TRUE
      ),
      
      selectInput(
        "assign_ruminant_dairy_BD",
        "Ruminant dairy",
        choices = fat_choices,
        multiple = TRUE
      ),
      
      selectInput(
        "assign_nonrum_adipose_BD",
        "Non-ruminant adipose",
        choices = fat_choices,
        multiple = TRUE
      ),
      
      selectInput(
        "assign_nonrum_dairy_BD",
        "Non-ruminant dairy",
        choices = fat_choices,
        multiple = TRUE
      ),
      
      selectInput(
        "assign_aquatic_BD",
        "Aquatic",
        choices = fat_choices,
        multiple = TRUE
      )
      
    )
  })
  
  
  output$siteControlsGrouped_BD <- renderUI({
    req(input$show_sites_BD, uploaded_data())
    n <- input$nSites_BD
    if (n < 1) return(NULL)
    
    site_choices <- sort(unique(uploaded_data()$Site))
    controls <- lapply(1:n, function(i) {
      site_id <- paste0("siteSelect_BD_", i)
      color_id <- paste0("color_site_BD_", i)
      shape_id <- paste0("shape_site_BD_", i)
      
      selected_site <- get_prev(input, site_id, site_choices[1])
      selected_color <- get_prev(input, color_id, "red")
      selected_shape <- get_prev(input, shape_id, 16)
      
      tagList(
        selectInput(site_id, paste("Select Site", i),
                    choices = site_choices, selected = selected_site, width = "100%"),
        fluidRow(
          column(6,
                 selectInput(color_id, paste("Color for Site", i),
                             choices = site_colors, selected = selected_color, width = "100%")
          ),
          column(6,
                 selectInput(shape_id, paste("Shape for Site", i),
                             choices = site_shapes, selected = selected_shape, width = "100%")
          )
        ),
        tags$hr(style = "margin-top: 10px; margin-bottom: 10px;")
      )
    })
    do.call(tagList, controls)
  })
  
  
  output$periodControlsGrouped_BD <- renderUI({
    req(input$show_period_BD, uploaded_data())
    n <- input$nPeriod_BD
    if (n < 1) return(NULL)
    
    period_choices <- sort(unique(uploaded_data()$Period))
    controls <- lapply(1:n, function(i) {
      period_id <- paste0("periodSelect_BD_", i)
      color_id <- paste0("color_period_BD_", i)
      shape_id <- paste0("shape_period_BD_", i)
      
      selected_period <- get_prev(input, period_id, period_choices[1])
      selected_color <- get_prev(input, color_id, "blue")
      selected_shape <- get_prev(input, shape_id, 16)
      
      tagList(
        selectInput(period_id, paste("Select Period", i),
                    choices = period_choices, selected = selected_period, width = "100%"),
        fluidRow(
          column(6,
                 selectInput(color_id, paste("Color for Period", i),
                             choices = period_colors, selected = selected_color, width = "100%")
          ),
          column(6,
                 selectInput(shape_id, paste("Shape for Period", i),
                             choices = period_shapes, selected = selected_shape, width = "100%")
          )
        ),
        tags$hr(style = "margin-top: 10px; margin-bottom: 10px;")
      )
    })
    do.call(tagList, controls)
  })
  
  #build big delta plot
  
  output$combinedPlot_BD <- renderPlot({
    
    req(input$BigDelta_BD)
    
    df <- uploaded_data()
    req(df)
    
    rf <- reffats()
    req(rf)
    
    
    
    rf$category <- NA_character_
    
    assign_map <- list(
      "Ruminant adipose" = input$assign_ruminant_adipose_BD,
      "Ruminant dairy" = input$assign_ruminant_dairy_BD,
      "Non-ruminant adipose" = input$assign_nonrum_adipose_BD,
      "Non-ruminant dairy" = input$assign_nonrum_dairy_BD,
      "Aquatic" = input$assign_aquatic_BD
    )
    
    for (cat in names(assign_map)) {
      
      fats <- assign_map[[cat]]
      
      if (!is.null(fats) && length(fats) > 0) {
        rf$category[rf$fatType %in% fats] <- cat
      }
    }
    
    rf <- rf %>% filter(!is.na(category))
    
    
    
    bigdeltadf <- rf %>%
      group_by(category) %>%
      summarize(
        Mean = mean(D13C, na.rm = TRUE),
        SD   = sd(D13C, na.rm = TRUE),
        Min  = Mean - SD,
        Max  = Mean + SD,
        .groups = "drop"
      ) %>%
      arrange(Mean)
    
    rect_df <- data.frame(
      ymin = head(bigdeltadf$Max, -1),
      ymax = tail(bigdeltadf$Min, -1)
    )
    
    bigdeltadf_filtered <- bigdeltadf %>%
      filter(category != "Aquatic")
    
    bigdeltadf_aq <- bigdeltadf %>%
      filter(category == "Aquatic")
    
    
    
    
    bigdeltadf_filtered <- bigdeltadf_filtered %>%
      arrange(Mean)
    
    rect_df <- bigdeltadf_filtered %>%
      mutate(
        ymin = lead(Min),
        ymax = Max
      ) %>%
      na.omit()
    
    
    
    
    bigdeltadf_aq <- bigdeltadf_aq %>%
      arrange(Mean)
    
    
    #Big Delta baseplot
    
    pBD <- ggplot() +
      
      geom_errorbar(
        data = transform(
          bigdeltadf_filtered,
          xpos = ifelse(category == "Non-ruminant dairy", -35.5, -35)
        ),
        aes(x = xpos, ymin = Min, ymax = Max),
        width = 0.4,
        size = 0.6
      ) +
      
      geom_point(
        data = transform(
          bigdeltadf_filtered,
          xpos = ifelse(category == "Non-ruminant dairy", -35.5, -35)
        ),
        aes(x = xpos, y = Mean),
        size = input$pointSize_period_BD
      ) +
      
      geom_errorbar(
        data = bigdeltadf_aq,
        aes(x = -13.5, ymin = Min, ymax = Max),
        width = 0.4,
        size = 0.6
      ) +
      
      geom_point(
        data = bigdeltadf_aq,
        aes(x = -13.5, y = Mean),
        size = input$pointSize_period_BD
      ) +
      
      geom_rect(
        data = rect_df,
        aes(xmin = -35, xmax = -13.5, ymin = ymin, ymax = ymax),
        fill = "lightgrey",
        alpha = 0.2
      ) +
      
      
      annotate(
        "text",
        x = -37.5,
        y = bigdeltadf_filtered$Mean[bigdeltadf_filtered$category == "Non-ruminant adipose"],
        label = "Non-ruminant \n adipose",
        size = 3,
        angle = 90
      ) +
      
      annotate(
        "text",
        x = -37.5,
        y = bigdeltadf_filtered$Mean[bigdeltadf_filtered$category == "Ruminant adipose"],
        label = "Ruminant \n adipose",
        size = 3,
        angle = 90
      ) +
      
      annotate(
        "text",
        x = -37.5,
        y = bigdeltadf_filtered$Mean[bigdeltadf_filtered$category == "Ruminant dairy"],
        label = "Ruminant \n dairy",
        size = 3,
        angle = 90
      ) +
      
      annotate(
        "text",
        x = -12.2,
        y = bigdeltadf_aq$Mean[bigdeltadf_aq$category == "Aquatic"],
        label = "Aquatic",
        size = 3,
        angle = 90
      )+
      
      geom_text(
        aes(x = -30, y = 4, label = "C[3]~diet"),
        parse = TRUE,
        size = 5
      ) +
      
      geom_text(
        aes(x = -18, y = 4, label = "Increasing~C[4]~diet"),
        parse = TRUE,
        size = 5
      ) +
      
      
      scale_x_continuous(
        breaks = seq(-40, -10, 10),
        limits = c(-38.64, -11.36),
        name = expression(paste(delta^{13}, "C"[16:0], " (\u2030)"))
      ) +
      scale_y_continuous(
        breaks = seq(-9, 5, 2),
        limits = c(-8.364, 4.364),
        name = expression(paste(Delta^{13}, "C (\u2030)"))
      ) +
      annotate(
        "segment",
        x = -32, xend = -15,
        y = 3.5, yend = 3.5,
        size = 0.5,
        arrow = arrow(length = unit(3, "mm"), type = "closed"),
        arrow.fill = "black"
      )+
      
      theme(
        panel.background = element_blank(),
        panel.grid = element_blank(),
        panel.border = element_rect()
      )
    
    
    if ("Non-ruminant dairy" %in% bigdeltadf$category) {
      
      nonrum_dairy_row <- bigdeltadf[
        bigdeltadf$category == "Non-ruminant dairy",
      ]
      
      pBD <- pBD +
        
        geom_rect(
          data = nonrum_dairy_row,
          aes(
            xmin = -35.5,
            xmax = -13.5,
            ymin = Min,
            ymax = Max
          ),
          inherit.aes = FALSE,
          fill = "lightgrey",
          alpha = 0.2
        ) +
        
        annotate(
          "text",
          x = -36.5,
          y = nonrum_dairy_row$Mean,
          label = "Non-ruminant \n dairy",
          size = 3,
          angle = 90
        )
    }
    
    if (isTRUE(input$showTitle_BD)) {
      pBD <- pBD + ggtitle(input$plotTitle_BD)
    }
    
    
    
    if (!isTRUE(input$show_sites_BD) && !isTRUE(input$show_period_BD)) {
      print(pBD)
      return()
    }
    
    
    
    selected_sites <- if (isTRUE(input$show_sites_BD) && input$nSites_BD > 0) {
      na.omit(sapply(seq_len(input$nSites_BD),
                     function(i) input[[paste0("siteSelect_BD_", i)]]))
    } else character(0)
    
    selected_periods <- if (isTRUE(input$show_period_BD) && input$nPeriod_BD > 0) {
      na.omit(sapply(seq_len(input$nPeriod_BD),
                     function(i) input[[paste0("periodSelect_BD_", i)]]))
    } else character(0)
    
    if (length(selected_sites) > 0 && length(selected_periods) > 0) {
      df_filtered <- df %>% filter(Site %in% selected_sites, Period %in% selected_periods)
    } else if (length(selected_sites) > 0) {
      df_filtered <- df %>% filter(Site %in% selected_sites)
    } else if (length(selected_periods) > 0) {
      df_filtered <- df %>% filter(Period %in% selected_periods)
    } else {
      df_filtered <- df
    }
    
    if (nrow(df_filtered) == 0) {
      print(pBD)
      return()
    }
    
    #points
    
    df_unique <- df_filtered %>%
      select(Site, Period, d13C16, BIGDELTA) %>%
      distinct()
    
    
    df_unique$Color <- "black"
    df_unique$Shape <- 16
    
    site_colors_map <- setNames(
      sapply(seq_len(input$nSites_BD),
             function(i) input[[paste0("color_site_BD_", i)]]),
      sapply(seq_len(input$nSites_BD),
             function(i) input[[paste0("siteSelect_BD_", i)]])
    )
    
    site_shapes_map <- setNames(
      as.numeric(sapply(seq_len(input$nSites_BD),
                        function(i) input[[paste0("shape_site_BD_", i)]])),
      sapply(seq_len(input$nSites_BD),
             function(i) input[[paste0("siteSelect_BD_", i)]])
    )
    
    period_colors_map <- setNames(
      sapply(seq_len(input$nPeriod_BD),
             function(i) input[[paste0("color_period_BD_", i)]]),
      sapply(seq_len(input$nPeriod_BD),
             function(i) input[[paste0("periodSelect_BD_", i)]])
    )
    
    period_shapes_map <- setNames(
      as.numeric(sapply(seq_len(input$nPeriod_BD),
                        function(i) input[[paste0("shape_period_BD_", i)]])),
      sapply(seq_len(input$nPeriod_BD),
             function(i) input[[paste0("periodSelect_BD_", i)]])
    )
    
    map_choice <- input$mapping_choice_BD
    
    if (map_choice == "site=color, period=shape") {
      
      df_unique$Color <- site_colors_map[df_unique$Site]
      df_unique$Shape <- period_shapes_map[df_unique$Period]
      
    } else if (map_choice == "site=shape, period=color") {
      
      df_unique$Color <- period_colors_map[df_unique$Period]
      df_unique$Shape <- site_shapes_map[df_unique$Site]
      
    } else if (map_choice == "site only") {
      
      df_unique$Color <- site_colors_map[df_unique$Site]
      df_unique$Shape <- site_shapes_map[df_unique$Site]
      
    } else if (map_choice == "period only") {
      
      df_unique$Color <- period_colors_map[df_unique$Period]
      df_unique$Shape <- period_shapes_map[df_unique$Period]
    }
    
    df_unique$Color[is.na(df_unique$Color)] <- "black"
    df_unique$Shape[is.na(df_unique$Shape)] <- 16
    
    pBD <- pBD +
      geom_point(
        data = df_unique,
        aes(x = d13C16, y = BIGDELTA),
        color = df_unique$Color,
        shape = df_unique$Shape,
        size = input$pointSize_BD
      )
    
    print(pBD)
    
  })
  
  
  
  
  output$download_plot_BD <- downloadHandler(
    
    filename = function() {
      fname <- input$download_filename_BD
      if (is.null(fname) || fname == "") fname <- "BigDeltaPlot"
      paste0(fname, ".", input$download_format_BD)
    },
    
    content = function(file) {
      
      req(input$BigDelta_BD)
      
      df <- uploaded_data()
      rf <- reffats()
      
      rf$category <- NA_character_
      
      assign_map <- list(
        "Ruminant adipose" = input$assign_ruminant_adipose_BD,
        "Ruminant dairy" = input$assign_ruminant_dairy_BD,
        "Non-ruminant adipose" = input$assign_nonrum_adipose_BD,
        "Non-ruminant dairy" = input$assign_nonrum_dairy_BD,
        "Aquatic" = input$assign_aquatic_BD
      )
      
      for (cat in names(assign_map)) {
        fats <- assign_map[[cat]]
        if (!is.null(fats) && length(fats) > 0) {
          rf$category[rf$fatType %in% fats] <- cat
        }
      }
      
      rf <- rf %>% filter(!is.na(category))
      
      bigdeltadf <- rf %>%
        group_by(category) %>%
        summarize(
          Mean = mean(D13C, na.rm = TRUE),
          SD   = sd(D13C, na.rm = TRUE),
          Min  = Mean - SD,
          Max  = Mean + SD,
          .groups = "drop"
        ) %>%
        arrange(Mean)
      
      rect_df <- data.frame(
        ymin = head(bigdeltadf$Max, -1),
        ymax = tail(bigdeltadf$Min, -1)
      )
      
      pBD <- ggplot() +
        geom_errorbar(data = bigdeltadf,
                      aes(x = -35, ymin = Min, ymax = Max),
                      width = 0.4) +
        geom_point(data = bigdeltadf,
                   aes(x = -35, y = Mean),
                   size = 3) +
        geom_rect(data = rect_df,
                  aes(xmin = -35, xmax = -13.5, ymin = ymin, ymax = ymax),
                  fill = "lightgrey", alpha = 0.2) +
        theme_minimal()
      
      
      
      ggsave(file, pBD,
             device = input$download_format_BD,
             width = input$download_width_BD,
             height = input$download_height_BD)
    }
  )
  
}

shinyApp(ui, server)
