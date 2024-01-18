import hashlib

hashes = [
    "602a4a8fff652291fdc0e049e3900dae608af64e5e4d2c5d4332603c9938171d",
    "f40e838809ddaa770428a4b2adc1fff0c38a84abe496940d534af1232c2467d5",
    "aa105295e25e11c8c42e4393c008428d965d42c6cb1b906e30be99f94f473bb5",
    "70f87d0b880efcdbe159011126db397a1231966991ae9252b278623aeb9c0450",
    "77a39d581d3d469084686c90ba08a5fb6ce621a552155730019f6c02cb4c0cb6",
    "456ae6a020aa2d54c0c00a71d63033f6c7ca6cbc1424507668cf54b80325dc01",
    "bd0fd461d87fba0d5e61bed6a399acdfc92b12769f9b3178f9752e30f1aeb81d",
    "372df01b994c2b14969592fd2e78d27e7ee472a07c7ac3dfdf41d345b2f8e305",
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
        if hash in hashes:
            headers.append(Header(X, Y, text, hash))

# sort headers by X*Y
headers.sort(key=lambda header: header.X * header.Y)

# print headers
for header in headers:
    print(header.text)
    print(header.hash)

# Read 8 images
images = []
for i in range(1, 9):
    with open("encrypted_files\File{}_encr.ppm".format(i), "rb") as f:
        images.append(f.read())

# sort images by size
images.sort(key=lambda image: len(image))

# append headers to images
for i in range(0, 8):
    images[i] = headers[i].text.encode("utf-8") + images[i]

# write images
for i in range(0, 8):
    with open("decrypted_files\File{}.ppm".format(i + 1), "wb") as f:
        f.write(images[i])
