# Stoica Ioan, gr. 251
# 31.10.2022 lab1 prob5

# Se dă o rețea neorientată cu n noduri și o listă de noduri reprezentând puncte de control 
# pentru rețea în fișierul graf.in, în formatul precizat la începutul laboratorului; 
# în plus, pe ultima linie din fișier se află punctele de control separate prin spațiu.
# Să se determine pentru fiecare nod din rețea distanța până la cel mai apropiat punct de control de acesta. 
# În fișierul graf.out se vor afișa pentru fiecare nod de la 1 la n aceste distanțe separate prin spațiu.

# create graph from graph.in
def create_graph():
    graph = {}
    with open('graf.in', 'r') as f:
        n, m = [int(x) for x in f.readline().split()]
        for i in range(1, n + 1):
            graph[i] = []
        for i in range(m):
            x, y = [int(x) for x in f.readline().split()]
            graph[x].append(y)
            graph[y].append(x)
        control_points = [int(x) for x in f.readline().split()]
    return graph, control_points

graph, control_points = create_graph()

visited = {}
distance = {}
for i in range(1, len(graph) + 1):
    visited[i] = False
    distance[i] = -1    

# for control points distance is 0
# create queue with control points
# check control points vizited
queue = []
for i in control_points:
    distance[i] = 0
    queue.append(i)
    visited[i] = True

# bfs
while len(queue) > 0:
    node = queue.pop(0)
    for neighbour in graph[node]:
        if visited[neighbour] == False:
            visited[neighbour] = True
            distance[neighbour] = distance[node] + 1
            queue.append(neighbour)

# print distances
with open('graf.out', 'w') as f:
    for i in range(1, len(graph) + 1):
        f.write(str(distance[i]) + ' ')
