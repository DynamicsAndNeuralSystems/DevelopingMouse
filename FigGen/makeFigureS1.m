function makeFigureS1()
  f=figure('color','w');
  plotVariance(false)
  % Save out:
  str = fullfile('Outs','figureS1','figureS1.svg');
  saveas(f,str)
end
