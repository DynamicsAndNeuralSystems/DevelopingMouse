function [angle_coronal,angle_axial,angle_sagittal]=makeDirectionality(coOrds)
  % function [angle_coronal,angle_axial,angle_sagittal]=makeDirectionality(coOrds)
  % determine directionality
  % read in the coordinates and voxgenemat
  coronalVec=[1 0 0]; % front-back
  axialVec=[0 1 0]; % top-down
  sagittalVec=[0 0 1]; % left-right

  % determine angle made with the three directions between two voxels
  % vec=[1 2 3] % for example
  % angle_coronal=acos((dot(vec,coronalVec))/(norm(vec)*norm(coronalVec)));
  % angle_axial=acos((dot(vec,axialVec))/(norm(vec)*norm(axialVec)));
  % angle_sagittal=acos((dot(vec,sagittalVec))/(norm(vec)*norm(sagittalVec)));

  [n,p] = size(coOrds);
  angle_sagittal = zeros(1,n*(n-1)./2);
  angle_coronal = zeros(1,n*(n-1)./2);
  angle_axial = zeros(1,n*(n-1)./2);

  % make the direction vectors
  vecMat = zeros(n*(n-1)./2,3); % stores direction vectors
  for i = 1:length(vecMat)
    for j = 1:n-1
      for k = j+1:n
        vecMat(i,:) = coOrds(k,:)-coOrds(j,:);
        % determine angle made with the three directions
        angle_coronal(i) = acos((dot(vecMat(i,:),coronalVec))/(norm(vecMat(i,:))*norm(coronalVec)));
        angle_axial(i) = acos((dot(vecMat(i,:),axialVec))/(norm(vecMat(i,:))*norm(axialVec)));
        angle_sagittal(i) = acos((dot(vecMat(i,:),sagittalVec))/(norm(vecMat(i,:))*norm(sagittalVec)));
      end
    end
  end
  %%
  % k = 1;
  % for i = 1:n-1 % for each coordinate triplet
  %     % determine direction vector with another coordinate triplet
  %     vecMat = zeros(n-i,p); % pair with another coordinate triplet
  %     for j = 1:n-1
  %       vecMat(j,:)=coOrds(j+1,:)-coOrds(i,:); % direction vector
  %     end
  %     % determine the angle made with the three directions between two voxels
  %     angle_coronal(k:(k+n-i-1)) = acos((dot(vecMat(j,:),coronalVec))/(norm(vecMat(j,:))*norm(coronalVec)));
  %     angle_axial(k:(k+n-i-1)) = acos((dot(vecMat(j,:),axialVec))/(norm(vecMat(j,:))*norm(axialVec)));
  %     angle_sagittal(k:(k+n-i-1)) = acos((dot(vecMat(j,:),sagittalVec))/(norm(vecMat(j,:))*norm(sagittalVec)));
  %     k = k + (n-i);
  % end
end
