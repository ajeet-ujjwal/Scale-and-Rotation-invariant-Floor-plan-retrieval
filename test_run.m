function avg_accuracy = test_run(method, resultsInputPath)
inputDir = dir(resultsInputPath);

TOTAL_CATEGORIES = 0;
% IMAGES_PER_CATEGORY = 0;
for d = 1:length(inputDir)
    if inputDir(d).isdir && ~strcmp(inputDir(d).name, '.') && ~strcmp(inputDir(d).name, '..')
        TOTAL_CATEGORIES = TOTAL_CATEGORIES + 1;
%         if IMAGES_PER_CATEGORY == 0
%             IMAGES_PER_CATEGORY = length(Utility.getAllImages(strcat(Utility.RESULTS_INPUT_PATH, '\', inputDir(d).name)));
%         end
    end
end

% stats{i, 1} - category name
% stats{i, 2} - matched images count
% stats{i, 3} - total images count
stats = cell(TOTAL_CATEGORIES, 3);
s = 1;
for d = 1:length(inputDir)
    if inputDir(d).isdir && ~strcmp(inputDir(d).name, '.') && ~strcmp(inputDir(d).name, '..')
        currDirName = inputDir(d).name;
        currDirPath = strcat(resultsInputPath, '\', currDirName);
        images = Utility.getAllImages(currDirPath);
        
        stats{s, 1} = currDirName;
        stats{s, 2} = 0;
        stats{s, 3} = length(images);
        
        fprintf('Processing category "%s"...\n', currDirName);
        for imgi = 1:length(images)
            imagePath = strcat(currDirPath, '\', images(imgi).name);
            fprintf('\tSearching for image "%s"\n', images(imgi).name);
            if method == 1
                result = SearchImage(imagePath, Utility.THRESHOLD);
            else
                result = SearchImage2(imagePath, Utility.THRESHOLD);
            end
            [m, ~] = size(result);
            for i = 1:m
                [~, resName, ~] = fileparts(result{i, 1});
                resName = resName(1:length(resName) - 5);
%                 [~, imageName, ~] = fileparts(imagePath);
                
                % Note: database image name and results input image name
                % should be same for same images (For comparison purpose only)
                if strcmp(resName, currDirName)
                    stats{s, 2} = stats{s, 2} + 1;
                end
            end
        end
        s = s + 1;
    end
end

avg_accuracy = 0;
fprintf('S.No.\t\tInput Category\t\t\tAccuracy\n');
for i = 1:TOTAL_CATEGORIES
    accuracy = stats{i, 2} * 100 / stats{i, 3};
    fprintf('%d)\t\t\t%s\t\t\t%.02f%%\n', i, stats{i, 1}, accuracy);
    avg_accuracy = avg_accuracy + accuracy;
end

avg_accuracy = avg_accuracy / TOTAL_CATEGORIES;

fprintf('\nAverage Accuracy = %.02f%%\n', avg_accuracy);
end