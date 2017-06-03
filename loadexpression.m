clear all

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

%create expression energy matrix in the form of structure x gene
v=cat(1,ExpressionEnergy_CA,ExpressionEnergy_DG,ExpressionEnergy_POTel,...
    ExpressionEnergy_THy,ExpressionEnergy_SeSPall,ExpressionEnergy_PaSe,...
    ExpressionEnergy_PHy,ExpressionEnergy_AOB,ExpressionEnergy_AOV,...
    ExpressionEnergy_AOD,ExpressionEnergy_OB,ExpressionEnergy_TTe,...
    ExpressionEnergy_PMCo,ExpressionEnergy_PLCo,ExpressionEnergy_ACo,...
    ExpressionEnergy_Pal,ExpressionEnergy_ASPall,ExpressionEnergy_Stri,...
    ExpressionEnergy_is,ExpressionEnergy_CbV,ExpressionEnergy_r1,...
    ExpressionEnergy_CbH,ExpressionEnergy_r2,ExpressionEnergy_PH,...
    ExpressionEnergy_PMH,ExpressionEnergy_MH,ExpressionEnergy_RSCx,...
    ExpressionEnergy_Strp,ExpressionEnergy_p2,ExpressionEnergy_p3,...
    ExpressionEnergy_p1,ExpressionEnergy_m1,ExpressionEnergy_CCx)
%%
%give sructure labels to the rows of the matrix
structurelabel={'CA','DG','POTel','THy','SeSPall','PaSe','PHy','AOB','AOV','AOD','OB','TTe',...
    'PMCo','PLCo','ACo','Pal','ASPall','Stri','is','CbV','r1','CbH','r2','PH','PMH','MH','RSCx',...
    'Strp','p2','p3','p1','m1','CCx'};
%create a vector 'h' of 0 and 1 indicating which rows are hubs, in which 0=nonhub and 1=hub
hubindex=zeros(6,1);
hubindex(1)=find(ismember(structurelabel,'Strp'));
hubindex(2)=find(ismember(structurelabel,'p2'));
hubindex(3)=find(ismember(structurelabel,'p3'));
hubindex(4)=find(ismember(structurelabel,'p1'));
hubindex(5)=find(ismember(structurelabel,'m1'));
hubindex(6)=find(ismember(structurelabel,'CCx'));

h=zeros(33,1);
h(hubindex)=1;
%%
%assign degree to the structures (according to data provided by Rubinov)
k=zeros(33,1);
k(find(ismember(structurelabel,'CA')))=57;
k(find(ismember(structurelabel,'DG')))=63;
k(find(ismember(structurelabel,'POTel')))=52;
k(find(ismember(structurelabel,'THy')))=62;
k(find(ismember(structurelabel,'SeSPall')))=55;
k(find(ismember(structurelabel,'PaSe')))=65.5;
k(find(ismember(structurelabel,'PHy')))=64.5;
k(find(ismember(structurelabel,'AOB')))=32.5;
k(find(ismember(structurelabel,'AOV')))=51;
k(find(ismember(structurelabel,'AOD')))=51;
k(find(ismember(structurelabel,'OB')))=26.5;
k(find(ismember(structurelabel,'TTe')))=67.5;
k(find(ismember(structurelabel,'PMCo')))=34;
k(find(ismember(structurelabel,'PLCo')))=34;
k(find(ismember(structurelabel,'ACo')))=34;
k(find(ismember(structurelabel,'Pal')))=56;
k(find(ismember(structurelabel,'ASPall')))=63.5;
k(find(ismember(structurelabel,'Stri')))=60;
k(find(ismember(structurelabel,'is')))=56;
k(find(ismember(structurelabel,'CbV')))=38.5;
k(find(ismember(structurelabel,'r1')))=68.5;
k(find(ismember(structurelabel,'CbH')))=37.5;
k(find(ismember(structurelabel,'r2')))=51;
k(find(ismember(structurelabel,'PH')))=56.5;
k(find(ismember(structurelabel,'PMH')))=45.5;
k(find(ismember(structurelabel,'MH')))=48.5;
k(find(ismember(structurelabel,'RSCx')))=67;
k(find(ismember(structurelabel,'Strp')))=43.5;
k(find(ismember(structurelabel,'p2')))=86;
k(find(ismember(structurelabel,'p3')))=72;
k(find(ismember(structurelabel,'p1')))=68;
k(find(ismember(structurelabel,'m1')))=66.5;
k(find(ismember(structurelabel,'CCx')))=80;




