# https://github.com/thomasp85/ggforce
# https://ihaddadenfodil.com/post/it-s-a-bird-it-s-a-plane-it-s-a-ggforce-function/


install.packages("ggforce")
library(tidyverse)
library(ggforce)

df <- data.frame(
  x = seq(10),
  y = c(runif(9), 100),
  type = c(rep("small", 9), "big")
)

# Add facets with relative widths and heights to the numberf of breaks
ggplot(df, aes(x, y)) +
  geom_col() +
  ggforce::facet_row(. ~ type,
                     scales = "free",
                     space = "free")

# Zoom in to a region of the plot
ggplot2::ggplot(iris,
                ggplot2::aes(x = Petal.Length,
                    y = Petal.Width,
                    colour = Species)) +
  ggplot2::geom_point() +
  ggforce::facet_zoom(x = Species == "versicolor")
