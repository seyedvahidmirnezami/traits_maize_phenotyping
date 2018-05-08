
# coding: utf-8

# In[1]:


import scipy.ndimage
a=scipy.ndimage.imread('C301B-1-07252017-2K7A2124.png')


# In[4]:


import numpy as np
ind=np.where(a==255)
y=ind[0]
x=ind[1]
print(y)
print(x)
c=list(zip(y,x))
from sklearn.neighbors import NearestNeighbors

#X = np.array([[-1, -1], [-2, -1], [-3, -2], [1, 1], [2, 1], [3, 2]])
nbrs = NearestNeighbors(n_neighbors=10, algorithm='ball_tree').fit(c)
distances, indices = nbrs.kneighbors(c)
#print(c)


# In[12]:


print(len(c))
#print(indices)
#print(distances)
sparse=[];
for i in range(distances.shape[0]):

    for j in range(1,distances.shape[1]):

        if distances[i][j]<2:
            sparse.append([i,indices[i][j]])
         
            
            
#print(sparse)


# In[104]:


import networkx as nx
GG=nx.Graph()
GG.add_edges_from(sparse)
i=np.where((y==8687) & (x==2071))
print('done')
nx.shortest_path(GG,1905512)


# In[92]:





# In[93]:
'''

a=np.array([[0,0,0,1],[1,1,1,1],[1,1,1,0],[0,1,1,0]]);
ind=np.where(a==1)
y=ind[0]
x=ind[1]

c=list(zip(y,x))

print(c)

from sklearn.neighbors import NearestNeighbors

#X = np.array([[-1, -1], [-2, -1], [-3, -2], [1, 1], [2, 1], [3, 2]])
nbrs = NearestNeighbors(n_neighbors=10, algorithm='ball_tree').fit(c)
distances, indices = nbrs.kneighbors(c)

print(indices)
print('distances')
print(distances)
sparse=[];
for i in range(distances.shape[0]):
    for j in range(1,distances.shape[1]):
        if distances[i][j]<2:
            sparse.append([i,indices[i][j]])
            
print(sparse)

import networkx as nx
GG=nx.Graph()
GG.add_edges_from(sparse)
print(nx.draw(GG))
inde=nx.shortest_path(GG,0,8)


# In[34]:


from scipy.sparse.csgraph import shortest_path
print(nx.shortest_path(G_sparse,source=start,target=end))


# In[46]:


res[1220,1320]

'''