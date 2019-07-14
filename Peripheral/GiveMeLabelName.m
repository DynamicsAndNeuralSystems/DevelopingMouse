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
    theParameter = 'Correlation length, {\lambda} (mm)';
case 'offset'
    theParameter = 'Offset (mm)';
case 'strength'
    theParameter = 'Strength (mm)';
case 'logLength'
    theParameter = 'log (Length scale)';
case 'logDecayConstant'
    theParameter = 'log (Decay constant)';
case 'brainSize'
    theParameter = 'Brain Size, d_m_a_x (mm)';
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
case 'forebrain'
    theParameter = 'Forebrain';
case 'midbrain'
    theParameter = 'Midbrain';
case 'hindbrain'
    theParameter = 'Hindbrain';
case 'wholeBrain'
    theParameter = 'Whole Brain';
end

end
