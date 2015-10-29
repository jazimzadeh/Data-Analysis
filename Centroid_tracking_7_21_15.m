% Open movie files,ask user to select bundle of interest in each, get
% displacement waveform 
% clear;clc;
cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/7_21_15/')
%%
for r = 3;
    %mov = aviread('Event15.avi');
    eval(['mov = aviread(''Event' num2str(r) '.avi'');']);

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
        %image_bw = image;
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

    y1 = ybars(1:200,1);
    y2 = ybars(201:400,1);
    y3 = ybars(401:600,1);
    y4 = ybars(601:800,1);
    y5 = ybars(801:1000,1);
    y6 = ybars(1001:1200,1);
    y7 = ybars(1201:1400,1);
    y8 = ybars(1401:1600,1);
    y9 = ybars(1601:1800,1);
    y10 = ybars(1801:2000,1);
    y_average = (y1 + y2 + y3 + y4+y5+y6+y7+y8+y9+y10) / 10; 

    % Filter, moving average
    %xbars = filter(ones(1,2), 1, xbars);
    
    % Median filter
    xbars = medfilt1(xbars, 4);
    
    x1 = xbars(1:200,1);
    x2 = xbars(201:400,1);
    x3 = xbars(401:600,1);
    x4 = xbars(601:800,1);
    x5 = xbars(801:1000,1);
    x6 = xbars(1001:1200,1);
    x7 = xbars(1201:1400,1);
    x8 = xbars(1401:1600,1);
    x9 = xbars(1601:1800,1);
    x10 = xbars(1801:2000,1);
    x_average = (x1 + x2 + x3 + x4+x5+x6+x7+x8+x9+x10) / 10; 
    
    t = [0.5:0.5:100];
    
    record(r).time = t;
    baseline = mean(x_average(40:60));    % This is the baseline displacement
    record(r).displacement = x_average - baseline;
    record(r).xpos = rect(1) + xbars(1,1);
    record(r).ypos = rect(2) + ybars(1,1);
    
end


%% Make a new field containing each bundle's X distance from bundle 1, in um
% Get a pixel to um calibration factor
%mov = aviread('Event1.avi');
%imagesc(mov(1,1).cdata);
% there are 138 pixels in 50 um, so the factor is 50/138 um/pixel

for i = 1:31
   record(i).distance = (abs(record(1).xpos - record(i).xpos)) * (50/138) ; 
end

%% Plot all the displacements, offset by run number
clf
offset = 0;
for i = 1:31
    plot(record(i).time, record(i).displacement + offset, 'k');
    offset = offset + 0.9;
    hold on
end

%% Plot just the good displacements, HB1
% There are no good displacements..
clf

set(0, 'DefaultAxesColorOrder', ametrine(13));
for i = 1:13
    plot(record(i).time, record(i).displacement + record(i).distance);
    hold all
end
xlabel('Time (ms)')
ylabel('Distance and Displacement (um)')
%axis([0 100 -1 16])
title('7/21/15 - 2 kHz videos - HB motion vs. Distance, HB1')

%% Plot just the good displacements, HB2
clf

set(0, 'DefaultAxesColorOrder', ametrine(7));
for i = 18:24
    plot(record(i).time, record(i).displacement + record(i).distance);
    hold all
end
xlabel('Time (ms)')
ylabel('Distance and Displacement (um)')
axis([0 100 -1 22])
title('7/21/15 - 2 kHz videos - HB motion vs. Distance, HB2')

%% Plot just the good displacements, HB3
clf

set(0, 'DefaultAxesColorOrder', ametrine(7));
for i = 25:31
    plot(record(i).time, record(i).displacement + record(i).distance);
    hold all
end
xlabel('Time (ms)')
ylabel('Distance and Displacement (um)')
axis([0 100 -1 22])
title('7/21/15 - 2 kHz videos - HB motion vs. Distance, HB3')

%% Calculate the amplitude of the laser evoked step, store as "delta"
for i = 1:31
    pre  = mean(record(i).displacement(1:60));
    step = mean(record(i).displacement(100:140));
    post = mean(record(i).displacement(160:200));
    delta= abs(step - mean([pre post])) * (50000/138); % Calculate delta size, convert to nm
    record(i).delta = delta;
end

%% Plot decay of response as a function of event number, HB1
clf
counter = 1;
subplot(4,1,1:2)
for i = [1:2:13]        % these are the events in which the bundle was in the laser beam
    event_HB1(counter) = i;
    delta_HB1(counter) = record(i).delta;
    counter = counter + 1;
    plot(i, record(i).delta,'.','MarkerSize',24);
    hold on
end
%axis([0 8 30 80])
ylabel('nm')
title('HB1 - Amplitudes of records in center of beam v. Event number')

