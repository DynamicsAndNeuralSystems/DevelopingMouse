# Data retrieval and processing

Navigate to the `DataRendering` directory.

#### Download the raw gene-expression grid data
```python
python download_devmouse_grid_gene_expression.py
```
Downloads to [[BF:]]___XXX___.

#### Download the grid annotation data

Manually download the folders `XXX_DevMouse2012_gridAnnotation` (for each time point `XXX`  (E11.5 to P28) from the [current mouse annotation release](http://download.alleninstitute.org/informatics-archive/current-release/mouse_annotation/).
Save them to `Data/API/AnnotationData`

#### Download Cahoy et al. cell-type enrichment data

Manually download Supplemental Table S4, S5 and S6 from the Cahoy paper "A Transcriptome Database for Astrocytes, Neurons, and Oligodendrocytes: A New Resource for Understanding Brain Development and Function" and save them to `Data/Others`.

Rename Supplemental Table S4, S5 and S6 to `Astrocyte_Cahoy_S4.xls`, `Oligodendrocyte_Cahoy_S5.xls`, and `Neuron_Cahoy_S6.xls`, respectively.


#### Obtain gene entrez IDs and abbreviations
```python
python download_devmouse_unionizes_genes.py
```
Saves output to two files: `SDK_geneEntrez.csv` and `SDK_geneAbbreviations.csv`.

[A partial version was replicated by uncommenting line 69 # if `len(rows) == 4000:` and commenting out line 68 "`if numRows == 0 or numRows < blockSize:`]

#### Retrieve descendant IDs of each structure
```python
python getBrainDivision.py
```
Retrieves the descendant structure IDs of each primary structure:
1. forebrain
2. midbrain
3. hindbrain
4. dorsal pallidum
5. spinal cord

#### Process raw data into matlab files
```matlab
renderBaseData()
```
This should only be run once [[BF: WHY?]].
Creates processed data files for further analysis.

```matlab
renderData()
```
Generates the default voxel x gene expression matrix and spatial data (distances and correlation) for whole brain and all cell types.

* The parameters of `renderData` can be filled in to make the voxel x gene expression matrix and spatial data for different brain subdivisions (forebrain, midbrain, hindbrain, DPall) and specific cell types (neuron, astrocytes, oligodendrocytes)
* To render all data at once, run `renderDataAll`
