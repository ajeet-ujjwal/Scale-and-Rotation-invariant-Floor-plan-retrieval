function angleHist = getAngleHist(ptList)
    TOTAL_ZONES = Utility.TOTAL_ZONES;
    nSeg = Utility.NUM_SEGMENTS;

    ptList = round(ptList);

    [n, ~] = size(ptList);
    gc = [0 0];
    
    iMin = ptList(1, 1);
    iMax = iMin;
    jMin = ptList(1, 2);
    jMax = jMin;
    
    for i = 1:n
        gc(1) = gc(1) + ptList(i, 1);
        gc(2) = gc(2) + ptList(i, 2);
        
        if iMin > ptList(i, 1)
            iMin = ptList(i, 1);
        end
        if iMax < ptList(i, 1)
            iMax = ptList(i, 1);
        end
        if jMin > ptList(i, 2)
            jMin = ptList(i, 2);
        end
        if jMax < ptList(i, 2)
            jMax = ptList(i, 2);
        end
    end
    
    gc = gc / n;

    u = iMax - iMin + 1;
    v = jMax - jMin + 1;
    bwImg = zeros(u, v);
    
    for i = 1:n
        bwImg(ptList(i, 1), ptList(i, 2)) = 1;
    end
    
    rOuter = 0;
    for i = 1:n
        distance = sqrt((ptList(i, 1) - gc(1)).^2 + (ptList(i, 2) - gc(2)).^2);
        if distance > rOuter
           rOuter = distance;
        end;
    end;
    
    d = rOuter / TOTAL_ZONES;
    I = cell(TOTAL_ZONES, 1);
    for i = 1:TOTAL_ZONES
        I{i} = bwImg;
    end;
    
    for i = 1:u
        for j = 1:v
            if bwImg(i,j)==1 
                distance = sqrt((i - gc(1)).^2 + (j - gc(2)).^2);
