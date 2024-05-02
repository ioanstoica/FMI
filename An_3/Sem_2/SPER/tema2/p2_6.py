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

# Traiectoria:
num_steps = 100
current_position = np.random.uniform(-2.5, 2.5, size=2)
trajectory = [current_position]
for _ in range(num_steps):
    attractive_force = (current_position - destination) / np.linalg.norm(current_position - destination)
    repulsive_force = np.zeros_like(current_position)
    for obstacle in obstacles:
        repulsive_force += ((current_position - obstacle) / np.linalg.norm(current_position - obstacle)) * (-a1 / (a2 + np.linalg.norm(current_position - obstacle))**2)
    command = -attractive_force + repulsive_force
    current_position += command * 0.1  # 0.1 este un pas de timp arbitrar
    trajectory.append(current_position.copy())  # trebuie să adăugăm o copie a poziției curente

trajectory = np.array(trajectory)

# Trasarea traiectoriei cu înălțimea asociată
plt.plot(trajectory[:, 0], trajectory[:, 1], color='red')


# Trasarea săgeților care indică direcția
plt.figure()
plt.quiver(X, Y, -u, -v)
plt.show()
