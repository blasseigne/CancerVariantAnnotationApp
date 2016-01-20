#HudsonAlpha Cancer Variant Annotation Tool
#Brittany N. Lasseigne, 160119
#v1.0
###Utilizes v1.0 cancer variant cache (Kandoth mutation data only)


library(shiny)  
library(data.table)

#mutation cache v1.0
load("AnnotationCache2.RData")
#load variant annotation function
if(!exists("Annotate", mode="function")) source("Variant_Annotation_Script.R")
#load example data for user
exampleInputFile<-fread("Example_InputVCFwithDupes.txt", stringsAsFactors = FALSE, sep="\t")


shinyServer(function(input, output, session) {
  
#read in data from user
  filedata <- reactive({
    infile <- input$datafile
    if(is.null(infile)) {
      return(NULL)
    }
    fread(infile$datapath, stringsAsFactors = FALSE, sep="\t")
  })
   
  
#return number of rows in file user loaded  
  output$numVarFile<-renderText({
    output$numVarFile<-renderText({paste("Total number of variants in file:", nrow(filedata()))})
  })
  
#view user input file head
  output$view <- renderTable({
    head(filedata(), n = 5)
  })
  
#view annotated variant file head
  output$viewAnno <- renderTable({
    head(zoutput()$Found_Annotations, n = 5)
  })
  
#variant selection module:  annotate all variants or only unique variants
  variantInput <- reactive({
      switch(input$uniqueAll,
             "All Variants" = FALSE,
             "Unique Variants Only" = TRUE)
  })
  
#show user if all variants or unique variants selected 
  output$options<-renderText({paste("Annotate only unique variants?", print(variantInput()))})

# #add pop up message while annotating
#   observeEvent(input$submitButton, {
#     session$sendCustomMessage(type = 'testmessage',
#                               message = 'Your analysis is executing')
#   })
  
#annotate user file
  zoutput<-eventReactive(input$submitButton, {
    Annotate(filedata(), AnnotationCache, variantInput())
  })
  
#show user total number of variants annotated/not annotated
  output$annotatedVariants<-renderText({
    paste("Total number of variants annotated:", zoutput()$Number_Found)
    })
  
  output$unannotatedVariants<-renderText({
    paste("Total number of variants not in cache:", zoutput()$Number_Missing)
  })
   
#downloading annotated, unannotated, or example data
   output$downloadData <- downloadHandler(
     filename = function() { 
       paste(input$dataOut, '.txt', sep='\t') },
     content = function(file) {
       write.table(datasetOutput(), file, quote=FALSE)
     })
  
#download data module
   datasetOutput <- reactive({
     switch(input$dataOut,
            "Annotated Variants" = zoutput()$Found_Annotations,
            "Unannotated Variants" = zoutput()$Missing_Annotations,
            "Example Input Data" = exampleInputFile)
   })
  
  })
