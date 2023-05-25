from sklearn.neural_network import MLPClassifier # importul clasei
import numpy as np

# h

train_images = np.loadtxt("data/train_images.txt")
train_labels = np.int32(np.loadtxt("data/train_labels.txt"))
test_images = np.loadtxt("data/test_images.txt")
test_labels = np.int32(np.loadtxt("data/test_labels.txt"))

# mlp_classifier_model = MLPClassifier(hidden_layer_sizes=(100, 100),
# activation='relu', learning_rate='constant', learning_rate_init=1e-2, momentum=0.9).fit(train_images, train_labels)

# mlp_classifier_model.score(test_images, test_labels)
# print(mlp_classifier_model.score(test_images, test_labels))

mlp_2 =  MLPClassifier(hidden_layer_sizes=(100, 100),
activation='relu', learning_rate='constant', learning_rate_init=1e-2).fit(train_images, train_labels)

print(mlp_2.score(test_images, test_labels))
