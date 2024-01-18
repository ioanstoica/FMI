import hashlib

hashes = [
'4e330d178d247c11b0fac0a6eaada74c3670310b77b4a0a51e6c04668321c77e',
'4e330d178d247c11b0fac0a6eaada74c3670310b77b4a0a51e6c04668321c77e',
'e4cadb0ff8f86dbd5e45bc65f63754f1d21f949db71a1c8924b227cdcdf7eee7',
'e4cadb0ff8f86dbd5e45bc65f63754f1d21f949db71a1c8924b227cdcdf7eee7',
]


class Header:
    def __init__(self, X, Y, text, hash):
        self.text = text
        self.X = X
        self.Y = Y
        self.hash = hash


headers = []

# Aflam dimensiunile imaginilor, folosind hash-urile date
for X in range(0, 1000):
    for Y in range(0, 1000):
        text = "P6 {} {} 255".format(X, Y)
        hash = hashlib.sha256(text.encode("utf-8")).hexdigest()
                
        # how many times hash is in hashes
        count = hashes.count(hash)
        for i in range(0, count):
            headers.append(Header(X, Y, text, hash))
        

# sort headers by X*Y
headers.sort(key=lambda header: header.X * header.Y)

# print headers
for header in headers:
    print(header.text)
    print(header.hash)


class Image:
    def __init__(self, data, order):
        self.data = data
        self.order = order


# Read 8 images
images = []
for i in range(1, 5):
    with open("encrypted_letters\{}.ppm".format(i), "rb") as f:
        images.append(Image(f.read(), i))

# sort images by size
images.sort(key=lambda image: len(image.data))

# append headers to images
for i in range(0, 4):
    images[i].data = headers[i].text.encode("utf-8") + images[i].data

# sort images by order
images.sort(key=lambda image: image.order)

# write images
for i in range(0, 4):
    with open("decrypted_letters\{}.ppm".format(images[i].order), "wb") as f:
        f.write(images[i].data)
