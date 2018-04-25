function results = SearchImage(imagePath, THRESHOLD)
    DATABASE_FILENAME = Utility.DATABASE_FILENAME;
    DATASET_PATH = Utility.DATASET_PATH;
    
    databaseDir = dir(DATASET_PATH);
    numDataMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    numDataMap(0) = 'Unknown';
    num = 1;
    for d = 1:length(databaseDir)
        if databaseDir(d).isdir && ~strcmp(databaseDir(d).name, '.') && ~strcmp(databaseDir(d).name, '..')
            numDataMap(num) = strcat(DATASET_PATH, '\', databaseDir(d).name);
            num = num + 1;
        end;
    end;
    clear num;
    
    im = imread(imagePath);
    bwImg = im2bw(im);
    
    features = CalcFeatures(bwImg);
    [m, n] = size(features);
    
    % key - image
    % value - similarity
    resultsMap = containers.Map('KeyType', 'char', 'ValueType', 'double');
    fileID = fopen(DATABASE_FILENAME, 'r');
    while ~feof(fileID)
        tline = fgetl(fileID);
        info = textscan(tline, '%f');
        ftrLabel = info{1}(1); % Label that the feature is corresponding to
        ftrSize = info{1}(2); % size of the feature histogram
        ftr = (info{1}(3:end))'; % feature histogram (' :- taking transpose)
        
        ftrDist = ftr(1 : ftrSize / 2);
        ftrAngle = ftr(ftrSize/2 + 1 : end);
        
        for i = 1:m
            featurei = features(i, :);
            dist = featurei(1 : n/2);
            angle = featurei(n/2 + 1 : end);
            
            p1 = PercentMatch(dist, ftrDist, Utility.DISTANCE_THRESHOLD);
            p2 = PercentMatch(angle, ftrAngle, Utility.ANGLE_THRESHOLD);
            
            p = (p1 + p2) / 2; % (p1 * distLength + p2 * angleLength) / TotalLength;
            if p >= THRESHOLD % && ftrSize == n
%                 if ftrSize == n
%                     disp('ftr');
%                     disp(ftr);
%                     disp('featurei');
%                     disp(featurei);
%                     disp('p1');
%                     disp(p1);
%                     disp('p2');
%                     disp(p2);
%                 end
                                
                tmpDirPath = numDataMap(ftrLabel);
                tmpDir = dir(tmpDirPath);
                
                % Taking zero rotation image of category ftrLabel
                key = strcat(tmpDirPath, '\', tmpDir(3).name); % tmpDir(1) -> '.', tmpDir(2) -> '..'
                
                if ~isKey(resultsMap, key)
                    resultsMap(key) = p;
                elseif resultsMap(key) < p
                    resultsMap(key) = p;
                end
            end
        end
    end
    fclose(fileID);
    
    mpLen = length(resultsMap);
    
    % results{i, 1} - Image Path
    % results{i, 2} - Similarity
    results = cell(mpLen, 2);
    
    k = keys(resultsMap);
    val = values(resultsMap);
    [sortedVal, idx] = sort(cellfun(@(x) x(1), val), 'descend');
    k = k(idx);
    for i = 1:mpLen
        results{i, 1} = k{i};
        results{i, 2} = sortedVal(i);
    end
end