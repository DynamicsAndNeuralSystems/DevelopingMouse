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
case 'resolutionGrid'
    theParameter = struct('E11pt5',80,'E13pt5',100,'E15pt5',120,'E18pt5',140,'P4',160,'P14',200,'P28',200);
end

end
