### Combine data with all Annotated lncRNAs v2
### Put all overlapping PCGs and percentage of overlapping
### April 15th 2020
### Libraries:
library(tidyverse)
library(magrittr)
options(stringsAsFactors = F)
setwd('/users/rg/ramador/D_me/RNA-seq/Add_info_annotate_lncRNAs/')


### How to unselect using -c: 
lncRNA_all_over <- rna_seq %>%
    select_at(vars(-c(matches("(CRG|_\\d+h$)")))) 




