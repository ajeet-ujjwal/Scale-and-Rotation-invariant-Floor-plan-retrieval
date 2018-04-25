function s = segments(angleVec, nSeg)
    nAngles = length(angleVec);
    s = zeros(nSeg, 1);
    for i = 1:nSeg
        j = round(i * nAngles / (nSeg + 1));
        s(i) = angleVec(j);
%         if s(i) == 0
%             % linearly interpolate value using left & right non zero values
%             jMin = j - 1;
%             jMax = j + 1;
%             
%             while jMin >= 1 && angleVec(jMin) == 0
%                 jMin = jMin - 1;
%             end
%             if jMin < 1
%                 jMin = 1;
%             end
%             
%             while jMax <= nAngles && angleVec(jMax) == 0
%                 jMax = jMax + 1;
%             end
%             if jMax > nAngles
%                 jMax = nAngles;
%             end
%             
%             s(i) = angleVec(jMin) + (j - jMin) * (angleVec(jMax) - angleVec(jMin)) / (jMax - jMin);
%         end
    end;
end