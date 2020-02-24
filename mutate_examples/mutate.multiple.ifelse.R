### Add Gene_ID of all neighbor PCGs 
### February 24th 2020
### Libraries:
library(tidyverse)
library(magrittr)
setwd('/users/rg/ramador/D_me/RNA-seq/Genomic_Location_lncRNAs/dm6_r6.29/analysis_lincRNA_distance')
options(stringsAsFactors = F)

### input data 
gene <- read_tsv("Data//GeneID.Gene_Name.Gene_Type.Length.tsv")
location <- read_tsv("Results//Genome.wide.classification.name.r6.29.PCG_ID.tsv")

lincRNAs <- location %>% filter(type == "intergenic") %>% distinct_all

genic <- location %>% filter(type == "genic") %>% rename(distance_tss=distance)

### Calculate distance from lncRNA TSS to PCG TSS: 

lncRNA_info <-  gene %>% select(Gene_ID, Length, Strand) %>%
    rename(lncRNA_ID=Gene_ID, lncRNA_length=Length, lncRNA_strand=Strand)

mRNA_info <- gene %>% select(Gene_ID, Length, Strand) %>%
    rename(mRNA_ID=Gene_ID, mRNA_length=Length, mRNA_strand=Strand)


genome_wide_tss <-  lincRNAs %>% left_join(., lncRNA_info, by="lncRNA_ID") %>%
    left_join(., mRNA_info, by="mRNA_ID") %>% 
    mutate(distance_tss=ifelse(subtype == "divergent", distance,
                        ifelse(subtype == "convergent",
                               lncRNA_length+distance+mRNA_length,
                        ifelse(subtype == "same_strand" & location == "upstream",
                               lncRNA_length+distance, "hola")))) %>%
    mutate(distance_tss=ifelse(subtype == "same_strand" & location == "downstream",
                               mRNA_length+distance, distance_tss)) %>%
    select(isBest:mRNA_ID, distance_tss) %>%
    select(isBest:type, distance_tss, subtype:mRNA_ID) %>%
    mutate(distance_tss= as.numeric(distance_tss)) %>% bind_rows(genic, .) %>%
    arrange(lncRNA_gene) 

## write.table(genome_wide_tss,
##             file = "Results//Genome.wide.classification.name.TSS.r6.29.PCG_ID.tsv",
##             sep="\t", quote = F, row.names = F, col.names = T)





