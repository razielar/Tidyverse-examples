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

fold_change %<>% mutate_at(vars(FoldChange_0h,FoldChange_15h,FoldChange_25h),
                          ~foldchange2logratio(., base=10)) %>%
    mutate_at(vars(FoldChange_0h,FoldChange_15h,FoldChange_25h),
              ~round(., digits = 4)) %>%
    mutate_at(vars(FoldChange_0h,FoldChange_15h,FoldChange_25h),
              ~replace(., . == -2 ,0)) %>%
    select(-c(Control.0h, Regeneration.0h,
              Control.15h, Regeneration.15h,
              Control.25h,Regeneration.25h)) %>% 
    mutate_at(vars(contains("_group")) ,
              ~replace_na(., replace = "flat"))


### Reorder the matrix
new_order <- fold_change %>% select_at(vars(contains("_group"))) %>%
    group_by_all() %>% summarise(Freq=n()) %>%
    arrange(desc(FoldChange_0h_group), desc(FoldChange_15h_group),
            desc(FoldChange_25h_group))

fold_change <- new_order %>%
    left_join(.,fold_change, by=c("FoldChange_0h_group",
                                  "FoldChange_15h_group",
                                  "FoldChange_25h_group")) %>%
    arrange(desc(FoldChange_0h_group),desc(FoldChange_15h_group),
            desc(FoldChange_25h_group), desc(FoldChange_0h),
            desc(FoldChange_15h),desc(FoldChange_25h)) %>% ungroup

## foldchange2logratio(., base=10))
foldchange2logratio(1.68, base = 10) %>% round(., digits = 4)
foldchange2logratio(-1.68, base = 10) %>% round(., digits = 4)

## bin the data: 
fold_change[which(fold_change$Gene_ID == "FBgn0260722"),][,7] <- 0.2000

#### Heatmap:
type <- c("Early", "Mid", "Late")
ha=HeatmapAnnotation(Time_Point=type, annotation_name_side = "left",
                     col=list(Time_Point=c("Early"=early, "Mid"=mid, "Late"=late)))

max_val <- as.matrix(fold_change[,7:ncol(fold_change)]) %>% max
min_val <- as.matrix(fold_change[,7:ncol(fold_change)]) %>% min

gradient_colors <- c("firebrick", dge_up,"white","white", dge_down, "dodgerblue4")

h=Heatmap(as.matrix(fold_change[,7:ncol(fold_change)]), name="log10(FoldChange)",
        cluster_columns = FALSE, column_title= "lncRNA DGE",
        cluster_rows = FALSE, show_column_names = FALSE,
        column_title_gp = gpar(fontsize = 15, fontface = "bold"),
        col= colorRamp2(c(max_val,0.2310,0.2253,-0.2253,-2.7,min_val), gradient_colors),
        top_annotation = ha,
        heatmap_legend_param = list(legend_height = unit(3.5, "cm"),at=c(-8,-2.5,0,2.5,8.5)))

## pdf(file = "Plots//heatmaps/heatmap.fold.change.pdf", paper = "a4r",
##     width = 0, height = 0)
## draw(h)
## dev.off()


