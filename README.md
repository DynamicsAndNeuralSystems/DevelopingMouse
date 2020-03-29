# Developing Mouse Scripts

## Retrieve data
### Raw data from Allen API (NOT YET REPLICATED)
* Fills the `Data/API` directory.
* First download Allen API package by `pip install allensdk`
* Run `download_devmouse_unionizes.py` to retrieve gene expression data at structure level (tentative)
* Run `structures.py` to download structure information
* Run `getBrainDivision.py` to download major brain division info (forebrain, midbrain and hindbrain) and ID of their descendants; data saved in `structure_F.csv`, `structure_M.csv`,`structure_H.csv`,`structure_F_descendant_ID.csv`,`structure_M_descendant_ID.csv`,`structure_H_descendant_ID.csv`
### download preprocessed data
* Fill the `Matlab_variables` directory with data from [this](https://drive.google.com/file/d/1Bw0frIZqJuTZCW797K-CUV1bVU1KG8eL/view?usp=sharing) Google Drive
* The Data processing step below can be skipped, or you can run `createData()` to create data starting from energyGrids .mat variables

## Data processing
* Fills the `Matlab_variables` directory
* To create most of the data, either run `createData()` to create data starting from energyGrids `.mat` variables, or `createData(true)` to create from the raw data
* Run `createVariance.m` to create the data of variance in decay constant against number of data points used (takes a long time, >24h)

## Figures
Either create single figures by running each of the separate functions below, or create all figures at once by running `createFigures.m`

### Figure 1
`makeFigure1()`
![Figure1_part1](Outs/figure1/figure1_part1.png)
![Figure1_part2](Outs/figure1/figure1_part2.png)
![Figure1_part3](Outs/figure1/figure1_part3.png)

### Figure 2A-I
`makeFigure2()`
![Figure2_part1](Outs/figure2/figure2_part1.png)
![Figure2_part2](Outs/figure2/figure2_part2.png)

### Figure 3A-C
`makeFigure3()`
![Figure3](Outs/figure3/figure3.png)

### Figure 4A-C
`makeFigure4()`
![Figure4](Outs/figure4/figure4.png)

### Figure 5A-D
`makeFigure5()`
![Figure5](Outs/figure5/figure5.png)

### Figure S1
`makeFigureS1()`
![FigureS1](Outs/figureS1/figureS1.png)

### Figure S2A-I
`makeFigureS2()`
![FigureS2_part1](Outs/figureS2/figureS2_part1.png)
![FigureS2_part2](Outs/figureS2/figureS2_part2.png)
![FigureS2_part3](Outs/figureS2/figureS2_part3.png)

* All figures are saved in Outs/figure(number)
