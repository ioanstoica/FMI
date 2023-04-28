# https://fmi-unibuc-ia.github.io/ia/Laboratoare/Laboratorul%201.pdf
import numpy as np
from skimage import io

# a. Citiți imaginile din aceste fișiere și salvați-le într-un np.array (va avea
# dimensiunea 9x400x600).
images = []
for i in range(0,9):
   image = np.load('images/car_' + str(i) + '.npy')
   
   images.append(image)

# b. Calculați suma valorilor pixelilor tuturor imaginilor.
sum = 0
for image in images:
   sum += np.sum(image)
print(sum)

# c. Calculați suma valorilor pixelilor pentru fiecare imagine în parte.
for image in images:
   print(np.sum(image))

# d. Afișați indexul imaginii cu suma maximă.
max_sum = 0
max_index = 0
for i in range(0,9):
   sum = np.sum(images[i])
   if sum > max_sum:
      max_sum = sum
      max_index = i
print(max_index)

# e. Calculați imaginea medie și afișati-o.
mean_image = np.mean(images, axis=0)
io.imshow(mean_image.astype(np.uint8))

io.show()

# f. Cu ajutorul funcției np.std(images_array), calculați deviația standard a
# imaginilor. 
std = np.std(images, axis=(0,1,2))
print(std)

# g. Normalizați imaginile. (se scade imaginea medie și se împarte rezultatul la
# deviația standard)
for i in range(0,9):
   images[i] = (images[i] - mean_image) / std

# h. Decupați fiecare imagine, afișând numai liniile cuprinse între 200 și 300,
# respectiv coloanele cuprinse între 280 și 400.
for image in images:
   io.imshow(image[200:300, 280:400].astype(np.uint8))
   io.show()

