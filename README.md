# Developing Mouse Scripts

## Retrieve data from Allen API
* Fills the `Data/API` directory.
* First download Allen API package by `pip install allensdk`
* Run `download_devmouse_unionizes.py` to retrieve gene expression data at structure level (tentative)
* Run `structures.py` to download structure information
* Run `getBrainDivision.py` to download major brain division info (forebrain, midbrain and hindbrain) and ID of their descendants; data saved in `structure_F.csv`, `structure_M.csv`,`structure_H.csv`,`structure_F_descendant_ID.csv`,`structure_M_descendant_ID.csv`,`structure_H_descendant_ID.csv`

## Other raw data
* `A mesoscale connectome of the mouse brain supp table 4_ipsi` is obtained from supplementary table 4 of the Oh et. al paper, which contains a distance matrix of adult brain structures
* Stored in `Data/others`

### Voxel-level expression data

Downloading gene-expression data:

```python
API_DevelopingMouseLevel5.py
```

### Distance data
Downloading distance related data (coordinates, colours):
Allen RMA
```
API.ipynb
```
OR
```
Allen+RMA+API.py
```

Produces the following data files:
* SDFDJKSL.csv
* ...

Other functionalities:
Looking at the organization of the RMA query classes:
Allen RMA API query `classes.ipynb` OR `Allen+RMA+API+query+classes.py`

## Data processing

Convert downloaded data into Matlab variables, fills the `DataRendering` [`ProcessedData`] directory.
* `createStructureInfo.m` creates a Matlab variable `dataDevMouse.mat` containing structure information, including structure abbreviation, ID, colour, coordinates, major division abbreviation (the level 3 structure it belongs to), major division colour, a table containing the above info, and distance matrix
* `createAnnotationGrids_SpinalCordID_energyGrid.m` creates `AnnotationGrids.mat`,`spinalCord_ID.mat`,`energyGridE11pt5.mat`,`energyGridE13pt5.mat`,`energyGridE15pt5.mat`,`energyGridE18pt5.mat`,`energyGridP4.mat`,`energyGridP14.mat`,`energyGridP28.mat`
* `createGeneExpressionMatrix.m` creates the following:
1) `voxelGeneCoexpression_all.mat` containing voxel x gene matrix, distance matrix and a selector (determines which voxels are sampled for further analysis; it also indicates the voxels included in the distance matrix) for 7 time points
2) `voxelGeneCoexpression_all_brainDiv.mat` containing the same data but separately for the forebrain, midbrain and hindbrain.
* `createDevMouseGeneExpression` creates gene expression matrices at the structure level normalized by different methods
* `extractCoords` extracts coordinates and ID of adult mouse (from `structureCenters_adult.csv`) with correct map ID into `coOrds_AdultMouse.csv` and `ID_AdultMouse.csv`
* `getAcronymFromID.py` queries (from API) for adult mouse acronym from ID using `ID_AdultMouse.csv` as input, yielding `acronym_AdultMouse.csv`
* `makeBrainDivisionID.m` extracts IDs from the csv files (`F_descendantID.csv`, `M_descendantID.csv`, `H_descendentID.csv`) and color from the csv files (`structure_F.csv`, `structure_M.csv`, `structure_H.csv`) and stores them in a variable `brainDivision.mat`
* `createSpatialData_2BrainDiv.m` computes correlation coefficients and distances from pairs of brain divisions (forebrain, midbrain and hindbrain), creating `spatialData_2brainDiv.mat`
* `createCellSpecificGenes.m` creates `enrichedGenes.mat` containing the struct `enrichedGenes` (the abbreviations of Allen data gene that are enriched in developing and mature astrocytes, and progenitor and postmitotic oligodendrocytes), `geneID` and `geneAbbreviation` for later use (mapping gene abbreviation to ID) 
* `createGeneList_gridExpression.m` obtains a list of gene IDs from the downloaded Grid Expression Data, storing them in `geneID_gridExpression.mat`
* `createBinnedData.m` bins the correlation and distance data by quantiles and save them in `binnedData_NumData_(number)_numThresholds_number.mat`


