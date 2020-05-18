### May 18th 2020
### Libraries:
library(tidyverse)
library(magrittr)
library(ggthemes)
options(stringsAsFactors = F)
setwd('/home/razielar/Documents/Reza_paper/Figure_3D/')

### Input data:

input <- read_tsv("../Data//allTissue_voom_table.txt")
sleep <- read_tsv("../Data//sleep.txt")

## Not found genes: 
## "AC016745.1", "GFRAL", "HCRTR2", "NXF5", "OR9Q1"

### Obtain number of sleep genes: 
total_number <- input %>% right_join(., sleep, by= "name") %>%
    arrange(name, tissue) %>% filter(P.Value <= 0.05) %>%
    mutate(DGE=ifelse(logFC > 0, "Night", "Day")) %>%
    count(tissue, DGE) %>% spread(key=DGE, value= n) %>%
    group_by(tissue) %>%
    mutate(total_number=sum(Day, Night, na.rm= TRUE)) %>% 
    ungroup %>% arrange(desc(total_number)) %>%
    select(tissue, total_number, Day, Night) %>%
    mutate_at(vars(-c(matches("total"))), ~replace_na(., 0)) 

### Obtain total number: 
total <- input %>% arrange(name, tissue) %>% filter(P.Value <= 0.05) %>%
    mutate(DGE=ifelse(logFC > 0, "Night", "Day")) %>%
    count(tissue, DGE) %>% spread(key=DGE, value= n) %>%
    group_by(tissue) %>%
    mutate(total_number=sum(Day, Night, na.rm= TRUE)) %>%
    ungroup %>% select(tissue, total_number, Day, Night) %>%
    rename(Total=total_number, Total_Day=Day, Total_Night=Night) 

final_df <- total_number %>% left_join(., total, by="tissue") %>%
    mutate(per_Day=round(Day/Total_Day, digits = 4),
           per_Night=round(Night/Total_Night,digits= 4)) %>%
    group_by(tissue) %>% 
    mutate(total_per=round(sum(per_Day, per_Night), digits= 4)) %>%
    ungroup %>% arrange(desc(total_per)) %>%
    mutate(tissue= gsub("_-_"," ", tissue)) %>%
    mutate(tissue= gsub("_"," ", tissue)) %>%
    mutate(tissue= gsub("__"," ", tissue)) %>%
    mutate(tissue= gsub("  "," ", tissue)) %>%
    mutate(tissue= gsub(" $","", tissue))

## final_df %>% select_at(vars(matches("tissue|Night"))) %>% View


######## Preprocessing plot: 

plot_df <- final_df %>% select_at(vars(matches("tissue|per"))) %>%
    select(-total_per) %>% gather(key=DGE, value= per,
                                  per_Day, per_Night) %>%
    mutate(DGE=gsub("per_Day", "Day", DGE)) %>%
    mutate(DGE=gsub("per_Night", "Night", DGE)) %>%
    mutate(per=ifelse(DGE == "Night", -per, per))

cb <- colorblind_pal()(8)
plot_df$tissue <- as.factor(plot_df$tissue)
new_order <- match(final_df$tissue ,levels(plot_df$tissue))
plot_df$tissue <- factor(plot_df$tissue,
                         levels= levels(plot_df$tissue)[rev(new_order)])


#### Plot: 

pdf(file= "Plots//sleep_percent.pdf", paper= "a4r", width= 0, height = 0)

ggplot()+
    geom_bar(data=plot_df, aes(x=tissue, y=per, fill=DGE),
             stat="identity", width = 0.8, lwd=0.5, color="black")+
    labs(title = "", x="Tissues",
         y="Percentage of sleep/insomnia genes", fill= "")+
    scale_fill_manual(values= rev( c(cb[6], cb[2])  ) )+
    geom_hline(yintercept=0, color = "black", size=0.5)+
    coord_flip()+ annotate("text", x = 10, y = 0.03, label = "Day",
                           vjust="inward", hjust="inward")+
    annotate("text", x = 10, y = -0.03, label = "Night",
             vjust="inward", hjust="inward")+
    theme_classic(base_size = 16)+
    theme(legend.text = element_text(vjust=0.65,colour = 'black'),
          legend.key.height=unit(1,"cm"),
          legend.position="right")+
    scale_y_continuous(breaks = seq(-0.04, 0.04, 0.01),
                       labels= scales::percent_format())


dev.off()

## ggsave(plot=p1, file="Plots/sleep_percent.pdf",
##        height  = 20, width = 20, units = "cm", useDingbats=FALSE )




