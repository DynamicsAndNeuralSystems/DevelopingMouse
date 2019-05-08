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
    theParameter = 'Separation Distance (um)';
case 'length'
    theParameter = 'length scale';
case 'decayConstant'
    theParameter = 'decay constant';
case 'logLength'
    theParameter = 'log (length scale)';
case 'logDecayConstant'
    theParameter = 'log (decay constant)'
end

end
