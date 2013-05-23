from matplotlib.colors import cnames
from matplotlib import pyplot as plots
from matplotlib import animation
from mpl_toolkits.mplot3d import Axes3D
import numpy as nump
from scipy import integrate


# Choose random starting points anf Number of Desired Paths
# Points will be evenly distributed from -40 to 40
NumberofPaths = 9
nump.random.seed(1)
x_0 = -40 + 80 * nump.random.random((NumberofPaths, 3))

# Deriviative over Time of a Lorenz System
def lorenzdt((x, y, z), t_0, sigma=17, beta=4, rho=39):
    return [sigma * (y - x), x * (rho - z) - y, x * y - beta * z]

# Create determined Paths
t = nump.linspace(0, 3, 1000)
x_t = nump.asarray([integrate.odeint(lorenzdt, x_0i, t)
                  for x_0i in x_0])

# Each Path is a random colour
colors = plots.cm.jet(nump.linspace(0, 1, NumberofPaths))

# 3D View/Graph Shape
figure = plots.figure()
graph = figure.add_axes([0, 0, 1, 1], projection='3d')
graph.axis('off')



# Define point of view from (altitude degrees, azimuth degrees)
graph.view_init(60, 12.5)

# Define Points and Lines
points = sum([graph.plot([], [], [], 'o', c=c)
           for c in colors], [])

lines = sum([graph.plot([], [], [], '-', c=c)
             for c in colors], [])

# Limit of the Axes
graph.set_zlim((2.5, 70))
graph.set_ylim((-45, 50))
graph.set_xlim((-40, 50))

# Function for plotting background of each Frame
def init():
    for point, line in zip(points, lines):
        point.set_3d_properties([])
        point.set_data([], [])
        
        line.set_3d_properties([])
        line.set_data([], [])
        
    return lines + points

# Animation Sequence which will match up with the corresponding frame sequence
# Each animation sequence will coresspond to 1.3 frame-time sequences
def animate(i):
    i = (1.3* i) % x_t.shape[1]

    for line, pt, xi in zip(lines, points, x_t):
        x, y, z = xi[:i].T
        line.set_data(x, y)
        line.set_3d_properties(z)

        pt.set_data(x[-1:], y[-1:])
        pt.set_3d_properties(z[-1:])

    graph.view_init(20, 0.3 * i)
    figure.canvas.draw()
    return lines + points

# Animation Instance
anim = animation.FuncAnimation(figure, animate, init_func=init,
                               frames=1000, interval=30, blit=True)

plots.show()
