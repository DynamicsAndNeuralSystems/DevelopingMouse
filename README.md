# Developing Mouse Scripts

## Retrieve data from Allen API (NOT YET REPLICATED)
* Fills the `Data/API` directory.
* First download Allen API package by `pip install allensdk`
* Run `download_devmouse_unionizes.py` to retrieve gene expression data at structure level (tentative)
* Run `structures.py` to download structure information
* Run `getBrainDivision.py` to download major brain division info (forebrain, midbrain and hindbrain) and ID of their descendants; data saved in `structure_F.csv`, `structure_M.csv`,`structure_H.csv`,`structure_F_descendant_ID.csv`,`structure_M_descendant_ID.csv`,`structure_H_descendant_ID.csv`

## Data processing
* Fills the `Matlab_variables` directory
* Run `createData.m` to create most of the Matlab variables from the raw data
* Run `createVariance.m` to create the data of variance in decay constant against number of data points used (take a long time, >24h)

## Figures
### Figure 1
`makeFigure1()`
![Figure1](Outs/figure1/figure1_part1.png)

* All figures are saved in Outs

