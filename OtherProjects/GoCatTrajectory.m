clear all

cd 'D:\Data\DevelopingAllenMouseAPI-master\Rubinov regions_80 genes'
load('newMatrixData.mat','V','geneEntrez','structureLabel');
load('GOresults.mat','geneEntrezAnnotationsCell')
geneEntrezLeft=cell(1,7);

%% 
% Create a 3D array of structure x gene x time points
overallV=V{1};
overallV(:,:,2)=V{2};
overallV(:,:,3)=V{3};
overallV(:,:,4)=V{4};
overallV(:,:,5)=V{5};
overallV(:,:,6)=V{6};
overallV(:,:,7)=V{7};

%%
%filter out missing genes in all 7 time points for 2D matrix analysis 
for j=1:7
    isMissing = sum(isnan(V{j})) > 0;
    V{j} = V{j}(:,~isMissing);
    geneEntrezLeft{j} = geneEntrez(:,~isMissing);
    fprintf(1,'Filtered %u missing genes\n',sum(isMissing));
end
%% compute correlation coefficient of expression between the genes in P28
%R=corrcoef(V{7})

%NormR=BF_NormalizeMatrix(R,'zscore')
%f=figure('color','w')
%imagesc(NormR)
%colorbar
%%
% find indices of genes that belong to the top three GO categories in the
% hub/nonhub in the 7th time point (P28)
idGenesBelong=cell(3,7); %after the loop, idGenesBelong contains cell array that contains 
%GO categories x time points
for i=1:7
    if isempty(geneEntrezAnnotationsCell{i})==1
        continue
    end
    for j=1:3
    v=double(cell2mat(geneEntrezAnnotationsCell{i}(j)));
    x=double(geneEntrezLeft{i});
    [~,genesBelong] = ismember(v,x);
    if sum(genesBelong)==0
        fprintf('No genes in the current time point belong to the GO category\n')
        continue
    else
        idGenesBelong{j}=x(genesBelong);
    end
    end
end

%% for GO category 1
% collect the matrices of those genes and put them into a 3D array
GoCat=1;
if isempty(idGenesBelong{GoCat})==1 
    fprintf('No genes belong to GO category 1')
    
else
    y=double(idGenesBelong{GoCat}); % Convert gene IDs to doubles so that "intersect" works
    [~,indexGenesBelong,~]=intersect(geneEntrez,y); % find the vector of index (on original geneEntrez list not filtered for missing genes) of genes that belong to the GO category
    [m,~]=size(indexGenesBelong);
    
    geneTimeV=squeeze(overallV(:,indexGenesBelong(GoCat),:)); %get the structure x time matrix of the first gene from overallV 
    %get the other structure x time matric and concatenate into the array
    %in the 3rd dimension
    for j=2:m % for the second to the last gene belonging to that GO category
        % collect and store the structure x time matrix inside geneTimeV 
        geneTimeV=cat(3,geneTimeV,squeeze(overallV(:,indexGenesBelong(m),:))) 
    end
end

%% take mean of the GO category 1 3D array across the 3rd dimension, ignoring NaN values
meanGeneTimeV=nanmean(geneTimeV,3);

%% Normalize expression across GO class
NormMeanGeneTimeV=BF_NormalizeMatrix(meanGeneTimeV,'zscore')
f=figure('color','w')
imagesc(NormMeanGeneTimeV)
colorbar
title('Normalized mean gene expression of GO category 1 genes over brain structures and time points')
xlabel('Time points')
ylabel('Brain structures')
set(gca, 'XTickLabel', {'E11.5','E13.5','E15.5','E18.5','P4','P14','P28'}, 'YTickLabel', structureLabel,'YTick',[1:33])

cd 'D:\Data\DevelopingAllenMouseAPI-master\Replication of developing mouse data'
saveas(gcf,'normGoClassExp','fig')

%%
% create structure x time matrices of certain genes
 %geneTimeV=cell(3,80);
% for i=1:3 % for each GO category
%     if isempty(idGenesBelong{i})==1 % Skip any GO categories to which no gene belong
%         continue
%     end
%     y=double(idGenesBelong{i}); % Convert gene IDs to doubles so that "intersect" works
%     [~,indexGenesBelong,~]=intersect(geneEntrez,y); % find the vector of index of genes that belong to the GO category
%     [m,~]=size(indexGenesBelong);
%     for j=1:m % for each gene belonging to that GO category, get the structure x time matrix from overallV
%         z=squeeze(overallV(:,indexGenesBelong(j),:));
%         geneTimeV{i,j}=z; % and store the matrix inside geneTimeV
%     end
% end
%% Average the gene expression across each GO class, treating missing data as zero expression
%geneTimeVz = geneTimeV;
%geneTimeVz(isnan(geneTimeVz))=0;

%%
% for i=1:3 % for each GO category
%     if isempty(geneTimeV{i,:})==1 % Skip any GO categories to which no gene belong
%         continue
%     end
%     %NotEmpGeneTimeV=length(idGenesBelong{i});
%     %for j=1:NotEmpGeneTimeV

