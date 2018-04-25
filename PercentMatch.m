function percent_match = PercentMatch(vector1, vector2, threshold)
    
    % To avoid floting point errors
    vector1 = floor(vector1 * 10000);
    vector2 = floor(vector2 * 10000);
    threshold = floor(threshold * 10000);

    n1 = length(vector1);
    n2 = length(vector2);
    
    if n1 == n2
        total = n1;
        matched = 0;
        
        for i = 1:total
            if abs(vector1(i) - vector2(i)) <= threshold
                matched = matched + 1;
            end
        end
    else
        small = n1;
        smallVector = vector1;
        big = n2;
        bigVector = vector2;
        
        if small > big
            [small, big] = deal(big, small);
            [smallVector, bigVector] = deal(bigVector, smallVector);
        end
        
        total = big;
        matched = 0;
        bis = 1; % Starting index of bi
        for si = 1:small
            for bi = bis:big
                if abs(bigVector(bi) - smallVector(si)) <= threshold
                    matched = matched + 1;
                    bis = bis + 1;
                    break;
                end
            end
        end
    end
    
    percent_match = matched * 100 / total;
end