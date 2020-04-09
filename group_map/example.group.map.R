######## Third plot analysis:
### Select by bins, regions or cluster k-means 
### November 12th 2019 
## Reading and writing data
t_current_directory <- "/Users/raziel/SIRIS/SIRIS_academics/"
setwd(t_current_directory)
source("functions/custom.global.variables.R")
source("functions//libraries.function.R")

library(OneR)

######## Input data:
Leiden_data_gathered_allyears <- tbl_df(read_csv("original_data/Data/Leiden_data_gathered_allyears.csv"))

### Select a field and indicator and do the bins: 
### Do the bins by year; each year the institutes might change 

reference_field <- "Biomedical and health sciences"
indicator <- "PP_Top10"

input_bin <- Leiden_data_gathered_allyears %>%
    filter(Field %in% reference_field & Indicator %in% indicator) %>%
    group_by(Period) %>% arrange(Indicator_Score, .by_group = T) 

input_bin$Indicator_Score %<>% round(., digits=4)

### Start binning:
indicator_value <- data.frame(Indicator_Score_Value=input_bin$Indicator_Score)

number <- 10:1
labels_bins <- paste("Rank", number, sep = "-") 

input_bin %<>% group_by(Period) %>%
    group_map(~ bin(., nbins = 10,
                    method="content", labels= labels_bins))

final <- cbind(as.data.frame(input_bin), indicator_value) %>%
    as_tibble()

final %>% group_by(Period, Indicator_Score ) %>%
    dplyr::summarise(F=n()) 

error_plor <-  final %>% group_by(Period, Indicator_Score) %>%
    dplyr::summarize(Median=median(Indicator_Score_Value),
                     Min=min(Indicator_Score_Value), Max=max(Indicator_Score_Value))

### Plot: 
error_plor$Indicator_Score <- factor(error_plor$Indicator_Score,
                                     levels = levels(error_plor$Indicator_Score)[c(10:1)])


final[grep("Paris", final$Institution),] %>%
    select(Institution) %>% unique

institutions <- c("Paris Descartes University", "Université Paris Diderot")

## pdf(file = "test_1.third.plot.pdf", paper = "a4r", width = 0, height = 0)

ggplot(data=error_plor, aes(x=Period, y=Median, group=Indicator_Score))+
    geom_line(linetype="solid")+geom_point(size=2)+
    geom_errorbar(aes(ymin=Min, ymax=Max), width=0.2, linetype="longdash")+
    geom_line(data = filter(final, Institution %in% institutions),
              aes(Period,Indicator_Score_Value, group=Institution, color=Institution),
              size=1.2)+xlab("")+ylab("Indicator Score")+
    theme(legend.position="top")

## dev.off()

### Start the plot:

## https://stackoverflow.com/questions/26020142/adding-shade-to-r-lineplot-denotes-standard-error
## https://stackoverflow.com/questions/12180515/using-geom-line-with-multiple-groupings
## http://www.sthda.com/english/wiki/ggplot2-error-bars-quick-start-guide-r-software-and-data-visualization

## pdf(file = "test.third.plot.pdf", paper = "a4r", width = 0, height = 0)
## ggplot(final, aes(x=Period, y=Indicator_Score_Value,
##                   group=Indicator_Score, colour=Indicator_Score))+geom_point()+
##     geom_line()

################## Appendix
## input_bin %>% group_by(Period) %>%
##     summarise(Mean=mean(.$Indicator_Score),
##               F=n())

## input_bin %>% group_by(Period) %>%
##     summarise(F=bin(.$Indicator_Score, method="content"))

## final %>% group_by(Period) %>%
##     group_map(~ tail(.x, 2L))

## final %>% group_by(Period) %>%
##     group_map(~ head(.x, 2L))

## number <- 85:1
## labels_bins <- paste("Top",number,sep="_")
## tapply(input_bin$Indicator_Score ,bin(input_bin$Indicator_Score, nbins = 85,
##                                       method="content", labels=labels_bins), length)
## tapply(input_bin$Indicator_Score ,bin(input_bin$Indicator_Score, nbins = 85,
##                                       method="content", labels = labels_bins), sd) %>% order




