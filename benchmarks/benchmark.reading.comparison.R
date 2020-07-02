### Benchmark 5 different methods to read files:

library(tidyverse)
## install.packages("microbenchmark")
library(microbenchmark)
library(feather)
library(data.table)
options(stringsAsFactors = F)
setwd('/home/razielar/Documents/git_rep/Dplyr-examples/')

### csv example:
## example <- read_csv("benchmarks/awards.csv")


## path_feather <- "benchmarks/awards.feather"
## path_rdata <- "benchmarks/awards.RData"
## path_rds <- "benchmarks/awards.rds"

### Write the example csv:

## write_feather(example, path = path_feather)
## save(example, file=path_rdata)
## saveRDS(example, path_rds)












