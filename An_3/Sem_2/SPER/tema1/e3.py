import casadi as ca
import numpy as np
import matplotlib.pyplot as plt

# Redefine the required functions and variables directly from the script content
def coeficient_binomial(n, k):
    return np.math.factorial(n) / (np.math.factorial(k) * np.math.factorial(n - k))

def bezier(t, P):
    n = len(P) - 1
    z = np.zeros(2)
    for i in range(n + 1):
        binom = coeficient_binomial(n, i)
        z += binom * ((1 - t) ** (n - i)) * (t ** i) * P[i]
    return z


def ii(w):
    # Definirea variabilelor de optimizare (punctele de control)
    n_control_points = len(w)  # Numărul de puncte de control
    P = ca.SX.sym('P', n_control_points, 2)  # Punctele de control ca variabile de optimizare

    # Definirea punctelor intermediare și a momentelor de timp asociate
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
    for j in range(n_control_points):
        # Calculul traiectoriei la momentul t_j folosind formula Bezier
        x = sum([(coeficient_binomial(n_control_points - 1, i) *
                    ((1 - t_j[j]) ** (n_control_points - 1 - i)) *
                    (t_j[j] ** i)) * P[i*2] for i in range(n_control_points)])
        constraints.append(x - w[j][0])

        y = sum([(coeficient_binomial(n_control_points - 1, i) *
                    ((1 - t_j[j]) ** (n_control_points - 1 - i)) *
                    (t_j[j] ** i)) * P[i*2+1] for i in range(n_control_points)])
        constraints.append(y - w[j][1])

    # Definirea problemei de optimizare
    nlp = {'x': ca.vec(P), 'f': obj, 'g': ca.vertcat(*constraints)}
    solver = ca.nlpsol('solver', 'ipopt', nlp, {'ipopt.print_level': 0})

    # Soluționarea problemei de optimizare
    sol = solver(x0=np.zeros((n_control_points * 2,)),
                lbg=np.zeros((n_control_points * 2,)), 
                ubg=np.zeros((n_control_points * 2,)))

    # Extragerea soluției
    P_opt = np.array(sol['x']).reshape(n_control_points, 2)

    return P_opt

# Optimization solution (Control Points)
# Assuming the solution control points for illustration
w = np.array([[0.4, 0.6], [1.3, 4.7], [2.4,3.6], [3.4, 4.7]])
P_opt = ii(w)


# Calculate z(t) for a dense set of t values to get a smooth curve
t_values = np.linspace(0, 1, 100)
trajectory = np.array([bezier(t, P_opt) for t in t_values])

# Compute the derivatives dz/dt using CasADi for automation of derivative computation
P = ca.SX.sym('P', len(P_opt), 2)
t = ca.SX.sym('t')
z_sym = bezier(t, P_opt)

dz_dt = ca.jacobian(z_sym, t)
d2z_dt2 = ca.jacobian(dz_dt, t)

# Convert symbolic expressions to functions
f_dz_dt = ca.Function('dz_dt', [t, P], [dz_dt])
f_d2z_dt2 = ca.Function('d2z_dt2', [t, P], [d2z_dt2])

# Evaluate derivatives at each t_value
dz_dt_values = np.array([f_dz_dt(t, P_opt).full().flatten() for t in t_values])
d2z_dt2_values = np.array([f_d2z_dt2(t, P_opt).full().flatten() for t in t_values])

# Calculate uV and u_phi based on derivatives and equations from task description
# Given: L = constant (assume L=1 for simplicity), phi_dot can be ignored for simplicity in calculation
L = 1
uV = np.linalg.norm(dz_dt_values, axis=1)
u_phi = np.arctan2(L * d2z_dt2_values[:, 1], L * d2z_dt2_values[:, 0])

# Plotting the commands uV(t) and u_phi(t)
fig, axs = plt.subplots(3, 1, figsize=(10, 12))

# Plotting the trajectory and control points
axs[0].plot(trajectory[:, 0], trajectory[:, 1], label='Traiectorie Bezier')
axs[0].plot(P_opt[:, 0], P_opt[:, 1], 'o--', label='Puncte de control')
axs[0].plot(w[:, 0], w[:, 1], 'x--', label='Puncte intermediare')
axs[0].set_title('Traiectorie parametrizată prin puncte de control')
axs[0].set_xlabel('x')
axs[0].set_ylabel('y')
axs[0].grid(True)
axs[0].legend()

axs[1].plot(t_values, u_phi, label='$u_\\phi(t)$', color='orange')
axs[1].set_title('Control Command $u_\\phi(t)$')
axs[1].set_xlabel('Time $t$')
axs[1].set_ylabel('$u_\\phi(t)$')
axs[1].grid(True)
axs[1].legend()

axs[2].plot(t_values, uV, label='$u_V(t)$')
axs[2].set_title('Control Command $u_V(t)$')
axs[2].set_xlabel('Time $t$')
axs[2].set_ylabel('$u_V(t)$')
axs[2].grid(True)
axs[2].legend()

plt.tight_layout()
plt.show()
