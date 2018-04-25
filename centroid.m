function centroid = centroid(image)
    [m, n] = size(image);
    sx = 0;
    sy = 0;
    npt = 0;
    for i = 1:m
        for j = 1:n
            if image(i, j) == 1
                sx = sx + i;
                sy = sy + j;
                npt = npt + 1;
            end;
        end;
    end;
    
    centroid = zeros(1, 2);
    centroid(1) = sx / npt;
    centroid(2) = sy / npt;
end