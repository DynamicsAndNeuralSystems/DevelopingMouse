cd 'D:\Data\DevelopingAllenMouseAPI-master\Rubinov regions_80 genes'

% load all gene expression energy data for all structures
load ExpressionEnergy_ACo.csv
load ExpressionEnergy_AOB.csv
load ExpressionEnergy_AOD.csv
load ExpressionEnergy_AOV.csv
load ExpressionEnergy_ASPall.csv
load ExpressionEnergy_CA.csv
load ExpressionEnergy_CbH.csv
load ExpressionEnergy_CbV.csv
load ExpressionEnergy_CCx.csv
load ExpressionEnergy_DG.csv
load ExpressionEnergy_is.csv
load ExpressionEnergy_m1.csv
load ExpressionEnergy_MH.csv
load ExpressionEnergy_OB.csv
load ExpressionEnergy_p1.csv
load ExpressionEnergy_p2.csv
load ExpressionEnergy_p3.csv
load ExpressionEnergy_Pal.csv
load ExpressionEnergy_PaSe.csv
load ExpressionEnergy_PH.csv
load ExpressionEnergy_PHy.csv
load ExpressionEnergy_PLCo.csv
load ExpressionEnergy_PMCo.csv
load ExpressionEnergy_PMH.csv
load ExpressionEnergy_POTel.csv
load ExpressionEnergy_r1.csv
load ExpressionEnergy_r2.csv
load ExpressionEnergy_RSCx.csv
load ExpressionEnergy_SeSPall.csv
load ExpressionEnergy_Stri.csv
load ExpressionEnergy_Strp.csv
load ExpressionEnergy_THy.csv
load ExpressionEnergy_TTe.csv


%% create cell array to store expression energy matrices in the form of structure x gene
% make cell array of E11.5, E13.5, E15.5, E18.5, P4, P14, P28
V=cell(7,1);
for i=1:7
    V{i}=cat(1,ExpressionEnergy_CA(i,:),ExpressionEnergy_DG(i,:),ExpressionEnergy_POTel(i,:),...
    ExpressionEnergy_THy(i,:),ExpressionEnergy_SeSPall(i,:),ExpressionEnergy_PaSe(i,:),...
    ExpressionEnergy_PHy(i,:),ExpressionEnergy_AOB(i,:),ExpressionEnergy_AOV(i,:),...
    ExpressionEnergy_AOD(i,:),ExpressionEnergy_OB(i,:),ExpressionEnergy_TTe(i,:),...
    ExpressionEnergy_PMCo(i,:),ExpressionEnergy_PLCo(i,:),ExpressionEnergy_ACo(i,:),...
    ExpressionEnergy_Pal(i,:),ExpressionEnergy_ASPall(i,:),ExpressionEnergy_Stri(i,:),...
    ExpressionEnergy_is(i,:),ExpressionEnergy_CbV(i,:),ExpressionEnergy_r1(i,:),...
    ExpressionEnergy_CbH(i,:),ExpressionEnergy_r2(i,:),ExpressionEnergy_PH(i,:),...
    ExpressionEnergy_PMH(i,:),ExpressionEnergy_MH(i,:),ExpressionEnergy_RSCx(i,:),...
    ExpressionEnergy_Strp(i,:),ExpressionEnergy_p2(i,:),ExpressionEnergy_p3(i,:),...
    ExpressionEnergy_p1(i,:),ExpressionEnergy_m1(i,:),ExpressionEnergy_CCx(i,:));
end


%%
%give structure labels to the rows of the matrices
structureLabel={'CA','DG','POTel','THy','SeSPall','PaSe','PHy','AOB','AOV','AOD','OB','TTe',...
    'PMCo','PLCo','ACo','Pal','ASPall','Stri','is','CbV','r1','CbH','r2','PH','PMH','MH','RSCx',...
    'Strp','p2','p3','p1','m1','CCx'};
%create a vector 'h' of 0 and 1 indicating which rows are hubs, in which 0=nonhub and 1=hub
hubindex=zeros(6,1);
hubindex(1)=find(ismember(structureLabel,'Strp'));
hubindex(2)=find(ismember(structureLabel,'p2'));
hubindex(3)=find(ismember(structureLabel,'p3'));
hubindex(4)=find(ismember(structureLabel,'p1'));
hubindex(5)=find(ismember(structureLabel,'m1'));
hubindex(6)=find(ismember(structureLabel,'CCx'));

h=zeros(33,1);
h(hubindex)=1;
%%
%assign degree to the structures (according to data provided by Rubinov)
k=zeros(33,1);
k(find(ismember(structureLabel,'CA')))=57;
k(find(ismember(structureLabel,'DG')))=63;
k(find(ismember(structureLabel,'POTel')))=52;
k(find(ismember(structureLabel,'THy')))=62;
k(find(ismember(structureLabel,'SeSPall')))=55;
k(find(ismember(structureLabel,'PaSe')))=65.5;
k(find(ismember(structureLabel,'PHy')))=64.5;
k(find(ismember(structureLabel,'AOB')))=32.5;
k(find(ismember(structureLabel,'AOV')))=51;
k(find(ismember(structureLabel,'AOD')))=51;
k(find(ismember(structureLabel,'OB')))=26.5;
k(find(ismember(structureLabel,'TTe')))=67.5;
k(find(ismember(structureLabel,'PMCo')))=34;
k(find(ismember(structureLabel,'PLCo')))=34;
k(find(ismember(structureLabel,'ACo')))=34;
k(find(ismember(structureLabel,'Pal')))=56;
k(find(ismember(structureLabel,'ASPall')))=63.5;
k(find(ismember(structureLabel,'Stri')))=60;
k(find(ismember(structureLabel,'is')))=56;
k(find(ismember(structureLabel,'CbV')))=38.5;
k(find(ismember(structureLabel,'r1')))=68.5;
k(find(ismember(structureLabel,'CbH')))=37.5;
k(find(ismember(structureLabel,'r2')))=51;
k(find(ismember(structureLabel,'PH')))=56.5;
k(find(ismember(structureLabel,'PMH')))=45.5;
k(find(ismember(structureLabel,'MH')))=48.5;
k(find(ismember(structureLabel,'RSCx')))=67;
k(find(ismember(structureLabel,'Strp')))=43.5;
k(find(ismember(structureLabel,'p2')))=86;
k(find(ismember(structureLabel,'p3')))=72;
k(find(ismember(structureLabel,'p1')))=68;
k(find(ismember(structureLabel,'m1')))=66.5;
k(find(ismember(structureLabel,'CCx')))=80;

%%
%assign the gene abbreviations to the columns
load geneEntrez.csv
% only 80 genes (out of 2107) are downloaded at this time
geneEntrez=geneEntrez(1:80)
%% saves the generated variables
save('newmatrixData.mat','h','V','k','geneEntrez','structureLabel')




