clear
load('fitting.mat','spatialData');
[~,F,~,~]=plotBinning(spatialData.voxel.distancesAll,spatialData.voxel.corrCoeffAll,100)
str = fullfile('Outs','binning_plot','voxel_binning.jpeg');
imwrite(F.cdata, str, 'jpeg');
