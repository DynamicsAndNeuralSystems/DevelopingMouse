% -------------------------------
%
% Download a NRRD reader
% For example:
% http://www.mathworks.com/matlabcentral/fileexchange/50830-nrrd-format-file-reader
%
% Requires: MATLAB 7.13 (R2011b)
%
% Download average_template_50.nrrd
% Download projection_density at 50 micron for SectionDataSet id = 287495026
%
% ---------------------------------
 
%
% Read image volume with NRRD reader
% Note that reader swaps the order of the first two axes
%
% AVGT = 3-D matrix of average_template
% PDENS = 3-D matrix of projection_density
% DMASK = 3-D matrix of data_mask
%
[AVGT, metaAVGT] = nrrdread('average_template_50.nrrd');
[PDENS, metaPDENS] = nrrdread('11_wks_coronal_287495026_50um_projection_density.nrrd');
[DMASK, metaDMASK] = nrrdread('11_wks_coronal_287495026_50um_data_mask.nrrd');
 
% Display one coronal section
figure;imagesc(squeeze(AVGT(:,184,:)));colormap(gray(256)); axis equal;
figure;imagesc(squeeze(PDENS(:,184,:)));colormap(jet(256)); axis equal;
figure;imagesc(squeeze(DMASK(:,184,:)));colormap(gray(256)); axis equal;
