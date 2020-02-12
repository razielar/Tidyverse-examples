### Association of lncRNAs and mRNAs 
### February 12th 2020
### Libraries:
library(tidyverse)
library(magrittr)
library(reshape2)
options(stringsAsFactors = F)
setwd("/users/rg/ramador/D_me/RNA-seq/mRNA_lncRNA_patternanalysis")
source("/users/rg/ramador/Scripts/R-functions/Regeneration/color.palette.R")

### input data:
dge <- read_tsv("Results//DGE.lncRNA.india.crg.genomiclocation.all.PCG.pairs.exonic.cutoff.mRNAs.expression.NA.0.GC.Descr.L3.cat.lincRNA.tsv")


### We want to know: how many lncRNAs are expressed >= 1 TPM in all conditions

## dge %>% distinct(Gene_ID, .keep_all = TRUE) %>%
##     filter(Control.0h >= 1 & Control.15h >= 1 & Control.25h >= 1 &
##            Regeneration.0h >= 1 & Regeneration.15h >= 1 & Regeneration.25h >= 1 &
##            L3 >= 1) 

### Select the desired pairs

input <- dge %>% filter(type == "genic" | cat_lincRNA == "proximal") %>%
    select(-c(Description, Percentage_gene_gc_content, Chr,
              phastCons27way, phastCons124way,
              mRNA_Description,mRNA_Percentage_gene_gc_content,
              direction:Overlap_Percentage)) %>%
    select_at(vars(-contains("Fold"))) %>%
    select(Gene_ID:Control.0h, Control.15h, Control.25h,
           Regeneration.0h, Regeneration.15h, Regeneration.25h,
           mRNA_ID:mRNA_Control.0h, mRNA_Control.15h, mRNA_Control.25h,
           mRNA_Regeneration.0h, mRNA_Regeneration.15h, mRNA_Regeneration.25h) 


## input %>% distinct(Gene_ID, .keep_all = TRUE) %>% select(type) %>%
##     group_by_all %>% summarise(N=n())

### We have a total of 118 lncRNAs: 73 genic and 45 lincRNA proximal
### We are going to remove the pairs from which the PCG is not expressed at all
### Obtaining 111 pairs 
### Replace by 0 if the expression is less than 1 TPM: 

input %<>% filter(!(is.na(L3_mRNA) & is.na(mRNA_Regeneration.25h))) %>%
    mutate_at(vars(contains("L3")), ~replace(., . < 1, 0)) %>%
    mutate_at(vars(contains("Control")), ~replace(., . < 1, 0)) %>%
    mutate_at(vars(contains("Regeneration")), ~replace(., . < 1, 0)) 


## Quality control to see if we grab what we want to 
## input %>% filter(!(is.na(L3_mRNA) & is.na(mRNA_Regeneration.25h))) %>%
##     select_at(vars(contains("Regeneration")))

######### Plot first example:

## pdf(file = "Plots//association.lncRNA.mRNA.pdf", paper = "a4r", width = 0, height = 0)

for(i in 1:nrow(input)){

    cat(i, "\n")
    
    tmp <- melt(input[i,])
    tmp$variable <- as.character(tmp$variable)
    tmp$variable[c(2:7,9:14)] %<>% 
        strsplit(., split=".", fixed=TRUE) %>% lapply(., function(x){y <- x[2]}) %>%
        unlist
    tmp$variable[8] <- "L3"
    tmp$variable <- as.factor(tmp$variable)
    tmp$variable <- factor(tmp$variable,
                           levels = levels(tmp$variable)[c(4,1:3)])

    tmp <- tmp %>% select(Gene_Name, partnerRNA_gene, variable, value)

    #Gene_Name, partnerRNA_gene and their values: 
    gene_name <- tmp[1,1]
    partner <- tmp[1,2]
    gene_value <- tmp[1,4]
    partner_value <- tmp[8,4]
    
    tmp <- tmp %>% add_row(., Gene_Name=gene_name, partnerRNA_gene=partner,
                           variable="L3", value=gene_value, .after = 4) %>%
        add_row(.,Gene_Name=gene_name, partnerRNA_gene=partner,
                variable="L3", value=partner_value, .after = 12)

    tmp$Treatment <- rep(c(rep("Control", 4), rep("Regeneration",4)),2)

    tmp[c(9:16),1] <- rep(tmp[1,2],8)
    tmp$partnerRNA_gene <- NULL
    
    #lncRNA always goes to the left:
    tmp$Gene_Name <- as.factor(tmp$Gene_Name)
    new_order <- match(as.character(unique(tmp$Gene_Name)), levels(tmp$Gene_Name))
    tmp$Gene_Name <- factor(tmp$Gene_Name,
                            levels = levels(tmp$Gene_Name)[ new_order ])


    p <- ggplot(data = tmp, aes(x=variable, y=value, group=Treatment))+
        geom_line( aes(linetype=Treatment, color=Treatment))+
        geom_point(aes(color=Treatment))+facet_wrap(~Gene_Name, scales = "free")+
        xlab("")+ylab("TPMs")+theme_light()+
        theme(legend.position = "bottom", strip.text = element_text(size=11))+
        labs(color="")+
        labs(linetype="")+
        scale_color_manual(values = c(control_sample, regene_sample))

    plot(p)

}
dev.off()










