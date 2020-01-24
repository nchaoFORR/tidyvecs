library(tidyverse)

data('iris')

### Create clusters of tidy data
cluster_data <- function(df, cols = NA, algo = 'k-means', ...) {

  # If cols is NA, grab all numeric calls, otherwise grab
  # specified cols
  if(is.na(cols)) df <- df[, map_lgl(df, is.numeric)]
  else df <- df[, map_lgl(names(df), ~ . %in% cols)]
  return(df)

}
