from allensdk.api.queries.rma_api import RmaApi
import pandas as pd
import os
api = RmaApi()

# specify the directories
abs_dir = os.path.dirname(__file__)
rel_dir = os.path.join(abs_dir, '..','Data','API','Filtering_testing')
# for each gene, for each developmental time point, search for the SectionDataSet
ages = ['E11.5','E13.5','E15.5','E18.5','P4','P14','P28']

def getSpinalCordDescendentID():
    age_str = "'" + "','".join(ages) + "'"

    criteria=['[graph_id$eq17][st_level$eq1][acronym$eqSpC],',
                'products[abbreviation$eqDevMouse],',
                'specimen(donor(age[name$in%s])),' %age_str,
                'plane_of_section[name$eqsagittal]']
    structure_SpC=pd.DataFrame(api.model_query('Structure',
                                                criteria="".join(criteria),
                                                include='descendant_hierarchies(descendant)',
                                                start_row=0,
                                                num_rows='all'))
    # extract ID of descendants
    descendantID=[]
    for i in range(len(structure_SpC['descendant_hierarchies'][0])):
        descendantID.append(structure_SpC['descendant_hierarchies'][0][i].get('descendant_id'))
        
    return descendantID

def main():
    descendantID = getSpinalCordDescendentID()
    data = os.path.join(rel_dir, 'SpC_descendantID.csv')
    pd.DataFrame(descendantID).to_csv(data)

if __name__ == '__main__':
    main()
