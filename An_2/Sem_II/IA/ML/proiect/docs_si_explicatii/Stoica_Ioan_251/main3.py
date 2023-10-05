# Importarea bibliotecilor necesare
import torch
from torch import nn
from torchvision import transforms
from torch.utils.data import Dataset, DataLoader
import pandas as pd
from PIL import Image

# Definirea transformărilor pe care să le aplicăm imaginilor: transformare în tensor și normalizare
transform = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5))
])

# Crearea unui set de date personalizat
class CustomDataset(Dataset):
    def __init__(self, img_path, csv_file, transform=None):
        self.img_path = img_path  # calea către imaginile din setul de date
        self.annotations = pd.read_csv(csv_file)  # citirea anotărilor (etichetelor) din fișierul csv
        self.transform = transform  # transformările pe care să le aplicăm imaginilor

    def __len__(self):
        return len(self.annotations)  # numărul total de elemente în setul de date

    def __getitem__(self, index):
        img_id = self.annotations.iloc[index, 0]  # obține id-ul imaginii
        img = Image.open(f"{self.img_path}/{img_id}").convert("RGB")  # încarcă imaginea și convertește-o la RGB
        if self.transform:  # aplică transformările dacă sunt specificate
            img = self.transform(img)

        if len(self.annotations.columns) == 2:  # dacă avem și etichete în anotări
            y_label = torch.tensor(int(self.annotations.iloc[index, 1]))  # extrage eticheta corespunzătoare imaginii
            return (img, y_label)  # întoarce imaginea și eticheta
        else:
            return img  # altfel întoarce doar imaginea

# Calea către directorul cu imagini și fișierul de output
folder = 'kaggle/input/unibuc-dhc-2023/'
output_file = 'kaggle/working/submission.csv'

# Încărcarea seturilor de date de antrenament, validare și testare
train_data = CustomDataset(folder + 'train_images', folder + 'train.csv', transform)
val_data = CustomDataset(folder + 'val_images', folder+ 'val.csv', transform)
test_data = CustomDataset(folder+ 'test_images', folder + 'test.csv', transform)

# Crearea loaderelor de date care vor încărca datele în batch-uri
train_loader = DataLoader(train_data, batch_size=64, shuffle=True)
val_loader = DataLoader(val_data, batch_size=64, shuffle=True)
test_loader = DataLoader(test_data, batch_size=64, shuffle=False)

# Definirea modelului de rețea neurală convoluțională
model = nn.Sequential(
    nn.Conv2d(3, 16, 3, padding=1),  # primul strat convoluțional
    nn.ReLU(),  # activare ReLU
    nn.MaxPool2d(2, 2),  # strat de max pooling
    nn.Conv2d(16, 32, 3, padding=1),  # al doilea strat convoluțional
    nn.ReLU(),  # activare ReLU
    nn.MaxPool2d(2, 2),  # strat de max pooling
    nn.Flatten(),  # aplatizează tensorul pentru straturile fully connected
    nn.Linear(32*16*16, 500),  # primul strat fully connected
    nn.ReLU(),  # activare ReLU
    nn.Linear(500, 96)  # ultimul strat fully connected cu 96 de neuroni (numărul de clase)
)

# Definirea funcției de pierdere și a optimizatorului
criterion = nn.CrossEntropyLoss()  # funcția de pierdere pentru clasificare multiclase
optimizer = torch.optim.Adam(model.parameters(), lr=0.001)  # optimizatorul Adam cu learning rate 0.001

# Începe bucla de antrenare
print("Training started...")
for epoch in range(10):  # iterează peste setul de date de 10 ori
    for images, labels in train_loader:  # obține un batch de imagini și etichete
        # face o trecere înainte prin rețea
        outputs = model(images)
        # calculează pierderea
        loss = criterion(outputs, labels)

        # face o trecere înapoi și optimizează
        optimizer.zero_grad()  # setează gradientul la zero
        loss.backward()  # calculează gradientul
        optimizer.step()  # face un pas de optimizare
    print(f"Epoch: {epoch}")  # afișează epoca curentă

    # Validare
    correct = 0  # numărul de predicții corecte
    total = 0  # numărul total de imagini
    with torch.no_grad():  # nu avem nevoie să calculăm gradienții în validare
        for images, labels in val_loader:
            outputs = model(images)  # face o trecere înainte prin rețea
            _, predicted = torch.max(outputs.data, 1)  # obține clasa cu cea mai mare probabilitate
            total += labels.size(0)
            correct += (predicted == labels).sum().item()  # calculează numărul de predicții corecte

    print(f'Validation accuracy is: {100 * correct / total}%')  # afișează acuratețea pe setul de validare

# Testare
result = []  # lista pentru a stoca predicțiile
with torch.no_grad():  # nu avem nevoie să calculăm gradienții în testare
    for i, images in enumerate(test_loader):
        outputs = model(images)  # face o trecere înainte prin rețea
        _, predicted = torch.max(outputs.data, 1)  # obține clasa cu cea mai mare probabilitate
        for j in range(predicted.shape[0]):  # pentru fiecare imagine din batch
            result.append({"Image": test_data.annotations.iloc[i*64+j, 0], "Class": predicted[j].item()})  # adaugă predicția în lista de rezultate

# Scrie rezultatele într-un fișier CSV
df = pd.DataFrame(result)  # transformă lista într-un DataFrame
df.to_csv(output_file, index=False)  # scrie DataFrame-ul într-un fișier CSV
print("Done!")  # afișează mesajul "Done!" la sfârșitul executării
