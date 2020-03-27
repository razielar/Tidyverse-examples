# Some tidyverse examples:

## 1) Arrange examples:

## 2) Group_by examples:

## 3) Mutate examples:

Mutate examples can be used in select

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
