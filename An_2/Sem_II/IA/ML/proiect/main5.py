import torch
from torch import nn
from torchvision import transforms
from torch.utils.data import Dataset, DataLoader
import pandas as pd
from PIL import Image

# Define the transformation
transform = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5))
])

# Create custom dataset
class CustomDataset(Dataset):
    def __init__(self, img_path, csv_file, transform=None):
        self.img_path = img_path
        self.annotations = pd.read_csv(csv_file)
        self.transform = transform

    def __len__(self):
        return len(self.annotations)

    def __getitem__(self, index):
        img_id = self.annotations.iloc[index, 0]
        img = Image.open(f"{self.img_path}/{img_id}").convert("RGB")
        if self.transform:
            img = self.transform(img)

        if len(self.annotations.columns) == 2:
            y_label = torch.tensor(int(self.annotations.iloc[index, 1]))
            return (img, y_label)
        else:
            return img

# Load the dataset
train_data = CustomDataset('/kaggle/input/unibuc-dhc-2023/train_images', '/kaggle/input/unibuc-dhc-2023/train.csv', transform)
val_data = CustomDataset('/kaggle/input/unibuc-dhc-2023/val_images', '/kaggle/input/unibuc-dhc-2023/val.csv', transform)
test_data = CustomDataset('/kaggle/input/unibuc-dhc-2023/test_images', '/kaggle/input/unibuc-dhc-2023/test.csv', transform)

# Create data loaders
train_loader = DataLoader(train_data, batch_size=64, shuffle=True)
val_loader = DataLoader(val_data, batch_size=64, shuffle=True)
test_loader = DataLoader(test_data, batch_size=64, shuffle=False)

# Define the model
model = nn.Sequential(
    nn.Conv2d(3, 16, 3, padding=1),
    nn.ReLU(),
    nn.MaxPool2d(2, 2),
    nn.Conv2d(16, 32, 3, padding=1),
    nn.ReLU(),
    nn.MaxPool2d(2, 2),
    nn.Flatten(),
    nn.Linear(32*16*16, 500),  # modified this line
    nn.ReLU(),
    nn.Linear(500, 96)  # we have 96 classes
)


# Define the loss and the optimizer
criterion = nn.CrossEntropyLoss()
optimizer = torch.optim.Adam(model.parameters(), lr=0.001)

# Training loop
for epoch in range(10):  # loop over the dataset multiple times
    for images, labels in train_loader:
        # forward pass
        outputs = model(images)
        loss = criterion(outputs, labels)

        # backward and optimize
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
    print(f"Training: {epoch}")

# Validation
correct = 0
total = 0
with torch.no_grad():
    for images, labels in val_loader:
        outputs = model(images)
        _, predicted = torch.max(outputs.data, 1)
        total += labels.size(0)
        correct += (predicted == labels).sum().item()

print(f'Validation accuracy is: {100 * correct / total}%')

# Testing
result = []
with torch.no_grad():
    for i, images in enumerate(test_loader):
        outputs = model(images)
        _, predicted = torch.max(outputs.data, 1)
        for j in range(predicted.shape[0]):
            result.append({"Image": test_data.annotations.iloc[i*64+j, 0], "Class": predicted[j].item()})

# Write to CSV
df = pd.DataFrame(result)
df.to_csv('/kaggle/working/submission.csv', index=False)
