function mask = MakeMeMask(theDim,indicator1,indicator2)
    mask = false(theDim,theDim);
    mask(indicator1,indicator2) = true;
    mask(indicator2,indicator1) = true;
    % make upper diagonal:
    mask = triu(mask,+1);
end