%                 z1 = floor(distance / d);
                for z1 = 1:TOTAL_ZONES
                    if distance > (z1-1)*d && distance <= z1*d
                        for z2 = 1:TOTAL_ZONES
                            if z2 ~= z1
                                I{z2}(i, j) = 0;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
    clear distance;

    set1 = zeros(TOTAL_ZONES + 1, 2);
    set2 = zeros(TOTAL_ZONES + 1, 2);
    set3 = zeros(TOTAL_ZONES + 1, 2);

    set1(1, 1) = gc(1);
    set1(1, 2) = gc(2);
    set2(1, 1) = gc(1);
    set2(1, 2) = gc(2);
    set3(1, 1) = gc(1);
    set3(1, 2) = gc(2);

    for i=2:TOTAL_ZONES + 1
        cg = centroid(I{i - 1});
        if isnan(cg(1)) || isnan(cg(2))
            set1(i, 1) = gc(1);
            set1(i, 2) = gc(2);
        else
            set1(i, 1) = cg(1);
            set1(i, 2) = cg(2);
        end;
    end;
    clear cg;

    for i = 2:TOTAL_ZONES + 1
        label = logical(I{i - 1});
        nComp = 0;
        for x = 1:u
            for y = 1:v
                if label(x, y)
                    nComp = nComp + 1;
                end
            end
        end
        
        stat = cell(nComp, 1);
        
        cnt = 1;
        for x = 1:u
            for y = 1:v
                if label(x, y)
                    stat{cnt} = [x y];
                    cnt = cnt + 1;
                end
            end
        end
        
        if nComp == 0
            [c1x, c1y] = deal(set1(i, 1), set1(i, 2));
            [c2x, c2y] = deal(set1(i, 1), set1(i, 2));
        else
            mxDist = 0;
            furthestPoints = cell(2, 1);
            furthestPoints{1} = [0, 0];
            furthestPoints{2} = [0, 0];
            for x = 1:nComp
                for y = 1:nComp
                    cX = stat{x};
                    cY = stat{y};
                    dist = (cX(1) - cY(1)).^2 + (cX(1) - cY(1)).^2;
                    if dist > mxDist
                        mxDist = dist;
                        furthestPoints{1} = cX;
                        furthestPoints{2} = cY;
                    end;
                end;
            end;

            c1sx = 0;
            c1sy = 0;
            nc1 = 0;
            c2sx = 0;
            c2sy = 0;
            nc2 = 0;

            for z = 1:nComp
                cent = stat{z};
                dist1 = (cent(1) - furthestPoints{1}(1)).^2 + (cent(2) - furthestPoints{1}(2)).^2;
                dist2 = (cent(1) - furthestPoints{2}(1)).^2 + (cent(2) - furthestPoints{2}(2)).^2;
                if dist1 < dist2
                    c1sx = c1sx + cent(1);
                    c1sy = c1sy + cent(2);
                    nc1 = nc1 + 1;
                else
                    c2sx = c2sx + cent(1);
                    c2sy = c2sy + cent(2);
                    nc2 = nc2 + 1;
                end;
            end;

            c1x = c1sx / nc1; c1y = c1sy / nc1;
            c2x = c2sx / nc2; c2y = c2sy / nc2;

            if nc1 == 0
                c1x = set1(i, 1);
                c1y = set1(i, 2);
            end;

            if nc2 == 0
                c2x = set1(i, 1);
                c2y = set1(i, 2);
            end;

            dist1 = (c1x - gc(1)).^2 + (c1y - gc(2)).^2;
            dist2 = (c2x - gc(1)).^2 + (c2y - gc(2)).^2;
            % For Rotation Invariant
            % Put nearer point in set2
            if dist1 > dist2
                [c1x, c2x] = deal(c2x, c1x);
                [c1y, c2y] = deal(c2y, c1y);
            end;
        end;
        set2(i, 1) = c1x;
        set2(i, 2) = c1y;
        set3(i, 1) = c2x;
        set3(i, 2) = c2y;
    end;
    clear label stat nComp mxDist furthestPoints x y z cX cY dist cent...
          dist1 dist2 c1sx c1sy nc1 c1x c1y c2sx c2sy nc2 c2x c2y;

    % Number of angles per set
    nAngles = 0;
    for i = 1:TOTAL_ZONES-1
        nAngles = nAngles + (TOTAL_ZONES - i) * i;
    end;

    set1angles = zeros(1, nAngles);
    set2angles = zeros(1, nAngles);
    set3angles = zeros(1, nAngles);
    cnt = 1;
    for i = TOTAL_ZONES+1:-1:3
        for j = i-1:-1:2
            for z1 = j-1:-1:1
                p0 = [set1(j, 1), set1(j, 2)]; p1 = [set1(i, 1), set1(i, 2)]; p2 = [set1(z1, 1), set1(z1, 2)];
                set1angles(cnt) = atan2(abs(det([p2-p0;p1-p0])),dot(p2-p0,p1-p0)) * 180 / pi;
                p0 = [set2(j, 1), set2(j, 2)]; p1 = [set2(i, 1), set2(i, 2)]; p2 = [set2(z1, 1), set2(z1, 2)];
                set2angles(cnt) = atan2(abs(det([p2-p0;p1-p0])),dot(p2-p0,p1-p0)) * 180 / pi;
                p0 = [set3(j, 1), set3(j, 2)]; p1 = [set3(i, 1), set3(i, 2)]; p2 = [set3(z1, 1), set3(z1, 2)];
                set3angles(cnt) = atan2(abs(det([p2-p0;p1-p0])),dot(p2-p0,p1-p0)) * 180 / pi;
                cnt = cnt + 1;
            end;
        end;
    end;
    clear i j k cnt p0 p1 p2;

    angleHist = segments([set1angles set2angles set3angles], nSeg);
%     angleHist = [set1angles set2angles set3angles];
end