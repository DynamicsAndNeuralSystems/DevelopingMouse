# Data retrieval and processing
Navigate to the `DataRendering` directory
#### Download the raw gene-expression grid data
In the `DataRendering` directory:
```python
python3 download_devmouse_grid_gene_expression.py
```
Downloads `energy.raw` files to `Data/API/GridData`.

#### Download the grid annotation data

You can use `DownloadGridAnnotations` to download the grid annotation data from the [current mouse annotation release](http://download.alleninstitute.org/informatics-archive/current-release/mouse_annotation/).
This saves `.zip` files to `Data/API/AnnotationData`, which you must then manually extract.

#### Download Cahoy et al. cell-type enrichment data

Manually download Supplemental Table S4, S5 and S6 from the Cahoy paper "A Transcriptome Database for Astrocytes, Neurons, and Oligodendrocytes: A New Resource for Understanding Brain Development and Function" and save them to `Data/Others`.

Rename Supplemental Table S4, S5 and S6 to `Astrocyte_Cahoy_S4.xls`, `Oligodendrocyte_Cahoy_S5.xls`, and `Neuron_Cahoy_S6.xls`, respectively.


#### Obtain gene entrez IDs and abbreviations
Developing mouse gene entrez ID:
1. Download the csv from the following:
http://api.brain-map.org/api/v2/data/query.csv?criteria=model::Gene,rma::criteria,products[abbreviation$eq%27Mouse%27],rma::options,[tabular$eq%27genes.entrez_id+as+entrez_gene_id%27],[order$eq%27genes.entrez_id%27]&num_rows=all&start_row=0
2. Manually delete the first row
3. Rename the file to "Adult_geneEntrez" and save it in "Data/API/Genes"

Developing mouse gene abbreviation:
1. Download the csv from the following:
http://api.brain-map.org/api/v2/data/query.csv?criteria=model::Gene,rma::criteria,products[abbreviation$eq%27DevMouse%27],rma::options,[tabular$eq%27genes.acronym+as+gene_symbol%27],[order$eq%27genes.entrez_id%27]&num_rows=all&start_row=0
2. Manually delete row 2108 first
3. Then manually delete the first row
4. Rename the file to "Dev_geneAbbreviation" and save it in "Data/API/Genes"

Adult mouse gene entrez ID:
1. Download the csv from the following:
http://api.brain-map.org/api/v2/data/query.csv?criteria=model::Gene,rma::criteria,products[abbreviation$eq%27Mouse%27],rma::options,[tabular$eq%27genes.entrez_id+as+entrez_gene_id%27],[order$eq%27genes.entrez_id%27]&num_rows=all&start_row=0
2. Manually delete the first row
3. Rename the file to "Adult_geneEntrez" and save it in "Data/API/Genes"

Adult mouse gene abbreviation:
1. Download the csv from the following:
http://api.brain-map.org/api/v2/data/query.csv?criteria=model::Gene,rma::criteria,products[abbreviation$eq%27Mouse%27],rma::options,[tabular$eq%27genes.acronym+as+gene_symbol%27],[order$eq%27genes.entrez_id%27]&num_rows=all&start_row=0
2. Manually delete the rows after 19470 (i.e. starting from row 19471) first
3. Then manually delete the first row
4. Rename the file to "Adult_geneAbbreviation" and save it in "Data/API/Genes"

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

#### Process raw data into Matlab files
```matlab
renderBaseData()
```

Creates processed Matlab data files from raw data for further analysis.

This includes:
* `makeAnnotationGrids`: annotation of each grid (to `annotationGrids.mat`)
* `makeBrainDivision`: (to `brainDivision.mat`) contains IDs of brain subdivisions (forebrain, midbrain, hindbrain, Dpallidum, SpinalCord).
* `energyGrids_*.mat`: voxel-level expression energy of genes at a certain time point.
* `makeGeneExpressionMatrix` -> `voxelGeneExpression**_*.mat`: voxel x gene expression matrix for each time point.
* `geneID_gridExpression.mat`: ID of genes included in the expression energy of each time point
* `goodGeneSubset.mat`: ID of genes with expression data in over 70% of voxels of all time points

```matlab
renderData()
```
Generates the default voxel x gene expression matrix and spatial data (distances and correlation) for whole brain and all cell types.

* The parameters of `renderData` can be filled in to make the voxel x gene expression matrix and spatial data for different brain subdivisions (forebrain, midbrain, hindbrain, DPall) and specific cell types (neuron, astrocytes, oligodendrocytes)
* To render all data at once, run `renderDataAll`
