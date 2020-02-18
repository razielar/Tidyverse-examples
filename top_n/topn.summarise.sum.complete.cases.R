### Post-analysis: obtain a table of 3 columns
### Goal, median of median of average and %target covered
### February 18th 2020
### Libraries:
library(tidyverse)
library(magrittr)
library(readxl)
library(googledrive)
options(stringsAsFactors = F)
setwd("/home/razielar/Documents/SIRIS/SDG_Serbia")

### Input data:
input <- read_csv("data//results.multiple.eu28.csv")

### Keep seriescodes > 5 countries and take lastest year by seriescode 

first_part <- input %>% filter(!is.na(Number_cou) & Number_cou > 5) %>% 
    group_by(goal, target, indicator, seriescode) %>%
    top_n(n=1, wt=timeperiod) %>% ungroup %>%
        group_by(goal, target, indicator) %>%
        summarise(mean_seriescode=round(mean(Result), digits = 4)) %>%
        ungroup %>% group_by(goal, target) %>%
        summarise(median_indicator=median(mean_seriescode)) %>%
        ungroup %>% group_by(goal) %>%
        summarise(result=round(median(median_indicator), digits = 4) ) %>%
        ungroup %>%
        rename(median.target_median.indicator_mean.seriescode=result)

### Second part keep track of indicators covered 

## input %>% select(goal:seriescode) %>%
##     group_by(goal) %>% summarise(F=n())


final_result <- input %>% select(goal:seriescode) %>% group_by(goal) %>%
    summarise(Total_number_targets=n(),
              covered_targets=sum(complete.cases(seriescode))) %>%
    mutate(percentage_target_covered=round(covered_targets/Total_number_targets,
                                           digits = 4)) %>%
    select(goal,percentage_target_covered) %>%
    left_join(., first_part, by="goal") %>%
    select(goal, median.target_median.indicator_mean.seriescode,
           percentage_target_covered)

## write.csv(final_result, row.names=FALSE,
##           file="data/post.analysis.eu28.csv")



