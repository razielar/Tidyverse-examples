require(ggplot2)
require(grid)
install.packages("palmerpenguins")
library(palmerpenguins)
data(package = 'palmerpenguins')
head(penguins)

# https://stackoverflow.com/questions/28436855/change-the-number-of-breaks-using-facet-grid-in-ggplot2
# defining the breaks function, 
# s is the scaling factor (cf. multiplicative expand)
equal_breaks <- function(n = 3, s = 0.05, ...){
  function(x){
    # rescaling
    d <- s * diff(range(x)) / (1 + 2 * s)
    round(seq(min(x) + d, max(x) - d, length = n), 2)
  }
}

ggplot2::ggplot(penguins, ggplot2::aes(x = species, y = bill_length_mm, color = sex)) +
  ggplot2::geom_boxplot() +
  ggplot2::facet_wrap(~ island, scales = "free") +
  ggplot2::scale_y_continuous(
    # Set exactly 3 breaks
    breaks = equal_breaks(n = 3, s = 0.05),
    # use same s as first expand argument, 
    # second expand argument should be 0
    expand = c(0.05, 0),
    # Remove unnecessary 0 to the right of the decimal
    labels = function(x) sapply(x, FUN = function(i) format(x = i, nsmall = 0)))
