# Pentru o colecție dată de obstacole (definite de centrele lor) și o destinație,
# construiți și ilustrați câmpul potențial definit în (4); 

import matplotlib.pyplot as plt
from matplotlib import cm
import numpy as np

# Funcție pentru calculul câmpului potențial total
def potential_field(X, Y, obstacles, destination, a1, a2):
    # Componenta atractivă către destinație
    psi = np.sqrt((X - destination[0])**2 + (Y - destination[1])**2)
    
    # Componentele repulsive de la obstacole
    fi = np.zeros_like(psi)
    for obstacle in obstacles:
        fi += a1 / (a2 + np.sqrt((X - obstacle[0])**2 + (Y - obstacle[1])**2))
    
    # Câmpul potențial total
    P = psi + fi
    return P

# Parametrii obstacolelor și destinației
obstacles = np.array([[-1, -1], [0, 2]])
destination = np.array([2, 2])

# Parametrii câmpului potențial
a1 = 1
a2 = 0.5

# Intervalul de valori pentru x și y
x_range = np.arange(-2.5, 2.5, 0.1)
y_range = np.arange(-2.5, 2.5, 0.1)
X, Y = np.meshgrid(x_range, y_range)

# Calculul câmpului potențial
Z = potential_field(X, Y, obstacles, destination, a1, a2)

# Trasarea câmpului potențial
fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
surf = ax.plot_surface(X, Y, Z, cmap=cm.coolwarm, linewidth=0, antialiased=False)
plt.show()

# Calculul gradientului pentru a obține direcția
v, u = np.gradient(Z)

# Trasarea săgeților care indică direcția
plt.figure()
plt.quiver(X, Y, -u, -v)
plt.show()
