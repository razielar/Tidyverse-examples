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


path_feather <- "benchmarks/awards.feather"
path_rdata <- "benchmarks/awards.RData"
path_rds <- "benchmarks/awards.rds"
path_csv <- "benchmarks/awards.csv"


### Write the example csv:

## write_feather(example, path = path_feather)
## save(example, file=path_rdata)
## saveRDS(example, path_rds)

### 1) Let's analyze the size of each file:

files <- c("benchmarks/awards.csv", "benchmarks/awards.feather",
           "benchmarks/awards.RData", "benchmarks/awards.rds")

info <- file.info(files)
info$size_mb <- info$size/(1024 * 1024)
print(subset(info, select=c("size_mb")))

### 2) Do the benchmark: 

benchmark <- microbenchmark(
    base = utils::read.csv(path_csv),
    tidyverse_readr = readr::read_csv(path_csv, progress = F),
    data.table_fread = data.table::fread(path_csv, showProgress = F),
    loadRdata = base::load(path_rdata),
    readRds = base::readRDS(path_rds),
    Feather = feather::read_feather(path_feather), times = 20)


print(benchmark, signif = 2)




