# -*- coding: utf-8 -*-
"""
Created on Fri Oct 21 08:47:52 2022

@author: Andreea Grecu
"""

import numpy as np
import matplotlib.pyplot as plt

#%% Ex 3
d = 2
r = 1
R = 2*r

N = 10000
X = np.random.uniform(-R/2,R/2,size=(d,N))

n = np.sum(1*(np.linalg.norm(X,axis=0)<=r))
P = n/N

aprox_volum_bila = P*R**d
print('Aproximare volum bila',d,'D de raza r =',r,':',aprox_volum_bila)

#%% if d=2
plt.figure()
plt.axis('equal')
plt.plot(X[0,:],X[1,:],'.')

ind = np.where(np.linalg.norm(X,axis=0)<=r)
plt.plot(X[0,ind],X[1,ind],'C1.')

#%% Ex 4
a = 3
b = 2

N = 10000
x = np.random.uniform(-a,a,size=N)
y = np.random.uniform(-b,b,size=N)

n = np.sum(1*((x/a)**2+(y/b)**2 <=1))
P = n/N

aprox_arie_elipsa = P*2*a*2*b
print(aprox_arie_elipsa)

plt.figure()
plt.axis('equal')
plt.plot(x,y,'.')

ind = np.where((x/a)**2+(y/b)**2 <=1)
plt.plot(x[ind],y[ind],'C1.')

#%%  Ex 6
f = lambda x,y: x**2+y**4+2*x*y-1
f = lambda x,y: y**2+x**2*np.cos(x)-1
f = lambda x,y: np.exp(x**2)+y**2-4+2.99*np.cos(y)

a = 3
b = 4 

N = 10000
x = np.random.uniform(-a,a,size=N)
y = np.random.uniform(-b,b,size=N)

n = np.sum(1*(f(x,y)<=0))
P = n/N

aprox_arie_dom = P*2*a*2*b
print(aprox_arie_dom)

plt.figure()
plt.axis('equal')
plt.plot(x,y,'.')

ind = np.where(f(x,y)<=0)
plt.plot(x[ind],y[ind],'C1.')