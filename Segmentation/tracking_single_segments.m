function [tracked_seg, gcamp_signal] = tracking_single_segments(mat_file, vid_name, first_n, start_seg)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
m = matfile(mat_file);
F = struct(getframe);

tracked_seg = zeros([first_n, 2]); % seg number, and IOU score
gcamp_signal = zeros([first_n, 1]); % score the CCaMP average from each tracked segments

for i = 1:first_n
    i
    green_vol = m.green(:,:,:,i); % GCaMP raw
    red_vol = m.red(:,:,:,i); % RFP raw
    mode(red_vol(:));
    % segmentation
    red_seg = segment_vol(red_vol);
%     size(red_seg)
%     min(red_seg(:))
%     max(red_seg(:))
%     
    % Tracking 
    if i == 1
        prev_seg = red_seg;
        prev_gcamp = 0;
    else
        prev_gcamp = gcamp_signal(i-1);
    end
    
    if i == 1
        prev_num = start_seg;
    else
        prev_num = tracked_seg(i-1, 1);
    end
    
    % compute IOU for tracking
%     red_seg(prev_seg == 100)
    unique_values = unique(red_seg(prev_seg == prev_num));
    if unique_values == 0
        max_num = prev_num;
        max_iou = 0;
        continue
    end
   
    overlapping_num = unique_values(unique_values~=0)
    max_iou = 0;
    max_num = overlapping_num(1);
    for j =1:length(overlapping_num)
        num = overlapping_num(j);
        
        % prev_seg, prev_num
        % red_seg, num
        vol1 = zeros(size(red_seg));
        vol2 = zeros(size(red_seg));
        vol1(prev_seg==prev_num) = 1;
        vol2(red_seg==num) = 1;
        
        
        inter = vol1 & vol2;
        union = vol1 | vol2;
        
        iou = sum(inter(:))/sum(union(:));
        
        if iou > max_iou
            max_iou = iou;
            max_num = num;
        end
    end
    
    [max_num, max_iou]
    
    tracked_seg(i,:) = [max_num, max_iou];
    prev_seg = red_seg;
    
    
    % get GCaMP signal
    if max_iou == 0
        current_gcamp = prev_gcamp;
    else
        current_gcamp = mean(green_vol(red_seg == max_num));
        
        
    end
    
    current_gcamp
    gcamp_signal(i) = current_gcamp;
    
    
    
    
    seg_viz = zeros(size(red_seg));
    
    seg_viz(red_seg == max_num) = 1;
%     max(seg_viz(:))

%       Make MIP 
    mip1 = max(seg_viz, [], 3); % 660 x 114
    mip2 = squeeze(max(seg_viz, [], 2)); % 660 x 87
    mip3 = squeeze(max(seg_viz, [], 1)); % 114 x 87

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

save('tracked_seg.mat', 'tracked_seg');
save('gcamp_signal.mat', 'gcamp_signal');

end



