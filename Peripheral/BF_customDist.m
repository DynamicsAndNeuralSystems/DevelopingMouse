function D2 = BF_customDist(XI,XJ)
% Euclidean distance ignoring coordinates with NaNs
% (from NANEUCDIST example from Matlab)
n = size(XI,2);
sqdx = (XI-XJ).^2;
nstar = sum(~isnan(sqdx),2); % Number of pairs that do not contain NaNs
nstar(nstar == 0) = NaN; % To return NaN if all pairs include NaNs
D2squared = nansum(sqdx,2).*n./nstar; % Correction for missing coordinates
D2 = sqrt(D2squared);

end
