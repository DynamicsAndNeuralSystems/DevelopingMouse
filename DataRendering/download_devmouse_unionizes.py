#-------------------------------------------------------------------------------
# Script from David Feng
#-------------------------------------------------------------------------------
import pandas as pd
from allensdk.api.queries.rma_api import RmaApi
import allensdk.core.json_utilities as json_utilities
import numpy as np
import csv # For saving string data to csv

#-------------------------------------------------------------------------------
# Global parameters:
#-------------------------------------------------------------------------------
json_file_name = 'all_unionizes.json'
csv_file_name = 'unionizes.csv'

structure_acronyms = ['isR','isA','r1R','r1A']
# structure_acronyms = ['is','r1']
ages = ['E11.5','E13.5','E15.5','E18.5','P4','P14','P28','P56']

def download_devmouse_unionizes(file_name, structure_acronyms, age_names):
    acronym_str = "'" + "','".join(structure_acronyms) + "'"
    age_str = "'" + "','".join(age_names) + "'"

    api = RmaApi()

    criteria = [
        "structure[acronym$in%s][graph_id$eq17]," % acronym_str,
        "section_data_set[failed$eqfalse](products[id$eq3],specimen(donor(age[name$in%s])))" % age_str
        ]

    # only_list = ["ages.name","donors.age_id","specimens.age_id","data_sets.age_id"]

    # Settings for retrieval
    rows = []
    blockSize = 2000
    done = False
    startRow = 0
    # for i in range(0, total_rows, blockSize):

    while not done:
        print "Row %d, attempting to retrieve %d rows..." % (startRow, blockSize)

        tot_rows = len(rows)
        rows += api.model_query(model='StructureUnionize',
                                criteria="".join(criteria),
                                include="section_data_set(probes(gene),specimen(donor(age))),structure",
                                start_row=startRow,
                                num_rows=blockSize)

        numRows = len(rows) - tot_rows # additional rows retrieved on running the query
        startRow += numRows

        print "%d rows retrieved." % numRows

        # Check if we're at the end of the road
        if numRows == 0 or numRows < blockSize:
            done = True

        # write out the results as they come in
        json_utilities.write(file_name, rows)

    return rows


def to_dataframe(unionizes, ages):
    fdata = []
    for unionize in unionizes:
        if 'section_data_set' not in unionize:
            continue

        fdata.append({
            'age_name': unionize['section_data_set']['specimen']['donor']['age']['name'],
            'data_set_id': unionize['section_data_set']['id'],
            'structure': unionize['structure']['acronym'],
            'gene_acronym': unionize['section_data_set']['probes'][0]['gene']['acronym'],
            'gene_entrez': unionize['section_data_set']['probes'][0]['gene']['entrez_id'],
            'delegate': unionize['section_data_set']['delegate'],
            'expression_energy': unionize['expression_energy'],
            'expression_density': unionize['expression_density']
        })

    return pd.DataFrame.from_records(fdata)

def SaveListCSV(stringList,fileName):
    resultFile = open(fileName,'wb')
    wr = csv.writer(resultFile, dialect='excel')
    wr.writerow(stringList)

def SaveExpressionEnergy(df):
    # Make a matrix for each structure
    # Rows are the datasets, and columns are the time points

    # First get set of unique genes:
    unique_genes = df.gene_acronym.unique()

    numGenes = len(unique_genes)
    numStructs = len(structure_acronyms)
    numTimePoints = len(ages)

    print "Saving expression data..."

    for structureName in structure_acronyms:
        print structureName+"..."
        ExpressionData = {};
        ExpressionData['energy'] = np.empty([numTimePoints,numGenes])
        ExpressionData['energy'].fill(np.nan)
        ExpressionData['density'] = np.empty([numTimePoints,numGenes])
        ExpressionData['density'].fill(np.nan)

        # Reduced data frame:
        df_red = df[df.structure.isin([structureName])]

        for gi,geneName in enumerate(unique_genes):
            # Match gene and structure:
            df_match = df_red[df_red.gene_acronym.isin([geneName])]

            for ai,ageName in enumerate(ages):
                # Store mean of all results in corresponding matrix element:
                ExpressionData['energy'][ai,gi] = df_match[df_match.age_name.isin([ageName])]['expression_energy'].mean()
                ExpressionData['density'][ai,gi] = df_match[df_match.age_name.isin([ageName])]['expression_density'].mean()

        # Save to a csv file:
        fileName = "SDK_ExpressionEnergy_%s.csv" % structureName
        np.savetxt(fileName, ExpressionData['energy'], delimiter=",")
        fileName = "SDK_ExpressionDensity_%s.csv" % structureName
        np.savetxt(fileName, ExpressionData['density'], delimiter=",")

    # Save the structures:
    SaveListCSV(structure_acronyms,"SDK_StructureNames.csv")

    # Save the time points:
    SaveListCSV(ages,"SDK_timePoints.csv")

    # Save the genes:
    SaveListCSV(unique_genes,"SDK_geneAbbreviations.csv")

    # Match the entrez_id
    unique_entrez = df.gene_entrez.unique()
    SaveListCSV(unique_entrez,"SDK_geneEntrez.csv")
    # entrez_ids = [df.gene_entrez[a] for ]

def main():
    # Download and save all of the data to file:
    # unionizes = download_devmouse_unionizes(file_name = json_file_name,
    #                                         structure_acronyms = structure_acronyms,
    #                                         age_names = ages)

    # Read in previously-downloaded results:
    unionizes = json_utilities.read(json_file_name)

    # Make a data frame of the datasets downloaded:
    df = to_dataframe(unionizes, ages)

    # Save data summary as a .csv file:
    df.to_csv(csv_file_name)

    # Show summary to screen:
    gb = df.groupby(['structure','age_name'])
    gdf = gb.agg({'data_set_id': pd.Series.nunique})

    print gdf

    # Make an expression energy matrix:
    SaveExpressionEnergy(df)

if __name__ == "__main__": main()
