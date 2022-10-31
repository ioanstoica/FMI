# C. Parcurgerea în adâncime DF
# https://infoarena.ro/problema/dfs

# dfs
from msilib.schema import Component


f = open('dfs.in', 'r')
data = f.read().split()
n = int(data[0])
m = int(data[1])

matrix = [[0 for i in range(n+1)] for j in range(n+1)]
# fill matrix
for i in range(2, len(data)-1, 2):
    matrix[int(data[i])][int(data[i+1])] = 1
    matrix[int(data[i+1])][int(data[i])] = 1

visited = [0 for i in range(n+1)]
path = []
def dfs(node):
    visited[node] = 1
    path.append(node)
    for i in range(len(matrix[node])):
        if matrix[node][i] == 1 and visited[i] == 0:
            dfs(i)

# number components
components = 0
for i in range (1, n+1):
    if visited[i] == 0:
        components += 1
        dfs(i)


# print in file components
g = open('dfs.out', 'w')
g.write(str(components))
