## Find the fastest way to load R libraries: 
## August 24th 2020
## install.packages("tictoc")
## install.packages("pacman")
library(tictoc)
library(profvis)
library(microbenchmark)
setwd('/home/razielar/Documents/git_rep/Dplyr-examples/benchmarks/')

### 1) Naive way: 

## tic("basic")

##     library(rmarkdown)
##     library(knitr)
##     library(shiny)
##     library(feather)
##     library(DT)
##     library(tidyverse) 
##     library(magrittr)
##     library(lubridate)
##     library(scales)
##     library(reshape2) 
##     library(plotly)
##     library(shinycssloaders)
##     library(shinyWidgets)
##     library(ggh4x)
##     library(fitdistrplus)
##     library(jsTree)
##     library(jsonlite)
##     library(ggbeeswarm)

## toc(log = TRUE)
## log.txt <- tic.log(format = TRUE)



## profvis({

##     library(rmarkdown)
##     library(knitr)
##     library(shiny)
##     library(feather)
##     library(DT)
##     library(tidyverse) 
##     library(magrittr)
##     library(lubridate)
##     library(scales)
##     library(reshape2) 
##     library(plotly)
##     library(shinycssloaders)
##     library(shinyWidgets)
##     library(ggh4x)
##     library(fitdistrplus)
##     library(jsTree)
##     library(jsonlite)
##     library(ggbeeswarm)

## })





### 2) lappy: 

tic("basic")

packages <- c("rmarkdown", "knitr", "shiny", "feather", "DT", "tidyverse",
              "magrittr", "lubridate", "scales", "reshape2", "plotly",
              "shinycssloaders", "shinyWidgets" ,"ggh4x", "fitdistrplus",
              "jsTree", "jsonlite", "ggbeeswarm")


lapply(packages, library, character.only = TRUE)

toc(log = TRUE)
log.txt <- tic.log(format = TRUE)


### 3) Packman

tic("basic")

pacman::p_load("rmarkdown", "knitr", "shiny", "feather", "DT", "tidyverse",
               "magrittr", "lubridate", "scales", "reshape2", "plotly",
               "shinycssloaders", "shinyWidgets" ,"ggh4x", "fitdistrplus",
               "jsTree", "jsonlite", "ggbeeswarm")

toc(log = TRUE)
log.txt <- tic.log(format = TRUE)


## profvis({

##     pacman::p_load("rmarkdown", "knitr", "shiny", "feather", "DT", "tidyverse",
##                    "magrittr", "lubridate", "scales", "reshape2", "plotly",
##                    "shinycssloaders", "shinyWidgets" ,"ggh4x", "fitdistrplus",
##                    "jsTree", "jsonlite", "ggbeeswarm")


## })


## mean(2.844, 2.794, 2.757, 2.728)
## mean(2.821, 2.781, 2.808, 2.825)


### lappy: 2.433
mean(2.433, 2.406, 2.458, 2.407, 2.367)

### pacman: 2.406
mean(2.406, 2.419, 2.415, 2.404, 2.419)



