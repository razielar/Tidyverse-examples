pacman::p_load("rmarkdown", "knitr", "shiny", "feather", "DT", "tidyverse",
               "magrittr", "lubridate", "scales", "reshape2", "plotly",
               "shinycssloaders", "shinyWidgets" ,"ggh4x", "fitdistrplus",
               "jsTree", "jsonlite", "ggbeeswarm")


used_program <- input$program_ac_1_3

                                        # Baseline: 
count_all_years_baseline <- baseline %>% filter(area != "All") %>%
    filter(case_when(used_program == "Health Research" ~ year >= 2019,
                     used_program == "Caixaimpulse" ~ year >= 2016,
                     used_program == "Inphinit (Phds)" ~ year >= 2018,
                     used_program == "Junior Leader" ~ year >= 2018,
                     T ~ year >= 2014)) %>% 
    group_by(subject_area_full) %>%
    summarise(total_baseline=sum(n_pubs))

total_all_years_baseline <- baseline %>% filter(area == "All") %>%
    filter(case_when(used_program == "Health Research" ~ year >= 2019,
                     used_program == "Caixaimpulse" ~ year >= 2016,
                     used_program == "Inphinit (Phds)" ~ year >= 2018,
                     used_program == "Junior Leader" ~ year >= 2018,
                     T ~ year >= 2014)) %>% 
    summarise(total_baseline=sum(n_pubs)) %>%
    unlist %>% as.numeric 



