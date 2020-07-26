function theParameter = GiveMeFileName(whatParam)
  % give parameter of file name from input
if nargin < 1
    error('Give me an input parameter please!');
end
%-------------------------------------------------------------------------------

switch whatParam
case {'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28','P56'}
        theParameter = sprintf('voxelGeneExpression_%s.mat',whatParam);
  case 'wholeBrain'
    theParameter = '';
  case 'forebrain'
    theParameter = '_forebrain';
  case 'midbrain'
    theParameter = '_midbrain';
  case 'hindbrain'
    theParameter = '_hindbrain';
  case 'Dpallidum'
    theParameter = '_DPallidum';
  case 'scaled'
    theParameter = '_scaled';
  case 'notScaled'
    theParameter = '';
  case 'allCellTypes'
    theParameter = '';
  case 'neuron'
    theParameter = '_neuron';
  case 'oligodendrocyte'
    theParameter = '_oligodendrocyte';
  case 'astrocyte'
    theParameter = '_astrocyte';
  case 'withDirection'
    theParameter = '';
  case 'noDirection'
    theParameter = '_noDirection';
  case 'sagittal'
    theParameter = '_sagittal';
  case 'axial'
    theParameter = '_axial';
  case 'coronal'
    theParameter = '_coronal';
  case 'allDirections'
    theParameter = '';
end

end