p_HB1 = polyfit(event_HB1, delta_HB1,1);    % Fit a linear polynomial 
xl = xlim;
x_fit = linspace(xl(1),xl(2),100);
y_fit = polyval(p_HB1,x_fit);
h1 = plot(x_fit,y_fit)
legend(h1,['slope = ' num2str(p_HB1(1)) ])

% Now plot corrected records from inside the beam 
for i = 1:17
    decayed = p_HB1(1) * (i) + p_HB1(2);
    c_factor = decayed/record(3).delta; % Use record 3 as the baseline
    record(i).corr_delta = record(i).delta/c_factor;    % Create a corr_delta field in each record, with the corrected amplitude
end

subplot(4,1,3:4)
for i = [1:2:13]        % these are the events in which the bundle was in the laser beam
    h1 = plot(i, record(i).delta,'k.','MarkerSize',24);
    hold on
    h2 = plot(i, record(i).corr_delta,'r.','MarkerSize',24);
end
xlabel('Event #')
ylabel('Displacement (nm)')
title('HB1 - Displacements within beam, corrected for decay')
%axis([0 8 0 90])
legend([h1 h2], 'Original','Corrected','location','SouthWest')

%% Plot decay of response as a function of event number, HB2
clf
counter = 1;
subplot(4,1,1:2)
for i = [18:2:24]        % these are the events in which the bundle was in the laser beam
    event_HB2(counter) = i-17;
    delta_HB2(counter) = record(i).delta;
    counter = counter + 1;
    plot(i-17, record(i).delta,'.','MarkerSize',24);
    hold on
end
axis([0 8 0 300])
ylabel('nm')
title('HB2 - Amplitudes of records in center of beam v. Event number')

p_HB2 = polyfit(event_HB2, delta_HB2,1);    % Fit a linear polynomial 
xl = xlim;
x_fit = linspace(xl(1),xl(2),100);
y_fit = polyval(p_HB2,x_fit);
h1 = plot(x_fit,y_fit)
legend(h1, ['slope = ' num2str(p_HB2(1)) ])

% Now plot corrected records from inside the beam 
for i = 18:24
    decayed = p_HB2(1) * (i-17) + p_HB2(2);
    c_factor = decayed/record(18).delta;
    record(i).corr_delta = record(i).delta/c_factor;    % Create a corr_delta field in each record, with the corrected amplitude
end

subplot(4,1,3:4)
for i = [18:2:24]       % these are the events in which the bundle was in the laser beam
    h1 = plot(i-17, record(i).delta,'k.','MarkerSize',24);
    hold on
    h2 = plot(i-17, record(i).corr_delta,'r.','MarkerSize',24);
end
xlabel('Event #')
ylabel('Displacement (nm)')
title('HB2 - Displacements within beam, corrected for decay')
axis([0 8 0 300])
legend([h1 h2], 'Original','Corrected','location','NorthEast')


%% Plot decay of response as a function of event number, HB3
clf
counter = 1;
subplot(4,1,1:2)
for i = [25:2:31]  
    event_HB3(counter) = i-24;
    delta_HB3(counter) = record(i).delta;
    counter = counter + 1;
    plot(i-24, record(i).delta,'.','MarkerSize',24);
    hold on
end
axis([0 8  0 100])
ylabel('nm')
title('HB3 - Amplitudes of records in center of beam v. Event number')

p_HB3 = polyfit(event_HB3, delta_HB3,1);    % Fit a linear polynomial 
xl = xlim;
x_fit = linspace(xl(1),xl(2),100);
y_fit = polyval(p_HB3,x_fit);
plot(x_fit,y_fit)
legend(['slope = ' num2str(p_HB3(1)) ])

% Now plot corrected records from inside the beam 

for i = 25:31
    decayed = p_HB3(1) * (i-24) + p_HB3(2);
    c_factor = decayed/record(25).delta;        % compare the values gotten fit to the original (non-decayed) to get correction factor
    record(i).corr_delta = record(i).delta/c_factor;
end
subplot(4,1,3:4)
for i = [25:2:31]        % these are the events in which the bundle was in the laser beam
    h1 = plot(i-24, record(i).delta,'k.','MarkerSize',24);
    hold on
    h2 = plot(i-24, record(i).corr_delta,'r.','MarkerSize',24);
end
xlabel('Event #')
ylabel('Displacement (nm)')
title('HB3 - Displacements within beam, corrected for decay')
axis([0 8 0 100])
legend([h1 h2], 'Original','Corrected','location','NorthEast')

