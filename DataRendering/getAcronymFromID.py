from allensdk.api.queries.ontologies_api import OntologiesApi
from allensdk.core.structure_tree import StructureTree
from allensdk.api.queries.mouse_connectivity_api import MouseConnectivityApi
from allensdk.config.manifest import Manifest
from allensdk.core.reference_space import ReferenceSpace
import os
import nrrd
import functools
import numpy as np
import itertools
import math
import csv

# secify directory of ID file
abs_dir = os.path.dirname(__file__)
rel_dir = os.path.join(abs_dir, '..','Processed')

def get_acronym_by_id(ID_file_name, mouse_graph_id):
    # mouse_graph_id: adult mouse = 1, developing mouse = 17
    IDFILENAME = os.path.join(abs_dir, rel_dir, ID_file_name)
    # read in the IDs
    f=open(IDFILENAME, "r")
    reader=csv.reader(f,delimiter=',')
    ID_need=[]
    for row in reader:
        ID=row[0]
        ID_need.append(ID)
    ID_need=[int(float(i)) for i in ID_need]
    print('A total of %d brain regions inputted'%(len(ID_need)))
    # create a structure tree
    oapi = OntologiesApi()
    structure_graph = oapi.get_structures_with_sets([mouse_graph_id])
    structure_graph = StructureTree.clean_structures(structure_graph) # This removes some unused fields returned by the query
    tree = StructureTree(structure_graph)
    # build a custom map that looks up acronyms by ids
    acronym_map = tree.value_map(lambda x: x['id'], lambda y: y['acronym'])
    # Get the acronyms
    acronym_need=[]
    index=0
    for i in ID_need:
        acronym_need=acronym_need+[acronym_map[ID_need[index]]]
        index=index+1
    return acronym_need


def main():
    # Get acronyms of adult mouse from ID
    acronym_need=get_acronym_by_id(ID_file_name='ID_AdultMouse.csv', mouse_graph_id=1)
    # specify the directories to save
    rel_dir = os.path.join(abs_dir, '..','Processed')
    str = os.path.join(abs_dir, rel_dir, 'acronym_AdultMouse.csv')
    # save the list of region acronyms
    np.savetxt(str, acronym_need, fmt='%.20s', delimiter=",")

    # testing
    # acronym_need1=get_acronym_by_id(ID_file_name='testing_id.csv', mouse_graph_id=1)
    # str = os.path.join(abs_dir, rel_dir, 'testing_acronym.csv')
    # # save the list of region acronyms
    # np.savetxt(str, acronym_need1, fmt='%.20s', delimiter=",")

if __name__ == '__main__':
    main()
