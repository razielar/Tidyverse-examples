# Some tidyverse examples:

1. [Arrange examples](#arrange)
2. [Group_by examples](#group)
3. [Mutate examples](#mutate)
4. [Select examples](#select)
5. [Count examples](#count)
6. [Gather and Spread](#gather)
7. [Benchmarks](#bench)

## 1)  <a id='arrange'></a> Arrange examples:

## 2) <a id='group'></a> Group_by examples:

## 3) <a id='mutate'></a> Mutate examples:

*mutate* examples can also be used in *select*

### 3.1) Mutate_at/select_at using regular expressions:

**Script**: *mutate.select.reg.expr.R*

**Description:** we can use regular expressions ([cheat sheet of regular expression for R](https://rstudio.com/wp-content/uploads/2016/09/RegExCheatsheet.pdf)) for *select_at* or *mutate_at* using the function: **matches**. See the script above for more details and see how to use *matches* and *replace* functions using a condition. This reg expression: | means: *or*.

```{r}

df %>%
  mutate_at(vars(matches("Control|Regeneration")),
                                            ~replace(., . < 1, 0))

df %>%
  select_at(vars(matches("FoldChange_(0|15|25)h_group$")))          

```

### 3.2) Mutate_at/select_at: using *replace* and *ifelse* statements:

**Script**: *mutate.multiple.ifelse.R*

**Description:** If you want to use multiple ifelse statements see the script above.

```{r}

df %>%
  mutate(new_status=ifelse(status == "Closed" | status == "Running", "Amount commitment only",
  "Amount with hypothesis" ))

```
### 3.3) Mutate_at/select_at: replace NA using *replace_na*:

**Script**: *complex.heatmap.foldchange.R*

**Description:** Replace *NAs* to 0.

```{r}

df %>%
  mutate_at(vars(matches("FoldChange_(0|15|25)h$")),
    ~replace_na(., replace = 0) )

```
### 3.4) Mutate: using str_detect and row_number():

**Script**: *mutate.str_detect.ifelse.row_numer.R*

**Description:** use inside mutate: ifelse, str_detect and row_number(). *str_detect* works as: str_detect(string or in this case column name, pattern).

```{r}

data %>%
  mutate(Biological_Sample=ifelse(str_detect(Dev_Time, "Adult"),
                                    paste("Adult", Biological_Sample, sep="_"),
                                    Biological_Sample)) %>%
    group_by(Biological_Sample) %>%
    mutate(Sample_Name= paste(Sample_Name, row_number(), sep="-")) %>% ungroup


```

## 4) <a id='select'></a> Select examples:

**Script**: *select.at.matches.inverse.R*

```{r}

df %>%
  select_at(vars(-c(matches("(CRG|_\\d+h$)"))))

```

## 5) <a id='count'></a> Count examples:

**Script**: *count.example.R*

**Description:** *count* function is the same as group_by and summarise(F=n())

```{r}
#group_by and summarise:

df %>%
  group_by(Gene_ID) %>%
  summarise(num_transcripts=n()) %>%
  group_by(num_transcripts) %>% summarise(F=n())

#count:

df %>% count(Gene_ID, name="num_transcripts") %>% count(num_transcripts)


```
## 6) <a id='gather'></a> Gather and spread example:

[Here](https://data.library.virginia.edu/a-tidyr-tutorial/) you have several good examples for gather and spread or you can see the script `gather_spread/gather.spread.example.R`

## 7) <a id='bench'></a> Benchmarks:

### 7.1) Benchmarks reading files in R:

**Script**: *benchmark.reading.comparison.R*

**Description:**  The method is feather but it's not the best compressing the file size.

<div align="center">
<img src="https://raw.githubusercontent.com/razielar/Dplyr-examples/master/img/benchmark.reading.png" alt="logo"></img>
</div>
