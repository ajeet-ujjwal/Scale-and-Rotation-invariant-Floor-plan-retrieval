% Angle ABC
function angle = CalcAngle(ptA, ptB, ptC)
    angle = atan2(abs(det([ptC-ptB;ptA-ptB])),dot(ptC-ptB,ptA-ptB)) * 180 / pi;
    v1 = ptA - ptB;
    v2 = ptC - ptB;
    crossprod = v1(1) * v2(2) - v1(2) * v2(1);
    if crossprod > 0
        angle = 360 - angle;
    end
end