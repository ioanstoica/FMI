# B. Parcurgerea în lățime BF
# https://infoarena.ro/problema/bfs

# bfs
f = open('bfs.in', 'r')
data = f.read().split()
n = int(data[0])
m = int(data[1])
s = int(data[2])
matrix = [[0 for i in range(n+1)] for j in range(n+1)]
# fill matrix
for i in range(3, len(data)-1, 2):
    matrix[int(data[i])][int(data[i+1])] = 1

dist = [-1 for i in range(n+1)]
dist[s] = 0
q = [s]
while len(q) > 0:
    node = q.pop(0)
    for i in range(len(matrix[node])):
        if (matrix[node][i] == 1 and dist[i] == -1) or (matrix[node][i] == 1 and dist[i] > dist[node] + 1):
            dist[i] = dist[node] + 1
            q.append(i)
        
g = open('bfs.out', 'w')
for i in range(1, len(dist)):
    g.write(str(dist[i]) + ' ')

s = int(input())
x = int(input())

dist = [-1 for i in range(n+1)]
dist[s] = 0
q = [s]
while len(q) > 0:
    node = q.pop(0)
    for i in range(len(matrix[node])):
        if (matrix[node][i] == 1 and dist[i] == -1) or (matrix[node][i] == 1 and dist[i] > dist[node] + 1):
            dist[i] = dist[node] + 1
            q.append(i)

#print the way from s to x
path = [x]
while x != s:
    for i in range(len(matrix[x])):
        if matrix[i][x] == 1 and dist[i] == dist[x] - 1:
            path.append(i)
            x = i
            break
        
path.reverse()
print(path)