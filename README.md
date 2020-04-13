# Some tidyverse examples:

1. [Arrange examples](#arrange)
2. [Group_by examples](#group)
3. [Mutate examples](#mutate)
4. [Count examples](#count)

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

## 4) <a id='count'></a> Count examples:

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
