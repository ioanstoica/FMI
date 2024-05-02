import matplotlib.pyplot as plt
import numpy as np
from matplotlib import cm

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

# Calculul gradientului pentru a obține direcția
v, u = np.gradient(Z)

# Trasarea câmpului potențial cu săgeți care indică direcția
plt.figure(figsize=(8, 6))
plt.contourf(X, Y, Z, levels=20, cmap=cm.coolwarm)
plt.quiver(X, Y, -u, -v, scale=50, color='black')  # Adăugarea săgeților

# Simularea mișcării agentului și trasearea traiectoriei
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

plt.xlabel('X')
plt.ylabel('Y')
plt.title('Câmpul Potențial cu Traseul Agentului')
plt.grid(True)
plt.gca().set_aspect('equal', adjustable='box')
plt.show()
