% Code to map distances between bundle and laser beam in different events

cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/10_09_14/')
fileList = dir('*.avi');
file_names={fileList.name}; 

centroid_positions = zeros(length(file_names),2);
%%
for event_number = 1:18;

    eval(['mov = aviread(''Event' num2str(event_number) '.avi'')']);
    % mov = aviread('Event1.avi');

    % Subsample the image to only one bundle
    clear subframe
    [cropframe rect] = imcrop(mov(1,1).cdata);  %ask user to crop image to one bundle, save the dimensions of the cropping rectangle
    rect_rounded = round(rect);

    subframe = imcrop(mov(1,1).cdata,rect_rounded);  % make a subframe of the dimensions gotten by the cropping above

    % Threshold the image (only keep values above a threshold)
    maximum = max(max(subframe)); % The highest value in the whole subframed movie
    minimum = min(min(subframe)); % The minimum value in hte whole subframed movie
    thresh_level = minimum + (maximum - minimum) * 0.5; 

    subframe_copy = subframe;
    subframe_copy(subframe_copy < thresh_level) = 0;    % Make everything less than threshold 
    threshold = subframe_copy;
    
        image = threshold;                          % define the current frame
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
        
        centroid_positions(event_number,1) = xbar + rect_rounded(1);
        centroid_positions(event_number,2) = ybar + rect_rounded(2);
end
    

    
%%  Finding the laser center, and distances
    % First get xbars and ybars by running the first part of the script for
    % Event1 (which has the laser spot on the marker
    mov = aviread('Event1.avi');
x_center = mean(xbars(:,1));                % x of centroid within subframe
y_center = mean(ybars(:,1));                % y of centroid within subframe
x_position = x_center + rect_rounded(1);    % add x in centroid to position of subframe
y_position = y_center + rect_rounded(2);    % add y in centroid to position of subframe

imshow(mov(1,10).cdata); 
hold on
plot((x_center + rect_rounded(1)), (y_center + rect_rounded(2)) ,'r+', 'MarkerSize',20)

%% POSITION MAP
plot(centroid_positions(1,1),centroid_positions(1,2),'r+','MarkerSize',15) % laser
hold on
plot(centroid_positions(2,1),centroid_positions(2,2),'m+','MarkerSize',15)
plot(centroid_positions(3,1),centroid_positions(3,2),'m+','MarkerSize',15)
plot(centroid_positions(4,1),centroid_positions(4,2),'m+','MarkerSize',15)
plot(centroid_positions(5,1),centroid_positions(5,2),'m+','MarkerSize',15)
plot(centroid_positions(6,1),centroid_positions(6,2),'m+','MarkerSize',15)
plot(centroid_positions(7,1),centroid_positions(7,2),'m+','MarkerSize',15)
plot(centroid_positions(8,1),centroid_positions(8,2),'g+','MarkerSize',15)
plot(centroid_positions(9,1),centroid_positions(9,2),'m+','MarkerSize',15)
plot(centroid_positions(10,1),centroid_positions(10,2),'m+','MarkerSize',15)
plot(centroid_positions(11,1),centroid_positions(11,2),'m+','MarkerSize',15)
plot(centroid_positions(12,1),centroid_positions(12,2),'b+','MarkerSize',15)
plot(centroid_positions(13,1),centroid_positions(13,2),'c+','MarkerSize',15)
plot(centroid_positions(14,1),centroid_positions(14,2),'m+','MarkerSize',15)
plot(centroid_positions(15,1),centroid_positions(15,2),'m+','MarkerSize',15)
plot(centroid_positions(16,1),centroid_positions(16,2),'m+','MarkerSize',15)
plot(centroid_positions(17,1),centroid_positions(17,2),'m+','MarkerSize',15)
plot(centroid_positions(18,1),centroid_positions(18,2),'y+','MarkerSize',15)

%%
% Distances of records from the origin.
for i = 1:7
x = centroid_positions(i+1,1) - centroid_positions(2,1);
y = centroid_positions(i+1,2) - centroid_positions(2,2);
z = sqrt(x^2 + y^2);
distance(i) = z/2.7273; %when divided by 2.72, the distance is converted from pixels to um
end

