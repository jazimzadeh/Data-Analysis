clear;clc;
cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/10_09_14/')

all_x = zeros(500,18);
for event_number = 1:25
    eval(['mov = aviread(''Event' num2str(event_number) '.avi'')']);

    % Subsample the image to only one bundle
    clear subframe
    [cropframe rect] = imcrop(mov(1,1).cdata);  %ask user to crop image to one bundle, save the dimensions of the cropping rectangle
    rect_rounded = round(rect);

    for i = 1:size(mov,2)
        eval(['subframe(:,:,' num2str(i) ') = imcrop(mov(1,i).cdata,rect_rounded);']);
    end

    % Threshold the image (only keep values above a threshold)
    maximum = max(max(max(subframe(:,:,:)))); % The highest value in the whole subframed movie
    minimum = min(min(min(subframe(:,:,:)))); % The minimum value in hte whole subframed movie
    thresh_level = minimum + (maximum - minimum) * 0.5; 

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

    %
    y1 = ybars(1:500,1);
    y2 = ybars(501:1000,1);
    y3 = ybars(1001:1500,1);
    y4 = ybars(1501:2000,1);
    y_average = (y1 + y2 + y3 + y4) / 4; 

    %
    x1 = xbars(1:500,1);
    x2 = xbars(501:1000,1);
    x3 = xbars(1001:1500,1);
    x4 = xbars(1501:2000,1);
    x_average = (x1 + x2 + x3 + x4) / 4; 
    
    all_x(:,event_number) = x_average;
end

%% Ploting

Fs = 1000;
L = length(all_x);
interval = 1/Fs;
t = linspace(0,L/Fs,L)';

all_x_normalized = all_x - all_x(1,6);
all_x_nm = all_x_normalized / 0.0027273;

offset = 0;
h = figure;
set(h,'DefaultAxesColorOrder', autumn(20))
for i = 2:18

    plot(t,-all_x_nm(:,i) + offset);
    offset = offset + 800;
    hold all
end
ylabel('Displacement (Pixels)')
xlabel('Time (ms)')
title('10/9/14 HB1 Videos, Events 2-18, bottom to top')

%% Plot selected runs
clf
i=2;
plot(t(200-199:299-199),-all_x_nm(200:299,i));
hold on
i=3;
plot(t(200-199:299-199),-all_x_nm(200:299,i)+600,'m');
i=5;plot(t(400-399:299-199),-all_x_nm(400:499,i)+900,'g');

laser_delay = 0.03;
laser_duration = 0.04;
ylim = get(gca, 'YLim');
ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
y = [ylim(1) ylim(2)-0.3 ylim(2)-0.3 ylim(1)+0.2 ylim(1)+0.2]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')




%% Control for decay of amplitude over time. Assume a linear decay between records 2 and 9. Find the scaling factors for the records in the middle.
initial = abs(mean(all_x_nm(450:470,2)) - mean(all_x_nm(400:420,2)));   % amplitude of initial central trace on 4th waveform
final =   abs(mean(all_x_nm(450:470,8)) - mean(all_x_nm(400:420,8)));   % amplitude of initial central trace on 4th waveform
percentile_interval = ((initial/initial)-(final/initial))/6;

scale_factor = zeros(5,1);
for i = 1:5
scale_factor(i,1) = final/initial+ i*percentile_interval;
end  

scale_factor = flipud(scale_factor);
scale_factor = [final/final ; scale_factor ; final/initial];

zeroed_displacements = zeros(size(all_x_nm));
for i = 1: size(all_x_nm,2)
zeroed_displacements(:,i) = all_x_nm(:,i) - mean(all_x_nm(1:20,i)); %subtract the initial value of each trace from itself to zero any offset
end

zeroed_displacements = -zeroed_displacements;   %flip sign so all displacements are (+)

%create a new variable that contains the scaled values
for i = 1:7
    zeroed_scaled_displacements(:,i) = zeroed_displacements(:,i+1)/scale_factor(i);
    zeroed_displacement(:,i) = zeroed_displacements(:,i+1);
