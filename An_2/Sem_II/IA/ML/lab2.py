# from sklearn.naive_bayes import MultinomialNB

# naive_bayes_model = MultinomialNB()

# X_train = [[1], [2], [1], [3], [3], [3], [3], [4]]
# y_train = ['F', 'F', 'F', 'F', 'B', 'B', 'B', 'B']

# naive_bayes_model.fit(X_train, y_train)

# X_test = [[1], [3]]
# y_pred = naive_bayes_model.predict(X_test)

# print(y_pred)

import numpy as np
from sklearn.naive_bayes import MultinomialNB

naive_bayes_model = MultinomialNB()

# X_train = [[1], [2], [1], [3], [3], [3], [3], [4]]
# y_train = ['F', 'F', 'F', 'F', 'B', 'B', 'B', 'B']

X_train = [[1,2 ], [1,2], [1,2], [1,2], [3,2], [3,2], [3,2], [3,2]]
# X_train = [[1], [1], [1], [1], [3], [3], [3], [3]]
y_train = ['F', 'F', 'F', 'F', 'B', 'B', 'B', 'B']

X_train_array = np.array(X_train).repeat(1000000, axis=0)
y_train_array = np.array(y_train).repeat(1000000, axis=0)

print(y_train_array)

naive_bayes_model.fit(X_train, y_train)

X_test = [[1,2], [3,2]]
# X_test = [[1], [3]]

# X_test = np.array(X_test) * 1000

y_pred = naive_bayes_model.predict(X_test)
# y_pred = y_pred / 1000

print(y_pred)

print(naive_bayes_model.predict_proba(X_test))
