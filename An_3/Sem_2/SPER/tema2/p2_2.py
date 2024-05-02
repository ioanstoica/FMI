import numpy as np
import matplotlib.pyplot as plt
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

# Funcție pentru calculul comenzii conform relației (5)
def calculate_command(position, obstacles, destination, a1, a2):
    attractive_force = (position - destination) / np.linalg.norm(position - destination)
    repulsive_force = np.zeros_like(position)
    for obstacle in obstacles:
        repulsive_force += ((position - obstacle) / np.linalg.norm(position - obstacle)) * (-a1 / (a2 + np.linalg.norm(position - obstacle))**2)
    command = -attractive_force + repulsive_force
    return command

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

# Simularea mișcării agentului și trasearea traiectoriei
num_steps = 100
current_position = np.random.uniform(-2.5, 2.5, size=2)
trajectory = [current_position]
for _ in range(num_steps):
    command = calculate_command(current_position, obstacles, destination, a1, a2)
    current_position += command * 0.1  # 0.1 este un pas de timp arbitrar
    trajectory.append(current_position.copy())  # trebuie să adăugăm o copie a poziției curente

trajectory = np.array(trajectory)
print(trajectory)
plt.plot(trajectory[:, 0], trajectory[:, 1], color='black')

plt.show()
