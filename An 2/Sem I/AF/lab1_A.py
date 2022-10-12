# A 1)
# create matrix for a graph
def adjacency_matrix(tip, file):
    # read file
    f = open(file, 'r')
    # create matrix
    data = f.read().split()
    n = int(data[0])
    m = int(data[1])
    matrix = [[0 for i in range(n+1)] for j in range(n+1)]
    # fill matrix
    for i in range(2, len(data)-1, 2):
        matrix[int(data[i])][int(data[i+1])] = 1
        if tip == 1:
            matrix[int(data[i+1])][int(data[i])] = 1
    
    return matrix

# call create_matrix
a = adjacency_matrix(0, 'graf.in')
# print(a)



# A 2)
# create adjacency list for a graph
def adjacency_lists(tip, file):
    # read file
    f = open(file, 'r')
    # create lists
    data = f.read().split()
    n = int(data[0])
    m = int(data[1])
    lists = [[] for i in range(n+1)]
    # fill lists
    for i in range(2, len(data)-1, 2):
        lists[int(data[i])].append(int(data[i+1]))
        if tip == 1:
            lists[int(data[i+1])].append(int(data[i]))
    
    return lists


b = adjacency_lists(0, 'graf.in')
# print(b)

# A 3)
# adjacency_matrix to adjacency_lists
def matrix_to_lists(matrix):
    lists = [[] for i in range(len(matrix))]
    for i in range(len(matrix)):
        for j in range(len(matrix[i])):
            if matrix[i][j] == 1:
                lists[i].append(j)
    
    return lists

c = matrix_to_lists(a)
# print(c)

# adjacency_lists to adjacency_matrix
def lists_to_matrix(lists):
    matrix = [[0 for i in range(len(lists))] for j in range(len(lists))]
    for i in range(len(lists)):
        for j in range(len(lists[i])):
            matrix[i][lists[i][j]] = 1
    
    return matrix

d = lists_to_matrix(b)
# print(d)

# B 1)
