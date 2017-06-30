import numpy as np
import json
import sys
import os
import urllib
import string
import csv # For saving string data to csv
import pickle # for saving data

# http://api.brain-map.org/api/v2/data/query.csv?
# criteria=model::StructureUnionize,
# rma::criteria,
# section_data_set[delegate$eqfalse]%28genes[id$eq21177],specimen%28donor%28age[name$in%27E11.5%27,%27E13.5%27,%27E15.5%27,%27E18.5%27,%27P4%27,%27P14%27,%27P28%27]%29%29%29,
# structure%28structure_sets_structures%28structure_set[name$eq%27Developing%20Mouse%20-%20Coarse%27]%29%29
# &order=ages.embryonic$desc,ages.days,structures.graph_order&num_rows=100&tabular=structure_unionizes.section_data_set_id,ages.name%20as%20age,ages.embryonic,ages.days,structures.acronym,structures.name,structures.graph_order,structure_unionizes.expression_energy


# URL path to the Allen Institute API, retrieving json:
API_PATH = "http://api.brain-map.org/api/v2/data/query.json?"
MOUSE_GRAPH_ID = 17 # (the graph ID)
MOUSE_PRODUCT_ID = 3 # the product ID


def GetGenes_section():
    # URL TO GET GENES:
    DATA_SET_URL = (("%scriteria=" % API_PATH) +\
              "model::SectionDataSet" +\
              ",rma::criteria" +\
              ",[failed$eq'false']" +\
              (",products[id$eq%d]" % MOUSE_PRODUCT_ID) +\
              ",rma::include,genes" +\
              ",rma::options[only$eq'genes.id'][order$eq'genes.id$asc']")
    sectionDatasets = QueryAPI(DATA_SET_URL)
    return structs


def GetGenes_gene():
    # ALL_GENES_URL = "http://api.brain-map.org/api/v2/data/Gene/query.xml?criteria=products[id$eq%d]" % MOUSE_PRODUCT_ID
    ALL_GENES_URL = (("%scriteria=" % API_PATH) +\
              "model::Gene" +\
              ",rma::criteria" +\
              (",products[id$eq%d]" % MOUSE_PRODUCT_ID)) # +\
                #   ",rma::options[only$eq'genes.id']")
    geneData = QueryAPI(ALL_GENES_URL)
    # Sort by ID:
    geneData = sorted(geneData, key=lambda k: k['id'])
    print "%d datasets retrieved" % len(geneData)
    return geneData


def StructureName(structID=16375):
    # Converts structure ID to a structure name (and associated metadata)
    URL = (("%s" % (API_PATH)) +\
            "criteria=model::Structure" +\
            ",rma::criteria," +\
            ("[id$eq%d]" % (structID)))
    structs = QueryAPI(URL)

    print "%d structures retrieved!\n" % len(structs)
    return structs[0]

def StructureID(structAcro="is"):
    # Converts structure ID to a structure name (and associated metadata)
    URL = (("%s" % (API_PATH)) +\
            "criteria=model::Structure" +\
            ",rma::criteria," +\
            ("[acronym$eq'%s'][graph_id$eq%d]" % (structAcro,MOUSE_GRAPH_ID)))
    structs = QueryAPI(URL)

    print "%d structures retrieved!\n" % len(structs)
    return structs[0]['id']

def Query_alltime(geneID=21177,structID=16375):
    # Retrieve for a given gene and structure across time
    URL = (("%s" % (API_PATH)) +\
            "criteria=model::StructureUnionize" +\
            ",rma::criteria" +\
            ",section_data_set" +\
            ("(genes[id$eq%d]," % (geneID)) +\
            "specimen(donor(age[name$in'E11.5','E13.5','E15.5','E18.5','P4','P14','P28']))," +\
            ("structure_unionizes[structure_id$eq%d])," % (structID)) +\
            "rma::include,section_data_set(specimen(donor(age)))" +\
            ",rma::options[only$eq'ages.name,donors.age_id,specimens.age_id,data_sets.age_id']")
            #  +\ "rma::include,section_data_set(specimen(donor(age)))")
            # "&tabular=ages.name%20as%20age,structures.acronym,structures.name,structure_unionizes.expression_energy")
    data = QueryAPI(URL,False,"all")
    return data

