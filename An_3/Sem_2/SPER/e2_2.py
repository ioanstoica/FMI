import casadi as ca
import numpy as np
import matplotlib.pyplot as plt

# Păstrăm funcția coeficient_binomial cu numpy pentru calcule care nu implică variabilele de optimizare
def coeficient_binomial(n, k):
    return np.math.factorial(n) / (np.math.factorial(k) * np.math.factorial(n - k))

# Funcția Bezier ajustată pentru a lucra cu CasADi, folosind coeficienții binomiali calculați cu numpy
def bezier(t, P):
    n = P.shape[0] - 1
    z = ca.MX.zeros(2)  # Inițializează z ca vector coloană
    for i in range(n + 1):
        binom = coeficient_binomial(n, i)
        # Asigură-te că toate vectorii sunt coloane; P[i, :].T sau ca.reshape(P[i, :], (2, 1))
        term = binom * ((1 - t) ** (n - i)) * (t ** i)
        z += term * ca.reshape(P[i, :], (2, 1))  # Transformă P[i, :] în vector coloană
    return z

# Restul codului rămâne neschimbat, asigurându-ne că utilizăm CasADi pentru toate calculările care implică variabilele de optimizare
n_control_points = 4
P = ca.MX.sym('P', n_control_points, 2)

w = np.array([[0, 0], [1, 1], [2, 1.5], [3, 3]])
t_j = np.linspace(0, 1, n_control_points)

obj = 0
constraints = []

for i in range(n_control_points - 1):
    delta_P = P[i + 1, :] - P[i, :]
    obj += ca.dot(delta_P, delta_P)

# La adăugarea constrângerilor, corectăm manipularea dimensiunilor
for j in range(n_control_points):
    z_j = bezier(t_j[j], P)  # Aceasta returnează un vector coloană în CasADi
    # Corectăm conversia lui w[j] într-un vector coloană compatibil cu CasADi
    w_j = ca.DM(w[j]).reshape((2,1))  # Folosim reshape pentru a asigura forma corectă
    # Acum ambele z_j și w_j sunt vectori coloană (2x1) și putem face diferența
    constraint = z_j - w_j
    # Adăugăm vectorul de diferență la lista de constrângeri fără a descompune
    constraints.append(constraint)



nlp = {'x': ca.vec(P), 'f': obj, 'g': ca.vertcat(*constraints)}
solver = ca.nlpsol('solver', 'ipopt', nlp, {'ipopt.print_level': 0})

sol = solver(x0=np.zeros((n_control_points * 2,)),
             lbg=np.zeros((n_control_points * 2,)),
             ubg=np.zeros((n_control_points * 2,)))

P_opt = np.array(sol['x']).reshape(n_control_points, 2)

# Generarea și plotarea traiectoriei
# Definirea unei funcții CasADi pentru a evalua funcția Bezier
t = ca.MX.sym('t')
bezier_eval = ca.Function('bezier_eval', [t, P], [bezier(t, P)])

# Utilizarea funcției definite pentru a genera traiectoria
trajectory = np.array([bezier_eval(t, P_opt).full() for t in np.linspace(0, 1, 100)])


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
