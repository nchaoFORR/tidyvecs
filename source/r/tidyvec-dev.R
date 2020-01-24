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

vec_engine = TidyVec(token_col=df["token"])
vec_engine$vectorize()


### Lemmatize Function for tidy workflow
lemmatize <- function(df, token_col, lemma = NA) {
  vec_engine = TidyVec(text_col=df[text_col])
  if(is.na(lemma)) {
    lemmas = vec_engine$lemmatize()
  }
  df[, "text_col"] <- lemmas
  return(df)
}


### Vectorize function for tidy workflow
vectorize <- function(df, token_col) {
  vec_engine = TidyVec(text_col=df[token_col])
  vectors = vec_engine$vectorize()

  # df <-
  #   df %>% 
  #   bind_cols(as.data.frame(vectors))
  
  return(vectors)
}


df %>% 
  vectorize(text_col = "text")
