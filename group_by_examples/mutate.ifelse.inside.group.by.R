### Association of lncRNAs and mRNAs: bethas
### February 13th 2020
### Libraries:
library(tidyverse)
library(magrittr)
library(reshape2)
options(stringsAsFactors = F)
setwd("/users/rg/ramador/D_me/RNA-seq/mRNA_lncRNA_patternanalysis")
source("/users/rg/ramador/Scripts/R-functions/Regeneration/color.palette.R")
library(factoextra)
library(NbClust)
library(schoolmath) #is.negative, is.positive

### input data
input <- readRDS("Results//association.mRNA.lncRNA.input.RDS")

### bethas analysis:

bethas <- input %>%
    mutate(lncRNA_control_t1=(Control.0h-L3)/(2-1)) %>%
    mutate(lncRNA_control_t2=(Control.15h-Control.0h)/(2-1)) %>%
    mutate(lncRNA_control_t3=(Control.25h-Control.15h)/(2-1)) %>%
    mutate(lncRNA_regene_t1=(Regeneration.0h-L3)/(2-1)) %>%
    mutate(lncRNA_regene_t2=(Regeneration.15h-Regeneration.0h)/(2-1)) %>%
    mutate(lncRNA_regene_t3=(Regeneration.25h-Regeneration.15h)/(2-1)) %>%
    mutate(PCG_control_t1=(mRNA_Control.0h-L3_mRNA)/(2-1)) %>%
    mutate(PCG_control_t2=(mRNA_Control.15h-mRNA_Control.0h)/(2-1)) %>%
    mutate(PCG_control_t3=(mRNA_Control.25h-mRNA_Control.15h)/(2-1)) %>%
    mutate(PCG_regene_t1=(mRNA_Regeneration.0h-L3_mRNA)/(2-1)) %>%
    mutate(PCG_regene_t2=(mRNA_Regeneration.15h-mRNA_Regeneration.0h)/(2-1)) %>%
    mutate(PCG_regene_t3=(mRNA_Regeneration.25h-mRNA_Regeneration.15h)/(2-1)) %>% 
    select(Gene_ID:Gene_Name, mRNA_ID, partnerRNA_gene,
           lncRNA_control_t1:lncRNA_control_t3,
           PCG_control_t1:PCG_control_t3,
           lncRNA_regene_t1:lncRNA_regene_t3,
           PCG_regene_t1:PCG_regene_t3) 


bethas$Gene_Name %>% str_detect("_") %>% table
bethas$partnerRNA_gene %>% str_detect("_") %>% table

bethas$pairs <- paste(bethas$Gene_Name,bethas$partnerRNA_gene, sep="_" )

bethas %<>%
    select(pairs, lncRNA_control_t1:PCG_regene_t3) #%>% as.data.frame

## rownames(bethas) <- bethas$pairs; bethas$pairs <- NULL

#### 

all_combinations <- bethas %>%
    mutate_at(vars(-contains("pairs")),
              ~ifelse(. > 0, "+", ifelse( . < 0, "-", "no_change"))) %>%
    group_by_at(vars(-pairs)) %>%
    summarise(F=n()) %>% arrange(desc(F)) %>% ungroup
    
control <- bethas %>% select_at(vars(contains("control"))) %>% 
    mutate_at(vars(contains("control")),
              ~ifelse(. > 0, "+", ifelse( . < 0, "-", "no_change"))) %>%
    group_by_all %>% summarise(F=n()) %>% arrange(desc(F)) %>% ungroup


regene <- bethas %>% select_at(vars(contains("regene"))) %>%
    mutate_at(vars(contains("regene")),
              ~ifelse(. > 0, "+", ifelse( . < 0, "-", "no_change"))) %>%
    group_by_all %>% summarise(F=n()) %>% arrange(desc(F)) %>% ungroup










