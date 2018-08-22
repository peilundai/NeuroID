function L = find_centroid(vol)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

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
end
