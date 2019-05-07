clearvars
%------------------------------------------------------------------------
% Load variables and initialize
%------------------------------------------------------------------------
load('dataDevMouse.mat');
% Initialize
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28','P56'};
%------------------------------------------------------------------------
% Plotting
%------------------------------------------------------------------------
% MDS
for i=1:length(timePoints)
    distMat = dataDevMouse.(timePoints{i}).distance;
    score = mdscale(distMat,2);
    xData = score(:,1);
    yData = score(:,2);
    numRegions=height(dataDevMouse.(timePoints{i}).info);
    
    % Plot
    f = figure('color','w');
    dotColors = arrayfun(@(x) rgbconv(dataDevMouse.(timePoints{i}).color{x})',...
                                        1:numRegions,'UniformOutput',0);
    dotColors = [dotColors{:}]';

    nodeSize = 50;
    scatter(xData,yData,nodeSize,dotColors,'fill','MarkerEdgeColor','k')
    str=sprintf('Developing Mouse %s MDS',timePoints{i});
    t=title(str);
    set(t,'Fontsize',18)

    % Add labels:
    xDataRange = range(xData);
    for j = 1:numRegions
        text(xData(j)+0.04*xDataRange,yData(j),dataDevMouse.(timePoints{i}).acronym{j},...
                        'color',brighten(dotColors(j,:),-0.3))
    end
    % save the figure
    filename=strcat('MDS','_',timePoints{i},'.jpeg');
    str=fullfile('Data','Outs','MDS',filename);
    saveas(f,str)
end

%% Scatter3 plot
for i=1:length(timePoints)
    coOrds_x=dataDevMouse.(timePoints{i}).coOrd(:,1);
    coOrds_y=dataDevMouse.(timePoints{i}).coOrd(:,2);
    coOrds_z=dataDevMouse.(timePoints{i}).coOrd(:,3);
    numRegions=height(dataDevMouse.(timePoints{i}).info);
    
    % Plot
    f1 = figure('color','w');
    dotColors = arrayfun(@(x) rgbconv(dataDevMouse.(timePoints{i}).color{x})',...
                                        1:numRegions,'UniformOutput',0);
    dotColors = [dotColors{:}]';
    
    nodeSize = 50;
    scatter3(coOrds_x,coOrds_y,coOrds_z,nodeSize,dotColors,'fill','MarkerEdgeColor','k');
    xlabel('x');
    ylabel('y');
    zlabel('z');
    str=sprintf('Developing Mouse %s Scatter3 Plot',timePoints{i});
    t=title(str);
    set(t,'Fontsize',18)

    % Add labels:
    xCoordRange = range(coOrds_x);
    for j = 1:numRegions
        text(coOrds_x(j)+0.04*xCoordRange,coOrds_y(j),coOrds_z(j),dataDevMouse.(timePoints{i}).acronym{j},...
                        'color',brighten(dotColors(j,:),-0.3))
    end
    % save the figure
    filename=strcat('scatter3','_',timePoints{i},'.jpeg');
    str=fullfile('Data','Outs','scatter3',filename);
    saveas(f1,str)
end
