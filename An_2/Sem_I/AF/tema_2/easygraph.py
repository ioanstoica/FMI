# Stoica Ioan
# https://infoarena.ro/problema/easygraph

# open file for reading easygraph.in
fin = open("easygraph.in", "r")
# read t from fin
t = int(fin.readline())
# repeat t times
for i in range(t):
    # read n, m from fin
    n, m = map(int, fin.readline().split())
    # read n numbers from easygraph.in 
    # and store them in a list
    v = list(map(int, fin.readline().split()))
    # read m lines with a pair, from easygraph.in
    # and store them in a list
    e = [list(map(int, fin.readline().split())) for i in range(m)]

    # create an oriented graph with n nodes and m edges
    
    
