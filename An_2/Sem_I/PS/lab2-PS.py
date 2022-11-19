# -*- coding: utf-8 -*-
"""
Created on Fri Oct 14 08:08:16 2022

@author: Andreea Grecu
"""
import numpy as np
import matplotlib.pyplot as plt

#%% Ex 3
def same4face(N,M):
    m = 0
    for i in range(M):
        x = np.random.rand(N)
        
        HT = 1*(x<0.5)
        
        seq = 0
        for i in range(N-3):
            if (HT[i],HT[i+1],HT[i+2],HT[i+3]) == (1,1,1,1) or \
                (HT[i],HT[i+1],HT[i+2],HT[i+3]) == (0,0,0,0):
                    
                    seq +=1
        if seq>=1:
            m +=1
    
    P = m/M
    print(P)
    
M = 1000
same4face(10,M)
same4face(20,M)

#%% Ex 4
NS = 1000

r = np.zeros(NS)
v = np.zeros(NS)
n = np.zeros(NS)

for i in range(NS):
    R = np.array([1,4,4,4,4,4])
    V = np.array([3,3,3,3,3,6])
    N = np.array([2,2,2,5,5,5])
    
    r[i] = R[np.random.randint(6)]
    v[i] = V[np.random.randint(6)]
    n[i] = N[np.random.randint(6)]
    
RV = np.sum(1*(r>v))/NS
RN = np.sum(1*(r>n))/NS
    
VN = np.sum(1*(v>n))/NS
VR = np.sum(1*(v>r))/NS

NR = np.sum(1*(n>r))/NS
NV = np.sum(1*(n>v))/NS

print('R>V:',RV)
print('R>N:',RN)

print('V>N:',VN)
print('V>R:',VR)

print('N>R:',NR)
print('N>V:',NV)