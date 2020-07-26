# Analysing the spatial embedding of gene expression across mouse brain development

Code for reproducing analyses presented in:
H.Y.G. Lau, B.D. Fulcher, A. Fornito. [Scaling of gene transcriptional gradients with brain size across mouse development](https://doi.org/10.1101/2020.06.04.135525), _bioRxiv_ (2020).

Data analysis is here; code for the simple physical model is in [this repo](https://github.com/NeuralSystemsAndSignals/DevelopmentalExpressionModeling).

Data was taken from the Allen Institute's [Developing Mouse Brain Atlas](https://developingmouse.brain-map.org/) using python scripts that call the [AllenSDK](https://allensdk.readthedocs.io/) (in `DataRendering`).

A description of the raw data retrieval via the Allen SDK is at the bottom of this document.

Processed data is available from [this figshare repository](https://figshare.com/projects/Developing_Mouse/64328), and can be downloaded to reproduce the results presented in our paper (using the functions outlined below).

<!-- ### Figure 1
`makeFigure1()`
![Figure1_part1](Outs/figure1/figure1_part1.png)
![Figure1_part2](Outs/figure1/figure1_part2.png)
![Figure1_part3](Outs/figure1/figure1_part3.png) -->

## Analysis Results

Before running analyses, add all repository paths using `startup`.

### Plotting

You can get the clustered gene-expression plots as:
```matlab
PlotAllExpressionMatrices
```
Or for each individual one, as, e.g., `PlotExpressionMatrix('E11pt5')`.


And for the three-dimensional voxel plots:
```matlab
PlotAll3dSpatial
```
And individual time points as `VisualizeSpatialExpression`.

For example, taking E18.5 (without distinguishing fore/mid/hindbrain) and subsampling to 5000 voxels:
```matlab
VisualizeSpatialExpression('E18pt5','','turboOne',5000)
```


### CGE Curves

```matlab
makeCGECurves()
```

Yields Fig. 2:

![](img/Fig2.png)

We can also modify the data used for these computations, including subsets of voxels and/or genes.

For example, to compute the same curves but only using forebrain voxels:

```matlab
params = GiveMeDefaultParams();
params.thisBrainDiv = 'forebrain';
makeCGECurves(params)
```

<!-- And Fig. 3:

![](img/Fig3.png) -->

### Scaling relationships

`makeParameterScalingFig()`

Produces the plots of parameter scaling in Fig. 4:

![](img/Fig4.png)

### Voxel sampling

Supplementary Fig. S1:

`makeFigureS1()`

![FigureS1](Outs/figureS1/figureS1.png)

## Data

### Raw data retrieval

Raw data was retrieved via the API made available using the Allen SDK.
Code is available in this repository:

1. Download Allen API package by `pip install allensdk`
2. Run `download_devmouse_unionizes.py` to retrieve gene expression data at structure level
3. Run `structures.py` to download structure information
4. Run `getBrainDivision.py` to download major brain division info (forebrain, midbrain and hindbrain) and ID of their descendants; data saved in `structure_F.csv`, `structure_M.csv`,`structure_H.csv`,`structure_F_descendant_ID.csv`,`structure_M_descendant_ID.csv`,`structure_H_descendant_ID.csv`.

### Processing of raw data

The processed data files were obtained by running `createData(false)`, which creates data files starting from `energyGrids.mat` variables (downloaded from [this figshare repository](https://figshare.com/projects/Developing_Mouse/64328).

The full pipeline from raw data (downloaded via the Allen SDK) can be reproduced using `createData(true)`.

You can also run `createVariance` to create the data of variance in decay constant against number of data points used (takes a long time, >24h).
