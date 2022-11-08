# Stoica Ioan
# ex 3
# Path: apm_3.py
# Second best minimum spanning tree

# read from grafpon n,m and a list with edges and costs
with open('grafpond.in', 'r') as f:
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

# Kruskal's algorithm
solution1 = []
cost1 = 0
for edge in edges:
    if get_root(edge[0]) != get_root(edge[1]):
        cost1 += edge[2]
        union(edge[0], edge[1])
        # save the edge in the solution
        solution1.append(edge)

# write to grafpon.out the cost
with open('grafpond.out', 'w') as f:
    f.write("Primul\n")
    f.write(str(cost1)+'\n' + str(n-1) + '\n')
    for edge in solution1:
        f.write(str(edge[0]) + ' ' + str(edge[1]) + '\n')

#  Second best minimum spanning tree
#  initialize the disjoint set
parent = [i for i in range(n + 1)]
rank = [0 for i in range(n + 1)]

# var costmin = infinit
costmin = 1000000000
solutionmin = []

for edge in solution1:
    # delete edge from edges
    edges.remove(edge)

    # Kruskal's algorithm
    solution2 = []
    cost2 = 0
    for edge in edges:
        if get_root(edge[0]) != get_root(edge[1]):
            cost2 += edge[2]
            union(edge[0], edge[1])
            # save the edge in the solution
            solution2.append(edge)

    # save the best solution
    if cost2 < costmin:
        costmin = cost2
        solutionmin = solution2

    # add edge to edges
    edges.append(edge)

# write to grafpon.out the cost
with open('grafpond.out', 'a') as f:
    f.write("Al doilea\n")
    f.write(str(costmin)+'\n' + str(n-1) + '\n')
    for edge in solutionmin:
        f.write(str(edge[0]) + ' ' + str(edge[1]) + '\n')


