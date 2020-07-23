from allensdk.api.queries.rma_api import RmaApi
import pandas as pd
import requests, zipfile
from io import BytesIO
import csv
import os
import time
api = RmaApi()

# specify the directories
abs_dir = os.path.dirname(__file__)
rel_dir = os.path.join(abs_dir, '..','Data','API','GridData')

# age_name = 'P56'

criteria=['[failed$eqfalse],',
           'products[abbreviation$eqMouse],',
           # 'specimen(donor(age[name$eq%s])),' %age_name,
           'plane_of_section[name$eqcoronal]',
           ]

def downloadBasicData(experiment):

    # extract the info
    expID_list=[]
    age_list=[]
    geneID_list=[]
    geneAcronym_list=[]

    # print(experiment)
    for counter, value in enumerate(experiment):
        #only keep those experiments with entrez ID available
        if experiment[counter]['probes']:
            if not (experiment[counter]['probes'][0]['gene']['entrez_id']==None):
                expID_list.append(experiment[counter]['id'])
                age_list.append(experiment[counter]['specimen']['donor']['age']['name'])
                geneID_list.append(experiment[counter]['probes'][0]['gene']['entrez_id'])
                geneAcronym_list.append(experiment[counter]['probes'][0]['gene']['acronym'])

    # used = set()
    # age_unique = [x for x in age_list if x not in used and (used.add(x) or True)]
    # used = set()
    # geneID_unique = [x for x in geneID_list if x not in used and (used.add(x) or True)]
    # used = set()
    # geneAcronym_unique = [x for x in geneAcronym_list if x not in used and (used.add(x) or True)]

    # file_str=os.path.join(rel_dir,'timePoints.csv')
    # with open(file_str, 'w') as myfile:
    #     wr = csv.writer(myfile, quoting=csv.QUOTE_ALL)
    #     wr.writerow(age_unique)
    # file_str=os.path.join(rel_dir,'geneEntrez.csv')
    # with open(file_str, 'w') as myfile:
    #     wr = csv.writer(myfile, quoting=csv.QUOTE_ALL)
    #     wr.writerow(geneID_unique)
    # file_str=os.path.join(rel_dir,'geneAbbreviations.csv')
    # with open(file_str, 'w') as myfile:
    #     wr = csv.writer(myfile, quoting=csv.QUOTE_ALL)
    #     wr.writerow(geneAcronym_unique)

    return expID_list, age_list, geneID_list

def downloadGridData(expID_list,age_list,geneID_list):
    # create the URL
    API_PATH='http://api.brain-map.org/grid_data/download/'
    URL_list=[]
    # dataType=['energy','intensity']
    dataType=['energy']
    dataType_str = ','.join(dataType)

    for j in expID_list: # for each experiment
        URL=(('%s' %(API_PATH)) +\
            '%d' % (j) +\
            '?include=' +\
            '%s' %(dataType_str))
        URL_list.append(URL)
    print('There are %d URLs in total'%(len(URL_list)))
    for j in range(len(URL_list)): #len(URL_list)
        connectSuccess = 0
        while connectSuccess == 0:
            try:
                r = requests.get(URL_list[j], stream=True)
                connectSuccess = 1
            except requests.exceptions.ConnectionError:
                print("Connection refused by the server..")
                print("Let me sleep for 5 seconds")
                print("ZZzzzz...")
                time.sleep(5)
                print("Was a nice sleep, now let me continue...")
                print('still %d grids left undownloaded'%(len(URL_list)-j))
                # print(URL_list[-(len(URL_list)-j):])
                continue
        temp_list = [age_list[j],'_',str(geneID_list[j]),'_',str(expID_list[j])]
        # temp_list = [age_list[j],'_',str(geneID_list[j])]
        dirName=os.path.join(rel_dir,age_list[j],"".join(temp_list))
        try:
            z = zipfile.ZipFile(BytesIO(r.content))
        except zipfile.BadZipFile:
            print('%s gives a bad zip file'%URL_list[j])
        else:
            z.extractall(dirName)

def main():
    experiment=api.model_query('SectionDataSet',
                                criteria="".join(criteria),
                                include='probes(gene),specimen(donor(age))',
                                start_row=0,
                                num_rows='all')
    expID_list, age_list, geneID_list = downloadBasicData(experiment)
    downloadGridData(expID_list,age_list,geneID_list)

if __name__ == '__main__':
    main()
