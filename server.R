### Coursera's Data Science Capstone : Final Project
### server.R file for the Shiny app
### It builds the user interfacefor the shiny app.

# load libraries 

library(tidyverse)
library(stringr)
library(tm)
library(shiny)

## Load Training Data

bigra_words <- readRDS("bigram.RData")
trigra_words  <- readRDS("trigram.RData")
quadgra_words <- readRDS("quadgram.RData")



#Create User Input and Data Cleaning Function; Calls the matching functions
ngrams <- function(input_text){
  
  # Create a dataframe
  input_text <- data_frame(text = input_text)
  
  # Clean the Inpput
  replace_reg <- "[^[:alpha:][:space:]]*"
  input_text <- input_text %>%
    mutate(text = str_replace_all(text, replace_reg, ""))
  
  # Find word count, separate words, lower case
  input_count <- str_count(input_text, boundary("word"))
  input_words <- unlist(str_split(input_text, boundary("word")))
  input_words <- tolower(input_words)
  
  # Call the matching functions
  
  nextWord <- ifelse(input_count == 0,"Please enter your word or phrase in the given left text box.",
                     ifelse(input_count == 1, bigram(input_words),
                            ifelse (input_count == 2, trigram(input_words),
                                    ifelse (input_count == 3, quadgram(input_words)))))
  if(nextWord == "?"){
    nextWord = "The application not found the next expected word due to limited size of the training data" 
  }
  return(nextWord)
}


## Create Ngram Matching Functions

# two word function
bigram <- function(input_words){
  mesg<-"The word is predicted by twogram data"
  num <- length(input_words)
  filter(bigra_words,
         bigra_words[,1]==input_words[num]) %>%
    head(2) %>%                            
    #filter(row_number() == 1L) %>%
    select(starts_with("bigram"))->x
  as.matrix(x)->y
  as.character(x)->out
  ifelse(out =="integer(0)", "?", ifelse(is.na(y[2]),paste(y[1],mesg,sep=" , "),paste(y[1],y[2],mesg,sep=" , ")))
  
}

# three word function
trigram <- function(input_words){
  mesg<-"The word is predicted by trigram data"
  num <- length(input_words)
  filter(trigra_words,
         trigra_words[,1]==input_words[num-1],
         trigra_words[,2]==input_words[num])  %>%
    head(2) %>%
    filter(row_number() == 1L) %>%
    select(starts_with("tri"))->x
  as.matrix(x)->y
  as.character(x)-> out
  ifelse(out =="integer(0)", bigram(input_words[num]), ifelse(is.na(y[2]),paste(y[1],mesg,sep=" , "),paste(y[1],y[2],mesg,sep=" , ")))
  
}

# four word function
quadgram <- function(input_words){
  mesg<-"The word is predicted by quadgram data"
  num <- length(input_words)
  filter(quadgra_words,
         quadgra_words[,1]==input_words[num-2],
         quadgra_words[,2]==input_words[num-1],
         quadgra_words[,3]==input_words[num])  %>%
    head(2) %>%
    filter(row_number() == 1L) %>%
    select(starts_with("qua"))-> x
  as.matrix(x)->y
  as.character(x)-> out
  a<-paste(input_words[num-1],input_words[num])
  a <- unlist(str_split(a, boundary("word")))
  ifelse(out=="integer(0)", trigram(a),ifelse(is.na(y[2]),paste(y[1],mesg,sep=" , "),paste(y[1],y[2],mesg,sep=" , ")))
}

shinyServer(function(input, output){
  output$prediction <- renderPrint({
    next_word <- ngrams(input$inputString)
    next_word
  })
  
  output$predicted <- renderText({
    input$inputString
  })
  
  
})