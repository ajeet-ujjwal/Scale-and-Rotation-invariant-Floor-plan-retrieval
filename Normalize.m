function normalizedVector = Normalize(vector)
    mn = min(vector);
    mx = max(vector);
    
    n = length(vector);
    normalizedVector = vector;
    
    for i = 1:n
        normalizedVector(i) = (vector(i) - mn) / (mx - mn);
    end
end