function theParameter = GiveMeLabelName(whatParam)
% Gives a paramter from input

if nargin < 1
    error('Give me an input parameter please!');
end
%-------------------------------------------------------------------------------

switch whatParam
case 'scaledDistance'
    theParameter = 'Separation Distance/maxDistance';
case 'originalDistance'
    theParameter = 'Separation Distance (mm)';
case 'CGE'
    theParameter = 'Correlated Gene Expression';
case 'length'
    theParameter = 'Length scale';
case 'decayConstant'
    theParameter = 'Decay Constant';
case 'freeParameter'
    theParameter = 'Free Parameter';
case 'multiplier'
    theParameter = 'Multiplier';
case 'logLength'
    theParameter = 'log (Length scale)';
case 'logDecayConstant'
    theParameter = 'log (Decay constant)';
case 'maxDistance'
    theParameter = 'Max Distance (mm)';
case 'genes'
    theParameter = 'Genes';
case 'voxels'
    theParameter = 'Voxels';
case 'timePoints'
    theParameter = 'Time Points';
case 'sampleSize'
    theParameter = 'Sample Size';
case 'variance'
    theParameter = 'Variance in decay constant';
end

end
