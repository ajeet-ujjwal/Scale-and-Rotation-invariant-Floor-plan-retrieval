clear;

% DO_COMPLEMENT_OF_IMAGE = Utility.DO_COMPLEMENT_OF_IMAGE;
COMPONENTS_LIMIT = Utility.COMPONENTS_LIMIT;
DATABASE_FILENAME = Utility.DATABASE_FILENAME;

DATASET_PATH = Utility.DATASET_PATH;
datasetDir = dir(DATASET_PATH);
datasetDir(~[datasetDir.isdir]) = [];

TOTAL_IMAGES = 0;
dataNumMap = containers.Map();
num = 1;
for d = 1:length(datasetDir)
    if datasetDir(d).isdir && ~strcmp(datasetDir(d).name, '.') && ~strcmp(datasetDir(d).name, '..')
        dataNumMap(lower(datasetDir(d).name)) = num;
        num = num + 1;
        TOTAL_IMAGES = TOTAL_IMAGES + length(dir(strcat(DATASET_PATH, '\', datasetDir(d).name))) - 2;
    end
end

fileID = fopen(DATABASE_FILENAME, 'w');
for d = 1:length(datasetDir)
    if datasetDir(d).isdir && ~strcmp(datasetDir(d).name, '.') && ~strcmp(datasetDir(d).name, '..')
        currDirName = datasetDir(d).name;
        currDir = Utility.getAllImages(strcat(DATASET_PATH, '\', currDirName));
        
        fprintf('Processing Image: %s\n', currDirName);
        for imgi = 1:length(currDir)
            im = imread(strcat(DATASET_PATH, '\', currDirName, '\', currDir(imgi).name));
            bwImg = im2bw(im);
%             if DO_COMPLEMENT_OF_IMAGE ~= 0
%                 bwImg = imcomplement(bwImg);
%             end
            
            fprintf('Calculating features of Image: %s_%d\n', currDirName, imgi);
            tmp = CalcFeatures(bwImg);
            [m, n] = size(tmp);
            for i = 1:m
                fprintf(fileID, '%d %d ', dataNumMap(lower(currDirName)), n);
                for j = 1:n
                    fprintf(fileID, '%f ', tmp(i, j));
                end
                fprintf(fileID, '\n');
            end
        end
    end
end
fclose(fileID);