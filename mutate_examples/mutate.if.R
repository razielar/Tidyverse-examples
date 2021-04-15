### Length analysis
### DE, Expressed, NE. For lncRNA classification 
### April 15th 2021
library(tidyverse)
library(magrittr)
library(janitor)
library(ggpubr)
options(stringsAsFactors = F)
setwd('/home/razielar/Documents/git_rep/PhD/lncRNA_genomic_features/')

### input data 
input <- read_tsv("results/table/lncRNA.genomic.features.tsv")
gc_per <- input %>% select_at(vars(matches("gene_id|gene_name|gc_")))
de <- read_tsv("data/tables/final.de.list.merge.ge.TPM.tsv") %>%
    clean_names %>% select_at(vars(matches("gene_|dge_"))) %>%
    filter(gene_type == "nRNA")

###################### Comparing DE and the rest: 
length_analysis <- input %>%
    select_at(vars(matches("gene_id|gene_name|length|^exon_join"))) %>%
    mutate_if(is.numeric, ~round(log(.), 4)) %>% 
    select_at(vars(-c(matches("exon_length")))) %>%
    left_join(., de %>% select(gene_id) %>% mutate(dge="dge"),
              by="gene_id") %>%
    mutate(dge=ifelse(is.na(dge), "not_dge", dge))



