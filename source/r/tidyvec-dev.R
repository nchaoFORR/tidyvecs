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

vec_engine = TidyVec(text_col=df["text"])
vec_engine$lemmatize()[[1]]


### Lemmatize Function for tidy workflow
lemmatize <- function(df, text_col, lemma = NA) {
  vec_engine = TidyVec(text_col=df[text_col])
  if(is.na(lemma)) {
    lemmas = vec_engine$lemmatize()
  }
  df[, "text_col"] <- lemmas
  return(df)
}


### Vectorize function for tidy workflow
vectorize <- function(df, text_col) {
  vec_engine = TidyVec(text_col=df[text_col])
  vectors = vec_engine$vectorize()

  # df <-
  #   df %>% 
  #   bind_cols(as.data.frame(vectors))
  
  return(vectors)
}


df %>% 
  vectorize(text_col = "text")
