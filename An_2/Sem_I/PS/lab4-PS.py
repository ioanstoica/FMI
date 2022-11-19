# -*- coding: utf-8 -*-
"""
Created on Fri Oct 28 08:09:20 2022

@author: Andreea Grecu
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import uniform, beta, gamma, norm, expon, cosine

#%%
note = np.array([5,5,6,7,8,9,9,9,8,8,10,4,1,2,3,6,7,5,5,4,9])

plt.figure()
plt.hist(note,alpha=0.5,bins=30)

#%% Ex 1 
#%% gen aleator unif in [a,b]
a = 0
b = 4
N = 10000
x=np.random.uniform(a,b,size=N)
plt.hist(x,alpha=0.5,density=True)

xd=np.linspace(a,b,100)
plt.plot(xd,uniform.pdf(xd,a,b))

#%% gen aleator cu distributia beta(a,b) in [0,1]
a = 3
b = 7
N = 1000000
x=beta.rvs(a,b,size=N)
plt.hist(x,alpha=0.5,density=True,bins=50)

xd=np.linspace(0,1,100)
plt.plot(xd,beta.pdf(xd,a,b))

#%% gen aleator cu distributia cos in [-pi,pi]
N = 1000000
x=cosine.rvs(size=N)
plt.hist(x,alpha=0.5,density=True,bins=50)

xd=np.linspace(-np.pi,np.pi,100)
plt.plot(xd,cosine.pdf(xd))

#%% gen aleator cu distributia norm pe R
N = 1000000
x=norm.rvs(0,1,size=N)
plt.hist(x,alpha=0.5,density=True,bins=50)

xd=np.linspace(-20,20,100)
plt.plot(xd,norm.pdf(xd,0,1))

#%% Ex 2
N = 1000000
B = np.zeros(N)
T = np.zeros(N)

for i in range(N):
    B[i] = 1*(np.random.rand()<0.02)
    if B[i] ==1:
        T[i] = 1*(np.random.rand()<0.98)
    if B[i] ==0:
        T[i] = 1*(np.random.rand()<0.05)

P = np.sum((1*(B==1))*(1*(T==1)))/np.sum(1*(T==1))
print(P)

#%% Ex 3
from pydataset import data

D = data()
d = data('titanic')
data('titanic',show_doc=True)
dnp = d.to_numpy()

plt.figure()
plt.hist(dnp[:,1],alpha=0.5,bins=50)

#%%
d = data('LakeHuron')

#%%
d = data('crohn')