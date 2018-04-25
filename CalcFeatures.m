function histograms = CalcFeatures(bwImg)
    % Background - Black(0)
    % Foreground - White(1)
    
    CC = bwconncomp(bwImg);
    [~,idx] = max(cellfun(@numel,CC.PixelIdxList));

    bwImg(CC.PixelIdxList{idx}) = 0;
    
    se = strel('disk', Utility.DISK_RADIUS);
    bwImg = imclose(bwImg, se);
    bwImg = imfill(bwImg, 'holes');
%     bwImg = bwareaopen(bwImg, 200);
%     [m, n] = size(bwImg);
    
    CC = bwconncomp(bwImg);
    
%     gc = [round(m/2) round(n/2)];
    gc = centroid(bwImg);
    centroids = regionprops(CC, 'Centroid');
%     centroids(idx) = [];

    tmp = extractfield(centroids, 'Centroid');
    ptList = zeros(length(centroids), 2);
    ptList(:, 1) = tmp(1:2:end); % tmp(odd indexed)
    ptList(:, 2) = tmp(2:2:end); % tmp(even indexed)
    clear tmp centroids;
    
    dist = zeros(1, CC.NumObjects);
    nMxDists = 1;
    mxDist = 0;
    mxDistI = 0;
    for i = 1:length(dist)
        dist(i) = EuclideanDist(gc, ptList(i, :));
        if dist(i) > mxDist
            mxDist = dist(i);
            mxDistI = i;
            nMxDists = 1;
        elseif dist(i) == mxDist
            nMxDists = nMxDists + 1;
        end
    end

    angles = getAngles(ptList(mxDistI, :), gc, ptList);
    [sortedangles, anglesIdx] = sort(angles);
    sortedangles = sortedangles';
    
    orderedDist = Normalize(dist(anglesIdx));
%     histograms = zeros(nMxDists, 2 * (CC.NumObjects));
    histograms = zeros(CC.NumObjects, 2 * (CC.NumObjects));
    histograms(1, :) = [orderedDist sortedangles];
    
    for i = 2:CC.NumObjects
%         if histograms(1, i) == mxDist
            histograms(i, :) = [orderedDist([i:end, 1:i-1]) sortedangles([i:end, 1:i-1])];
%         end
    end
end