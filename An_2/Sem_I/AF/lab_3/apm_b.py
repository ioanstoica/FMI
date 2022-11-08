# Stoica Ioan
# ex 1.b
# Path: apm_b.py

# b) Modificați programul de la a) astfel încât să determine (dacă există) un arbore parțial de cost cât mai mic care să conțină 3muchii ale căror extremități se citesc de la tastatură.Se vor afișa muchiile arborelui determinat.

# Minimum spanning tree with 3 edges from keyboard

# read from apm.in n,m and a list with edges and costs
with open('apm_b.in', 'r') as f:
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
cost = 0
# read from keyboard the 3 edges
for i in range(3):
    # ask for new edge
    print("Edge " + str(i + 1) + ":")
    x, y, c = [int(x) for x in input().split()]
    if get_root(x) != get_root(y):
        union(x, y)
        solution.append([x, y, c])
        cost += c
    else: 
        print("The edges create a cycle")
        # exit the program
        exit()

# Kruskal's algorithm
for edge in edges:
    if get_root(edge[0]) != get_root(edge[1]):
        cost += edge[2]
        union(edge[0], edge[1])
        # save the edge in the solution
        solution.append(edge)

# write to apm.out the cost
with open('apm_b.out', 'w') as f:
    f.write(str(cost)+'\n' + str(n-1) + '\n')
    for edge in solution:
        f.write(str(edge[0]) + ' ' + str(edge[1]) + '\n')

print("The solution is in apm_b.out")