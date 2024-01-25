# Cate solutii (x1,x2, .. , x9) apartin {0,1} ^9 are urmatoarea instanta a problemei SAT?
# (x1 ∨ ¬ x2 ∨ ¬x3 ) ∧ (¬x4 ∨ x5 ∨ ¬x6)∧(¬x7 ∨ ¬x8 ∨ x9)

nr_sol = 0

for i in range(0, pow(2,9)):
    x = [0,0,0,0,0,0,0,0,0]
    for j in range(0,9):
        if i & (1 << j):
            x[j] = 1
    print(x)
    if (x[0] or not x[1] or not x[2]) and (not x[3] or x[4] or not x[5]) and (not x[6] or not x[7] or x[8]):
        nr_sol += 1
        

print("Au fost gasite: ", nr_sol, "solutii")