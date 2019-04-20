load('corrCoeff_distances_ontoDist_clean.mat','corrCoeff_clean','ontoDist_clean');
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
%Plot gene coexpression against ontological distance
for i=1:length(timePoints)
    f=figure('color','w','units','normalized','outerposition',[0 0 1 1],'Position',get(0,'Screensize'));
    scatter(ontoDist_clean{i},corrCoeff_clean{i})
    ylim([-0.6 1])
    str=sprintf('Developing Mouse %s',timePoints{i});
    title(str)
    xlabel('Ontological distance')
    ylabel('Gene coexpression (correlation coefficient)')
    hold on
    uniqueOntoDist=unique(ontoDist_clean{i});

    % prepare to collect the coexpression data for later use
    corrCoeffCell{i}=cell(length(uniqueOntoDist),1);

    % mean of gene coexpression at each ontological distance
    meanCoexpress=zeros(length(uniqueOntoDist),1);
    sdCoexpress=zeros(length(uniqueOntoDist),1);
    range=zeros(length(uniqueOntoDist),1);
    for j=1:length(uniqueOntoDist)
        isRight=(ontoDist_clean{i}==uniqueOntoDist(j));
        corrCoeffCell{i}{j}=corrCoeff_clean{i}(isRight);
        meanCoexpress(j)=mean(corrCoeff_clean{i}(isRight));
        sdCoexpress(j)=std(corrCoeff_clean{i}(isRight));
        range(j)=max(corrCoeff_clean{i}(isRight))-min(corrCoeff_clean{i}(isRight));
    end
    for j=1:length(uniqueOntoDist)
        text(uniqueOntoDist(j),meanCoexpress(j),strcat('mean=',num2str(meanCoexpress(j))))
        text(uniqueOntoDist(j),meanCoexpress(j)-0.1*range(j),strcat('SD=',num2str(sdCoexpress(j))))
        hold on
    end
    % save figure
    str=fullfile('Outs','ontological_distance',sprintf('OntoDistance_DevMouse%s.jpg',timePoints{i}))
    F=getframe(f);
    imwrite(F.cdata,str,'jpeg');

    % Plot jitter scatter for each time point
    BF_JitteredParallelScatter(corrCoeffCell{i})
    hold on
    str=sprintf('Developing Mouse %s',timePoints{i});
    title(str)
    xlabel('Ontological distance')
    ylabel('Gene coexpression (correlation coefficient)')
    ax = gca;
    ax.XTick=[1 2 3 4 5];
    ax.XTickLabel=num2str(uniqueOntoDist);
    % save figure
    str=fullfile('Outs','ontological_distance',sprintf('OntoDistanceJitter_DevMouse%s.jpeg',timePoints{i}))
    saveas(gcf,str)
end
