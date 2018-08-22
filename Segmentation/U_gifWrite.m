function U_gifWrite(inarray,filepath,delay,method)
%   GIFWRITE(INARRAY, FILEPATH, {DELAY}, {METHOD})
%       write image stack to an animated gif
%
%   INARRAY: 4-D image array (rgb, uint8)
%       If images of class~='uint8' are passed, they will be cast as uint8
%       'logical' or 'double' arrays will be treated as whiteval=1.
%       array will be expanded on dim 3 when necessary.
%   FILEPATH: full name and path of output animation
%   DELAY: frame delay in seconds (default = 0.05)
%   METHOD: animation method, 'native' or 'imagemagick' (default = 'native')
%       'imagemagick' may have better quality, but is much slower

if nargin<4
    method='native';
end

if nargin<3
    delay=0.05;
end

if size(inarray,3)==1
    inarray=repmat(inarray,[1 1 3 1]);
elseif size(inarray,3)~=3
    fprintf('GIFWRITE: Expecting size(inpict,3) to be 1 or 3.Arrayed images expected to be concatenated on dim4.  What is this?\n');
    return
end

if islogical(inarray) || strcmp(class(inarray),'double')
    inarray=cast(inarray*255,'uint8');
end

numframes=size(inarray,4);

if strcmpi(method,'native')
    % disp('creating animation')
    for n=1:1:numframes
        [imind,cm]=rgb2ind(inarray(:,:,:,n),256);
        if n==1
            imwrite(imind,cm,filepath,'gif','DelayTime',delay,'Loopcount',inf);
        else
            imwrite(imind,cm,filepath,'gif','DelayTime',delay,'WriteMode','append');
        end
    end
else
    disp('creating frames')
    for n=1:1:numframes
        imwrite(inarray(:,:,:,n),sprintf('/dev/shm/%03dgifwritetemp.png',n),'png');
    end
    
    disp('creating animation')
    system(sprintf('convert -delay %d -loop 0 /dev/shm/*gifwritetemp.png %s',delay*100,filepath));
    
    disp('cleaning up')
    system('rm /dev/shm/*gifwritetemp.png');
end
return
