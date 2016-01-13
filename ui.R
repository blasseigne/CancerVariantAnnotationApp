library(shiny)

shinyUI(fluidPage(
  
  #title panel
  titlePanel(
    h1("Cancer Variant Annotation", align="center"),
    br()),
  fluidRow(
    column(10, offset=1,
           h4("Upload variant file for annotation of known cancer associated mutations")),
    column(12,
           hr())),
  
  #Upload data
  fluidRow(
    column(4,
           h4("Upload Data", align="center"),
           p("This is where you upload your vcf."),
           fileInput('file1', 'Choose CSV File',
                     accept=c('text/csv', 
                              'text/comma-separated-values,text/plain', 
                              '.csv')),
           tags$hr(),
           checkboxInput('header', 'Header', TRUE),
           radioButtons('sep', 'Separator',
                        c(Comma=',',
                          Semicolon=';',
                          Tab='\t'),
                        ','),
           radioButtons('quote', 'Quote',
                        c(None='',
                          'Double Quote'='"',
                          'Single Quote'="'"),
                        '"')),
    
    #file stats
    column(4,
           h4("File Stats", align="center"),
           p("Number of variants in file:  xx"),
           br(),
           p("Number of known cancer-associated variants annotated:  xx"),
           p("Number of variants without annotation:  xx")
           ),
    
    #download files
    column(4,
           h4("Data Download", align="center"),
           p("This is where you download annotated and nonannotated variants"),
           selectInput("dataset", "Choose a dataset:", 
                       choices = c("rock", "pressure", "cars")),
           downloadButton('downloadData', 'Download'))
    )
#   ,
#   fluidRow(
#     column(4,
#            hr(),
#            verbatimTextOutput('out1'),
#            selectInput('in1', 'Options', c(Choose='', state.name), selectize=FALSE)
#     ),
#     column(4,
#            hr(),
#            verbatimTextOutput('out2'),
#            selectInput('in2', 'Options', state.name, selectize=FALSE)
#     ),
#     column(4,
#            hr(),
#            verbatimTextOutput('out3'),
#            selectInput('in3', 'Options', state.name, multiple=TRUE, selectize=FALSE)
#     )
#   )
))