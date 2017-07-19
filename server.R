

### server.R ###


# proj4string(nyc_price) <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

shinyServer(function(input, output){
  

  # Value per square foot map:
  output$valuemap <- renderLeaflet({
    
    x1 <- input$year
    #x1a <- get(x1)
    
    # Color palette (colorNumeric functino defined in color_map.R):
    pal1 <- colorNumeric(
      palette = "YlOrRd",
      domain = nyc_price$X2016, 
      na.color = "#e2e2e2")
    
    # Tooltip labels:
    labels1 <- sprintf(
      "<strong>%s</strong><br/><strong>%s</strong><br/>$%g / ft<sup>2</sup>",
      nyc_price$COUNTY, nyc_price$ZIPCODE, round(nyc_price$X2016) 
      ) %>% 
      lapply(htmltools::HTML)

        
    leaflet(data = nyc_price) %>%
    #addTiles() %>%             # default base map layer
    setView(lng = -73.9772, lat = 40.7527, zoom = 11) %>%
    addProviderTiles("CartoDB.Positron") %>%
    addPolygons(fillColor = ~pal1(get(x1)), fillOpacity = 0.65, 
                smoothFactor = 0.5, weight = 0.3, 
                color = "black", opacity = 1, stroke = TRUE, 
                highlight = highlightOptions(
                  weight = 2,
                  color = "gray30",
                  dashArray = "",
                  fillOpacity = 0.7,
                  bringToFront = TRUE), 
                label = labels1,
                labelOptions = labelOptions(
                  style = list("font-weight" = "normal", 
                                padding = "3px 8px"),
                  textsize = "15px",
                  direction = "auto")) %>% 
    addLegend(pal = pal1, values = ~get(x1), opacity = 0.5, 
              title = "Value/sq. ft.", 
              position = "bottomright")

    
  })
  
  
  # If I have time, I want to figure out how to use clickable  
  # polygons to add charts based on the selected zip code:

##############################################################    
  
  # observe({
  #   leafletProxy("valuemap") %>% clearPopups()
  #   
  #   event <- input$valuemap_shape_click
  #   
  #   if (is.null(event))
  #     return()
  #   
  #   if ( file.exists("www/temp.png") ) {
  #     file.remove("www/temp.png")
  #     print("temp.png removed")
  #   }
  #   
  #   png("www/temp.png")
  #   plot(mussels[[as.integer(event$id)]], main="")
  #   dev.off()
  #   
  #   isolate({
  #     showPopup(event$id, event$lat, event$lng)
  #   })
  # })
  # 
  # showPopup <- function (id, lat, lng) {
  #   selectedhex <- hab.grid@data[hab.grid@data$OBJECTID == id,]
  #   content <- as.character(tagList(
  #     tags$h4(paste("Number of Mussels:", selectedhex$NumberofMussels)),
  #     tags$h4(paste("River Zone:", selectedhex$RiverZone)),
  #     tags$img(src="temp.png", width = 300)
  #   ))
  #   leafletProxy("valuemap") %>% addPopups(lng, lat, content)
  # }
  
  
  
##############################################################  
  
  # observeEvent(input$valuemap_shape_click, {
  #   click <- input$valuemap_shape_click
  #   
  #   if(is.null(click))
  #     return()   
  #   
  #   #pulls lat and lon from shiny click event
  #   lat <- click$lat
  #   lon <- click$lng
  #   
  #   #puts lat and lon for click point into its own data frame
  #   coords <- as.data.frame(cbind(lon, lat))
  #   
  #   #converts click point coordinate data frame into SP object, sets CRS
  #   point <- SpatialPoints(coords)
  #   proj4string(point) <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
  #   
  #   #retrieves country in which the click point resides, set CRS for country
  #   selected <- nyc_price[point,]
  #   proj4string(selected) <- spTransform(nyc, CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
  #   
  #   proxy <- leafletProxy("valuemap")
  #   if(click$id == "Selected"){
  #     proxy %>% removeShape(layerId = "Selected")
  #   } else {
  #     proxy %>% addPolygons(data = selected, 
  #                           fillColor = "black",
  #                           fillOpacity = 1, 
  #                           color = "red",
  #                           weight = 3, 
  #                           stroke = T,
  #                           layerId = "Selected")
  #   } 
  # })
  
##############################################################
  
  # Price change map:
  output$pctmap <- renderLeaflet({
    
    x2 <- input$pct
    #x2a <- get(x2)
    
    # Percent map color palette:
    pal2 <- colorNumeric(
      palette = "YlOrRd",
      domain = nyc_pct$CAGR_5, 
      na.color = "#e2e2e2")
    
    # Tooltip labels for percent map
    labels2 <- sprintf(
      "<strong>%s</strong><br/><strong>%s</strong><br/>%g&#37;",
      nyc_pct$COUNTY, nyc_pct$ZIPCODE, round(nyc_pct$CAGR_5) 
      ) %>% 
      lapply(htmltools::HTML)
    
    # get(x2)
    
    leaflet(data = nyc_pct) %>%
    setView(lng = -73.9772, lat = 40.7527, zoom = 11) %>%
    addProviderTiles("CartoDB.Positron") %>%
    addPolygons(fillColor = ~pal2(get(x2)), 
                #layerId = "primary2",  # layerId name seems to be breaking the code
                fillOpacity = 0.65, smoothFactor = 0.5, 
                weight = 0.3, color = "black", opacity = 1, 
                stroke = TRUE, 
                highlight = highlightOptions(
                  weight = 2,
                  color = "gray30",
                  dashArray = "",
                  fillOpacity = 0.7,
                  bringToFront = TRUE), 
                label = labels2,
                labelOptions = labelOptions(
                  style = list("font-weight" = "normal", 
                               padding = "3px 8px"),
                   textsize = "15px",
                   direction = "auto")) %>% 
      addLegend(pal = pal2, values = ~get(x2), opacity = 0.5, 
               title = "Pct. Cng.", 
               position = "bottomright")
    

  })
  

  top5zips <- reactive({
    
    y2 <- input$pct
    
    percent_vpsf %>% 
      arrange_(y2) %>%  
      tail(5) %>%
      select(RegionName)
  })
  
  bottom5zips <- reactive({
    
    y2 <- input$pct
    
    percent_vpsf %>%
      arrange_(y2) %>%
      head(5) %>%
      select(RegionName)
  })
  
  subset_top_pct <- reactive({
    if(input$topzips) {
      zipSPDF_top <- subset(nyc_pct, ZIPCODE == top5zips()[1,1] |
                          ZIPCODE == top5zips()[2,1] |
                          ZIPCODE == top5zips()[3,1] |
                          ZIPCODE == top5zips()[4,1] |
                          ZIPCODE == top5zips()[5,1]
                        ) 
                      }  
  })  
  
  subset_low_pct <- reactive({
    if(input$bottomzips) {
      zipSPDF_low <- subset(nyc_pct, ZIPCODE == bottom5zips()[1,1] |
                         ZIPCODE == bottom5zips()[2,1] |
                         ZIPCODE == bottom5zips()[3,1] |
                         ZIPCODE == bottom5zips()[4,1] |
                         ZIPCODE == bottom5zips()[5,1]
                        )
                      }  
  })  
  

  observeEvent({
    input$bottomzips
    input$topzips
    #input$bottomzips
    }, {
    
    x2 <- input$pct
    #x2a <- get(x2)
    
    # Percent map color palette:
    pal2 <- colorNumeric(
      palette = "YlOrRd",
      domain = nyc_pct$CAGR_5, 
      na.color = "#e2e2e2")
    
    # Tooltip labels for percent map
    labels2 <- sprintf(
      "<strong>%s</strong><br/><strong>%s</strong><br/>%g&#37;",
      nyc_pct$COUNTY, nyc_pct$ZIPCODE, round(nyc_pct$CAGR_5) 
      ) %>% 
      lapply(htmltools::HTML)
    
    proxy <- leafletProxy("pctmap")
    if(input$topzips) {
      if(input$bottomzips) {
        
        proxy %>% #removeShape(group = "primary2") #%>%
          addPolygons(data=subset_top_pct(), fillColor = ~pal2(get(x2)),
                      fillOpacity = 1, layerId = LETTERS[1:13], 
                      smoothFactor = 0.5, weight = 2,
                      color = "black", opacity = 1, stroke = TRUE,
                      highlight = highlightOptions(
                        weight = 2,
                        color = "gray30",
                        dashArray = "",
                        fillOpacity = 0.7,
                        bringToFront = TRUE), 
                      label = labels2,
                      labelOptions = labelOptions(
                        style = list("font-weight" = "normal", 
                                     padding = "3px 8px"),
                        textsize = "15px",
                        direction = "auto")) 
        
        proxy %>% #removeShape(group = "primary2") #%>%
          addPolygons(data=subset_low_pct(), fillColor = ~pal2(get(x2)),
                      fillOpacity = 1, 
                      layerId = LETTERS[14:26], 
                      smoothFactor = 0.5, weight = 2,
                      color = "red", opacity = 1, stroke = TRUE,
                      highlight = highlightOptions(
                        weight = 2,
                        color = "gray30",
                        dashArray = "",
                        fillOpacity = 0.7,
                        bringToFront = TRUE), 
                      label = labels2,
                      labelOptions = labelOptions(
                        style = list("font-weight" = "normal", 
                                     padding = "3px 8px"),
                        textsize = "15px",
                        direction = "auto"))
      } else {
        proxy %>% #removeShape(group = "primary2") #%>%
          removeShape(layerId = LETTERS[14:26]) %>% 
          addPolygons(data=subset_top_pct(), fillColor = ~pal2(get(x2)),
                      fillOpacity = 1, layerId = LETTERS[1:13], 
                      smoothFactor = 0.5, weight = 2,
                      color = "black", opacity = 1, stroke = TRUE,
                      highlight = highlightOptions(
                        weight = 2,
                        color = "gray30",
                        dashArray = "",
                        fillOpacity = 0.7,
                        bringToFront = TRUE), 
                      label = labels2,
                      labelOptions = labelOptions(
                        style = list("font-weight" = "normal", 
                                     padding = "3px 8px"),
                        textsize = "15px",
                        direction = "auto"))
      }

    } else if(!input$topzips) {
      if(input$bottomzips) {
        proxy %>% #removeShape(group = "primary2") #%>%
          removeShape(layerId = LETTERS[1:13]) %>% 
          addPolygons(data=subset_low_pct(), fillColor = ~pal2(get(x2)),
                      fillOpacity = 1, 
                      layerId = LETTERS[14:26], 
                      smoothFactor = 0.5, weight = 2,
                      color = "red", opacity = 1, stroke = TRUE,
                      highlight = highlightOptions(
                        weight = 2,
                        color = "gray30",
                        dashArray = "",
                        fillOpacity = 0.7,
                        bringToFront = TRUE), 
                      label = labels2,
                      labelOptions = labelOptions(
                        style = list("font-weight" = "normal", 
                                     padding = "3px 8px"),
                        textsize = "15px",
                        direction = "auto"))
      } else {
        proxy %>% removeShape(layerId = LETTERS[1:13]) %>% 
          removeShape(layerId = LETTERS[14:26])
      }

    } 

  })
  
  
  # Pop density map:
  output$popmap <- renderLeaflet({
    
    #x3 <- input$year
    #x3a <- get(x3)
    
    # Pop density color palette: 
    pal3 <- colorBin("YlOrRd", 
                     domain = nyc_pop$density, 
                     bins = c(0, 5, 10, 15, 20, 25, 
                              30, 40, 50, Inf), 
                     na.color = "#e2e2e2")
    
    # Tooltip labels for pop density map
    labels3 <- sprintf(
      "<strong>%s</strong><br/><strong>%s</strong><br/>%g / km<sup>2</sup>",
      nyc_pop$COUNTY, nyc_pop$ZIPCODE, nyc_pop$density
      ) %>%
      lapply(htmltools::HTML)
    
    
    leaflet(data = nyc_pop) %>%
    setView(lng = -73.9772, lat = 40.7527, zoom = 11) %>%
    addProviderTiles("CartoDB.Positron") %>%
    addPolygons(fillColor = ~pal3(density), fillOpacity = 0.65, 
                smoothFactor = 0.5, weight = 0.3, 
                color = "black", opacity = 1, stroke = TRUE, 
                 highlight = highlightOptions(
                   weight = 2,
                   color = "gray30",
                   dashArray = "",
                   fillOpacity = 0.7,
                  bringToFront = TRUE), 
                 label = labels3,
                 labelOptions = labelOptions(
                   style = list("font-weight" = "normal", 
                                padding = "3px 8px"),
                   textsize = "15px",
                  direction = "auto")) %>% 
    addLegend(pal = pal3, values = ~density, opacity = 0.5, 
              title = "People/ sq. km", 
              position = "bottomright") 
    
  })
  

  # Scatterplot population vs. price: 
  output$scatter<- renderPlotly(
    
    plot_ly(data = nyc_pop_stats, 
            x = ~POPULATION, y = ~X2016, 
            color = ~COUNTY, colors = "Set1") %>% 
      layout(plot_bgcolor='rgb(254, 247, 234)', 
             xaxis = list(range = c(0, 100000),
                          title = "Zip Code Population"), 
             yaxis = list(title = "$ per Square Foot (2016)")) 
    )
  
  # Scatterplot pop density vs. price: 
  output$scatter2<- renderPlotly(
    
    plot_ly(data = nyc_pop_stats, 
            x = ~density, y = ~X2016, 
            color = ~COUNTY, colors = "Set1") %>% 
      layout(plot_bgcolor='rgb(254, 247, 234)', 
             xaxis = list(range = c(0, 60), 
                          title = "Zip Code Population Density"), 
             yaxis = list(title = "$ per Square Foot (2016)")) 
  )
  
  # Boxplot vpsf by boro:
  output$box<- renderPlotly(
    
    plot_ly(data = nyc_pop_stats, 
            x = ~COUNTY, y = ~X2016, 
            color = ~COUNTY, colors = "Set1", type = "box") %>% 
      layout(plot_bgcolor='rgb(254, 247, 234)',
             xaxis = list(title = ""), 
             yaxis = list(title = "$ per Square Foot"))
  )
  
  # Lineplot vpsf by boro:
  output$line<- renderPlotly(
    
    plot_ly(data = as.data.frame(t_annual_county), x = ~Year, 
            y = ~New_York, name = "New York", 
            type = 'scatter', mode = 'lines', colors = "Set1") %>%
      add_lines(y = ~Kings, name = "Kings", 
                type = 'scatter', mode = 'lines') %>%
      add_lines(y = ~Queens, name = "Queens",
                type = 'scatter', mode = 'lines') %>%
      add_lines(y = ~Richmond, name = "Richmond",
                type = 'scatter', mode = 'lines') %>% 
      layout(xaxis = list(title = "", autotick = F, dtick = 3), 
             yaxis = list(title = "$ per Square Foot"))#, 
             #legend = list(orientation = 'h') )#, 
             #autosize = F, width = 475, height = 300, 
            # margin = list(l = 55, r = "auto", b = "auto", 
                           #t = 20, pad = 4) )
  )
  
  
})










