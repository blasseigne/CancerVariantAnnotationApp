#HudsonAlpha Cancer Variant Annotation Tool
#Brittany N. Lasseigne, 160119
#v1.0 
###Utilizes v1.0 cancer variant cache (Kandoth curated mutation data only)


library(shiny)

shinyUI(fluidPage(
  
#title panel
  titlePanel(
    h1("HudsonAlpha Cancer Variant Annotation Tool", align="center")
    ),

  fluidRow(
    column(10, 
           offset=1,
           h4("Fast Annotation of Known Cancer-Associated Variants",align="center"))
  ),
  
  fluidRow(
    column(12,
           br(),
           tags$hr()
          )
   ),
  
#Upload data
  fluidRow(
    column(3, 
            wellPanel(
              h4("Upload Data", align="center"),
              p("HudsonAlpha's Cancer Variant Annotation tool requires an input VCF file containing variants of interest:"),
              a("Click for more information about VCF files", href="http://gatkforums.broadinstitute.org/gatk/discussion/1268/what-is-a-vcf-and-how-should-i-interpret-it"),
              br(),
              br(),
              fileInput('datafile', 'Choose VCF Text File'),
              p("Alternatively, download example input VCF from the 'Download Center'"),
              tags$hr(),
              selectInput("uniqueAll", 
                          "Would you like to annotate all variants or only unique variants in the file?", 
                          choices = c("All Variants", "Unique Variants Only"),
                          selected="Unique Variants Only"),
              tags$hr(),
              #message handler for popup
              #tags$head(tags$script(src = "message-handler.js")),
              actionButton("submitButton", "Execute Analysis")
            ),
           p("Developed and Maintained by:"),
           a("Rick Myers' and", href="http://research.hudsonalpha.org/Myers/"),
           a("Sara Cooper's Labs", href="http://research.hudsonalpha.org/CooperS/"),
           br(),
           p("Contact: Brittany Lasseigne (blasseigne@hudsonalpha.org) or Ryne Ramaker (rramaker@hudsonalpha.org)"),
           a("HudsonAlpha Institute for Biotechnology", href="http://hudsonalpha.org", align="center"),
           img(src = "hudson-logo.png", height=50, width=200, align="center")
          ),


#file stats
    column(6,
           h4("Input File Information", align="center"),
           br(),
           textOutput("numVarFile"),  #show number of variants in file
           conditionalPanel(
             condition = "infile!==NULL",
             textOutput("infile$datapath")),
           textOutput("options"),  #show whether annotating all/unique variants
           conditionalPanel(
             condition = "options!==NULL",
             textOutput("variantInput")),
           br(),
           p("The first five lines of a successfully loaded file display here:"),
           tableOutput("view"),
           br(),
           p("The first five annotated variants display here:"),
           tableOutput("viewAnno"),
           textOutput("annotatedVariants"),  #number of annotated variants
           textOutput("unannotatedVariants"),  #number of variants not in cache (unannotated)
           br()
           ),
    
#download files
    column(3, 
           #info about CADD
           h5("CADD v1.3 C Scores", align="center"),
           p("See the following links for more information about CADD and c scores, or to annotate variants not in the cancer mutation cache:"),
           a("Combined Annotation Dependent Depletion (CADD)", href="http://cadd.gs.washington.edu"), 
           a("Kircher & Witten, et al. 2014", href="http://www.nature.com/ng/journal/v46/n3/full/ng.2892.html"), 
           br(),
           br(),
           #download center
            wellPanel(
              h4("Download Center", align="center"),
              p("This is where you download annotated and nonannotated variants"),
              selectInput("dataOut", "Select file to download:", 
                          choices = c("Example_Input_Data", "Annotated_Variants", "Unannotated_Variants")),
              downloadButton('downloadData', 'Download')
            ), #end of wellPanel
           #info about mutation cache
           h5("Cancer Mutation Cache v1.0", align="center"), 
           p("The current cancer mutation cache includes all curated variants previously reported by the TCGA PanCancer Project in"),
           a("Kandoth, et al. 2013", href="http://www.nature.com/nature/journal/v502/n7471/full/nature12634.html"),
           br(),
           br(),
           p("Additional variants and annotations will be added soon.")
          )
  )
))