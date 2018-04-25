clear;

% DATASET_PATH = strcat(PROJECT_PATH, '\dataset'); 
IMAGES_PATH = Utility.IMAGES_PATH;
INPUT_PATH = Utility.INPUT_PATH;

images = Utility.getAllImages(IMAGES_PATH);

if 7 == exist(INPUT_PATH, 'dir')
    rmdir(INPUT_PATH, 's');
end
mkdir(INPUT_PATH);

% Angle A
% A = 42;
for i = 1:length(images)
    imgPath = strcat(IMAGES_PATH, '\', images(i).name);
    im = imcomplement(imread(imgPath));
    [~, name, ext] = fileparts(imgPath);
    fprintf('Rotating Image: %s\n', images(i).name);
    for A = 14:1:14
        fprintf('Rotating at angle %d\n', A);
        rotated = imrotate(im, A, 'bicubic', 'loose');
        scaled2_rotated = imresize(rotated, 2);
        scaled15_rotated = imresize(rotated, 1.5);
        imwrite(rotated, strcat(INPUT_PATH, '\', name, '.', int2str(A), '.1', ext));
%         imwrite(scaled2_rotated, strcat(INPUT_PATH, '\', name, '.', int2str(A), '.2', ext));
%         imwrite(scaled15_rotated, strcat(INPUT_PATH, '\', name, '.', int2str(A), '.1.5', ext));
    end
end

% newSize = size * B
% B = 2;
% for i = 1:length(images)
%     imgPath = strcat(IMAGES_PATH, '\', images(i).name);
%     im = imcomplement(imread(imgPath));
%     [~, name, ext] = fileparts(imgPath);
%     fprintf('Resizing Image: %s\n', images(i).name);
%     imwrite(imresize(im, B), strcat(INPUT_PATH, '\', name, '.0.2', ext));
% end
% 
% B = 1.5;
% for i = 1:length(images)
%     imgPath = strcat(IMAGES_PATH, '\', images(i).name);
%     im = imcomplement(imread(imgPath));
%     [~, name, ext] = fileparts(imgPath);
%     fprintf('Resizing Image: %s\n', images(i).name);
%     imwrite(imresize(im, B), strcat(INPUT_PATH, '\', name, '.0.1.5', ext));
% end