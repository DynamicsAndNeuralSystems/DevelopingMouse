
# coding: utf-8

# In[ ]:


# download structure colours at level 5

from allensdk.api.queries.rma_api import RmaApi
import pandas as pd
api = RmaApi()

structures = pd.DataFrame(
    api.model_query('Structure',
                    criteria='[graph_id$eq17][st_level$eq5]',
                    num_rows='all'))


# In[ ]:


structures.to_csv('structureData.csv')


# In[ ]:


# download structure colours at level 3 (Major divisions)

from allensdk.api.queries.rma_api import RmaApi
import pandas as pd
api = RmaApi()

structures = pd.DataFrame(
    api.model_query('Structure',
                    criteria='[graph_id$eq17][st_level$eq3]',
                    num_rows='all'))


# In[ ]:


structures.to_csv('structureData_level3.csv')


# In[ ]:


# download structure coords at level 5

from allensdk.api.queries.rma_api import RmaApi
import pandas as pd
api = RmaApi()

structure_centers = pd.DataFrame(
    api.model_query('StructureCenter',
                    criteria='structure[st_level$eq5][graph_id$eq17]',
                    num_rows='all'))


# In[ ]:


structure_centers.to_csv('structureCenters.csv')


# In[ ]:


# download structure coords for adult mouse


from allensdk.api.queries.rma_api import RmaApi
import pandas as pd
api = RmaApi()

structure_centers_adult = pd.DataFrame(
    api.model_query('StructureCenter',
                    criteria='structure[graph_id$eq1]',
                    num_rows='all'))


# In[ ]:


structure_centers_adult.to_csv('structureCenters_adult.csv')


# In[ ]:


# download acronym path for developing mouse


from allensdk.api.queries.rma_api import RmaApi
import pandas as pd
api = RmaApi()

OntologyNode = pd.DataFrame(
    api.model_query('OntologyNode',
                    criteria='structure[st_level$eq5][graph_id$eq17]',
                    num_rows='all'))


# In[ ]:


OntologyNode.to_csv('AcronymPath_level5.csv')

