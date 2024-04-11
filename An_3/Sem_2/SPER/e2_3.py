import casadi as ca
import numpy as np

# Funcția pentru calculul coeficienților binomiali
def coeficient_binomial(n, k):
    return np.math.factorial(n) / (np.math.factorial(k) * np.math.factorial(n - k))

# Funcția Bezier
def bezier(t, P):
    n = len(P) - 1
    z = np.zeros(2)
    for i in range(n + 1):
        binom = coeficient_binomial(n, i)
        z += binom * ((1 - t) ** (n - i)) * (t ** i) * P[i]
    return z

# Funcția Bezier
def bezier_2(t, P):
    n = P.shape[0] 
    z = np.zeros(2)
    for i in range(n + 1):
        binom = coeficient_binomial(n, i)
        z += binom * ((1 - t) ** (n - i)) * (t ** i) * P[i]
    return z

# Definirea variabilelor de optimizare (punctele de control)
n_control_points = 4  # Numărul de puncte de control
P = ca.MX.sym('P', n_control_points, 2)  # Punctele de control ca variabile de optimizare


# Definirea punctelor intermediare și a momentelor de timp asociate
w = np.array([[0, 0], [1, 0.5], [2, 3], [3, 3]])  # Punctele intermediare
t_j = np.linspace(0, 1, n_control_points)  # Momentul de timp pentru fiecare punct intermediar

# Construirea expresiei pentru obiectivul de optimizare și constrângeri
obj = 0  # Inițializarea obiectivului de optimizare
constraints = []  # Lista de constrângeri
for i in range(n_control_points - 1):
    # Diferențele dintre punctele de control consecutive pentru derivata primei
    delta_P = P[i + 1, :] - P[i, :]
    # Adăugarea termenului de cost bazat pe lungimea segmentului
    obj += ca.dot(delta_P, delta_P)

# Adăugarea constrângilor pentru punctele intermediare
# for j in range(n_control_points):
#     # Calculul traiectoriei la momentul t_j folosind formula Bezier
#     z_j = sum([coeficient_binomial(n_control_points - 1, i) *
#                 ((1 - t_j[j]) ** (n_control_points - 1 - i)) *
#                 (t_j[j] ** i) * P[i] for i in range(n_control_points)])
#     # Adăugarea constrângii pentru fiecare punct intermediar
#     constraints.append(w[1] - P[1])
    # constraints.append([0,0])

# constraints.append(w[0][0] - bezier_2(t_j[0], P)[0])
# constraints.append(w[0][1] - bezier_2(t_j[0], P)[1])
constraints.append(w[0] - bezier_2(t_j[0], P))
constraints.append(w[1] - bezier_2(t_j[1], P))
constraints.append(w[2] - bezier_2(t_j[2], P))
constraints.append(w[3] - bezier_2(t_j[3], P))
# constraints.append(w[1][0] - bezier_2(t_j[1], P)[0])
# constraints.append(w[1][1] - bezier_2(t_j[1], P)[1])
# constraints.append(w[2][0] - bezier_2(t_j[2], P)[0])
# constraints.append(w[2][1] - bezier_2(t_j[2], P)[1])
# constraints.append(w[3][0] - bezier_2(t_j[3], P)[0])
# constraints.append(w[3][1] - bezier_2(t_j[3], P)[1])

# constraints.append(w[1][0] - P[2])
# constraints.append(w[1][1] - P[3])
# constraints.append(w[2][0] - P[4])
# constraints.append(w[2][1] - P[5])

z = np.zeros(2)
z[0] = 0
z[1] = 1
print("z: ", z)
print("z[0]: ", z[0])
print("z[1]: ", z[1])

# print("bezier: ", bezier(t_j[0], [[0,0], [1,1], [2,2], [3,3]]))

# constraints.append([0,0])
# # constraints.append([0])
# constraints.append([0])
# constraints.append([0])

# Definirea problemei de optimizare
nlp = {'x': ca.vec(P), 'f': obj, 'g': ca.vertcat(*constraints)}
solver = ca.nlpsol('solver', 'ipopt', nlp, {'ipopt.print_level': 0})

x0 = [0, 0, 0.5, 1, 2, 2, 3, 3]

# Soluționarea problemei de optimizare
sol = solver(x0=x0, 
             lbg=np.zeros((n_control_points * 2,)), 
             ubg=np.zeros((n_control_points * 2,)))

# Extragerea soluției
P_opt = np.array(sol['x']).reshape(n_control_points, 2)

P_opt

print(P_opt)

# Plotarea traiectoriei și a punctelor de control
import matplotlib.pyplot as plt

# Generarea traiectoriei
t_values = np.linspace(0, 1, 100)
trajectory = np.array([bezier(t, P_opt) for t in t_values])

# Plotarea traiectoriei și a punctelor de control
plt.figure(figsize=(8, 6))
plt.plot(trajectory[:, 0], trajectory[:, 1], label='Traiectorie Bezier')
plt.plot(P_opt[:, 0], P_opt[:, 1], 'o--', label='Puncte de control')
plt.plot(w[:, 0], w[:, 1], 'x--', label='Puncte intermediare')
plt.legend()
plt.xlabel('x')
plt.ylabel('y')
plt.title('Traiectorie parametrizată prin puncte de control')
plt.grid(True)
plt.show()

