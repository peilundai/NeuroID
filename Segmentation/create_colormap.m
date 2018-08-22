function color_map = create_colormap(num_colors)
%UNTITLED9 Summary of this function goes here
%   return color_map of size num_colors x 3, 0-255, 'utin8'

    color_map = randi(256, [num_colors, 3]) - 1;
   

end

