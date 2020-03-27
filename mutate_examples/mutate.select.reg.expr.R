### Polish results from: Fold.change.TPM.CRG.Comparison.R
### March 27 2020
### Libraries:
library(tidyverse)
library(magrittr)
options(stringsAsFactors = F)
setwd('/users/rg/ramador/D_me/RNA-seq/DGE_reanalysis/dme_r6.29/foldchange/')

### Input data:

fold_change <- read_tsv("Results/FoldChange.calculation.india.crg.tsv")

### --- Polish results: 
## 1) replace if gene expression < 1 TPM for 0
## 2) FoldChange group (up,down,flat):
##            For each time-point replace flat for NA if in both condition == 0
## 3) FoldChange (float):
##            For each time-point replace flat for NA if in both condition == 0

polish_results <- fold_change %>% mutate_at(vars(matches("Control|Regeneration")),
                                            ~replace(., . < 1, 0)) %>% 
    mutate_at(vars(matches("FoldChange_0h_group$")),
              ~replace(., Control.0h == 0 & Regeneration.0h == 0, NA)) %>%
    mutate_at(vars(matches("FoldChange_15h_group$")),
              ~replace(., Control.15h == 0 & Regeneration.15h == 0, NA)) %>%
    mutate_at(vars(matches("FoldChange_25h_group$")),
              ~replace(., Control.25h == 0 & Regeneration.25h == 0, NA)) %>%
    mutate_at(vars(matches("FoldChange_0h$")),
              ~replace(., Control.0h == 0 & Regeneration.0h == 0, NA)) %>%
    mutate_at(vars(matches("FoldChange_15h$")),
              ~replace(., Control.15h == 0 & Regeneration.15h == 0, NA)) %>%
    mutate_at(vars(matches("FoldChange_25h$")),
              ~replace(., Control.25h == 0 & Regeneration.25h == 0, NA)) 


## write.table(polish_results,
##             file = "Results//FoldChange.calculation.india.crg.polish.tsv",
##             sep="\t", quote = F, row.names = F, col.names = T)

### Appendix: 

fold_change %>% select_at(vars(matches("Control|Regeneration")))
fold_change %>% select_at(vars(matches("FoldChange_(0|15|25)h_group$")))
fold_change %>% select_at(vars(matches("FoldChange_0h_group$")))
fold_change %>% select_at(vars(matches("FoldChange_0h$")))



