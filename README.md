# Developing Mouse Scripts
Steps:
1. Downloading API data  [DataProcessing folder]
Downloading distance related data (coordinates, colours):
Allen RMA API.ipynb OR Allen+RMA+API.py
Downloading gene expression data:
API_DevelopingMouseLevel5 (1).py

Other functionalities:
Looking at the organization of the RMA query classes:
Allen RMA API query classes.ipynb OR Allen+RMA+API+query+classes.py

2. Converting downloaded API data into matlab variables [DataRendering folder]
A. Extracted coordinates ("coOrds_AdultMouse.csv") and ID ("ID_AdultMouse.csv") of adult mouse structures from the file "coOrds_AdultMouse.csv":
extractCoords_allenserver.m
B. Obtain the list of adult mouse structure abbreviation ("acronym_AdultMouse.csv") using the list of structure ID
Allen_Reference space-make_abbrev_list.ipynb OR Allen_Reference+space-make_abbrev_list.py
and inputting "ID_AdultMouse.csv"
C. Convert developing mouse distance-related info into "dataDevMouse.mat" which stores structure abbreviation, ID, colour, coordinates, major division abbreviation (the level 3 structure it belongs to), major division colour, a table containing the above info, and distance matrix
level5info.m(function) and LoadData_SDK_full_data_level5.m (script)
D. Convert gene expression data into DevMouseGeneExpression.mat with structure fields "raw", "norm" and "normGene".
Using scaled sigmoid for norm field: MakeDevMouseGeneExpression.m
Using log2 for norm field: MakeDevMouseGeneExpression_log2.m
Using zscore for norm field: MakeDevMouseGeneExpression_zscore.m

Note: the csv files are stored in Data folder

3.Compared distances obtained from adult structure coordinates with that provided in Oh et al supplementary table 4 ("A mesoscale connectome of the mouse brain supp table 4_ipsi.xlsx"), plot MDS and scatter 3 for API adult structure and Oh et al, as well as for 7 developmental time points [DataAnalysis folder]
distanceMatrix_removeDup.m

4. Fitting linear, 1 parameter exponential, 2 parameter exponential and 3 parameter exponential to each of the 7 time points and all time point together (global) and checking Degrees of Freedom Adjusted R-Square and the fitting parameter values with 95% confidence interval [Analysis folder]
GeneCoexpression.m

5. Fitting 3 parameter exponential to each time point and plotting all together on the same graph, also performs binning [Analysis folder]
GeneCoexpression_Binning.m

6. Plotting exponential decay constant against max distances for different methods of normalization [Analysis folder]
fittingGeneCoexpression.m
