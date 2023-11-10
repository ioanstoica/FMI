# Laboratorul 5, Exercitiul 1
# 1. Linear Feedback Shift Registers (LFSRs)

# Implementați un LFSR definit peste F2 care permite citirea de la tastatură a coeficienților c1, ... cL și a stării inițiale s0, ..., sL-1 (toate aceste valori sunt elemente binare, 0 sau 1). Generați și afișați secvența de ieșire pentru o perioadă completă și valoarea perioadei. Testați funcționarea corectă pe exemplul din Tabelul 1 prezent în sursa indicată mai sus.

# An LFSR of length L over Fq (see finite field) is
# a finite state automaton which produces a semiinfinite sequence of elements of Fq , s = (st)t≥0 =
# s0s1... , satisfying a linear recurrence relation of
# degree L over Fq

# Default
# L = 4
# (c1, c2, c3, c4) = (0, 0, 1, 1)
# (s0, s1, s2, s3) = (1, 0, 1, 1)

L = 4
c = [0, 0, 1, 1]
s = [1, 0, 1, 1]


def read_input():
    L = int(input("L = "))
    for i in range(L):
        c.append(int(input("c" + str(i) + " = ")))
    for i in range(L):
        s.append(int(input("s" + str(i) + " = ")))
    return L, c, s


# read_input()

print("L = ", L)
print("c = ", c)
print("s = ", s)


def LFSR(L, c, s):
    for i in range(L):
        s.append(s[i] ^ c[i])
    return s


# for i in range(10):
#     for j in range(L):
#         print("s" + str(i * L + j) + " = ", s[i])


def lfsr_fib():
    start_state = 0xACE1  # Any nonzero start state will work.
    lfsr = start_state
    bit = 0
    period = 0

    while True:
        # taps: 16 14 13 11; feedback polynomial: x^16 + x^14 + x^13 + x^11 + 1
        bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5)) & 1
        lfsr = (lfsr >> 1) | (bit << 15)
        period += 1

        if lfsr == start_state:
            break

    return period


# Example usage
result = lfsr_fib()
print(f"Period of the LFSR: {result}")
