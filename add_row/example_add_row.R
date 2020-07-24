### Preprocessinng: master and baseline dataframes: 
### July 23th 2020
### Libraries:
library(tidyverse)
library(magrittr)
library(feather)
options(stringsAsFactors = F)
setwd('/home/razielar/Documents/SIRIS/la_caixa/la_caixa_debugging_report/')

## DENT  Dentistry  3500    35
## sub_area_code[which(!(sub_area_code$Full %in% unique(master$subject_area))),]
sub_area_code <- read_csv("Preprocessing_data//SubjAreas.code.csv") %>%
    filter(Abbr != "DENT") %>%
    mutate(Full_desc=paste0(Abbr, ": ", Full)) %>%
    select_at(vars(-c(matches("A")))) %>%
    rename(subject_area=Full)

baseline_subj_area <- add_row(sub_area_code,
        subject_area="All", Full_desc="ALL: All subject areas") %>%
    arrange(subject_area) %>%
    rename(area=subject_area,subject_area_full=Full_desc) %>%
    mutate(area=str_to_title(area))



