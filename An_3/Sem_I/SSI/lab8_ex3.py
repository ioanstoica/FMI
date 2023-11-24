# 3. Detecția fișierelor pe baza valorii hash
# Realizați un script în Python care calculează valoarea SHA256 pentru un fișier de pe disk. Realizați un request către VirusTotal folosind VirusTotal API v3 [6] pentru hash-ul unui fișier și afișați numărul de vendori anti-virus care detectează acel fișier, interpretând răspunsul JSON primit.

import hashlib
import requests
import dotenv
import os

dotenv.load_dotenv()

file = "eicar.com"
hash = hashlib.sha256()
with open(file, "rb") as f:
    for chunk in iter(lambda: f.read(4096), b""):
        hash.update(chunk)  # hash.update(chunk) for Python 2.7.x

print(hash.hexdigest())

# Realizați un request către VirusTotal folosind VirusTotal API v3 [6]
url = "https://www.virustotal.com/api/v3/files/" + hash.hexdigest()

headers = {
    "accept": "application/json",
    "x-apikey": os.getenv("VIRUSTOTAL_API_KEY"),
}

response = requests.get(url, headers=headers)

with open("lab8_ex3_response_2.txt", "w") as f:
    f.write(response.text)
    print("Fisierul a fost detectat ca fiind malitios de catre: ", end="")
    print(response.json()["data"]["attributes"]["total_votes"]["malicious"], end=" ")
    print("vendori antivirus.")
