### Coursera's Data Science Capstone : Final Project
### ui.R file for the Shiny app
### It builds required UI for Next Word Predictor application which accepts an n-gram and predicts the next word.

library(shiny)
library(markdown)
#library(png)
shinyUI(navbarPage("Coursera's Data Science Capstone: Final Project",
                   tabPanel("Word Predictor",
                            HTML("<strong>Author: Benjamin Eggart</strong>"),
                            br(),
                            HTML("<strong>Date: 30th August 2021</strong>"),
                            br(),
                            img(src = "header_ega.PNG",height=50,width=400),
                            # Sidebar
                            sidebarLayout(
                              sidebarPanel(
                                textInput("inputString", "Enter your word or partial sentence:",value = ""),
                                submitButton('Prediction'),
                                br(),
                                helpText("Predict the next word/words upon your string entered above"),
                              ),
                              mainPanel(
                                h2("Prediction of the App:"),
                                br(),
                                textOutput('predicted'),
                                br(),
                                verbatimTextOutput("prediction"),
                                tags$style(type='text/css', '#predicted {background-color: rgba(255,255,0,0.40); color: red;}') 
                                
                              )
                            )
                            
                   ),
                   tabPanel("Instructions",
                            mainPanel(
                              img(src = "header_ega.PNG",height=50,width=400),
                              includeMarkdown("Instructions.md")
                            )
                   ),
                   tabPanel("Explanation",
                            mainPanel(
                              img(src ="header_ega.PNG",height=50,width=400),
                              includeMarkdown("Overview.md"),
                              img(src = "app.png",height=300,width=800)
                            )
                   )
)
)