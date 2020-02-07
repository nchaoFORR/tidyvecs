library(reticulate)
library(tidytext)
library(dplyr)
library(janeaustenr)

VENV_FP <- '~/Dev/virtualenvs/py3/'
TIDYVEC_FP <- '~/Dev/tidyvecs/source/python/TidyVec.py'

use_virtualenv(VENV_FP, require = TRUE)
source_python(TIDYVEC_FP)

###

df <- austen_books()

df <- 
  df %>% 
  unnest_tokens(token, text)

### Lemmatize Function for tidy workflow
lemmatize <- function(df, token_col, lemma = NA) {
  engine = TidyVec()
  df %>% 
    mutate(lemma = purrr::map_chr(pull(df[token_col]), ~engine$lemmatize(.)))
}


### Vectorize function for tidy workflow
bind_word_vectors <- function(df, token_col) {
  engine = TidyVec()
  df %>% 
    bind_cols(
      purrr::map_dfr(pull(df[token_col]), function(token) {
        tibble(val = engine$vectorize(token)) %>% 
          tibble::rowid_to_column('var') %>% 
          mutate(var = paste0("dim_", var)) %>% 
          tidyr::spread(var, val)
      })
    )
}


### Create clusters of tidy data
cluster_data <- function(df, cols = NA,centers,  algo = 'k-means') {
  # If cols is NA, grab all numeric calls, otherwise grab
  # specified cols
  if(is.na(cols)) df <- df[, purrr:::map_lgl(df, is.numeric)]
  else df <- df[, map_lgl(names(df), ~ . %in% cols)]
  if(algo == 'k-means') {
    cluster_model <- kmeans(df, centers=centers)
    df <-
      df %>% 
      mutate(cluster = cluster_model$cluster)
  }
  return(df)
}


df %>% 
  sample_n(100) %>% 
  lemmatize("token")

df %>% 
  sample_n(100) %>% 
  bind_word_vectors("token")

df %>% 
  sample_n(100) %>% 
  bind_word_vectors("token") %>% 
  cluster_data(centers=15)
