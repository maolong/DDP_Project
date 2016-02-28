
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(data.table)


shinyUI(
  navbarPage("Car fuel consumptions and emissions 2000-2013",
     tabPanel("Plot",
          sidebarPanel(sliderInput("range", "Engine:", min = 599, max = 8285, value = c(599,3500))
                       , radioButtons("trans_type", "Transmission Type:", c("Manual"="Manual","Automatic"="Automatic","Both"="Both"), selected = "Both", inline = FALSE, width = NULL)
                       , checkboxGroupInput("euro_std", "Euro Standard:", c("2"=2,"3"=3,"4"=4,"5"=5,"6"=6), selected = c("3","4","5","6"), inline = FALSE, width = NULL)
          ),
          mainPanel(
           tabsetPanel(
            tabPanel('Explore Data'
                     , h4('Emission/Consumptions by year of construction', align = "center"), plotOutput("Emissionbyyear")
                     , h4('Emission/Consumptions by euro standard', align = "center"), plotOutput("Emissionbyfuel")
            ),
            tabPanel('Emission Density'
                     , h4('Emission density by fuel type', align = "center"), plotOutput("EmissionDensitybyFuel")
                     , h4('Emission density by euro standard', align = "center"), plotOutput("EmissionDensitybyEuro")
            )
           )
          )
      ),
      tabPanel("About",mainPanel(includeMarkdown("README.md")))
  )
)
