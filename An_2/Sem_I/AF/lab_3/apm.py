# https://www.infoarena.ro/problema/apm
# Stoica Ioan
# ex 1.a
# Path: apm.py

# Arbore partial de cost minim
# Se da un graf conex neorientat G cu N noduri si M muchii, fiecare muchie avand asociat un cost. Se cere sa se determine un subgraf care cuprinde toate nodurile si o parte din muchii, astfel incat subgraful determinat sa aiba structura de arbore si suma costurilor muchiilor care il formeaza sa fie minim posibila. Subgraful cu proprietatile de mai sus se va numi arbore partial de cost minim pentru graful dat.

# read from apm.in n,m and a list with edges and costs
with open('apm.in', 'r') as f:
    n, m = [int(x) for x in f.readline().split(' ')]
    edges = []
    for line in f:
        edges.append([int(x) for x in line.split()])

# sort edges by cost
edges.sort(key=lambda x: x[2])

# initialize the disjoint set
parent = [i for i in range(n + 1)]
rank = [0 for i in range(n + 1)]

# find the root of a node
def get_root(x):
    if parent[x] != x:
        parent[x] = get_root(parent[x])
    return parent[x]

# union by rank
def union(x, y):
    x_root = get_root(x)
    y_root = get_root(y)
    if x_root == y_root:
        return
    if rank[x_root] < rank[y_root]:
        parent[x_root] = y_root
    elif rank[x_root] > rank[y_root]:
        parent[y_root] = x_root
    else:
        parent[y_root] = x_root
        rank[x_root] += 1

solution = []

# Kruskal's algorithm
cost = 0
for edge in edges:
    if get_root(edge[0]) != get_root(edge[1]):
        cost += edge[2]
        union(edge[0], edge[1])
        # save the edge in the solution
        solution.append(edge)

# write to apm.out the cost
with open('apm.out', 'w') as f:
    f.write(str(cost)+'\n' + str(n-1) + '\n')
    for edge in solution:
        f.write(str(edge[0]) + ' ' + str(edge[1]) + '\n')


    

