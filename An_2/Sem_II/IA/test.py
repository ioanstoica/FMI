# adun 2 numere
def add(a, b):
    return a + b

# afiseaza suma lui 3 si 5 folosind functia add
print(add(3, 5))

# scrie o functie care calculeaza al n-lea numar din sirul lui Fibonacci
def fib(n):
    if n == 1 or n == 2:
        return 1
    return fib(n - 1) + fib(n - 2)

# afiseaza al 10-lea numar din sirul lui Fibonacci
print(fib(10))