end



clf
subplot(1,2,1)
offset = 0;
for i = 1:7
    plot(t,zeroed_displacement(:,i) + offset)
    hold on
    offset = offset + 650;
end
axis([0 0.5 -200 4500])
title('Raw displacement')

subplot(1,2,2)
offset = 0;
for i = 1:7
    plot(t,zeroed_scaled_displacements(:,i) + offset)
    hold on
    offset = offset + 650;
end
axis([0 0.5 -200 4500])
title('Scaled')

%%
amplitudes = zeros(5,7);
for i = 1:7
amplitudes(1,i) = mean(zeroed_displacement(50:70,i))   - mean(zeroed_displacement(1:20,i));
amplitudes(2,i) = mean(zeroed_displacement(150:170,i)) - mean(zeroed_displacement(101:120,i));
amplitudes(3,i) = mean(zeroed_displacement(250:270,i)) - mean(zeroed_displacement(201:220,i));
amplitudes(4,i) = mean(zeroed_displacement(350:370,i)) - mean(zeroed_displacement(301:320,i));
amplitudes(5,i) = mean(zeroed_displacement(450:470,i)) - mean(zeroed_displacement(401:420,i));
end

amplitudes_scaled = zeros(5,7);
for i = 1:7
amplitudes_scaled(1,i) = mean(zeroed_scaled_displacements(50:70,i))   - mean(zeroed_scaled_displacements(1:20,i));
amplitudes_scaled(2,i) = mean(zeroed_scaled_displacements(150:170,i)) - mean(zeroed_scaled_displacements(101:120,i));
amplitudes_scaled(3,i) = mean(zeroed_scaled_displacements(250:270,i)) - mean(zeroed_scaled_displacements(201:220,i));
amplitudes_scaled(4,i) = mean(zeroed_scaled_displacements(350:370,i)) - mean(zeroed_scaled_displacements(301:320,i));
amplitudes_scaled(5,i) = mean(zeroed_scaled_displacements(450:470,i)) - mean(zeroed_scaled_displacements(401:420,i));
end
%% Plot amplitudes versus distance from center.
% Need to run DistanceMap_10_09_14 to obtain 'distance' variable for this
% plot
clf
subplot(1,2,1)
for j = 1:7
    
        plot(distance(j),amplitudes(1,j),'.','MarkerSize',20,'color',[0.9 0 0])
        hold on
        plot(distance(j),amplitudes(2,j),'.','MarkerSize',20,'color',[0.9 0.4 0])
        plot(distance(j),amplitudes(3,j),'.','MarkerSize',20,'color',[1 0.9 0])
        plot(distance(j),amplitudes(4,j),'.','MarkerSize',20,'color',[0.1 1 0.4])
        plot(distance(j),amplitudes(5,j),'.','MarkerSize',20,'color',[0.2 0.4 0.9])
end
title('Displacement as a function of distance from center - raw amplitudes')
xlabel('Distance from laser center (um)')
ylabel('Displacement amplitude (nm)')
axis([-5 25 0 520])

subplot(1,2,2)
for j = 1:7
    
        plot(distance(j),amplitudes_scaled(1,j),'.','MarkerSize',20,'color',[0.9 0 0])
        hold on
        plot(distance(j),amplitudes_scaled(2,j),'.','MarkerSize',20,'color',[0.9 0.4 0])
        plot(distance(j),amplitudes_scaled(3,j),'.','MarkerSize',20,'color',[1 0.9 0])
        plot(distance(j),amplitudes_scaled(4,j),'.','MarkerSize',20,'color',[0.1 1 0.4])
        plot(distance(j),amplitudes_scaled(5,j),'.','MarkerSize',20,'color',[0.2 0.4 0.9])
end
title('Displacement as a function of distance from center - scaled amplitudes')
xlabel('Distance from laser center (um)')
ylabel('Displacement amplitude (nm)')
axis([-5 25 0 520])





    

    
