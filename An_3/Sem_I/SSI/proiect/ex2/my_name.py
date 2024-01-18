import hashlib
from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes

# read 1.pmm, 2.pmm, 3.pmm, 4.pmm from 'plain_text' folder
images = []
for i in range(1, 5):
    with open("plain_text\{}.ppm".format(i), "rb") as f:
        images.append(f.read())

headers = []

# extract headers from images
for image in images:
    headers.append(image[:14])
    image = image[14:]

# replace in headers '/n' with ' '
for i in range(0, 4):
    headers[i] = headers[i].replace(b"\n", b" ")

# print headers
for header in headers:
    print(header)

hashes = []
# compute hashes for headers
for header in headers:
    hashes.append(hashlib.sha256(header).hexdigest())

# print hashes
for hash in hashes:
    print(hash)

# cheie pentru AES
key = get_random_bytes(16)

# encrypt images using key and AES cipher
for i in range(0, 4):
    cipher = AES.new(key, AES.MODE_ECB)
    # Adăugarea de padding la date pentru a se potrivi cu dimensiunea blocului AES
    while len(images[i]) % 16 != 0:
        images[i] += b" "
    images[i] = cipher.encrypt(images[i])


# write encrypted images to 'encrypted_files' folder
for i in range(0, 4):
    with open("encrypted_letters\{}.ppm".format(i + 1), "wb") as f:
        f.write(images[i])
