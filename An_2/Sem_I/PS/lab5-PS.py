# -*- coding: utf-8 -*-
"""
Created on Fri Nov  4 08:19:43 2022

@author: Andreea Grecu
"""

import numpy as np
import matplotlib.pyplot as plt

#%% Ex 1 
N = 10000

Z1 = 1+np.random.randint(6,size=N)
Z2 = 1+np.random.randint(6,size=N)

A = 1*(Z1==1)
B = 1*(Z2==6)
C = 1*(Z1+Z2==7)

#%% (i) A ind C?
P = np.sum(A*C)/N
prodP = np.sum(A)/N*np.sum(C)/N

print(P)
print(prodP)

#%% (ii) B ind C?
P = np.sum(B*C)/N
prodP = np.sum(B)/N*np.sum(C)/N

print(P)
print(prodP)

#%% (iii) A,B,C ind?
P = np.sum(A*B*C)/N
prodP = np.sum(B)/N*np.sum(B)/N*np.sum(C)/N

print(P)
print(prodP)

#%% Ex 2 - similar cu 1

#%% Ex 3 a

N = 100000
X = np.random.uniform(-1,1,size=N)
Y = np.random.uniform(-1,1,size=N)

a = 0.1
b = 0.3

c = 0.25
d = 0.5

A = (1*(a<=X))*(1*(X<=b))
B = (1*(c<=Y))*(1*(Y<=d))

P = np.sum(A*B)/N
prodP = np.sum(A)/N*np.sum(B)/N

print(P)
print(prodP)

#%% 3 b

N = 100000
X = np.random.uniform(-1,1,size=N)
Y = -X

a = -0.1
b = 0.3

c = -0.25
d = 0.5

A = (1*(a<=X))*(1*(X<=b))
B = (1*(c<=Y))*(1*(Y<=d))

P = np.sum(A*B)/N
prodP = np.sum(A)/N*np.sum(B)/N

print(P)
print(prodP)

#%% Ex 4
def joc(m,M):
    i = 0
    w = 0
    while (m>0 and m<M):
        i += 1
        moneda = np.random.rand()
        if moneda<0.5:
            m += 1
        else:
            m += -1
    if m==M:
        w = 1
    return w, i

#%%
m = 1
M = 10
w, i = joc(m,M)
print(w)
print(i)

#%%
m = 40
M = 50

N = 10000
n = 0
i = np.zeros(N)
for k in range(N):
    w, i[k] = joc(m,M)
    n += w

P = n/N

print(P)

#%%
plt.figure()
plt.hist(i,bins=100)