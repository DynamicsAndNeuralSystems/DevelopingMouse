%------------
% Download and unzip the energy grid file for P4 Rora Pdyn SectionDataSet
% -----------
 
%  grid volume size
sizeGrid = [132,80,114];
 
% ENERGY = 3-D matrix of expression energy grid volume
fid = fopen('11_wks_coronal_183282970_100um/energy.raw', 'r', 'l' );
ENERGY = fread( fid, prod(sizeGrid), 'float' );
fclose( fid );
ENERGY = reshape(ENERGY,sizeGrid);
 
% Display one coronal and one sagittal section
figure;imagesc(squeeze(ENERGY(36,:,:)));colormap(gray);
figure;imagesc(squeeze(ENERGY(:,:,14)));colormap(gray);
