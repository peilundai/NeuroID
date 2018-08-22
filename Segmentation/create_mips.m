function [mip1, mip2, mip3] = create_mips(vol, color_map)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% assuming size of 660 x 114 x 87

mip1 = max(vol, [], 3); % 660 x 114
mip2 = squeeze(max(vol, [], 2)); % 660 x 87
mip3 = squeeze(max(vol, [], 1)); % 114 x 87

mip1_t = transpose(mip1); % 114 x 660
mip2_t = transpose(mip2); % 87 x 660
mip3_t = mip3;

% size(mip1_t)
% size(mip2_t)
% size(mip3_t)

if 1
    figure;
%     pos1 = [0.05, 0.5, 0.45, 0.45]; % left bottom, width, height
    ah1 = subplot(2,7,1:6);
    im1 = imagesc(mip1_t);
%     im1.AlphaData = .9;
    colormap(color_map)
    axis image;
    
    ah2 = subplot(2,7,7);
    im2 = imagesc(mip3_t);
%     im2.AlphaData = .9;
    colormap(color_map)
    axis image;
    
    ah3 = subplot(2,7,8:14);
    im3 = imagesc(mip2_t);
%     im3.AlphaData = .9;
    colormap(color_map)
    axis image;
    
    pos1 = get(ah1, 'Position');
    pos2 = get(ah2, 'Position');
    pos3 = get(ah3, 'Position');
    
    pos2(1) = pos1(1) + pos1(3) + 0.05;
    pos2(2) = pos1(2);
%     pos3(2) = pos1(2);
    pos2(4) = pos1(4);
    
    
    pos3(1) = pos1(1);
    pos3(2) = pos1(2) - pos3(4);
    pos3(3) = pos1(3);
    pos3(4) = pos1(4);
    
    set(ah2, 'Position', pos2);
    set(ah3, 'Position', pos3);
    
    linkaxes([ah1, ah3],'x');
    linkaxes([ah1, ah2],'y');
    
    
    

end

end

