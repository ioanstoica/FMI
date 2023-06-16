# adauga  regularizare la modelul de mai jos. (de exemplu, dropout sau regularizare L1 / L2),

from keras.preprocessing.image import ImageDataGenerator
from keras.models import Sequential
from keras.layers import Dense, Flatten
from keras.layers import Conv2D, MaxPooling2D
from keras.optimizers import SGD
from keras.preprocessing import image
from keras.layers import Dropout, BatchNormalization
from keras.optimizers import Adam

# This Python 3 environment comes with many helpful analytics libraries installed
# It is defined by the kaggle/python Docker image: https://github.com/kaggle/docker-python
# For example, here's several helpful packages to load

import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)

# Input data files are available in the read-only "../input/" directory
# For example, running this (by clicking run or pressing Shift+Enter) will list all files under the input directory

import os
#for dirname, _, filenames in os.walk('/kaggle/input'):
 #   for filename in filenames:
  #      print(os.path.join(dirname, filename))

# You can write up to 20GB to the current directory (/kaggle/working/) that gets preserved as output when you create a version using "Save & Run All" 
# You can also write temporary files to /kaggle/temp/, but they won't be saved outside of the current session

# Dimensiunile imaginilor
img_width, img_height = 64, 64

# Calea directoarelor
train_data_dir = '/kaggle/input/unibuc-dhc-2023/train_images'
val_data_dir = '/kaggle/input/unibuc-dhc-2023/val_images'
test_data_dir = '/kaggle/input/unibuc-dhc-2023/test_images'

# Parametri
epochs = 5
batch_size = 32
num_classes = 96 # numarul de clase

# Crearea modelului
model = Sequential()
model.add(Conv2D(32, (3, 3), activation='relu', padding='same', input_shape=(img_width, img_height, 3)))
model.add(BatchNormalization())
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))

model.add(Conv2D(64, (3, 3), activation='relu', padding='same'))
model.add(BatchNormalization())
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))

model.add(Conv2D(128, (3, 3), activation='relu', padding='same'))
model.add(BatchNormalization())
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))

model.add(Flatten())
model.add(Dense(512, activation='relu'))
model.add(BatchNormalization())
model.add(Dropout(0.5))
model.add(Dense(num_classes, activation='softmax'))

# Compilarea modelului
model.compile(loss='categorical_crossentropy', optimizer=Adam(learning_rate=0.001), metrics=['accuracy'])

# Preprocesarea imaginilor
train_datagen = ImageDataGenerator(
    rescale=1./255,
    rotation_range=15,
    width_shift_range=0.1,
    height_shift_range=0.1,
    horizontal_flip=True,
)
val_datagen = ImageDataGenerator(rescale = 1./255)

train_df = pd.read_csv('/kaggle/input/unibuc-dhc-2023/train.csv')
val_df = pd.read_csv('/kaggle/input/unibuc-dhc-2023/val.csv')

# Convertirea coloanei "Class" la string
train_df['Class'] = train_df['Class'].astype(str)
val_df['Class'] = val_df['Class'].astype(str)

train_generator = train_datagen.flow_from_dataframe(dataframe=train_df, directory=train_data_dir, x_col="Image", y_col="Class", class_mode="categorical", target_size=(img_width, img_height), batch_size=batch_size)
val_generator = val_datagen.flow_from_dataframe(dataframe=val_df, directory=val_data_dir, x_col="Image", y_col="Class", class_mode="categorical", target_size=(img_width, img_height), batch_size=batch_size)


#train_generator = train_datagen.flow_from_dataframe(dataframe=train_df, directory=train_data_dir, x_col="Image", y_col="Class", class_mode="categorical", target_size=(img_width, img_height), batch_size=batch_size)
#val_generator = val_datagen.flow_from_dataframe(dataframe=val_df, directory=val_data_dir, x_col="Image", y_col="Class", class_mode="categorical", target_size=(img_width, img_height), batch_size=batch_size)

# Antrenarea modelului
model.fit(train_generator, epochs=epochs, validation_data=val_generator)

# Citirea si procesarea datelor de test
test_df = pd.read_csv("/kaggle/input/unibuc-dhc-2023/test.csv")
test_datagen = ImageDataGenerator(rescale = 1./255)
test_generator = test_datagen.flow_from_dataframe(dataframe=test_df, directory=test_data_dir, x_col="Image", y_col=None, class_mode=None, target_size=(img_width, img_height), batch_size=1, shuffle=False)

# Predictia claselor pentru datele de test
predictions = model.predict(test_generator)
predicted_classes = np.argmax(predictions, axis=1)

# Salvarea rezultatelor
results=pd.DataFrame({"Image": test_df["Image"], "Class": predicted_classes})
results.to_csv("/kaggle/working/rezultat.csv", index=False)