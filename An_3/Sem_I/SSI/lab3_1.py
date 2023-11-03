import base64

# Mesaj criptat în format Base64
encrypted_message_base64 = "o9/khC3Pf3/9CyNCbdzHPy5oorccEawZSFt3mgCicRnihDSM8Obhlp3vviAVuBbiOtCSz6husBWqhfF0Q/8EZ+6iI9KygD3hAfFgnzyv9w=="

# Cheie secretă în format hexadecimal
hex_key = "ecb181a479a6121add5b42264db9b44b4b48d7d93c62c56a3c3e1aba64c7517a90ed44f8919484b6ed8acc4670db62c249b9f5bada4ed474c9e4d111308b614788cd4fbdc1e949c1629e12fa5fdbd9"

# Decodificăm mesajul criptat din Base64
encrypted_message = base64.b64decode(encrypted_message_base64)

# Decodificăm cheia secretă din reprezentarea hexadecimală
key = bytes.fromhex(hex_key)

# Aplicăm operația XOR pentru a decripta mesajul
decrypted_message = bytes(a ^ b for a, b in zip(encrypted_message, key))

# Convertim mesajul clar într-un șir de caractere
decrypted_message_str = decrypted_message.decode("utf-8")

# printeaza encrypted_message sub forma de 0 si 1
print("Encrypted message: ")
for i in encrypted_message:
    print(bin(i)[2:].zfill(8), end=" ")
print()

# printeaza key sub forma de 0 si 1
print("Key: ")
for i in key:
    print(bin(i)[2:].zfill(8), end=" ")
print()

# printeaza decrypted_message sub forma de 0 si 1
print("Decrypted message: ")
for i in decrypted_message:
    print(bin(i)[2:].zfill(8), end=" ")
print()

# Afișăm mesajul clar
print(decrypted_message_str)
