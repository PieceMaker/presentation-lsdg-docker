# install.packages("DT")

library(shiny)

# Read in credit risk data
creditData <- read.csv('./german_credit_data.csv', header = T, stringsAsFactors = T)
creditRiskModel <- glm(
  Risk ~ Age + Sex + Job + Housing + Saving.accounts + Checking.account + Credit.amount + Duration + Purpose,
  data = creditData,
  family = 'binomial'
)

jobLookup <- list("Unskilled Non-Resident" = 0, "Unskilled Resident" = 1, "Skilled" = 2, "Highly Skilled" = 3)

simpleCap <- function(x) {
  s <- strsplit(x, " ")[[1]]
  s <- paste(toupper(substring(s, 1,1)), substring(s, 2),
        sep="", collapse=" ")
  s <- strsplit(s, "/")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2),
             sep="", collapse="/")
}

# NOT BEST PRACTICE!!
resultsTable <<- data.frame(
  Age = NA,
  Sex = NA,
  Job = NA,
  Housing = NA,
  Savings = NA,
  Checking = NA,
  Amount = NA,
  Duration = NA,
  Purpose = NA,
  Probability = NA,
  Approval = NA
)

app <- shinyApp(
  ui = fluidPage(
    titlePanel("Shiny Credit Approval System"),
    sidebarLayout(
      sidebarPanel(
        sliderInput(inputId = "age", label = "Age:", value = 25, min = 18, max = 75, step = 1),
        selectInput(inputId = "sex", label = "Sex:", choices = sapply(levels(creditData$Sex), simpleCap, USE.NAMES = F)),
        selectInput(inputId = "job", label = "Job:", choices = c("Unskilled Non-Resident", "Unskilled Resident", "Skilled", "Highly Skilled")),
        selectInput(inputId = "housing", label = "Housing:", choices = sapply(levels(creditData$Housing), simpleCap, USE.NAMES = F)),
        selectInput(inputId = "savings", label = "Savings:", choices = sapply(levels(creditData$Saving.accounts), simpleCap, USE.NAMES = F)),
        selectInput(inputId = "checking", label = "Checking:", choices = sapply(levels(creditData$Checking.account), simpleCap, USE.NAMES = F)),
        numericInput(inputId = "amount", label = "Amount:", value = 1000, min = 100, max = 25000, step = 1),
        sliderInput(inputId = "duration", label = "Duration (in months):", value = 12, min = 6, max = 72, step = 6),
        selectInput(inputId = "purpose", label = "Loan Purpose:", choices = sapply(levels(creditData$Purpose), simpleCap, USE.NAMES = F)),
        actionButton(inputId = "calculate", "Calculate")
      ),
      mainPanel(
        DT::dataTableOutput("resultsTable")
      )
    )
  ),
  
  server = function(input, output) {
    predictAcceptance <- observeEvent(input$calculate, {
      print("calculate clicked")
      sex <- tolower(input$sex)
      job <- jobLookup[[input$job]]
      housing <- tolower(input$housing)
      savings <- tolower(input$savings)
      checking <- tolower(input$checking)
      purpose <- tolower(input$purpose)
      if(purpose == "radio/tv") {
        purpose <- "radio/TV"
      }
      newData <- data.frame(
        Age = input$age,
        Sex = sex,
        Job = job,
        Housing = housing,
        Saving.accounts = savings,
        Checking.account = checking,
        Credit.amount = input$amount,
        Duration = input$duration,
        Purpose = purpose
      )
      probability <- predict(creditRiskModel, newdata = newData, type = "response")
      approval <- ifelse(probability >= 0.5, "Approved", "Denied")
      results <- data.frame(
        Age = input$age,
        Sex = input$sex,
        Job = input$job,
        Housing = input$housing,
        Savings = input$savings,
        Checking = input$checking,
        Amount = input$amount,
        Duration = input$duration,
        Purpose = input$purpose,
        Probability = probability,
        Approval = approval
      )
      print(results)
      # Again, not best practice!!
      if(all(is.na(resultsTable))) {
        resultsTable <<- results
      } else {
        resultsTable <<- rbind(results, resultsTable)
      }
      output$resultsTable <- DT::renderDataTable(DT::datatable(resultsTable, rownames = F))
    })
    
    # Render blank 
    output$resultsTable <- DT::renderDataTable(DT::datatable(resultsTable, rownames = F))
  }
)

runApp(app, port = 3838, host = "0.0.0.0")
