from Crypto.Cipher import AES

key = b"O cheie oarecare"
data = b"test"
# MODE_ECB
cipher = AES.new(key, AES.MODE_CCM)
print(cipher.encrypt(data))