%% HB1 - Plot both corrected and uncorrected delta against distance from laser
clf
set(0, 'DefaultAxesColorOrder', ametrine(13));
subplot(2,1,1)
for i = 1:13
   plot(record(i).distance,record(i).delta,'.','Markersize',24)
   hold all
end
axis([-5 60 0 450])
ylabel('Laser-evoked displacement (nm)')
title('Displacement v. Distance from laser beam, 7/21/15 HB1')

subplot(2,1,2)
for i = 1:13
   plot(record(i).distance,record(i).corr_delta,'.','Markersize',24)
   hold all
end
axis([-5 60 0 450])
xlabel(' Distance from laser (um)')
ylabel('CORRECTED Laser-evoked displacement (nm)')

%% HB2 - Plot both corrected and uncorrected delta against distance from laser
clf
set(0, 'DefaultAxesColorOrder', ametrine(7));
subplot(2,1,1)
for i = 18:24
   plot(record(i).distance,record(i).delta,'.','Markersize',24)
   hold all
end
axis([-5 20 0 250])
ylabel('Laser-evoked displacement (nm)')
title('Displacement v. Distance from laser beam, 7/21/15 HB2')

subplot(2,1,2)
for i = 18:24
   plot(record(i).distance,record(i).corr_delta,'.','Markersize',24)
   hold all
end
axis([-5 20 0 250])
xlabel(' Distance from laser (um)')
ylabel('CORRECTED Laser-evoked displacement (nm)')

%% HB3 - Plot both corrected and uncorrected delta against distance from laser
% Didn't plot the last 3 runs because there was almost no mvt, and lots of
% error
clf
set(0, 'DefaultAxesColorOrder', ametrine(6));
subplot(2,1,1)
for i = 25:31
   plot(record(i).distance,record(i).delta,'.','Markersize',24)
   hold all
end
axis([-2 30 0 80])
ylabel('Laser-evoked displacement (nm)')
title('Displacement v. Distance from laser beam, 7/21/15 HB3')

subplot(2,1,2)
for i = 25:31
   plot(record(i).distance,record(i).corr_delta,'.','Markersize',24)
   hold all
end
axis([-2 30 0 80])
xlabel(' Distance from laser (um)')
ylabel('CORRECTED Laser-evoked displacement (nm)')

%% HB1 - Calculate what % of maximum amplitude each event represents, then plot it
for i = [3 2 4 6 8 10]
   record(i).corr_delta_percent = record(i).corr_delta / record(3).corr_delta; 
end

clf
subplot(2,1,1)
for i = [3 2 4 6 8 10]
   plot(record(i).distance , record(i).corr_delta_percent ,'.k','Markersize',24)
   hold all
end
%axis([-5 16 0 1.1])

%% HB2 - Calculate what % of maximum amplitude each event represents, then plot it
for i = [18:24]
   record(i).corr_delta_percent = record(i).corr_delta / record(18).corr_delta; 
end

clf
subplot(2,1,1)
for i = [18 19 21 23]
   plot(record(i).distance , record(i).corr_delta_percent ,'.k','Markersize',24)
   hold all
end
%axis([-5 16 0 1.1])


%% HB3 - Calculate what % of maximum amplitude each event represents, then plot it
clf
for i = [25:31]
   record(i).corr_delta_percent = record(i).corr_delta / record(25).corr_delta; 
end

subplot(2,1,2)
for i = [25 26 28 30]
   plot(record(i).distance , record(i).corr_delta_percent ,'.k','Markersize',24)
   hold all
end

%% Plot corrected delta percents for all three bundles
clf
subplot(4,1,2:3)
for i = [3 2 4 6 8 10]
   h1 = plot(record(i).distance , record(i).corr_delta_percent ,'.r','Markersize',24);
   hold all
end

for i = [18 19 21 23]
   h2 = plot(record(i).distance , record(i).corr_delta_percent ,'.g','Markersize',24);
   hold all
end

for i = [25 26 28 30]
   h3 = plot(record(i).distance , record(i).corr_delta_percent ,'.b','Markersize',24);
   hold all
end
%axis([-5 35 0 1.6])
legend([h1 h2 h3],'HB1','HB2','HB3','location','NorthEast')
title('Fraction of initial displacement v. Distance')
xlabel('Distance (um)')
ylabel('Fraction of initial displacement')

%% Put the normalized data for all 3 bundles in one variable, so I can combine it with 7/9/15
clf
counter = 1;
for i = [3 2 4 6 8 10 18 19 21 23 25 26 28 30]
    aggregate_data(counter,1) = record(i).distance;
    aggregate_data(counter,2) = record(i).corr_delta_percent;
    counter = counter + 1;
end

plot(aggregate_data(:,1),aggregate_data(:,2),'.k','markersize',24)











