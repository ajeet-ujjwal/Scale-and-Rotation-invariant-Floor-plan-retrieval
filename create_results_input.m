function create_results_input(resultsInputPath, resultsImagesPath)
RESULTS_INPUT_PATH = resultsInputPath;
IMAGES_PATH = resultsImagesPath;

images = Utility.getAllImages(IMAGES_PATH);

% Creating Dataset
if 7 == exist(RESULTS_INPUT_PATH, 'dir')
    rmdir(RESULTS_INPUT_PATH, 's');
end
mkdir(RESULTS_INPUT_PATH);

for i = 1:length(images)
    im = imcomplement(imread(strcat(IMAGES_PATH, '\', images(i).name)));
    [~, name, ext] = fileparts(images(i).name);
    fprintf('Rotating Image: %s\n', images(i).name);
    dirPath = strcat(RESULTS_INPUT_PATH, '\', name);
    if 7 == exist(dirPath, 'dir')
        rmdir(dirPath, 's');
    end
    mkdir(dirPath);
    
    dA = floor(360 / Utility.RESULTS_IMAGE_ROTATIONS);
    for ind = 1:Utility.RESULTS_IMAGE_ROTATIONS
        a = mod(Utility.RESULTS_IMAGE_START_ANGLE + (ind-1) * dA, 360);
        rotated = imrotate(im, a, 'bicubic', 'loose');
        imwrite(rotated, strcat(RESULTS_INPUT_PATH, '\', name, '\', name, '_', int2str(a), 'deg', ext));
    end
end
end