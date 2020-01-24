library(tidyverse)

data('iris')

### Create clusters of tidy data
cluster_data <- function(df, cols = NA, algo = 'k-means', centers) {

  # If cols is NA, grab all numeric calls, otherwise grab
  # specified cols
  if(is.na(cols)) df <- df[, map_lgl(df, is.numeric)]
  else df <- df[, map_lgl(names(df), ~ . %in% cols)]
  
  if(algo == 'k-means') {
    cluster_model <- kmeans(df, centers=centers)
    df <-
      df %>% 
      mutate(cluster = cluster_model$cluster)
  }

  return(df)
  
}


cluster_data(iris, centers=3)
