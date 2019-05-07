# for each gene, for each developmental time point, search for the SectionDataSet

from allensdk.api.queries.rma_api import RmaApi
import pandas as pd
import os
api = RmaApi()

# specify directory of ID file
abs_dir = os.path.dirname(__file__)
rel_dir = os.path.join(abs_dir, '..','Data','API','Structures')

# user input directory name here for saving the files at the end # ages = ['E11.5']
#directory='D:\Data\DevelopingAllenMouseAPI-master\Git\Data\\'
def getDivision(brainDivision):
    BRAIN_DIVISION=brainDivision
    ages = ['E11.5','E13.5','E15.5','E18.5','P4','P14','P28']
    age_str = "'" + "','".join(ages) + "'"
    criteria=['[graph_id$eq17][st_level$eq1]'+('[acronym$eq%s]'%BRAIN_DIVISION)
              #'products[abbreviation$eqDevMouse],'
              #'specimen(donor(age[name$in%s])),' %age_str,
              #'plane_of_section[name$eqsagittal]'
             ]
    structure=pd.DataFrame(api.model_query('Structure',
                                criteria="".join(criteria),
                                include='descendant_hierarchies(descendant)',
                                start_row=0,
                                num_rows='all'))
    # str = os.path.join(abs_dir, rel_dir, 'acronym_AdultMouse.csv')


    # extract ID of descendants
    descendantID=[]
    #only keep those experiments with entrez ID available
    for i in range(len(structure['descendant_hierarchies'][0])):
        descendantID.append(structure['descendant_hierarchies'][0][i].get('descendant_id'))
    return structure,descendantID
def main():
    # get forebrain data and descendant ID
    structure, descendantID = getDivision('F')
    structure.to_csv(os.path.join(abs_dir, rel_dir,'structure_F.csv'))
    pd.DataFrame(descendantID).to_csv(os.path.join(abs_dir, rel_dir,'structure_F_descendant_ID.csv'))
    # get midbrain and descendant ID
    structure, descendantID = getDivision('M')
    structure.to_csv(os.path.join(abs_dir, rel_dir,'structure_M.csv'))
    pd.DataFrame(descendantID).to_csv(os.path.join(abs_dir, rel_dir,'structure_M_descendant_ID.csv'))
    # get hindbrain and descendant ID
    structure, descendantID = getDivision('H')
    structure.to_csv(os.path.join(abs_dir, rel_dir,'structure_H.csv'))
    pd.DataFrame(descendantID).to_csv(os.path.join(abs_dir, rel_dir,'structure_H_descendant_ID.csv'))
if __name__ == '__main__':
    main()
