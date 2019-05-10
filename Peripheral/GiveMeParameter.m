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
    theParameter = {'wholeBrain','forebrain','midbrain','hindbrain'};
case 'smallBrainDivisions'
    theParameter = {'forebrain','midbrain','hindbrain'};
case 'scaledDistance'
    theParameter = {true,false};
case 'useEnrichedGenes'
    theParameter = {true,false};
case 'cellTypes'
    theParameter = {'allCellTypes','oligodendrocyte','neuron','astrocyte'};
case 'smallCellTypes'
    theParameter = {'oligodendrocyte','neuron','astrocyte'};
case 'constantTypes'
    theParameter = {'decayConstant','multiplier','freeParameter'};
case 'matTypes'
    theParameter = {'voxGeneMat','distMat','cgeMat'};
case 'directions'
    theParameter = {'sagittal','coronal','axial'};
end

end
