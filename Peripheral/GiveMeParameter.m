function theParameter = GiveMeParameter(whatParam)
% Gives a paramter from input

if nargin < 1
    error('Give me an input parameter please!');
end
%-------------------------------------------------------------------------------

switch whatParam
case 'sizeGrids'
    theParameter = struct('E11pt5',[70,75,40],'E13pt5',[89,109,69],...
                    'E15pt5',[94,132,65],'E18pt5',[67,43,40],'P4',[77,43,50],...
                    'P14',[68,40,50],'P28',[73,41,53]);
case 'timePoints'
    theParameter = {'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
case 'fileTimePoints'
    theParameter = {'E11.5','E13.5','E15.5','E18.5','P4','P14','P28'};
case 'resolutionGrid'
    theParameter = struct('E11pt5',0.08,'E13pt5',0.1,'E15pt5',0.12,'E18pt5',0.14,'P4',0.16,'P14',0.2,'P28',0.2);
case 'brainDivisions'
    theParameter = {'wholeBrain','forebrain','midbrain','hindbrain','Dpallidum'};
case 'smallBrainDivisions'
    theParameter = {'forebrain','midbrain','hindbrain','Dpallidum'};
case 'createBrainDivisions'
    theParameter = {'forebrain','midbrain','hindbrain','Dpallidum','SpinalCord'};
case 'smallBrainDivisionsAbbrev'
    theParameter = {'F','M','H','DPall'};
case 'createBrainDivisionsAbbrev'
    theParameter = {'F','M','H','DPall','SpC'};
case 'scaledDistance'
    theParameter = false;
case 'useEnrichedGenes'
    theParameter = {true,false};
case 'cellTypes'
    theParameter = {'allCellTypes','oligodendrocyte','neuron','astrocyte'};
case 'smallCellTypes'
    theParameter = {'oligodendrocyte','neuron','astrocyte'};
case 'constantTypes'
    theParameter = {'decayConstant','strength','offset'};
case 'matTypes'
    theParameter = {'voxGeneMat','distMat','cgeMat'};
case 'directions'
    theParameter = {'sagittal','coronal','axial'};
case 'whatNorm'
    theParameter = 'scaledSigmoid';
case 'whatVoxelThreshold'
    theParameter = 0.3;
case 'whatGeneThreshold'
    theParameter = 0.3;
case 'numData'
    theParameter = 1000;
case 'numThresholds'
    theParameter = 21;
case 'incrementVector'
    theParameter = 100:100:1000;
case 'samplingNum'
    theParameter = 100;
case 'descendantCsvDim'
    theParameter = {[1 1 1130 1],[1 1 176 1],[1 1 1089 1],[1 1 118 1],[1 1 93 1]};
end

end
