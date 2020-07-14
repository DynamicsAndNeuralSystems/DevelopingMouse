# for each gene, for each developmental time point, search for the SectionDataSet

from allensdk.api.queries.rma_api import RmaApi
import pandas as pd
import os
api = RmaApi()

# specify directory of ID file
abs_dir = os.path.dirname(__file__)
rel_dir = os.path.join(abs_dir,'..','Data','API','Structures')
brainDivisions = ['F','M','H','DPall','SpC']

# user input directory name here for saving the files at the end # ages = ['E11.5']
#directory='D:\Data\DevelopingAllenMouseAPI-master\Git\Data\\'
def getDivision(brainDivision):
    BRAIN_DIVISION=brainDivision
    ages = ['E11.5','E13.5','E15.5','E18.5','P4','P14','P28']
    age_str = "'" + "','".join(ages) + "'"
    if BRAIN_DIVISION == 'DPall':
        ST_LEVEL = '7'
    else: # forebrain, midbrain or hindbrain
        ST_LEVEL = '1'

    criteria=['[graph_id$eq17][st_level$eq%s]'%ST_LEVEL+('[acronym$eq%s]'%BRAIN_DIVISION)]
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
    for brainDivision in brainDivisions:
        structure, descendantID = getDivision(brainDivision)
        fileNameStructure = os.path.join(abs_dir,rel_dir,'structure_%s.csv' % brainDivision)
        structure.to_csv(fileNameStructure)
        print("Saved structure info for %s to %s" % (brainDivision,fileNameStructure))
        fileNameDescendant = os.path.join(abs_dir,rel_dir,'structure_%s_descendant_ID.csv' % brainDivision)
        pd.DataFrame(descendantID).to_csv(fileNameDescendant)
        print("Saved descendant IDs for %s to %s" % (brainDivision,fileNameDescendant))

    # # get forebrain data and descendant ID
    # structure, descendantID = getDivision('F')
    # structure.to_csv(os.path.join(abs_dir, rel_dir,'structure_F.csv'))
    # pd.DataFrame(descendantID).to_csv(os.path.join(abs_dir, rel_dir,'structure_F_descendant_ID.csv'))
    # # get midbrain and descendant ID
    # structure, descendantID = getDivision('M')
    # structure.to_csv(os.path.join(abs_dir, rel_dir,'structure_M.csv'))
    # pd.DataFrame(descendantID).to_csv(os.path.join(abs_dir, rel_dir,'structure_M_descendant_ID.csv'))
    # # get hindbrain and descendant ID
    # structure, descendantID = getDivision('H')
    # structure.to_csv(os.path.join(abs_dir, rel_dir,'structure_H.csv'))
    # pd.DataFrame(descendantID).to_csv(os.path.join(abs_dir, rel_dir,'structure_H_descendant_ID.csv'))

if __name__ == '__main__':
    main()
