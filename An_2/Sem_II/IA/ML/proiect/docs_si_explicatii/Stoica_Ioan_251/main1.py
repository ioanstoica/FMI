# Importați modulele necesare pentru preprocesarea imaginilor, crearea modelului de rețea neuronală și optimizarea acestuia
from keras.preprocessing.image import ImageDataGenerator
from keras.models import Sequential
from keras.layers import Dense, Flatten
from keras.layers import Conv2D, MaxPooling2D
from keras.optimizers import SGD
import numpy as np # Folosit pentru operațiuni matematice
import pandas as pd # Folosit pentru manipularea datelor

# Setează dimensiunile imaginilor la 64x64 pixeli
img_width, img_height = 64, 64

# Calea către directoarele care conțin datele de antrenament, validare și test
train_data_dir = '/kaggle/input/unibuc-dhc-2023/train_images'
val_data_dir = '/kaggle/input/unibuc-dhc-2023/val_images'
test_data_dir = '/kaggle/input/unibuc-dhc-2023/test_images'

# Setează parametrii de antrenament: numărul de epoci, dimensiunea batch-ului și numărul de clase
epochs = 20
batch_size = 32
num_classes = 96

# Inițializează modelul secvențial
model = Sequential()
# Adaugă primul strat convoluțional cu 32 de filtre de dimensiunea 3x3, activare ReLU și specifică dimensiunea de intrare
model.add(Conv2D(32, (3, 3), activation='relu', input_shape=(img_width, img_height, 3)))
# Adaugă un strat de max pooling pentru a reduce dimensiunea spațială a outputului
model.add(MaxPooling2D(pool_size=(2, 2)))
# Adaugă al doilea strat convoluțional cu 64 de filtre și activare ReLU
model.add(Conv2D(64, (3, 3), activation='relu'))
# Adaugă un alt strat de max pooling
model.add(MaxPooling2D(pool_size=(2, 2)))
# Aplatizează outputul pentru a pregăti datele pentru stratul fully connected
model.add(Flatten())
# Adaugă un strat fully connected cu 256 de neuroni și activare ReLU
model.add(Dense(256, activation='relu'))
# Adaugă un strat de output cu număr de neuroni egal cu numărul de clase și funcție de activare softmax
# Funcția softmax este adesea utilizată în stratul de ieșire al unei rețele neuronale care este folosită pentru problemele de clasificare multi-clasă. Ea transformă vectorul de numere reale într-un vector de probabilități, astfel încât suma tuturor elementelor vectorului este 1. Fiecare element din vectorul de ieșire reprezintă probabilitatea ca exemplul dat să aparțină unei anumite clase.
# Mai precis, fiecare neuron din stratul de ieșire (câte unul pentru fiecare clasă posibilă) va produce un scor. Funcția softmax va transforma aceste scoruri în probabilități.
model.add(Dense(num_classes, activation='softmax'))

# Compilează modelul utilizând ca funcție de pierdere "categorical_crossentropy" și SGD ca optimizator, cu o rată de învățare de 0.01
model.compile(loss='categorical_crossentropy', optimizer=SGD(lr=0.01, decay=1e-6, momentum=0.9, nesterov=True), metrics=['accuracy'])

# Creează generatoare de imagini pentru antrenare și validare care vor scala imaginile la valori între 0 și 1
train_datagen = ImageDataGenerator(rescale = 1./255)
val_datagen = ImageDataGenerator(rescale = 1./255)

# Citirea datelor de antrenament și validare din fișierele CSV
train_df = pd.read_csv('/kaggle/input/unibuc-dhc-2023/train.csv')
val_df = pd.read_csv('/kaggle/input/unibuc-dhc-2023/val.csv')

# Convertirea coloanei "Class" la string pentru a putea fi utilizată în generatoarele de imagini
train_df['Class'] = train_df['Class'].astype(str)
val_df['Class'] = val_df['Class'].astype(str)

# Crearea generatoarelor de imagini pentru antrenare și validare, care vor returna batch-uri de imagini și etichete corespondente
train_generator = train_datagen.flow_from_dataframe(dataframe=train_df, directory=train_data_dir, x_col="Image", y_col="Class", class_mode="categorical", target_size=(img_width, img_height), batch_size=batch_size)
val_generator = val_datagen.flow_from_dataframe(dataframe=val_df, directory=val_data_dir, x_col="Image", y_col="Class", class_mode="categorical", target_size=(img_width, img_height), batch_size=batch_size)

# Antrenează modelul utilizând generatorul de antrenament, pentru numărul de epoci specificat și validând pe datele de validare
model.fit(train_generator, epochs=epochs, validation_data=val_generator)

# Citirea datelor de test din fișierul CSV
test_df = pd.read_csv("/kaggle/input/unibuc-dhc-2023/test.csv")
# Crearea unui generator de imagini pentru datele de test care va scala imaginile la valori între 0 și 1
test_datagen = ImageDataGenerator(rescale = 1./255)
# Crearea unui generator de imagini pentru datele de test, care va returna imagini unul câte unul, fără etichete
test_generator = test_datagen.flow_from_dataframe(dataframe=test_df, directory=test_data_dir, x_col="Image", y_col=None, class_mode=None, target_size=(img_width, img_height), batch_size=1, shuffle=False)

# Face predicții pe datele de test
predictions = model.predict(test_generator)
# Obține clasa predictată ca fiind indexul cu cea mai mare valoare din predicții
predicted_classes = np.argmax(predictions, axis=1)

# Creează un DataFrame cu numele imaginilor și clasele prezise și salvează-l într-un fișier CSV
results=pd.DataFrame({"Image": test_df["Image"], "Class": predicted_classes})
results.to_csv("/kaggle/working/rezultat.csv", index=False)
