# Stoica Ioan
# https://www.infoarena.ro/problema/retea2

# read n and m from retea.in
fin = open("retea.in", "r")
n, m = map(int, fin.readline().split())

# read n pairs of numbers from retea.in in a list centrale
centrale = []
for i in range(n):
    centrale.append(list(map(int, fin.readline().split())))

# read m pairs of numbers from retea.in in a list locuinte
locuinte = []
for i in range(m):
    locuinte.append(list(map(int, fin.readline().split())))

# create graph with n+m nodes
graph = [[] for i in range(n+m)]
