### Debugging plots DC-14
### Agust 4th 2020
### Libraries:
library(tidyverse)
library(plotly)
library(magrittr)
library(feather)
library(reshape2)
options(stringsAsFactors = F)
setwd('/home/razielar/Documents/SIRIS/la_caixa/la_caixa_debugging_report/')

### Input data:

dc_14 <- read_feather("feather_files//DC14.feather") %>%
    mutate(affiliation=
               gsub("no publications$", "no publications after PhD", affiliation))

## there're NA in affiliations: 7: 148,158,257,534

baseline <- read_csv("Data//DC-14.baseline.MC.csv") %>%
    select(phdId, universityLeidenName, leidenRank) %>%
    filter(!is.na(leidenRank)) %>% arrange(leidenRank) %>%
    rename(author=phdId, affiliation=universityLeidenName,
           ranking=leidenRank) %>%
    filter(!is.na(affiliation)) %>%
    mutate(affiliation=gsub("University Of Cambridge",
                            "University of Cambridge", affiliation))


############## --- 1) Ranking: 

breaks_ranking <- c(0,20,40,60,80,
            100, 120,140,160,180,
            200, 220,240,260,280,
            300, 320, 340, 360, 380,
            400, 420, 440,460,480,
            500, 520, 540, 560, 580,
            600, 620, 640, 660, 680,
            700, 720, 740, 760, 780,
            800, 820, 840, 860, 880,
            900, 920, 940, 960)


dc_14_caixa_ranking <- dc_14 %>% filter(!is.na(ranking)) %>%
    group_by(affiliation, ranking) %>%
    summarise(number_fellows=n()) %>%
    arrange(ranking) %>% ungroup %>% 
    mutate(bins=cut(ranking, breaks= breaks_ranking,
                    include.lowest = T, right = F)) %>%
    mutate(affiliation=paste(affiliation, ranking, sep=" (")) %>%
    mutate(affiliation=paste0(affiliation, ")")) %>% select(-ranking) %>%
    group_by(bins, affiliation) %>%
    summarise(number_fellows=sum(number_fellows)) %>% ungroup %>% 
    mutate(bins=as.character(bins)) %>%
    rename(caixa_affiliation=affiliation,
           caixa_number_fellows=number_fellows) %>%
    mutate(bins=str_sort(bins, numeric = T))


##### Baseline: 

### Binning data: 


dc_14_caixa_baseline_ranking <- baseline %>%
    group_by(affiliation, ranking) %>%
    summarise(number_fellows=n()) %>% arrange(ranking) %>%
    ungroup %>% 
    mutate(bins=cut(ranking, breaks= breaks_ranking,
                    include.lowest = T, right = F)) %>%
    mutate(affiliation=paste(affiliation, ranking, sep=" (")) %>%
    mutate(affiliation=paste0(affiliation, ")")) %>%
    select(-ranking) %>%
    group_by(bins) %>%
    summarise(number_fellows=sum(number_fellows),
              num_aff=n(),
              all_aff=paste(affiliation, collapse=", ")) %>%
    rename(MC_baseline_number_fellows=number_fellows,
           MC_baseline_affiliations= all_aff,
           MC_baseline_number=num_aff) %>%
    full_join(., dc_14_caixa_ranking, by="bins") %>%
    select(bins, caixa_affiliation, caixa_number_fellows,
           MC_baseline_affiliations, MC_baseline_number_fellows) %>%
    mutate(caixa_affiliation=replace_na(caixa_affiliation, "")) %>%
    mutate(caixa_number_fellows=replace_na(caixa_number_fellows, 0))



