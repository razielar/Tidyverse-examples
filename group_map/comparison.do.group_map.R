### Comparison between do and group_map
### April 10th 2020
### Libraries:
library(tidyverse)
library(magrittr)
library(lubridate)
library(scales) #dollar_format
library(reshape2)
options(stringsAsFactors = F)
setwd('/home/razielar/Documents/SIRIS/SIRIS_internal_dashboard/')


######### 1) Input: 
proj_income <- readRDS("Data//proj_income.RDS")

######### 2) Using do: 

projects_second <- proj_income %>%
    mutate(amount_month= round(Income/round_project_length,
                               digits=2)) %>%
    mutate(new_end_date=start_date+months(round_project_length)) %>% 
    select(project, new_status, start_date,
           new_end_date, round_project_length, Income, amount_month) %>% 
    group_by(project, new_status, start_date, new_end_date,
             round_project_length, Income) %>%
    do(
        data.frame( amount_month= rep(.$amount_month,
                                      .$round_project_length) )
    ) %>%
    arrange(start_date, project) %>% ungroup %>% group_by(project) %>%
    mutate(start_date=start_date+months( row_number()-1 ) ) %>%
    mutate(new_end_date=start_date+months(1)) %>% ungroup

######### 3) Using group_map:





