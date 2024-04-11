import numpy as np
import matplotlib.pyplot as plt

# Definirea punctelor de control
P = np.array([[0, 0], [1, 2], [3, 1], [4, 3]])

# Numărul de puncte de control
n = len(P) - 1

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

# Generarea traiectoriei
t_values = np.linspace(0, 1, 100)
trajectory = np.array([bezier(t, P) for t in t_values])

# Plotarea traiectoriei și a punctelor de control
plt.figure(figsize=(8, 6))
plt.plot(trajectory[:, 0], trajectory[:, 1], label='Traiectorie Bezier')
plt.plot(P[:, 0], P[:, 1], 'o--', label='Puncte de control')
plt.legend()
plt.xlabel('x')
plt.ylabel('y')
plt.title('Traiectorie parametrizată prin puncte de control')
plt.grid(True)
plt.show()