* Matlab variables are saved in the folder `Matlab_variables`
* csv files are saved in the folder `Processed`

* Extracted coordinates (`coOrds_AdultMouse.csv`) and ID (`ID_AdultMouse.csv`) of adult mouse structures from the file "coOrds_AdultMouse.csv": `extractCoords_allenserver.m`
* Obtain the list of adult mouse structure abbreviation (`acronym_AdultMouse.csv`) using the list of structure ID
Allen_Reference `space-make_abbrev_list.ipynb` OR `Allen_Reference+space-make_abbrev_list.py`
and inputting `ID_AdultMouse.csv`
* Convert developing mouse distance-related info into `dataDevMouse.mat` which stores structure abbreviation, ID, colour, coordinates, major division abbreviation (the level 3 structure it belongs to), major division colour, a table containing the above info, and distance matrix
`level5info.m` (function) and `LoadData_SDK_full_data_level5.m` (script)
* Convert gene expression data into `DevMouseGeneExpression.mat` with structure fields ``raw`, `norm` and `normGene`.

Using scaled sigmoid for norm field:
```
whatNormalization = 'log2';
MakeDevMouseGeneExpression(whatNormalization);
```
Using log2 for norm field: `MakeDevMouseGeneExpression_log2.m`
Using z-score for norm field: `MakeDevMouseGeneExpression_zscore.m`

Note: the `.csv` files are stored in `Data` folder

## Analysis
* `createVariance.m` plots variance in estimation of decay constant against the number of voxels used in the analysis.
* `createGeneExpressionMatrix.m` creates the gene expression matrix for each time point, storing them in `voxelGeneCoexpression_(timepoint).mat`
* `createSpatialData.m` computes correlation coefficient and distances for a given number of voxels, and determines the direction vector of voxel pairs, saving everything in `spatialData_NumData_(number).mat`
* `createSpatialData_subsetGenes.m` computes correlation coefficient and distances for a given number of voxels using a subset of genes only, saving them in `spatialData_NumData_(number)_subsetGenes.mat` (gene subset used: oligodendrocyte progenitor)
* `createDirectionalityData.m` obtains the logical vectors for indexing out voxel pairs in particular directions, and get their distances and correlation coefficients; saves data in `directionalityData.mat`
* `createFitting.m` fits the voxel data to the 3 parameter exponential curve, and save the fitting statistic, decay constant and maximum distance to `fitting_NumData(number).mat`; also fits scaled distance, saving the resut to `fitting_NumData(number)_scaled.mat`
* `createFitting_structures.m` does the same thing as `createFitting.m` except it works on structural-level data, saving result in `fitting_structures.mat`
* `createFitting_subsetGenes.m` fits the voxel data of a subset of genes to the 3 parameter exponential curve, and save the fitting statistic, decay constant and maximum distance to `fitting_NumData(number)_subsetGenes.mat`; also fits scaled distance, saving the resut to `fitting_NumData(number)_subsetGenes_scaled.mat` [not yet complete since no computer memory to run the full data; only ran i=1]
* `createFitting_directionality.m` does the same thing as `createFitting.m` except it separately fits data in different directions, saving result in `fitting_NumData_(number)_sagittal.mat`
* `geneCoexpression_scatter_voxel.m` (matlab 2015b or later only) plots gene coexpression against distance separation at the voxel level 
* `createDecayConstantPlot.m` plots decay constant against max distance at voxel level
* `createDecayConstantPlot_binned.m` plots decay constant against max distance at voxel level for binned data
* `createDecayConstantPlot_binned_scaled.m` plots decay constant against max distance at voxel level for binned data, with distance scaled
* `createDecayConstantPlot_strutures.m` plots decay constant against max distance at structural level
* `createDecayConstantPlot_subsetGenes.m` plots decay constant against max distance at voxel level for a subset of genes
* `createDecayConstantPlot_directionality.m` plots decay constant against max distance for voxel pairs in different directions separately
* `decayConstant_voxel.m` plots the logarithm of decay constant (3 parameter exponential fitting) against maximum distance
* `createBinnedData.m` bins the voxel data, saving the results in `binnedData_NumData_(number)_numThresholds_(number).m`
* `createBinnedFitting.m` does the same thing as `createFitting.m` except it works on binned data from `createBinnedData.m`; it creates `fitting_NumData_1000_binnedData_numThresholds_100.mat` and `fitting_NumData_1000_binnedData_numThresholds_100_scaled.mat`
* `createExponentialPlot.m` plots 3 term exponential of voxel data
* `createExponentialPlot_scaled.m` plots 3 term exponential of voxel data with distance scaled
* `createExponentialPlot_plusStructures.m` plots 3 term exponential of voxel plus structure data
* `createBinnedExponentialPlot.m` plots the exponential fitting of the binned data (with and without distance scaled)
* `createExponentialPlot_subsetGenes.m` plots 3 term exponential of voxel data of a subset of genes [not complete, only plotted i=1]
* `createExponentialPlot_directionality.m` plots 3 term exponential of voxel data in different directions separately

To be deleted:
* `createCorrCoeffAll_distancesAll.m` computes correlation, distance and scaled distance from voxGeneMat and distMat (with dataIndSelect), saving them into `corrCoeffAll_distancesAll.mat`
* `GeneCoexpression_scatter.m` plots gene coexpression against distance separation at the structure level; also create `'corrCoeff_distances_ontoDist_clean.mat` which contains distances, correlation coefficient and ontological distances at the structural level
* `compareDistanceMatrix.m` serves to validate the accuracy of our methodology of querying the API; it plots the MDS of API and Oh et al data, scatter3 plot of API data, and % error in distance (Oh et al as gold standard) against distance 
* `GeneCoexpression_ontologicalDistance.m` plots gene coexpression against ontological distance at the structural level (ontological distance between structure x and y is calculated as: steps of x from nearest common ancestor + steps of y from nearest common ancestor)
* `GeneCoexpression_scatter_voxel_brainDiv.m` plots gene coexpression against distance separation at the voxel level for forebrain, midbrain and hindbrain
* `createFitting_brainDiv.m` has the similar function as `createFitting.m` except it is for forebrain, midbrain and hindbrain separately; saves the fitting statistic, decay constant and maximum distance to `fitting_brainDiv.mat`
* `decayConstant_voxel_brainDiv.m`  plots the logarithm of decay constant (3 parameter exponential fitting) against maximum distance separately for forebrain, midbrain and hindbrain 
* `GeneCoexpression_Binning_voxel_2brainDiv.m` plots forebrain-midbrain, forebrain-hindbrain and midbrain-hindbrain coexpression against distance for all time points

* `createFitting_scaledDistance.m` does the same thing as `createFitting.m` except it works on scaled distance; saves data to `fitting_scaled.mat`


* All figures are saved in Outs
## Testing

### Distance comparison
 Compared distances obtained from adult structure coordinates with that provided in Oh et al supplementary table 4 ("A mesoscale connectome of the mouse brain supp table 4_ipsi.xlsx"), plot MDS and scatter 3 for API adult structure and Oh et al, as well as for 7 developmental time points [`DataAnalysis` folder]

```
distanceMatrix_removeDup
```

### Spatial dependence functional form

Fitting linear, 1 parameter exponential, 2 parameter exponential and 3 parameter exponential to each of the 7 time points and all time point together (global) and checking Degrees of Freedom Adjusted R-Square and the fitting parameter values with 95% confidence interval
```
GeneCoexpression
```

5. Fitting 3 parameter exponential to each time point and plotting all together on the same graph, also performs binning [Analysis folder]
`GeneCoexpression_Binning`

6. Plotting exponential decay constant against max distances for different methods of normalization [Analysis folder]
`fittingGeneCoexpression.m`
