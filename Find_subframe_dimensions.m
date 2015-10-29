% This script prompts the user to crop video stills to individual bundles
% and to mark the center of each bundle.
% The crop and click coordinates are saved in a structure.
% This structure is used in later scripts to analyze the motion of hair
% bundles.

%clear;clc;clf
cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/9_4_15/')

for r = 1:4
    r
    % *** Import movie ***
    eval(['mov = aviread(''Event' num2str(r) '.avi'',1);']);        % Read first frame
    
    % *** Subsample the image to only one bundle ***
    clear subframe
    [cropframe rect] = imcrop(mov.cdata);  % ask user to crop image to one bundle, save the dimensions of the cropping rectangle
    rect_rounded = round(rect);
    
    % *** Crop every frame using the dimensions gotten above ***
%     for i = 1:size(mov,2)       
%         eval(['subframe(:,:,' num2str(i) ') = imcrop(mov(1,i).cdata,rect_rounded);']);
%     end

    subframe = imcrop(mov.cdata,rect_rounded); % Crop the first frame so I can click the center later
    
    % *** Click on brightest pixel, in vertical center of bundle ***
    image(subframe);
    [x_click y_click] = ginput;     % Solicit a click from the user
    x_click = round(x_click);
    y_click = round(y_click);
    
    % Store the coordinates in the structure
    record(r).rect          = rect;
    record(r).rect_rounded  = rect_rounded;
    record(r).x_click       = x_click;
    record(r).y_click       = y_click;

    % *** Create time vector ***
    t = [0.5:0.5:100];
    record(r).time = t;             % Store a time vector for each record
end

save('Record_coordinates.mat')

