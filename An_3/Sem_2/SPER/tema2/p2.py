import matplotlib.pyplot as plt
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

# Funcție pentru calculul comenzii aplicate sistemului
def calculate_command(current_position, obstacles, destination, a1, a2):
    attractive_force = (current_position - destination) / np.linalg.norm(current_position - destination)
    repulsive_force = np.zeros_like(current_position)
    for obstacle in obstacles:
        repulsive_force += ((current_position - obstacle) / np.linalg.norm(current_position - obstacle)) * (a1 / (a2 + np.linalg.norm(current_position - obstacle))**2)
    command = -attractive_force + repulsive_force
    return command

# Parametrii obstacolelor și destinației
obstacles = np.array([[1, 1], [1, -2], [-1.5, 1], [-1, -1.8]])
destination = np.array([0, 0])

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

# Trasarea săgeților care indică direcția câmpului potențial
plt.figure(figsize=(8, 6))
plt.quiver(X, Y, -u, -v, color='blue', alpha=0.5)  # Săgețile pentru câmpul potențial

# Simularea mișcării agentului și trasearea traiectoriei
num_steps = 100
current_position = np.random.uniform(-2.5, 2.5, size=2)
trajectory = [current_position]
for _ in range(num_steps):
    command = calculate_command(current_position, obstacles, destination, a1, a2)
    current_position += command * 0.1  # 0.1 este un pas de timp arbitrar
    trajectory.append(current_position.copy())  # trebuie să adăugăm o copie a poziției curente

trajectory = np.array(trajectory)
trajectory = trajectory[1:]

# Trasarea traiectoriei ca săgeți roșii
plt.quiver(trajectory[:-1, 0], trajectory[:-1, 1], trajectory[1:, 0] - trajectory[:-1, 0], trajectory[1:, 1] - trajectory[:-1, 1], color='red', scale_units='xy', angles='xy', scale=1)

plt.xlabel('X')
plt.ylabel('Y')
plt.title('Săgeți pentru Câmpul Potențial și Traseul Agentului')
plt.grid(True)
plt.gca().set_aspect('equal', adjustable='box')
plt.show()
