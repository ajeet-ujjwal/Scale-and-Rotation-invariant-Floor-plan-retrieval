clear;

% DO_COMPLEMENT_OF_IMAGE = Utility.DO_COMPLEMENT_OF_IMAGE;
COMPONENTS_LIMIT = Utility.COMPONENTS_LIMIT;
DATABASE_FILENAME = Utility.DATABASE_FILENAME2;

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
            
            histogram = CalcFeatures2(bwImg);
            n = length(histogram);
            fprintf(fileID, '%d %d ', dataNumMap(lower(currDirName)), n);
            for i = 1:n
                fprintf(fileID, '%f ', histogram(i));
            end
            fprintf(fileID, '\n');
        end
    end
end
fclose(fileID);