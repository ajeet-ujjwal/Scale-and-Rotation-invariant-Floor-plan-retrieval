function results = SearchImage2(imagePath, THRESHOLD)
    DATABASE_FILENAME = Utility.DATABASE_FILENAME2;
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
    
    feature = CalcFeatures2(bwImg);
    n = length(feature);
    
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
        
        p = PercentMatch(ftr, feature, Utility.ANGLE_THRESHOLD);
        if p >= THRESHOLD
            tmpDirPath = numDataMap(ftrLabel);
            tmpDir = dir(tmpDirPath);
            
            % Taking zero degree rotated image of category ftrLabel
            key = strcat(tmpDirPath, '\', tmpDir(3).name); % tmpDir(1) -> '.', tmpDir(2) -> '..'

            if ~isKey(resultsMap, key)
                resultsMap(key) = p;
            elseif resultsMap(key) < p
                resultsMap(key) = p;
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