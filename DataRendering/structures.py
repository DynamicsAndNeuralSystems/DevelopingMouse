# import sys
# print('\n'.join(sys.path))

from allensdk.api.queries.rma_api import RmaApi
import pandas as pd
import os



api = RmaApi()

MOUSE_GRAPH_ID = 17

def getStructureInfo(structure_level, other_criteria):
    STRUCTURE_LEVEL=structure_level
    OTHER_CRITERIA=other_criteria

    structures = pd.DataFrame(
        api.model_query('Structure',
                        criteria=('[graph_id$eq%d]' % MOUSE_GRAPH_ID)+\
                                ('[st_level$eq%d]' % STRUCTURE_LEVEL)+\
                                (str(OTHER_CRITERIA)),
                        num_rows='all'))
    return structures

def getStructureInfo_AdultMouse():
    structures = pd.DataFrame(
        api.model_query('Structure',
                        criteria='[graph_id$eq1]',
                        num_rows='all'))
    return structures

def getCentreCoordinates_DevMouse(structure_level):
    STRUCTURE_LEVEL=structure_level

    structure_centers = pd.DataFrame(
    api.model_query('StructureCenter',
                    criteria='structure'+\
                            ('[st_level$eq%d]' % STRUCTURE_LEVEL)+\
                            ('[graph_id$eq%d]' % MOUSE_GRAPH_ID),
                    num_rows='all'))
    return structure_centers

def getCentreCoordinates_AdultMouse():
    structure_centers_adult = pd.DataFrame(
    api.model_query('StructureCenter',
                    criteria='structure[graph_id$eq1]',
                    num_rows='all'))
    return structure_centers_adult

def getAcronymPath(structure_level, other_criteria):
    STRUCTURE_LEVEL=structure_level
    OTHER_CRITERIA=other_criteria

    OntologyNode = pd.DataFrame(
    api.model_query('OntologyNode',
                    criteria='structure'+\
                            ('[st_level$eq%d]' % STRUCTURE_LEVEL)+\
                            ('[graph_id$eq%d]' % MOUSE_GRAPH_ID)+\
                            (str(OTHER_CRITERIA)),
                    num_rows='all'))
    return OntologyNode

def main():
    #os.chdir(r'D:\Data\DevelopingAllenMouseAPI-master\Git') # user input the Git directory as on their computer here

    # download level 5 structures of developing mouse
    other_criteria_level5 = '[parent_structure_id$ne126651574]\
                            [parent_structure_id$ne126651586]\
                            [parent_structure_id$ne126651606]\
                            [parent_structure_id$ne126651618]\
                            [parent_structure_id$ne126651642]\
                            [parent_structure_id$ne126651654]\
                            [parent_structure_id$ne126651670]\
                            [parent_structure_id$ne126651682]\
                            [parent_structure_id$ne126651698]\
                            [parent_structure_id$ne126651710]\
                            [parent_structure_id$ne126651730]\
                            [parent_structure_id$ne126651742]\
                            [parent_structure_id$ne126651758]\
                            [parent_structure_id$ne126651770]\
                            [parent_structure_id$ne126651790]\
                            [parent_structure_id$ne126651810]\
                            [parent_structure_id$ne126651830]\
                            [parent_structure_id$ne126651854]\
                            [parent_structure_id$ne126651874]\
                            [parent_structure_id$ne126651898]\
                            [parent_structure_id$ne126651918]\
                            [parent_structure_id$ne126651942]\
                            [parent_structure_id$ne126651962]\
                            [parent_structure_id$ne126651982]\
                            [parent_structure_id$ne126652002]\
                            [parent_structure_id$ne126652022]\
                            [parent_structure_id$ne17651]\
                            [parent_structure_id$ne126652042]'

    structures=getStructureInfo(structure_level=5, other_criteria=other_criteria_level5)

    STRUCTURE_LEVEL = 5

    # specify the directories
    abs_dir = os.path.dirname(__file__)
    rel_dir = os.path.join(abs_dir, '..','Data','API','Structures')

    data = os.path.join(rel_dir, 'structureData_level%d.csv' % STRUCTURE_LEVEL)
    structures.to_csv(data)

    # download level 3 structures pf developing mouse
    other_criteria_level3 = '[parent_structure_id$ne126651566]\
                            [parent_structure_id$ne126651634]\
                            [parent_structure_id$ne126651722]\
                            [parent_structure_id$ne126651786]\
                            [parent_structure_id$ne126651850]\
                            [parent_structure_id$ne126651894]\
                            [parent_structure_id$ne126651938]'
    structures=getStructureInfo(structure_level=3, other_criteria=other_criteria_level3)

    STRUCTURE_LEVEL = 3

    data = os.path.join(rel_dir, 'structureData_level%d.csv' % STRUCTURE_LEVEL)
    structures.to_csv(data)

    # download adult mouse structure info
    structures = getStructureInfo_AdultMouse()
    data = os.path.join(rel_dir, 'structureData_adult.csv')
    structures.to_csv(data)

    # Download coordinates of centre of developing mouse structures
    structure_centers=getCentreCoordinates_DevMouse(structure_level=5)
    STRUCTURE_LEVEL = 5
    data = os.path.join(rel_dir, 'structureCenters_level%d.csv' % STRUCTURE_LEVEL)
    structure_centers.to_csv(data)

    # Download coordinates of centre of adult mouse structures
    structure_centers_adult=getCentreCoordinates_AdultMouse()
    data = os.path.join(rel_dir, 'structureCenters_adult.csv')
    structure_centers_adult.to_csv(data)

    # download acronym path for developing mouse
    OntologyNode=getAcronymPath(structure_level=5, other_criteria=other_criteria_level5)
    STRUCTURE_LEVEL = 5
    data = os.path.join(rel_dir, 'AcronymPath_level%d.csv' % STRUCTURE_LEVEL)
    OntologyNode.to_csv(data)

if __name__ == '__main__':
    main()
