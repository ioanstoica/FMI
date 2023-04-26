from sklearn.naive_bayes import MultinomialNB

naive_bayes_model = MultinomialNB(alpha=0, force_alpha=True, fit_prior=False)

# naive_bayes_model.fit([[1], [2], [1], [3], [3], [3], [3], [4]], ['F', 'F', 'F', 'F', 'B', 'B', 'B', 'B'])
naive_bayes_model.fit([[1], [1], [1], [1], [3], [3], [3], [3]], ['F', 'F', 'F', 'F', 'B', 'B', 'B', 'B'])

print(naive_bayes_model.predict([[3]]))
print(naive_bayes_model.predict([[1]]))

# print(naive_bayes_model.predict_proba([[1], [3]]))
# print(naive_bayes_model.predict_proba([[1]]))
