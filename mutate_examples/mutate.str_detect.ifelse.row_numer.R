#### Modify the first table from google drive
### June 14th 2020 
### Libraries: 
library(tidyverse)
library(magrittr)
library(reshape2)
options(stringsAsFactors = F)
setwd('/users/rg/ramador/D_me/RNA-seq/External_datasets/modENCODE_compound_based/metadata_analysis/')

### import data: we're going to keep only pair-end RNA-seq: 

data <- read_csv("Data//modENCODE_compound_based.csv") %>%
    filter(`PAIRED-END` == "Yes") %>%
    select(-c(`PAIRED-END`, Replicates)) %>% as.data.frame

for( i in 1:(ncol(data)-1) ){

    cat(i, "\n")
    
    data[,i] %<>% strsplit(., split= " ", fixed=TRUE) %>%
        lapply(.,function(x){y <- paste0(x, collapse = "_")}) %>%
        unlist()


}


data %>% as_tibble %>% group_by(Biological_Sample) %>%
    mutate(Sample_Name=paste(Sample_Name, row_number(), sep="-")) 


metadata <- data %>% as_tibble %>%
    mutate(Biological_Sample=ifelse(str_detect(Dev_Time, "Adult") &
                                    Biological_Sample == "Control",
                                    paste("Adult", Biological_Sample, sep="_"),
                             ifelse(str_detect(Dev_Time, "L3") &
                                    Biological_Sample == "Control",
                                    paste("L3", Biological_Sample, sep="_"),
                                    Biological_Sample))) %>%
    mutate(Sample_Name= ifelse(str_detect(Dev_Time, "Adult"),
                               paste("Adult", Sample_Name, sep="_"),
                        ifelse(str_detect(Dev_Time, "L3"),
                               paste("L3", Sample_Name, sep= "_"),
                               Sample_Name))) %>%
    group_by(Biological_Sample) %>%
    mutate(Sample_Name= paste(Sample_Name, row_number(), sep="-")) %>%
    ungroup


### For example only: the correct one is above: 

metadata <- data %>% as_tibble %>%
    mutate(Biological_Sample=ifelse(str_detect(Dev_Time, "Adult"), 
                                    paste("Adult", Biological_Sample, sep="_"),
                                    Biological_Sample)) %>% 
    group_by(Biological_Sample) %>%
    mutate(Sample_Name= paste(Sample_Name, row_number(), sep="-")) %>%
    ungroup




