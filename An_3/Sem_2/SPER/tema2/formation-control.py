# -*- coding: utf-8 -*-
"""
Created on Mon Mar 21 23:25:43 2022

@author: florin stoican
"""

import numpy as np
from matplotlib import pyplot as plt

#%% ############################## init data ############################

# desired formation, defined by relative positions and velocities
p=np.array([[0,0],[np.sqrt(3)/2,-1/2],[0,1],[-np.sqrt(3)/2,-1/2]])
v=np.zeros((4,2))

# neighbors
N=np.array([[0,2,3],[0,1,3],[0,1,2]])

# sampling time
T=0.1
# number of steps in simulation
Nsim=100

# parameters for control
kp=0.5
kv=0.5

# initial positions and velocities for the followes
p_initial=np.random.rand(3,2)*10-5
v_initial=np.random.rand(3,2)*2

agent=[]
for i in range(1,len(p)):
    agent.append({'position':p_initial[i-1,:],'velocity':v_initial[i-1,:]})
    
    
#%% ############################## run the simulation ############################

for k in range(Nsim):
    for i in range(1,len(p)):
        control=np.zeros((1,2))
        
        for j in N[i-1,1:]:
            if k==0:
                control=-kp*(agent[i-1]['position']-agent[j-1]['position']-p[i,:]+p[j,:])\
                    -kv*(agent[i-1]['velocity']-agent[j-1]['velocity']-v[i,:]+v[j,:])
                agent[i-1]['command']=control
            else:
                control=control-kp*(agent[i-1]['position'][-1,:]-agent[j-1]['position'][-1,:]-p[i,:]+p[j,:])\
                    -kv*(agent[i-1]['velocity'][-1,:]-agent[j-1]['velocity'][-1,:]-v[i,:]+v[j,:])
        if k==0:
            agent[i-1]['position']=np.vstack((agent[i-1]['position'],\
                                    agent[i-1]['position']+T*agent[i-1]['velocity']))
            agent[i-1]['velocity']=np.vstack((agent[i-1]['velocity'],\
                                    agent[i-1]['velocity']+T*control))
        else:
            agent[i-1]['command']=np.vstack((agent[i-1]['command'],control))        
            agent[i-1]['position']=np.vstack((agent[i-1]['position'],\
                                    agent[i-1]['position'][-1,:]+T*agent[i-1]['velocity'][-1,:]))
            agent[i-1]['velocity']=np.vstack((agent[i-1]['velocity'],\
                                    agent[i-1]['velocity'][-1,:]+T*control))
    
    
#%% ############################## plot the results ############################


fig = plt.figure()
plt.grid()

plt.xlabel('x')
plt.ylabel('y')
plt.suptitle('Position 2D space')

for i in range(1,len(p)):
    plt.plot(agent[i-1]['position'][:,0], agent[i-1]['position'][:,1])
    #plt.scatter(agent[i-1]['position'][:,0], agent[i-1]['position'][:,1],30,'r')

time=np.linspace(0,T*Nsim,len(agent[i-1]['position'][:,0]))
plt.show()

#%%
fig = plt.figure()
plt.xlabel('time')
plt.ylabel('velocity')
plt.suptitle('Velocities time series')
plt.grid()

for i in range(1,len(p)):
    plt.plot(time, agent[i-1]['velocity'][:,0])
    plt.plot(time, agent[i-1]['velocity'][:,1],'--')
plt.show()

#%%

fig = plt.figure()
plt.xlabel('time')
plt.ylabel('command')
plt.suptitle('Commands (accelerations) time series')
plt.grid()

for i in range(1,len(p)):
    plt.plot(time[:-1], agent[i-1]['command'][:,0])
    plt.plot(time[:-1], agent[i-1]['command'][:,1],'--')
plt.show()

