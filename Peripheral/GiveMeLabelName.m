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
    theParameter = 'Decay constant';
case 'logLength'
    theParameter = 'log (Length scale)';
case 'logDecayConstant'
    theParameter = 'log (Decay constant)'
case 'maxDistance'
    theParameter = 'Max distance (mm)'
end

end
