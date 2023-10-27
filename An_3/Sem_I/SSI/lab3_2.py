import base64

# Mesaj criptat în format Base64
encrypted_message_base64 = "o9/khC3Pf3/9CyNCbdzHPy5oorccEawZSFt3mgCicRnihDSM8Obhlp3vviAVuBbiOtCSz6husBWqhfF0Q/8EZ+6iI9KygD3hAfFgnzyv9w=="

# Mesaj clar
decrypted_message_str = "Orice text clar poate obtinut dintr-un text criptat cu OTP dar cu o alta cheie."

# Decodificăm mesajul criptat din Base64
encrypted_message = base64.b64decode(encrypted_message_base64)

# Codificăm mesajul clar în UTF-8
decrypted_message = decrypted_message_str.encode('utf-8')

# Aplicăm operația XOR pentru a afla cheia secretă
key = bytes(a ^ b for a, b in zip(encrypted_message, decrypted_message))

#printeaza encrypted_message sub forma de 0 si 1
print("Encrypted message: ")
for i in encrypted_message:
    print(bin(i)[2:].zfill(8), end=" ")
print()

#printeaza decrypted_message sub forma de 0 si 1
print("Decrypted message: ")
for i in decrypted_message:
    print(bin(i)[2:].zfill(8), end=" ")
print()

#printeaza key sub forma de 0 si 1
print("Key: ")
for i in key:
    print(bin(i)[2:].zfill(8), end=" ")
print()

# Afișăm cheia secretă
print(key.hex())