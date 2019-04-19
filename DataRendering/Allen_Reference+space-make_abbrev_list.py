from allensdk.api.queries.ontologies_api import OntologiesApi
from allensdk.core.structure_tree import StructureTree
from allensdk.api.queries.mouse_connectivity_api import MouseConnectivityApi
from allensdk.config.manifest import Manifest
from allensdk.core.reference_space import ReferenceSpace
import os
import nrrd
import functools
import numpy as np
import itertools
import math

# Input directory of where the ID file is stored
ID_directory='D:\Data\DevelopingAllenMouseAPI-master\API data'
# Input file name
ID_file='structureData_level5_clean_ParentStructureID.csv'

import csv
f=open(os.path.join(ID_directory, ID_file), "r")
reader=csv.reader(f,delimiter=',')
ID_need=[]
for row in reader:
    ID=row[0]
    ID_need.append(ID)
ID_need=[int(float(i)) for i in ID_need]

print('A total of %d brain regions inputted'%(len(ID_need)))


oapi = OntologiesApi()
structure_graph = oapi.get_structures_with_sets([17])  # 1 is the id of the adult mouse structure graph

# This removes some unused fields returned by the query
structure_graph = StructureTree.clean_structures(structure_graph)

tree = StructureTree(structure_graph)


# In[ ]:


tree.get_structures_by_name()


# In[18]:


name_map = tree.get_name_map()
name_map[17156]


# In[20]:


# make a list of abbreviations (for trial)
acronym_need=[]
acronym_map = tree.value_map(lambda x: x['id'], lambda y: y['acronym'])
#print( acronym_map[385] )


index=0
for i in ID_need:
    acronym_need=acronym_need+[acronym_map[ID_need[index]]]
    index=index+1


# In[ ]:





# In[ ]:


# save the list of structure ID
np.savetxt("ID.csv",ID_need,fmt='%.20d',delimiter=",")


# In[21]:


# save the list of region acronyms
np.savetxt("structureData_level5_clean_ParentStructureAcronym.csv",acronym_need,fmt='%.20s',delimiter=",")


# In[ ]:


acronym_need[352]


# In[ ]:


tree.get_structures_by_acronym


# In[ ]:


tree.get_structures_by_acronym('MTN')


# In[ ]:


# get a dictionary mapping structure ids to names

name_map = tree.get_name_map()
name_map[1009]


# In[ ]:


name_map[997]


# In[ ]:


tree.get_structures_by_name('root')


# In[ ]:


tree.get_structures_by_name('fiber tracts')


# In[ ]:


tree.get_structure_sets()


# In[ ]:
