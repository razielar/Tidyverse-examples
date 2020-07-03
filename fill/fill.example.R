### Keep only one PCG for classification purpose
### July 1st 2020 
### Libraries:
library(tidyverse)
library(magrittr)
options(stringsAsFactors = F)
setwd('/users/rg/ramador/D_me/RNA-seq/Genomic_Location_lncRNAs/dm6_r6.29/cleanSpurious_lncRNAs_genome_wide/')

### Input data:

input <- read_tsv("Results//percentage.overlapping.genic.exonic.PCG.by.exon.tsv")

all_genic_exonic <- read_tsv("Data//genic.exonic.all.pairs.transcript.information.tsv") %>%
    rename("lncRNA_Name" = "lncRNA_gene", "mRNA_Name" = "partnerRNA_gene",
           "lncRNA_transcript_name"="lncRNA_transcript",
           "mRNA_transcript_name"= "partnerRNA_transcript") 

genic_exonic <- read_tsv("Results//percentage.overlapping.genic.exonic.PCG.by.exon.tsv") %>%
    select(chr, lncRNA_ID, lncRNA_Name, lncRNA_strand, mRNA_ID, mRNA_Name,
           mRNA_gene_length, mRNA_strand, 
           Final_Percentage_overlapping)


### Analysis: 

# mRNA_transcript_length and Final_Percentage_overlapping
## didn't change the output. 

class <- input %>% group_by(lncRNA_ID) %>%
    top_n(1, wt=mRNA_gene_length) %>% top_n(-1, wt=mRNA_Name) %>%
    ungroup %>% left_join(., all_genic_exonic,
                          by=c("lncRNA_ID", "lncRNA_Name",
                               "lncRNA_transcript_name", 
                               "mRNA_ID", "mRNA_Name",
                               "mRNA_transcript_name")) %>%
    select(-c(Number_overlapping)) %>% select(chr:mRNA_strand,
                                              direction:location,
                                              Final_Percentage_overlapping,
                                              Number_overlapping_genes)


## write_tsv(class, path="Results/classification.genic.exonic.complete.info.tsv")

class_summary <- class %>% select_at(vars(-c(matches("transcript"))))

class_summary %>%
    count(type, location, direction, subtype) %>%
    mutate(Total=sum(n))


### --- Save classification and the 741 genic-exonic_mRNA paris:

class_overlapping <- class_summary %>%
    right_join(., genic_exonic,
               by=c("chr", "lncRNA_ID", "lncRNA_Name","lncRNA_strand",
                    "mRNA_ID", "mRNA_Name", "mRNA_gene_length",
                    "mRNA_strand", "Final_Percentage_overlapping")) %>%
    group_by(lncRNA_ID) %>% 
    mutate(Number_overlapping_genes=n()) %>%
    fill(c(direction, type, distance, subtype, location),
         .direction = "downup") %>% ungroup


## write_tsv(class_overlapping, path="Results//percentage.overlapping.genic.exonic.PCG.by.exon.Classification.tsv")




