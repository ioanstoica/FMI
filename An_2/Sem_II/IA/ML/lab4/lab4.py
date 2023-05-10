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

svm_model = svm.SVC(C=1, kernel='linear')

svm_model.fit(train_features_norm, train_labels)

print("Acuratete: " )
print(svm_model.score(test_features_norm, test_labels))

# nr de substringuri comune de lungime 3, dintre 2 exemple

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