def Query_alltime_structs(geneID=21177):
    # Specify a gene and get all data for it
    URL = (("%s" % (API_PATH)) +\
            "criteria=model::StructureUnionize" +\
            ",rma::criteria" +\
            ",section_data_set[delegate$eqfalse]" +\
            ("(genes[id$eq%d]," % (geneID)) +\
            "specimen(donor(age[name$in'E11.5','E13.5,'E15.5','E18.5','P4','P14','P28']))")
    data = QueryAPI(URL)
    return data

def GiveMeFullURL(timePoint="E11.5",geneID=21177,structID=16375):
    # Piece together a unionize URL:
    # Specify all parameters
    URL = (("%s" % (API_PATH)) +\
            "criteria=model::StructureUnionize" +\
            ",rma::criteria" +\
            ",section_data_set[delegate$eqfalse]" +\
            ("(genes[id$eq%d]," % (geneID)) +\
            ("specimen(donor(age[name$eq'%s']))," % (timePoint)) +\
            ("structure_unionizes[structure_id$eq%d])" % (structID)))
    return URL


def GiveMeURL(timePoint,structID):
    # Specify just time point and structure ID
    URL = (("%s" % (API_PATH)) +\
        "criteria=model::StructureUnionize" +\
        ",rma::criteria" +\
        ",section_data_set[delegate$eqfalse]" +\
        ("(specimen(donor(age[name$eq'%s']))," % (timePoint)) +\
        ("structure_unionizes[structure_id$eq%d])" % (structID)) +\
        ",structure(structure_sets_structures(structure_set[name$eq'Developing Mouse - Coarse']))")
    return URL
            # "&order=structures.graph_order&num_rows=100&tabular=structure_unionizes.section_data_set_id,ages.name as age," +\
            # "ages.embryonic,ages.days,structures.acronym,structures.name,structures.graph_order,structure_unionizes.expression_energy")

def SaveListCSV(stringList,fileName):
    resultFile = open(fileName,'wb')
    wr = csv.writer(resultFile, dialect='excel')
    wr.writerow(stringList)

def sortExpData(data,timePoints):
    # Sorts data from Query_alltime -- outputs properly ordered data vector

    # Initialize:
    expEnergy = np.empty([len(timePoints)])
    expEnergy.fill(np.nan)
    expDensity = np.empty([len(timePoints)])
    expDensity.fill(np.nan)

    # Check if data exists
    if len(data)==0:
        return expEnergy,expDensity

    # Get age of each entry:
    ages = [d['section_data_set']['specimen']['donor']['age']['name'] for d in data]

    # timePoints = ["E11.5","E13.5","E15.5","E18.5","P4","P14","P28"]
    for ai,age in enumerate(ages):
        # index of timePoints:
        ind = [i for i,timePoint in enumerate(timePoints) if timePoint==age][0]
        # print ind
        # Store data:
        expEnergy[ind] = data[ai]['expression_energy']
        expDensity[ind] = data[ai]['expression_density']

    return expEnergy,expDensity

def QueryAPI(url,doPrint=False,num_rows=2000):
    # Make a query to the API via a URL:
    start_row = 0
    total_rows = -1
    rows = []
    done = False

    # The data has to be downloaded in pages, since the API will not return more than 2000 rows at once.

    while not done:
        if isinstance(num_rows, basestring):
            pagedUrl = url + '&start_row=%d&num_rows=all' % (start_row)
            done = True
        else:
            pagedUrl = url + '&start_row=%d&num_rows=%d' % (start_row,num_rows)

        if doPrint:
            print pagedUrl
        source = urllib.urlopen(pagedUrl).read()

        response = json.loads(source)
        rows += response['msg']

        if total_rows < 0:
            total_rows = int(response['total_rows'])

        # print "start_row = %d, total_rows = %d, response_msg = %d, num_rows = %d" % (start_row, total_rows,len(response['msg']),response['num_rows'])
        start_row += len(response['msg'])


        if start_row >= total_rows:
            done = True
        if int(response['num_rows']) == 0:
            # print "No rows...?"
            done = True

    return rows

#-------------------------------------------------------------------------------

