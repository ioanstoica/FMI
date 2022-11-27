# Stoica Ioan
# https://www.infoarena.ro/problema/retea2

# read n and m from retea2.in
fin = open("retea2.in", "r")
n, m = map(int, fin.readline().split())

# read n pairs of numbers from retea2.in in a list centrale
centrale = []
for i in range(n):
    centrale.append(list(map(int, fin.readline().split())))

# read m pairs of numbers from retea2.in in a list locuinte
locuinte = []
for i in range(m):
    locuinte.append(list(map(int, fin.readline().split())))

#create a list with m+1 element and initialize it with 2000000000.0
dist = [2000000000.0] * (m + 1)

for i in range(1,m+1):
    for j in range(1, n+1):
        dist[i] = min(dist[i], ((centrale[j-1][0] - locuinte[i-1][0]) ** 2 + (centrale[j-1][1] - locuinte[i-1][1]) ** 2) ** 0.5)

ok = [False] * (m + 1)

rez = 0
for i in range(1, m+1):
    minim = 2000000000.0
    poz = 0
    for j in range(1, m+1):
        if ok[j]: 
            continue
        if dist[j] < minim:
            minim = dist[j]
            poz = j
    
    rez += minim
    ok[poz] = True

    for j in range(1, m+1):
        if ok[j]: 
            continue
        dist[j] = min(dist[j], ((locuinte[poz-1][0] - locuinte[j-1][0]) ** 2 + (locuinte[poz-1][1] - locuinte[j-1][1]) ** 2) ** 0.5)

import math
# write rez to retea2.out
fout = open("retea2.out", "w")  
fout.write(str("{:.6f}".format(rez)))
fout.close()

# Complexity: O(n*)