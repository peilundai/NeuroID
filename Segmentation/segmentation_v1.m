
%% read data
close all; clearvars; clc;

file_path = "/Volumes/GoogleDrive/My Drive/Experimental Data" + ...
    "/C. elegans Data/20180709/worm3_AML32_runC_small_1to20BeadImmobilized_skewCorrected.mat";
m = matfile(file_path);

% 660x114x87x1813
%%
num_colors = 1000;
color_map = rand(num_colors, 3);


%% Read a single volume for processing

% min_val = 100;
% global max and min values for normalization purpose
max_val = 993.6786; % single, max value over all volumes
min_val = -26.1004; 

vol = m.red(:,:,:,1);
%     mip = max(current_vol, [], 3);
%     mip_t(:,:,i) = mip;

%% Preprocessing? denoising? removing background

% Gaussian filtering
fil_vol = imgaussfilt3(vol, 0.5);

% Remove background
level = 20;
BW1 = imbinarize(fil_vol, level);
fg_vol = fil_vol.*BW1;

% Segmentation

ord = 'max';
winSize = 3;
max_vol = ordfilt3(fg_vol, ord, winSize);
% BW3 = imregionalmax(max_vol);
max_vol = imgaussfilt3(max_vol, 0.5);

H = fspecial('log', 20);
max_vol = imfilter(max_vol, H);

level2 = 3;
BW2 = imbinarize(max_vol, level2);
max_vol = max_vol.*BW2;

% overlay = imimposemin(fg_vol, BW2);
% make label bigger
% se = strel('sphere',3);
% L = imdilate(BW2, se);
% Label = bwlabeln(L);

% watershed
D = -max_vol;
D(~BW2) = Inf;
L = watershed(D);
L(~BW2) = 0;

se2 = strel('sphere', 2);
L = imopen(L, se2);
% max(L(:))

[mip1, mip2, mip3] = create_mips(L, color_map);

%% Max filter to find centroid
centroid = find_centroid_points(vol);
[mip1, mip2, mip3] = create_mips(centroid);

%% Segmentation




%% display (with videos for all volumes)
[mip1, mip2, mip3] = create_mips(vol);



%% Tracking point sets using CPD (Coherent Point Drift) or ICP (Iterative Closest Point)
    
for i = 1:10
    current_vol = m.red(:,:,:,i);
    
    

    % find neuron centroid in current volume
    
    
    % match current volume with previous volum
    
    
    % set previous volume to current volume
    
    
end

%% Display tracked results




