def main():

    # 1. Get all gene IDs:
    # subsetGenes = 10
    allGenes = GetGenes_gene()
    geneIDs = [g['id'] for g in allGenes]
    # geneIDs = [21177,18199,16909]
    # geneIDs = geneIDs[0:subsetGenes]
    numGenes = len(geneIDs)

    # 2. Get all structureIDs:
    structureNames = ["isR","isA","r1R","r1A"]
    # structureNames = ["is","r1"]
    structureIDs = [StructureID(sname) for sname in structureNames]
    numStructs = len(structureIDs)

    # 3. Specify all time points:
    timePoints = ["E11.5","E13.5","E15.5","E18.5","P4","P14","P28"]
    numTimePoints = len(timePoints)

    print "Retrieving over %d time points for %d genes over %d structures" % (numTimePoints, numGenes, numStructs)

    # 3. Loop over each to get expression at each time point
    ExpressionData = {} # dictionary because why not
    ExpressionData['exp_density'] = {}
    ExpressionData['exp_energy'] = {}

    for si,structID in enumerate(structureIDs):
        structureName = structureNames[si]

        print "\n\n\n\nSTRUCTURE %s: %d / %d\n\n\n\n" % (structureName,si+1,numStructs)
        ExpressionData['exp_density'][structureName] = np.empty([numTimePoints,numGenes])
        ExpressionData['exp_density'][structureName].fill(np.nan)
        ExpressionData['exp_energy'][structureName] = np.empty([numTimePoints,numGenes])
        ExpressionData['exp_energy'][structureName].fill(np.nan)

        for gi,geneID in enumerate(geneIDs):
            geneName = [g['acronym'] for g in allGenes if g['id']==geneID][0]

            # for ti,timePoint in enumerate(timePoints):
            # print "Time %d / %d, gene %d / %d" % (ti+1,numTimePoints,gi+1,numGenes)
            # data = QueryAPI(GiveMeFullURL(timePoint,geneID,structID))

            # Get data for this gene and structure from the Allen API:
            data = Query_alltime(geneID,structID)

            if len(data)>0:
                # Retrieved some data, match it to the time points and store in the matrix:
                expEnergy,expDensity = sortExpData(data,timePoints)
                ExpressionData['exp_energy'][structureName][:,gi] = expEnergy
                ExpressionData['exp_density'][structureName][:,gi] = expDensity
                print "[%d/%d]~~SUCCESS~~ for gene: %s (%d), structure: %s (%d)" % (gi+1,numGenes,geneName,geneID,structureName,structID)
            else:
                print "[%d/%d]No data for gene: %s (%d), structure: %s (%d)" % (gi+1,numGenes,geneName,geneID,structureName,structID)

        # Save full expression data for this structure to csv:
        fileName = "ExpressionEnergy_%s.csv" % structureName
        np.savetxt(fileName, ExpressionData['exp_energy'][structureName], delimiter=",")
        fileName = "ExpressionDensity_%s.csv" % structureName
        np.savetxt(fileName, ExpressionData['exp_density'][structureName], delimiter=",")


    #-------------------------------------------------------------------------------
    # Save results to file:
    #-------------------------------------------------------------------------------

    # Saving the objects:
    # with open('objs.pickle','w') as f:
        # pickle.dump([ExpressionData, structureIDs, geneIDs, timePoints], f)

    # Saving metadata to csv:

    # 1) Data files:
    # for ti,timePoint in enumerate(timePoints):
        # fileName = "ExpressionEnergy_%s.csv" % timePoint
        # np.savetxt(fileName, ExpressionData['exp_energy'][timePoint], delimiter=",")

    # 2) Structure info:
    SaveListCSV(structureIDs, "StructureIDs.csv")
    SaveListCSV(structureNames,"StructureNames.csv")

    # 3) Gene info:
    geneIDs = [g['id'] for g in allGenes]
    SaveListCSV(geneIDs, "GeneIDs.csv")
    # np.savetxt("GeneIDs.csv", geneIDs, delimiter=",")
    geneEntrez = [g['entrez_id'] for g in allGenes]
    SaveListCSV(geneEntrez, "geneEntrez.csv")
    geneAbbreviations = [g['acronym'] for g in allGenes]
    SaveListCSV(geneAbbreviations,"geneAbbreviations.csv")

    # 4) Time point info:
    SaveListCSV(timePoints,"timePoints.csv")

    # Getting back the objects:
    # with open('objs.pickle') as f:
    #     obj0, obj1, obj2 = pickle.load(f)
