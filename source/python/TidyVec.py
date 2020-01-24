"""
TidyVec Object provides the source of
word vectors and other nlp tools for R,
through reticulate.
"""

import numpy as np
import spacy


class TidyVec:

    '''
    A tidy vec object represents an R tibble column.
        text_col = text column coming from an R tibble
        model = which (spacy) word embedding movel to use
    '''

    def __init__(self, text_col, model="en_core_web_sm"):
        self.text = text_col
        self.model = spacy.load(model)
        self.docs = [self.model(doc) for doc in self.text]

    """
    Vectorizes text column from R tibble..
    """

    def vectorize(self):
        return [doc.vector for doc in self.docs]

    """
    Lemmatizes text column from R tibble
    """

    def lemmatize(self):
        return [doc.lemma for doc in self.docs]
