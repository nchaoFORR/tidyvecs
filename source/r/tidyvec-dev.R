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

vec_engine = TidyVec()
vec_engine$vectorize("text")
vec_engine$lemmatize("text")


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


df %>% 
  sample_n(100) %>% 
  lemmatize("token")

df %>% 
  sample_n(100) %>% 
  bind_word_vectors("token")
