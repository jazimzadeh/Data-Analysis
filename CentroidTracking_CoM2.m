clear;clc;
cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/10_06_14/')
mov = aviread('Event11.avi');

%% Subsample the image to only one bundle
clear subframe
[cropframe rect] = imcrop(mov(1,1).cdata);  %ask user to crop image to one bundle, save the dimensions of the cropping rectangle
rect_rounded = round(rect);

for i = 1:size(mov,2)
    eval(['subframe(:,:,' num2str(i) ') = imcrop(mov(1,i).cdata,rect_rounded);']);
end

%% Threshold the image (only keep values above a threshold)
maximum = max(max(max(subframe(:,:,:)))); % The highest value in the whole subframed movie
minimum = min(min(min(subframe(:,:,:)))); % The minimum value in hte whole subframed movie
thresh_level = minimum + (maximum - minimum) * 0.4; 

subframe_copy = subframe;
subframe_copy(subframe_copy < thresh_level) = 0;
threshold = subframe_copy;

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

%%
y1 = ybars(1:1000,1);
y2 = ybars(1001:2000,1);
y3 = ybars(2001:3000,1);
y4 = ybars(3001:4000,1);
y_average = (y1 + y2 + y3 + y4) / 4; 

%%
x1 = xbars(1:500,1);
x2 = xbars(501:1000,1);
x3 = xbars(1001:1500,1);
x4 = xbars(1501:2000,1);
x_average = (x1 + x2 + x3 + x4) / 4; 
    

    
