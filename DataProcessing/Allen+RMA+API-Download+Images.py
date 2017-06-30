
# coding: utf-8

# In[ ]:


# download projection experiment details for image download


from allensdk.api.queries.rma_api import RmaApi
import pandas as pd

# input wanted downsample factor in image download(1=halved)
downsample=4

api = RmaApi()

projection = pd.DataFrame(
    api.model_query('Equalization',
                    num_rows='all'))
projection=projection[pd.notnull(projection['section_data_set_id'])] # remove experiments where the section dataset id is unknown


# In[ ]:


# save projection experiment data
projection.to_csv('projection.csv')


# In[ ]:


# download projection experiment details for image download
# extract as list the section_data_set_id column (last column) of projection dataframe
projection_list=projection['section_data_set_id'].tolist()


# In[ ]:


# extract the colors values
red_lower_list=projection['red_lower'].tolist()
red_upper_list=projection['red_upper'].tolist()
green_lower_list=projection['green_lower'].tolist()
green_upper_list=projection['green_upper'].tolist()
blue_lower_list=projection['blue_lower'].tolist()
blue_upper_list=projection['blue_upper'].tolist()


# In[ ]:


image_list=[]

for i in range(len(projection_list)):
    images = pd.DataFrame(api.model_query('SectionImage',
                            criteria='[data_set_id$eq%f]'%(projection_list[i]),
                            num_rows='all'))
    # extract the image id column as list
    image_list.append(images)
    
    


# In[ ]:


# Create the URLs

API_PATH = 'http://api.brain-map.org/api/v2/image_download/'

URL_list=[]
image_id_many_list=[]
for i in range(len(image_list)): # for each sectionImage
    image_id_many=image_list[i]['id'].tolist()
    image_id_many_list.append(image_id_many)
    for j in range(len(image_list[i])): # for each image
        image_id=image_id_many[j]
        URL=(('%s' %(API_PATH)) +             '%d' % (image_id) +             '?range=' +             '%d' % (red_lower_list[j]) +             ',' +             '%d' % (red_upper_list[j]) +             ',' +             '%d' % (green_lower_list[j]) +             ',' +             '%d' % (green_upper_list[j]) +             ',' +             '%d' % (blue_lower_list[j]) +             ',' +             '%d' % (blue_upper_list[j]) +             '&downsample=%d' % (downsample))
        URL_list.append(URL)
        


# In[ ]:


# create file names
filenames=[]
sectionImageID=[int(x) for x in projection_list] # as for image id: image_id_many_list 
for i in range(len(image_list)):
    for j in range(len(image_id_many_list[i])):
        filename=('SecImID_%d' %(sectionImageID[i])+                  '_'+                  'ImID_%d' %(image_id_many_list[i][j])+                  '.jpg')  
        filenames.append(filename)
        
        


# In[ ]:


import requests 
for i in range(len(URL_list)):
    fName=filenames[i]
    URL_name=URL_list[i]
    with open(fName, 'wb') as handle:
        response = requests.get(URL_name, stream=True)

        if not response.ok:
            print response

        for block in response.iter_content(1024):
            if not block:
                break

            handle.write(block)

