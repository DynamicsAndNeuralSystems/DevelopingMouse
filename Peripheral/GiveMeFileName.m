function theParameter = GiveMeFileName(whatParam)
  % give parameter of file name from input
if nargin < 1
    error('Give me an input parameter please!');
end

switch whatParam
  case 'wholeBrain'
    theParameter = '';
  case 'forebrain'
    theParameter = '_forebrain';
  case 'midbrain'
    theParameter = '_midbrain';
  case 'hindbrain'
    theParameter = '_hindbrain';
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
end
end
