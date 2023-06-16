from keras.preprocessing.image import ImageDataGenerator
from keras.models import Sequential
from keras.layers import Dense, Flatten
from keras.layers import Conv2D, MaxPooling2D
from keras.optimizers import SGD
from keras.preprocessing import image
import pandas as pd
import numpy as np
import os

# Dimensiunea imaginilor
img_width, img_height = 64, 64

# Calea directoarelor
train_data_dir = 'train_images'
val_data_dir = 'val_images'
test_data_dir = 'test_images'

# Parametri
epochs = 20
batch_size = 32
num_classes = 96 # numarul de clase

# Crearea modelului
model = Sequential()
model.add(Conv2D(32, (3, 3), activation='relu', input_shape=(img_width, img_height, 3)))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(64, (3, 3), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Flatten())
model.add(Dense(256, activation='relu'))
model.add(Dense(num_classes, activation='softmax'))

# Compilarea modelului
model.compile(loss='categorical_crossentropy', optimizer=SGD(lr=0.01, decay=1e-6, momentum=0.9, nesterov=True), metrics=['accuracy'])

# Citirea datelor de antrenament si validare
train_datagen = ImageDataGenerator(rescale = 1./255)
val_datagen = ImageDataGenerator(rescale = 1./255)

train_df = pd.read_csv("train.csv")
val_df = pd.read_csv("val.csv")

train_generator = train_datagen.flow_from_dataframe(dataframe=train_df, directory=train_data_dir, x_col="Image", y_col="Class", class_mode="categorical", target_size=(img_width, img_height), batch_size=batch_size)
val_generator = val_datagen.flow_from_dataframe(dataframe=val_df, directory=val_data_dir, x_col="Image", y_col="Class", class_mode="categorical", target_size=(img_width, img_height), batch_size=batch_size)

# Antrenarea modelului
model.fit(train_generator, epochs=epochs, validation_data=val_generator)

# Citirea si procesarea datelor de test
test_df = pd.read_csv("test.csv")
test_datagen = ImageDataGenerator(rescale = 1./255)
test_generator = test_datagen.flow_from_dataframe(dataframe=test_df, directory=test_data_dir, x_col="Image", y_col=None, class_mode=None, target_size=(img_width, img_height), batch_size=1, shuffle=False)

# Predictia claselor pentru datele de test
predictions = model.predict(test_generator)
predicted_classes = np.argmax(predictions, axis=1)

# Salvarea rezultatelor
results=pd.DataFrame({"Image": test_df["Image"], "Class": predicted_classes})
results.to_csv("rezultat.csv", index=False)
