# Data retrieval and processing

Navigate to the `DataRendering` directory.

#### Download the raw gene-expression grid data
```python
python3 download_devmouse_grid_gene_expression.py
```
Downloads to [[BF:]]___XXX___.

#### Download the grid annotation data

You can use `DownloadGridAnnotations` to download the grid annotation data from the [current mouse annotation release](http://download.alleninstitute.org/informatics-archive/current-release/mouse_annotation/).
This saves `.zip` files to `Data/API/AnnotationData`, which you must then manually extract.

#### Download Cahoy et al. cell-type enrichment data

Manually download Supplemental Table S4, S5 and S6 from the Cahoy paper "A Transcriptome Database for Astrocytes, Neurons, and Oligodendrocytes: A New Resource for Understanding Brain Development and Function" and save them to `Data/Others`.

Rename Supplemental Table S4, S5 and S6 to `Astrocyte_Cahoy_S4.xls`, `Oligodendrocyte_Cahoy_S5.xls`, and `Neuron_Cahoy_S6.xls`, respectively.


#### Obtain gene entrez IDs and abbreviations

___[[[WHY IS THIS NECESSARY? THIS DOWNLOADS ALL DATA AT THE STRUCTURE-AVERAGE LEVEL FOR A CUSTOM STRUCTURE LIST???]]]]___

```python
python3 download_devmouse_unionizes_genes.py
```
Saves output to two files: `SDK_geneEntrez.csv` and `SDK_geneAbbreviations.csv`.

[A partial version was replicated by uncommenting line 69 # if `len(rows) == 4000:` and commenting out line 68 "`if numRows == 0 or numRows < blockSize:`]

#### Retrieve descendant IDs of each structure
In the `DataRendering` directory:
```python
python3 getBrainDivision.py
```
Retrieves the structure information, and descendant structure IDs of each primary structure:
1. forebrain (`F`)
2. midbrain (`M`)
3. hindbrain (`H`)
4. dorsal pallidum (`DPall`)
5. spinal cord (`SpC`)

And saves `.csv` files to `Data/API/Structures`.

___[[[SAVES DATA TO: XXX]]]___

#### Process raw data into Matlab files
```matlab
renderBaseData()
```
This should only be run once ___[[BF: WHY?]]___.
Creates processed Matlab data files for further analysis.

This includes:
* `energyGrids_*.mat`: voxel-level expression energy across genes
*

```matlab
renderData()
```
Generates the default voxel x gene expression matrix and spatial data (distances and correlation) for whole brain and all cell types.

* The parameters of `renderData` can be filled in to make the voxel x gene expression matrix and spatial data for different brain subdivisions (forebrain, midbrain, hindbrain, DPall) and specific cell types (neuron, astrocytes, oligodendrocytes)
* To render all data at once, run `renderDataAll`
