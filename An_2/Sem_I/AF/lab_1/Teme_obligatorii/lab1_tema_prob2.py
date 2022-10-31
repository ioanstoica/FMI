# Stoica Ioan, gr. 251
# 28.10.2022 lab1 prob1

# 2. https://csacademy.com/contest/archive/task/check-dfs
# In this problem you are given a graph with NN nodes and MM edges 
# and a permutation PP of size NN. If you are allowed to shuffle the adjacency lists, 
# is it possible to visit the nodes during a DFS starting in node 11 in the order given by PP?

# get data with input()
n,m = map(int, input().split())
p = list(map(int, input().split()))

# read m lines with edges
edges = []
for i in range(m):
    edges.append(list(map(int, input().split())))

# create graph from edges
graph = {}
for i in range(1, n+1):
    graph[i] = []
for i in edges:
    graph[i[0]].append(i[1])
    graph[i[1]].append(i[0])

for i in range(1, n):
    # if is not edge between p[i] and another node in p[:i]
    # then return False
    possible = False
    for j in range(i):
        if p[i] in graph[p[j]]:
            possible = True
            break
    if not possible:
        print(0)
        break
else:
    print(1)