
# coding: utf-8

# In[ ]:


# for each gene, for each developmental time point, search for the SectionDataSet 

from allensdk.api.queries.rma_api import RmaApi
import pandas as pd
api = RmaApi()


# user input directory name here for saving the files at the end # ages = ['E11.5']
#directory='D:\Data\DevelopingAllenMouseAPI-master\Git\Data\\'
directory='/home/hyglau/kg98/Gladys/Git'
ages = ['E11.5','E13.5','E15.5','E18.5','P4','P14','P28']

age_str = "'" + "','".join(ages) + "'"

criteria=['[graph_id$eq17][st_level$eq1][acronym$eqF]'
          #'products[abbreviation$eqDevMouse],'
          #'specimen(donor(age[name$in%s])),' %age_str,
          #'plane_of_section[name$eqsagittal]'
         ]
structure_F=pd.DataFrame(api.model_query('Structure',
                            criteria="".join(criteria),
                            include='descendant_hierarchies(descendant)',
                            start_row=0,
                            num_rows='all'))


# In[ ]:


import os 
structure_F.to_csv(os.path.join(directory,'structure_F.csv'))


# In[ ]:


# extract ID of descendants
descendantID=[]
#only keep those experiments with entrez ID available
for i in range(len(structure_F['descendant_hierarchies'][0])):
    descendantID.append(structure_F['descendant_hierarchies'][0][i].get('descendant_id'))

            #expID_list.append(experiment[counter]['id']) 
            #age_list.append(experiment[counter]['specimen']['donor']['age']['name'])
            #geneID_list.append(experiment[counter]['probes'][0]['gene']['entrez_id'])
            #geneAcronym_list.append(experiment[counter]['probes'][0]['gene']['acronym'])


# In[ ]:


pd.DataFrame(descendantID).to_csv(os.path.join(directory,'F_descendantID.csv'))

