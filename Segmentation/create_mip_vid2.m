
function create_mip_vid2(mat_file, vid_name, first_n, tracked_seg)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% assuming size of 660 x 114 x 87 x 1183

m = matfile(mat_file);
F = struct(getframe);

for i = 1:first_n
    vol = m.green(:,:,:,i);
    
    vol = find_centroid(vol);
    
    mip1 = max(vol, [], 3); % 660 x 114
    mip2 = squeeze(max(vol, [], 2)); % 660 x 87
    mip3 = squeeze(max(vol, [], 1)); % 114 x 87

    mip1_t = transpose(mip1); % 114 x 660
    mip2_t = transpose(mip2); % 87 x 660
    mip3_t = mip3;

    
    fig = figure(1);
    ah1 = subplot(2,7,1:6);
    imagesc(mip1_t);
%     colormap(color_map);
    axis image;
    
    ah2 = subplot(2,7,7);
    imagesc(mip3_t);
%     colormap(color_map);
    axis image;
    
    ah3 = subplot(2,7,8:14);
    imagesc(mip2_t);
%     colormap(color_map);
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
    F(i) = getframe(fig);
    drawnow
end

% create the video writer with 1 fps
writerObj = VideoWriter(vid_name);
writerObj.FrameRate = 10;
% set the seconds per image

% open the video writer
open(writerObj);
% write the frames to the video
for i=1:length(F)
    % convert the image to a frame
    frame = F(i);    
    size(frame.cdata);
    writeVideo(writerObj, frame);
end
% close the writer object
close(writerObj);

end

