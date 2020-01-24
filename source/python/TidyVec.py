"""
TidyVec Object provides the source of
word vectors and other nlp tools for R,
through reticulate.
"""

import numpy as np
from pandas import DataFrame
import spacy


class TidyVec:

    '''
    A tidy vec object represents an R tibble column.
        token_col = token column coming from an R tibble
        model = which (spacy) word embedding movel to use
    '''

    def __init__(self, model="en_core_web_sm"):
        self.model = spacy.load(model)

    """
    Vectorizes text column from R tibble..
    """

    def vectorize(self, token):
        return self.model(token).vector

    """
    Lemmatizes text column from R tibble
    """

    def lemmatize(self):
        return [doc.lemma for doc in self.docs]
