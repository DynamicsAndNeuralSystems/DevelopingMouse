from allensdk.api.queries.rma_api import RmaApi
import pandas as pd
import requests, zipfile
from io import StringIO
import csv
import os
api = RmaApi()

age_names = ['E11.5','E13.5','E15.5','E18.5','P4','P14','P28']

age_str = "'" + "','".join(age_names) + "'"

criteria='[failed$eqfalse],products[abbreviation$eqDevMouse],specimen(donor(age[name$in%s])),plane_of_section[name$eqsagittal]'%age_str

print('hi')

experiment=api.model_query('SectionDataSet',
                            criteria=criteria,
                            include='probes(gene),specimen(donor(age))',
                            start_row=0,
                            num_rows='all')
print(experiment)
