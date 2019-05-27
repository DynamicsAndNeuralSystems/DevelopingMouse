function [angle_coronal,angle_axial,angle_sagittal]=makeDirectionality(coOrds,shuffledOrder)
  % this function determines directionality of voxel pairs; shuffledOrder is a shuffled sequence
  % for reordering the sequence of computing the direction vectors
  % the three vectors in the main direciton
  coronalVec=[1 0 0]; % front-back
  axialVec=[0 1 0]; % top-down
  sagittalVec=[0 0 1]; % left-right

  [n,p] = size(coOrds);
  angle_sagittal = zeros(1,n*(n-1)./2);
  angle_coronal = zeros(1,n*(n-1)./2);
  angle_axial = zeros(1,n*(n-1)./2);

  % make the direction vectors
  vecMat = zeros(n*(n-1)./2,3); % stores direction vectors
  C = combnk(1:n,2); % obtain the combination indexes of two coOrds taken at a time
  C = C(shuffledOrder,:); % shuffle order to eliminate left-right bias inherent in coOrds
  for i = 1:size(vecMat,1)
    vecMat(i,:) = coOrds(C(i,2),:)-coOrds(C(i,1),:);
    % determine angle made with the three directions
    angle_coronal(i) = acos((dot(vecMat(i,:),coronalVec))/(norm(vecMat(i,:))*norm(coronalVec)));
    angle_axial(i) = acos((dot(vecMat(i,:),axialVec))/(norm(vecMat(i,:))*norm(axialVec)));
    angle_sagittal(i) = acos((dot(vecMat(i,:),sagittalVec))/(norm(vecMat(i,:))*norm(sagittalVec)));
  end
end
