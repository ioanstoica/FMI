# Laboratorul 5, Exercitiul 1
# 1. Linear Feedback Shift Registers (LFSRs)

# Implementați un LFSR definit peste F2 care permite citirea de la tastatură a coeficienților c1, ... cL și a stării inițiale s0, ..., sL-1 (toate aceste valori sunt elemente binare, 0 sau 1). Generați și afișați secvența de ieșire pentru o perioadă completă și valoarea perioadei. Testați funcționarea corectă pe exemplul din Tabelul 1 prezent în sursa indicată mai sus.

L = 4
c = [0, 0, 0, 1, 1]
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

for i in range(100):
    s.append(0)

finish = False
period = 0
for t in range(4, 100):
    s[t] = 0
    for i in range(1, L + 1):
        s[t] = (s[t] + c[i] * s[t - i]) % 2

    for i in range(t - 4, 3, -1):
        if (
            s[i] == s[t]
            and s[i - 1] == s[t - 1]
            and s[i - 2] == s[t - 2]
            and s[i - 3] == s[t - 3]
        ):
            print("Period = ", t - i)
            period = t - i
            finish = True
            break
    if finish:
        break


for t in range(period + 1):
    print(
        str(t)
        + ". ["
        + str(s[t])
        + ", "
        + str(s[t + 1])
        + ", "
        + str(s[t + 2])
        + ", "
        + str(s[t + 3])
        + "]"
    )
