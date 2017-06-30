
# coding: utf-8

# In[ ]:


# shows detailed info about possible RMA query methods
from allensdk.api.queries.rma_api import RmaApi


rma = RmaApi()
# http://api.brain-map.org/api/v2/data.json
schema = rma.get_schema()
for entry in schema:
    data_description = entry['DataDescription']
    clz = data_description.keys()[0]
    info = data_description.values()[0]
    fields = info['fields']
    associations = info['associations']
    table = info['table']
    print("class: %s" % (clz))
    print("fields: %s" % (','.join(f['name'] for f in fields)))
    print("associations: %s" % (','.join(a['name'] for a in associations)))
    print("table: %s\n" % (table))

