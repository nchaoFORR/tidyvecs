library(dplyr)
library(reticulate)

VENV_FP <- '~/Dev/virtualenvs/py3/'
TIDYVEC_FP <- '~/Dev/tidyvecs/source/python/TidyVec.py'

use_virtualenv(VENV_FP, require = TRUE)
source_python(TIDYVEC_FP)


# Lemmatize Function for tidy workflow
# token_col = name of column containing tokens (string)
# model = pretrained word-embedding model to used from spacy
lemmatize <- function(df, token_col, model = "en_core_web_sm") {
  engine = TidyVec(model)
  df %>% 
    mutate(lemma = purrr::map_chr(pull(df[token_col]), ~engine$lemmatize(.)))
}

### Vectorize function for tidy workflow
# token_col = name of column containing tokens (string)
# model = pretrained word-embedding model to used from spacy
bind_word_vectors <- function(df, token_col, model = "en_core_web_sm") {
  engine = TidyVec(model)
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