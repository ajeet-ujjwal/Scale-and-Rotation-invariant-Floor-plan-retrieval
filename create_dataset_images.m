clear;

DATASET_PATH = Utility.DATASET_PATH;
IMAGES_PATH = Utility.IMAGES_PATH;

images = Utility.getAllImages(IMAGES_PATH);

% Creating Dataset
if 7 == exist(DATASET_PATH, 'dir')
    rmdir(DATASET_PATH, 's');
end
mkdir(DATASET_PATH);



for i = 1:length(images)
%     im = imresize(imcomplement(imread(strcat(IMAGES_PATH, '\', images(i).name))), [500 NaN]);
    im = imcomplement(imread(strcat(IMAGES_PATH, '\', images(i).name)));
    [~, name, ext] = fileparts(images(i).name);
    fprintf('Rotating Image: %s\n', images(i).name);
    dirPath = strcat(DATASET_PATH, '\', name);
    if 7 == exist(dirPath, 'dir')
        rmdir(dirPath, 's');
    end
    mkdir(dirPath);
    imwrite(im, strcat(DATASET_PATH, '\', name, '\', name, '_0deg', ext));
    
    dA = floor(360 / Utility.DATABASE_IMAGE_ROTATIONS);
    for ind = 1:Utility.DATABASE_IMAGE_ROTATIONS
        a = (ind-1) * dA;
        rotated = imrotate(im, a, 'bicubic', 'loose');
        imwrite(rotated, strcat(DATASET_PATH, '\', name, '\', name, '_', int2str(a), 'deg', ext));
    end
    
%     for a = 15:50:355
%         rotated = imrotate(im, a, 'bicubic', 'loose');
%         imwrite(rotated, strcat(DATASET_PATH, '\', name, '\', name, '_', int2str(a), 'deg', ext));
%     end
end


