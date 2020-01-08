###### Heatmap of lncRNAs using Fold-Change
### December 19th 2019
### Libraries:
library(tidyverse)
library(circlize)
library(magrittr)
library(ComplexHeatmap)
library(gtools)
options(stringsAsFactors = F)
setwd("/users/rg/ramador/D_me/RNA-seq/DGE_reanalysis/dme_r6.29/foldchange/after_cutoff/")
source("/users/rg/ramador/Scripts/R-functions/Regeneration/color.palette.R")

### Input Data:
## dge <- read_tsv("Results//DGE.lncRNA.india.crg.genomiclocation.124.27.way.all.PCG.pairs.exonic.cutoff.mRNAs.expression.NA.tsv")

## ### Replace NA for 0's in FoldChange numerical variable:

## replace_na_0 <- dge %>%  mutate_at(vars(FoldChange_0h,FoldChange_15h,FoldChange_25h),
##                    ~replace_na(., replace = 0) )

## write.table(replace_na_0, file = "Results//DGE.lncRNA.india.crg.genomiclocation.124.27.way.all.PCG.pairs.exonic.cutoff.mRNAs.expression.NA.0.tsv",
##             sep = "\t", col.names = T, row.names = F, quote = F)


dge <- read_tsv("Results//DGE.lncRNA.india.crg.genomiclocation.124.27.way.all.PCG.pairs.exonic.cutoff.mRNAs.expression.NA.0.01.tsv")

fold_change <- dge %>% select(Gene_ID, Gene_Name, Control.0h:Regeneration.25h,
                              FoldChange_0h_group, FoldChange_15h_group, FoldChange_25h_group,
                              FoldChange_0h:FoldChange_25h) %>% distinct()

### See the summary between foldchange and log10 foldchange: 
fold_change %>% select(FoldChange_0h) %>% summary
foldchange2logratio(fold_change$FoldChange_0h, base = 10) %>% summary

### Transform foldchange to log10-FoldChange: 

# See the summary withou replacing -2 which is basically 0 FoldChange (0.01):
## fold_change %>% mutate_at(vars(FoldChange_0h,FoldChange_15h,FoldChange_25h),
##                           ~foldchange2logratio(., base=10)) %>%
##     mutate_at(vars(FoldChange_0h,FoldChange_15h,FoldChange_25h),
##               ~round(., digits = 4)) %>%
##     select_at(vars(FoldChange_0h,FoldChange_15h,FoldChange_25h)) %>% summary

fold_change %>% select_at(vars(FoldChange_0h,FoldChange_15h,FoldChange_25h))

fold_change %<>% mutate_at(vars(FoldChange_0h,FoldChange_15h,FoldChange_25h),
                          ~foldchange2logratio(., base=10)) %>%
    mutate_at(vars(FoldChange_0h,FoldChange_15h,FoldChange_25h),
              ~round(., digits = 4)) %>%
    mutate_at(vars(FoldChange_0h,FoldChange_15h,FoldChange_25h),
              ~replace(., . == -2 ,0))

### Reorder the matrix

input <- read_tsv("Data//DGE.lncRNA.india.crg.genomiclocation.124.27.way.all.PCG.pairs.exonic.cutoff.FoldChange.mRNAs.tsv")

input %<>% distinct(Gene_ID, Gene_Name, FoldChange_0h_group,
                   FoldChange_15h_group, FoldChange_25h_group) %>%
    select(-c(Gene_ID, Gene_Name))

colnames(input) <- c("Early", "Mid", "Late")

input %>% group_by(Early, Mid, Late) %>%
    summarise(Freq=n())

new_order <- fold_change %>% select_at(vars(contains("_group"))) %>%
    group_by_all() %>% summarise(Freq=n()) 


new_order <- new_order[c(25:nrow(new_order),16:24, 1:8, 9:15),] 

fold_change <- new_order %>%
    left_join(.,fold_change, by=c("FoldChange_0h_group",
                                  "FoldChange_15h_group",
                                  "FoldChange_25h_group")) 

#### Heatmap: 
type <- c("Early", "Mid", "Late")

ha=HeatmapAnnotation(Time_Point=type, annotation_name_side = "left",
                     col=list(Time_Point=c("Early"=early, "Mid"=mid, "Late"=late)))


Heatmap(as.matrix(fold_change[,13:ncol(fold_change)]), name="log10(FoldChange)",
        cluster_columns = FALSE,
        cluster_rows = FALSE, show_column_names = FALSE,
        top_annotation = ha)

## h=Heatmap(as.matrix(fold_change[,13:ncol(fold_change)]), name="log10(FoldChange)",
##         cluster_columns = FALSE,
##         cluster_rows = FALSE, show_column_names = FALSE,
##         top_annotation = ha)


## pdf(file = "Plots//heatmaps/heatmap.fold.change.pdf", paper = "a4r",
##     width = 0, height = 0)
## draw(h)
## dev.off()




