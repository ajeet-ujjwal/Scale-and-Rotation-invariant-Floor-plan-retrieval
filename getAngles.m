function angles = getAngles(mxPt, gc, ptList)
    % angleIdx(i) - value of angle for point ptList(i)
    angles = zeros(length(ptList), 1);
    for i = 1:length(angles)
        angles(i) = CalcAngle(mxPt, gc, ptList(i, :));
    end
end