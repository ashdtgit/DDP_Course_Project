#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws various models
ui <- fluidPage(
   
   # Application title
   titlePanel("Swiss fertility in 1888 based on agricultural percentage"),
   
   # Sidebar with a slider input for agricultural percentage 
   sidebarLayout(
      sidebarPanel(
              h3("Select an agricultural percentage"),
              sliderInput("sliderAg", "Agricultural Percentage", 0, 100, value = 75),
              h6("The fertility will be predicted as a red point on the plot, based on the value you select")
      ),
      
      # Show a plot of the actual data, linear model and prediction
      mainPanel(
         plotOutput("plotAg"),
         h3("Fertility based on agriculture percentage"),
         textOutput("predAg")
      )
   )
)

server <- function(input, output) {
        sws <- swiss
        
        modelAg <- lm(Fertility ~ Agriculture, data = sws)

        modelAgPred <- reactive({
                AgInput <- input$sliderAg
                predict(modelAg, newdata = data.frame(Agriculture = AgInput))        
        })

   
   output$plotAg <- renderPlot({
           AgInput <- input$sliderAg
           
           plot(sws$Agriculture, sws$Fertility, 
                xlab = "Agriculture %", 
                ylab = "Fertility",
                bty = "n", 
                pch = 16,
                xlim = c(0,100), 
                ylim = c(0,100)
           )
           abline(modelAg, col = "red", lwd = 1)
           legend(25, 250, "Prediction using Agri %", pch = 16, 
                  col = "red", bty = "n", cex = 1.2)
           points(AgInput, modelAgPred(), col = "red", pch = 16, cex = 2)

      
   })
   output$predAg <- renderText({
           modelAgPred()
   })
   
}

# Run the application 
shinyApp(ui = ui, server = server)

