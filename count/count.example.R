### Update GeneID.Gene_Name.Gene_Type.Length.tsv
### April 13th 2020
### Libraries:
library(tidyverse)
library(magrittr)
options(stringsAsFactors = F)
setwd('/nfs/users2/rg/ramador/D_me/Data/Genes/dm6_r6.29')


### Input: 
trans <- read_tsv("lncRNAs//lncRNAs.GeneID.Gene_Name.TranscriptID.Transcript_Name.Gene_Type.Length.tsv")

### Comparison between count and group_by and summarise:

### 1) group_by and summarise:

trans %>% group_by(Gene_ID) %>%
    summarise(num_transcripts=n()) %>% 
    group_by(num_transcripts) %>% summarise(F=n())


### 2) count: 

trans %>% count(Gene_ID, name="num_transcripts") %>% count(num_transcripts)




