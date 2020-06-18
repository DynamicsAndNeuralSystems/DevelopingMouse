# Developing Mouse Scripts

Code for reproducing analyses presented in:
H.Y.G. Lau, B.D. Fulcher, A. Fornito. [Scaling of gene transcriptional gradients with brain size across mouse development](https://doi.org/10.1101/2020.06.04.135525), _bioRxiv_ (2020).

Data analysis is here; code for the simple physical model is in [this repo](https://github.com/NeuralSystemsAndSignals/DevelopmentalExpressionModeling).

Processed data is available from [this figshare repository](https://figshare.com/projects/Developing_Mouse/64328).
These data files should be placed in the `Matlab_variables` directory.

Before running analyses, add all repository paths using `startup`.

<!-- ### Figure 1
`makeFigure1()`
![Figure1_part1](Outs/figure1/figure1_part1.png)
![Figure1_part2](Outs/figure1/figure1_part2.png)
![Figure1_part3](Outs/figure1/figure1_part3.png) -->

### CGE Curves

`makeCGECurves()`

Yields Fig. 2:

![](img/Fig2.png)

And Fig. 3:

![](img/Fig3.png)

### Scaling relationships

`makeParameterScalingFig()`

Produces the plots of parameter scaling in Fig. 4:

![](img/Fig4.png)

### Voxel sampling

Supplementary Fig. S1:

`makeFigureS1()`

![FigureS1](Outs/figureS1/figureS1.png)


## Data processing

The data processing steps are contained in `createData()`, which generates processed data starting from `energyGrids` `.mat` variables.

* Fills the `Matlab_variables` directory
* To create most of the data, either run `createData()` to create data starting from energyGrids `.mat` variables, or `createData(true)` to create from the raw data
* Run `createVariance.m` to create the data of variance in decay constant against number of data points used (takes a long time, >24h)
