import numpy as np

# Exercitiul 2
# Definiți funcția normalize_data(train_data, test_data, type=None) care primește ca 
# parametri datele de antrenare, respectiv de testare și tipul de normalizare ({None, 
# ‘standard’, ‘l1’, ‘l2’}) și întoarce aceste date normalizate.
def normalize_data(train_data, test_data, type_=None):
    # standard, l1, l2
    # N X F
    if type_ == 'standard':
        mean_train = np.mean(train_data, axis=0)
        std_train = np.std(train_data, axis=0)
        scaled_train_data = (train_data - mean_train) / std_train
        scaled_test_data = (test_data - mean_train) / std_train
    elif type_ == 'l1':
        norm_train = np.sum(np.abs(train_data), axis=1, keepdis=True) + 10 ** -8
        scaled_train_data = train_data / norm_train
        norm_test = np.sum(np.abs(test_data), axis=1, keepdims=True) + 10 ** -8
        scaled_test_data = test_data / norm_test
    elif type_ == 'l2':
        norm_train = np.sqrt(np.sum(train_data ** 2, axis=1, keepdims=True)) + 10 ** -8
        scaled_train_data = train_data / norm_train
        norm_test = np.sqrt(np.sum(test_data ** 2, axis=1, keepdims=True) )+ 10 ** -8
        scaled_test_data = test_data / norm_test
    else:
        raise Exception("Type not found")
    
    return scaled_train_data, scaled_test_data



# load toy data
# training_data = np.load('data/svm_train_data.npy')
# training_labels = np.load('data/svm_train_labels.npy')



# Exercitiul 3
class BagOfWords:
    def __init__(self):
        self.vocabulary = {} # word: id
        self.voc_len = 0
        self.words = []
        
    # Eercitiul 3
    def build_vocabulary(self, data):
        for sentence in data:
            for word in sentence:
                if word not in self.vocabulary:
                    self.vocabulary[word] = len(self.vocabulary)
                    self.words.append(word)
            self.voc_len = len(self.vocabulary)

    # Exercitiul 4 
    def get_features(self, data):
        features = np.zeros((len(data), self.voc_len))
        
        for id_sen, sentence in enumerate(data):
            for word in sentence:
                if word in self.vocabulary:
                    features[id_sen, self.vocabulary[word]] += 1
        return features
    
# l = [['ana', 'are', 'mere'], 'add', 'ss', 'sssssss', []]

train_sentences = np.load("data/training_sentences.npy", allow_pickle=True)
train_labels = np.load("data/training_labels.npy", allow_pickle=True)

test_sentences = np.load("data/test_sentences.npy", allow_pickle=True)
test_labels = np.load("data/test_labels.npy", allow_pickle=True)

bag_of_words = BagOfWords()
bag_of_words.build_vocabulary(train_sentences)

# Exercitiul 3
# Afișați dimensiunea vocabularul construit (9522).
print("Dimensiune vocabular: ")
print( bag_of_words.voc_len)

# Exercitiul 5
train_features = bag_of_words.get_features(train_sentences)
test_features = bag_of_words.get_features(test_sentences)
train_features_norm, test_features_norm = normalize_data(train_features, test_features, type_='l2')
    
# Exercitiul 6
from sklearn import svm

# svm_model = svm.SVC(C=1, kernel='linear')

# svm_model.fit(train_features_norm, train_labels)

# print("Acuratete: " )
# print(svm_model.score(test_features_norm, test_labels))


# Exercitiul 7
# nr de substringuri comune de lungime 2, dintre 2 exemple
svm_model_2 = svm.SVC(C=1, kernel='precomputed')

# svm_model_2.fit(train_features_norm, train_labels, )
# print(train_sentences)
# print(train_labels)
# print(test_sentences)
# print(test_labels)

# def get_common_substrings(data):
#     common_substrings = []
#     for sentence in data:
#         substrings = []
#         for word in sentence:
#             for i in range(len(word) - 1):
#                 substrings.append(word[i:i+2])
#         common_substrings.append(substrings)
#     return common_substrings

# train_substrings = get_common_substrings(train_sentences)
# test_substrings = get_common_substrings(test_sentences)

# train_substrings = bag_of_words.get_features(train_substrings)
# test_substrings = bag_of_words.get_features(test_substrings)

# train_substrings_norm, test_substrings_norm = normalize_data(train_substrings, test_substrings, type_='l2')

# svm_model_2.fit(train_substrings_norm, train_labels)

print("Acuratete: " )
# print(svm_model_2.score(test_substrings_norm, test_labels))

import numpy as np
from sklearn import svm, metrics

# Generam un set de date aleatorii
X = train_sentences
y = train_labels

def count_common_substrings(list1, list2):
    count = 0
    for string1 in list1:
        for i in range(len(string1) - 3):
            sustring1=string1[i:i+3]
            for string2 in list2:
                for j in range(len(string2) - 3):
                    sustring2=string2[j:j+3]
                    if sustring1==sustring2:
                        count+=1
                        break
            
    return count

# Calculam matricea de similaritate
K = np.zeros((len(X), len(X)))
for i in range(len(X)):
    for j in range(len(X)):
        K[i, j] = count_common_substrings(X[i], X[j])

# Definim si antrenam SVM-ul folosind matricea precalculata
svm_model = svm.SVC(C=1, kernel='precomputed')
svm_model.fit(K, y)

X_test = test_sentences
y_test = test_labels
K_test = np.zeros((len(X_test), len(X)))
for i in range(len(X_test)):
    for j in range(len(X)):
        K_test[i, j] = count_common_substrings(X_test[i], X[j])

# y_pred = svm_model.predict(K_test)

# print(y_pred)

# print score of the model
print("Accuracy: ", svm_model.score(K_test, y_test))



# def get_most_positive_negative_words(svm_model, vectorizer, n=10):
#     coeficients = svm_model.coef_[0]
#     feature_names = vectorizer.get_feature_names()
#     coeficients_dict = dict(zip(feature_names, coeficients))
#     sorted_coeficients = sorted(coeficients_dict.items(), key=lambda x: x[1], reverse=True)
#     most_positive_words = sorted_coeficients[:n]
#     most_negative_words = sorted_coeficients[-n:]
#     return most_positive_words, most_negative_words

# most_positive_words, most_negative_words = get_most_positive_negative_words(svm_model, vectorizer, n=10)
# from sklearn.feature_extraction.text import CountVectorizer

# vectorizer = CountVectorizer()
# train_features = vectorizer.fit_transform(train_data)
# train_features_norm = normalize_data(train_features, None, 'l2')

# most_positive_words, most_negative_words = get_most_positive_negative_words(svm_model, vectorizer, n=10)

# print("Cele mai pozitive cuvinte: ", [x[0] for x in most_positive_words])
# print("Cele mai negative cuvinte: ", [x[0] for x in most_negative_words])


# print("Cele mai pozitive cuvinte: ", [x[0] for x in most_positive_words])
# print("Cele mai negative cuvinte: ", [x[0] for x in most_negative_words])
