# Stoica Ioan
# ex 2
# Path: apm_prim.py
# https://www.infoarena.ro/problema/apm
# using Prim's algorithm

from queue import PriorityQueue

# read from apm.in n,m and a list with edges and costs
with open('apm.in', 'r') as f:
    n, m = [int(x) for x in f.readline().split(' ')]
    edges = []
    for line in f:
        edges.append([int(x) for x in line.split()])

# create adjacency list
adj = [[] for i in range(n + 1)]
for edge in edges:
    adj[edge[0]].append([edge[1], edge[2]])
    adj[edge[1]].append([edge[0], edge[2]])

# visited nodes
visited = [False for i in range(n + 1)]

# initialize the priority queue
pq = PriorityQueue()
# add the first node
visited[1] = True
for edge in adj[1]:
    pq.put([edge[1], 1, edge[0]])

solution = []
cost = 0
# Prim's algorithm
while not pq.empty():
    # get the edge with the lowest cost
    edge = pq.get()
    # if the node is not visited
    if not visited[edge[2]]:
        # mark the node as visited
        visited[edge[2]] = True
        # add the edge to the solution
        solution.append([edge[1], edge[2], edge[0]])
        cost += edge[0]
        # add the edges from the current node to the priority queue
        for e in adj[edge[2]]:
            pq.put([e[1], edge[2], e[0]])
    
# write to apm.out the cost
with open('apm.out', 'w') as f:
    f.write(str(cost) + '\n' + str(n-1) + '\n')
    for edge in solution:
        f.write(str(edge[0]) + ' ' + str(edge[1]) + '\n')
