
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

# Dataset is published by Vehicle Certification Agency (VCA) for years 2000 to 2013. 
# The VCA is an Executive Agency of the United Kingdom Department for Transport
# You can find original dataset in http://data.okfn.org/data/amercader/car-fuel-and-emissions
# This is an example of shiny application, we use only a subset of dataset

require(markdown)

library(shiny)
library(data.table)
library(ggplot2)

ourdataset <- fread('data/VCA_data.csv')
ourdataset$year <- as.factor(ourdataset$year)


shinyServer(function(input, output) {

  ourdataset.agg <- reactive({
    ds.tmp <- ourdataset[ourdataset$engine_capacity <= as.integer(input$range[2]),]
    ds.tmp <- ds.tmp[ds.tmp$engine_capacity >= as.integer(input$range[1]),] 
    if (input$trans_type!="Both") {
      ds.tmp <- ds.tmp[ds.tmp$transmission_type == input$trans_type,] 
    } 
    ds.tmp <- ds.tmp[ds.tmp$euro_standard == input$euro_std,] 
    ds.tmp
  })

  output$Emissionbyyear <- renderPlot(
    {
      data <- ourdataset.agg()
      #data <- ourdataset

      title <- paste("Emission/Consumptions by year of construction")
      p <- ggplot(data, aes(combined_metric,co2))
      p <- p + geom_point(aes(colour = year))
      p <- p + labs(x = "Consumption", y = "emission")
      print(p)
    })
  
  output$Emissionbyfuel <- renderPlot(
    {
      data <- ourdataset.agg()
      #data <- ourdataset
      
      title <- paste("Emission/Consumptions by fuel type")
      p <- ggplot(data, aes(combined_metric,co2))
      p <- p + geom_point(aes(colour = fuel_type))
      p <- p + labs(x = "Consumption", y = "emission")
      print(p)
    })
  
  output$EmissionDensitybyFuel <- renderPlot(
    {
      data <- ourdataset.agg()

      p <- ggplot(data, aes(x=co2)) + geom_density(aes(group=fuel_type, colour=fuel_type))
      p <- p + labs(x = "Emission", y = "Density")
      print(p)
    })
  
  output$EmissionDensitybyEuro <- renderPlot(
    {
      data <- ourdataset.agg()
      
      p <- ggplot(data, aes(x=co2)) + geom_density(aes(group=euro_standard, colour=euro_standard))
      p <- p + labs(x = "Emission", y = "Density")
      print(p)
    })
  
})
