classdef Utility
    %UTILITY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
      METHOD_IN_GUI = 1; % 1 or 2
      
      IMAGES_PATH = strcat(pwd, '\input_dataset');
      DATASET_PATH = strcat(pwd, '\dataset'); 
      INPUT_PATH = strcat(pwd, '\input');
      
      %Filters constants
      DISK_RADIUS = 50;
      
%       RESULTS_IMAGES_PATH = strcat(pwd, '\results_input_dataset_0_extra_comp');
%       RESULTS_INPUT_PATH = strcat(pwd, '\results_input0');
      RESULTS_IMAGE_ROTATIONS = 16;
      RESULTS_IMAGE_START_ANGLE = 10; % in degrees
      
      DATABASE_IMAGE_ROTATIONS = 32;
      
      DATABASE_FILENAME = 'ajeetDB.txt';
      DATABASE_FILENAME2 = 'ajeetDB2.txt';
      
      DO_COMPLEMENT_OF_IMAGE = 0;
      COMPONENTS_LIMIT = 200;
      
      THRESHOLD = 80; % Minimum percentage similarity
      DISTANCE_THRESHOLD = 0.1; % distances are normalized
      ANGLE_THRESHOLD = 10; % in degrees
      
      TOTAL_ZONES = 14;
      NUM_SEGMENTS = 12;
    end
    
    methods (Static)
        function images = getAllImages(path_to_imageDir)
            images0 = dir(fullfile(path_to_imageDir, '\*.tif'));
            images1 = dir(fullfile(path_to_imageDir, '\*.tiff'));
            images2 = dir(fullfile(path_to_imageDir, '\*.jpg'));
            images3 = dir(fullfile(path_to_imageDir, '\*.jpeg'));
            images4 = dir(fullfile(path_to_imageDir, '\*.png'));
            images = vertcat(images0, images1, images2, images3, images4);
        end
    end
    
end

