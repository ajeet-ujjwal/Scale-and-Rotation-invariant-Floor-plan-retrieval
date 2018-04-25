function histogram = CalcFeatures2(bwImg)
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
%     gc = centroid(bwImg);
    centroids = regionprops(CC, 'Centroid');
%     centroids(idx) = [];

    tmp = extractfield(centroids, 'Centroid');
    nPt = length(centroids);
    ptList = zeros(nPt, 2);
    ptList(:, 1) = tmp(1:2:end); % tmp(odd indexed)
    ptList(:, 2) = tmp(2:2:end); % tmp(even indexed)
    clear tmp centroids;

    histogram = getAngleHist(ptList);

%     dist = zeros(1, CC.NumObjects);
%     nMxDists = 1;
%     mxDist = 0;
%     mxDistI = 0;
%     for i = 1:length(dist)
%         dist(i) = EuclideanDist(gc, ptList(i, :));
%         if dist(i) > mxDist
%             mxDist = dist(i);
%             mxDistI = i;
%             nMxDists = 1;
%         elseif dist(i) == mxDist
%             nMxDists = nMxDists + 1;
%         end
%     end
%     
%     [dist, idx] = sort(dist, 'descend');
% 
%     ptList = ptList(idx, :);
%     
%     total_angles = nPt * (nPt - 1) * (nPt - 2) / 6;
%     histogram = zeros(total_angles, 1);
%     cnt = 1;
%     for i = 1:nPt-2
%         for j = i+1:nPt-1
%             for k = j+1:nPt
%                 histogram(cnt) = CalcAngle(ptList(i, :), ptList(j, :), ptList(k, :));
%                 cnt = cnt + 1;
%             end
%         end
%     end
end