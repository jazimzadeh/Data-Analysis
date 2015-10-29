clear;clc;
cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/9_30_14/')
mov = aviread('Event1.avi');

% Subsample the image to only one bundle
for i = 1:4096
    eval(['subframe(:,:,' num2str(i) ') = mov(1,i).cdata([75:85],[30:45]);']);
end

% Add some code to threshold the image (only keep values above a threshold)
threshold = subframe;
threshold(threshold <125)=0;

%
xbars = zeros(size(threshold,3),1);
ybars = zeros(size(threshold,3),1);

for i = 1:size(threshold,3)
    image = threshold(:,:,i);                   % define the current frame
    image = image > 1;                          % make the object all 1's; logical
    image_bw = imfill(image,'holes');           % fill in the object (any discontinuous parts are filled in
    image_L = bwlabel(image_bw);                % label each continous object with a number (in case there are multiple)
    image_s = regionprops(image_L, 'PixelIdxList', 'PixelList');    % Get the index of pixels, and their x,y coordinates
    idx = image_s(1).PixelIdxList;              % put the indexes into a new variable
    sum_region = sum(image(idx));               % sum to get the total intensity of all pixels in the object
    x = image_s(1).PixelList(:,1);              % get the x coordinates of all pixels in the object
    y = image_s(1).PixelList(:,2);              % get the y coordinates of all pixels in the object
    xbar = sum(x .* double(image(idx))) / sum_region;   % calculate the position of the mean intensity in x
    ybar = sum(y .* double(image(idx))) / sum_region;   % calculate the position of the mean intensity in x
    xbars(i,1) = xbar;
    ybars(i,1) = ybar;
end
help

y1 = ybars(1:1000,1);
y2 = ybars(1001:2000,1);
y3 = ybars(2001:3000,1);
y4 = ybars(3001:4000,1);
y_average = (y1 + y2 + y3 + y4) / 4;    

x = 0:0.5:499.5;
plot(x,-y_average)
    

    
