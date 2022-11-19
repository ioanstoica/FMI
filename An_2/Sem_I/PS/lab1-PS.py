# -*- coding: utf-8 -*-
"""
Created on Fri Oct  7 08:01:07 2022

@author: Andreea Grecu

"""
import matplotlib.pyplot as plt
import numpy as np

#%% exercitiu de plotare
x = np.array([1,2.])
x2 = np.linspace(1,20,10)
y = x**2
y2 = x2**2
plt.figure()
plt.plot(x,y)
plt.plot(x,y,'*')

plt.figure()
plt.plot(x2,y2)

#%% metoda 1: => P=1/3
N = 1000
n = 0
plt.figure()
plt.xlim([-1,1])
plt.ylim([-1,1])
plt.axis('equal')
for i in range(N):
    theta = 2*np.pi*np.random.rand(2)
    x = np.cos(theta)
    y = np.sin(theta)
    
    # # verificare - varianta 1
    # l = np.sqrt((x[1]-x[0])**2+(y[1]-y[0])**2)
    # if l>np.sqrt(3):
    #     n +=1
    
    # verificare - varianta 2  
    m = np.array([(x[0]+x[1])/2,(y[0]+y[1])/2])
    lm = np.sqrt((m[1])**2+(m[0])**2)
    if lm<1/2:
        n +=1
    
    plt.plot(x,y,'C0',linewidth=0.5)
    plt.plot(x,y,'o')
    plt.plot(m[0],m[1],'C1*')

P = n/N
print(P)

#%% metoda 2: => P=1/4
N = 1000
n = 0
plt.figure()
plt.xlim([-1,1])
plt.ylim([-1,1])
plt.axis('equal')
for i in range(N):
    theta = 2*np.pi*np.random.rand()
    r = np.sqrt(np.random.rand())
    
    # verificare - varianta 2  
    m = np.array([r*np.cos(theta),r*np.sin(theta)])
    lm = np.sqrt((m[1])**2+(m[0])**2)
    if lm<1/2:
        n +=1
    a = -m[0]/m[1]
    b = m[1]-a*m[0]
    delta = 4*a**2*b**2-4*(1+a**2)*(b**2-1)
    x = np.array([(-2*a*b+np.sqrt(delta))/(2*(1+a**2)),(-2*a*b-np.sqrt(delta))/(2*(1+a**2))])
    y = a*x+b
    
    plt.plot(x,y,'C0',linewidth=0.5)
    plt.plot(x,y,'o')
    plt.plot(m[0],m[1],'C1*')

P = n/N
print(P)

#%% metoda 3: => P=
N = 5000
n = 0
plt.figure()
plt.xlim([-1,1])
plt.ylim([-1,1])
plt.axis('equal')
for i in range(N):
    theta = 2*np.pi*np.random.rand()
    r = np.random.rand()
    
    # verificare - varianta 2  
    m = np.array([r*np.cos(theta),r*np.sin(theta)])
    lm = np.sqrt((m[1])**2+(m[0])**2)
    if lm<1/2:
        n +=1
    a = -m[0]/m[1]
    b = m[1]-a*m[0]
    delta = 4*a**2*b**2-4*(1+a**2)*(b**2-1)
    x = np.array([(-2*a*b+np.sqrt(delta))/(2*(1+a**2)),(-2*a*b-np.sqrt(delta))/(2*(1+a**2))])
    y = a*x+b
    
    plt.plot(x,y,'C0',linewidth=0.5)
    plt.plot(x,y,'o')
    plt.plot(m[0],m[1],'C1*')

P = n/N
print(P)