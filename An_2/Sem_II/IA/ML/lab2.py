import numpy as np
from sklearn.naive_bayes import MultinomialNB

naive_bayes_model = MultinomialNB()

X_train = [[0,0,0,1 ], [0,0,1,0], [0,0,0,1], [0,1,0,0], [0,1,0,0], [0,1,0,0], [0,1,0,0], [1,0,0,0]]
# X_train = [[1 ], [1], [1], [1],  [0], [0]]
y_train = ['F', 'F', 'F', 'F',  'B', 'B', 'B', 'B']

naive_bayes_model.fit(X_train, y_train)

X_test = [[0,0,0,1]]

print(naive_bayes_model.predict(X_test))
print(naive_bayes_model.predict_proba(X_test))
