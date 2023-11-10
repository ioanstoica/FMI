import secrets

# Generează o parolă de minim 10 caractere care conține cel puțin o literă mare, o literă mică, o cifră și un caracter special (.!$@).
# Parola trebuie să fie aleatoare.
password = ""
password = password + secrets.choice("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
password = password + secrets.choice("abcdefghijklmnopqrstuvwxyz")
password = password + secrets.choice("0123456789")
password = password + secrets.choice(".!$@")
password = password + secrets.token_hex(6)


print("Password: " + password)

# La ce poate să folosească într-o aplicație informatică această funcționalitate? Dați exemplu de un scenariu de utilizare
# La crearea unui cont pe un site, pentru a avea o parola sigura, care sa nu poata fi ghicita de un atacator.

# Generează un string URL-safe de (cel puțin) 32 caractere.
url = secrets.token_urlsafe(32)
print("URL: https://example.com/" + url)

# La ce poate să folosească într-o aplicație informatică această funcționalitate? Dați exemplu de un scenariu de utilizare.
# La generarea unor link-uri pentru documente partajate, in cazul in care imi doresc ca documentul sa poata fi accesat doar de catre cei care au link-ul,
# dar nu doresc sa fie accesibil de catre oricine.

# Generează un token hexazecimal de (cel puțin) 32 cifre hexazecimale.
token_hex = secrets.token_hex(32)

# La ce poate să folosească într-o aplicație informatică această funcționalitate? Dați exemplu de un scenariu de utilizare (diferit de scenariul anterior).
# La generarea token-urilor pentru API-uri.

# Verifică dacă 2 secvențe sunt identice sau nu, minimizând riscul unui atac de timp (timing attack).
secv1 = "abc"
secv2 = "abc"
print(
    "Secventele ("
    + secv1
    + ") si ("
    + secv2
    + ") sunt identice? "
    + str(secrets.compare_digest(secv1, secv2))
)

# Generează o cheie fluidă binară care ulterior să poată fi folosită pentru criptarea unui mesaj de 100 caractere.
key = secrets.token_bytes(100)
print("Key: " + str(key))

# Stochează parole folosind un modul / o librărie care să ofere un nivel suficient de securitate. Ce ați folosit? De ce?
# passlib si argon2_cffi
# De ce?
# implementeaza argon2
# De ce argon2?
# Pentru ca ne-ati recomandat-o la laboratorul 5:))

from passlib.hash import argon2

# Generați o parolă hashată
password = "parola_secreta"
hashed_password = argon2.using(rounds=12).hash(password)

# Verificați parola
is_valid = argon2.verify("parola_gresita", hashed_password)
print(is_valid)  # Va returna False
is_valid = argon2.verify("parola_secreta", hashed_password)
print(is_valid)  # Va returna True

# Am folosit si pip install argon2_cffi
