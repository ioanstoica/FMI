# Scrie in python un server de DNS,
#  care sa trimita cererile mai departe la 8.8.8.8, 
# si sa raspunda cu raspunsul primit
# si sa poate raspunde la mai multe cereri in paralel.

# cum opresc un porces in Windows Power Shell?
# - opreste procesul care asculta pe portul 53:
# taskkill /PID 1234 /F

# scrie in python un server care sa poata sa raspunda in paralel la mai multe cereri

import concurrent.futures

with concurrent.futures.ThreadPoolExecutor(max_workers=2) as executor:
    future = executor.submit(pow, 2, 4)
    future2 = executor.submit(pow, 2, 4)
    print(future.result())
    print(future2.result())