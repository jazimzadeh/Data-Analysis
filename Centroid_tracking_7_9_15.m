% Open movie files,ask user to select bundle of interest in each, get
% displacement waveform 
% clear;clc;
cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/7_9_15/')

for r = 3:27;
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


%% Make a new field containing each bundle's X distance from bundle 15, in um
% Get a pixel to um calibration factor
%mov = aviread('Event1.avi');
%imagesc(mov(1,1).cdata);
% there are 138 pixels in 50 um, so the factor is 50/138 um/pixel

for i = 3:27
   record(i).distance = (abs(record(15).xpos - record(i).xpos)) * (50/138) ; 
end

%% Plot all the displacements, offset by run number
clf
offset = 0;
for i = 3:27
    plot(record(i).time, -record(i).displacement + offset, 'k');
    offset = offset + 0.9;
    hold on
end

%% Plot just the good displacements, HB2
clf

set(0, 'DefaultAxesColorOrder', ametrine(6));
for i = 8:14
    plot(record(i).time, -record(i).displacement + record(i).distance);
    hold all
end
xlabel('Time (ms)')
ylabel('Distance and Displacement (um)')
axis([0 100 -1 16])
title('7/9/15 - 2 kHz videos - HB motion vs. Distance, HB2')

%% Plot just the good displacements, HB3
clf

set(0, 'DefaultAxesColorOrder', ametrine(9));
for i = 15:23
    plot(record(i).time, -record(i).displacement + record(i).distance);
    hold all
end
xlabel('Time (ms)')
ylabel('Distance and Displacement (um)')
axis([0 100 -1 22])
title('7/9/15 - 2 kHz videos - HB motion vs. Distance, HB3')

%% Compare the kinetics of laser-evoked displacements as function of distance - HB3
for i = 15:23
   maximum =  max(abs(record(i).displacement));     % Calculate the maximum displacement in that trace
   record(i).displacement_norm = abs(record(i).displacement)./maximum;
end
%% Overlay the recording from the center and the three to the left - HB3
clf
%figure('color',[1 1 1 ])
h1 = plot(record(15).time, record(15).displacement_norm,'color',[0 0 0]);    % center
hold on
h2 = plot(record(16).time, record(16).displacement_norm,'color',[0 0.9 0.3]);
h3 = plot(record(18).time, record(18).displacement_norm,'color',[0 0.6 0.8]);
h4 = plot(record(20).time, record(20).displacement_norm,'color',[0 0.3 1]);
set([h1 h2 h3 h4],'LineWidth',2)
%set(gca,'color',[0.5 0.5 0.5])
legend([h1 h2 h3 h4],   sprintf('%d um, Rec 15',round(record(15).distance)), sprintf('%d um',round(record(16).distance)), sprintf('%d um',round(record(18).distance)),sprintf('%d um',round(record(20).distance)),'location','NorthWest')
axis([0 100 -0.05 1.05])
xlabel('Time (ms)')
ylabel('Displacement (fraction of maximum)')
title('7/9/15 - HB3')

%% Overlay the recordings from the center - HB3
clf
%figure('color',[1 1 1 ])
h1 = plot(record(15).time, record(15).displacement_norm,'color',[0 0 0]);    % center
hold on
h2 = plot(record(17).time, record(17).displacement_norm,'color',[1 0.1 0.1]);
h3 = plot(record(19).time, record(19).displacement_norm,'color',[0.8 0.1 0.1]);
h4 = plot(record(21).time, record(21).displacement_norm,'color',[0.6 0.1 0.1]);
set([h1 h2 h3 h4],'LineWidth',2)
%set(gca,'color',[0.5 0.5 0.5])
legend([h1 h2 h3 h4],   sprintf('%d um, Rec 15',round(record(15).distance)), sprintf('%d um, Rec 17',round(record(17).distance)), sprintf('%d um, Rec 19',round(record(19).distance)),sprintf('%d um, Rec 21',round(record(21).distance)),'location','NorthWest')
axis([0 100 -0.05 1.05])
xlabel('Time (ms)')
ylabel('Displacement (fraction of maximum)')
title('7/9/15 - HB3')


%% Calculate the amplitude of the laser evoked step, store as "delta"
for i = 3:27
    pre  = mean(record(i).displacement(1:60));
    step = mean(record(i).displacement(100:140));
    post = mean(record(i).displacement(160:200));
    delta= abs(step - mean([pre post])) * (50000/138); % Calculate delta size, convert to nm
    record(i).delta = delta;
end


%% Plot decay of response as a function of event number, HB2
clf
counter = 1;
subplot(4,1,2:3)
for i = [8 10 12 14]        % these are the events in which the bundle was in the laser beam
    event_HB2(counter) = i-7;
    delta_HB2(counter) = record(i).delta;
    counter = counter + 1;
    plot(i-7, record(i).delta,'.','MarkerSize',24);
    hold on
end
axis([0 8 30 80])
ylabel('nm')
xlabel('Event number')
title('HB2 - Amplitudes of records in center of beam v. Event number')

p_HB2 = polyfit(event_HB2, delta_HB2,1);    % Fit a linear polynomial 
xl = xlim;
x_fit = linspace(xl(1),xl(2),100);
y_fit = polyval(p_HB2,x_fit);
plot(x_fit,y_fit)
legend(['slope = ' num2str(p_HB2(1)) ])


%% Plot decay of response as a function of event number, HB3
clf
clear delta_HB3;
clear event_HB3;
counter = 1;
subplot(4,1,2:3)
for i = [15 17 19 21 23 25]  % removed record 27 from the list
    event_HB3(counter) = i-14;
    delta_HB3(counter) = record(i).delta;
    counter = counter + 1;
    plot(i-14, record(i).delta,'.','MarkerSize',24);
    hold on
end
axis([0 14  -50 300])
ylabel('nm')
xlabel('Event number')
title('HB3 - Amplitudes of records in center of beam v. Event number')

p_HB3 = polyfit(event_HB3, delta_HB3,1);    % Fit a linear polynomial 
xl = xlim;
x_fit = linspace(xl(1),xl(2),100);
y_fit = polyval(p_HB3,x_fit);
plot(x_fit,y_fit)
legend(['slope = ' num2str(p_HB3(1)) ])

%% HB2 - Now that we have the decay equation we correct each of the displacements with it.
clf
for i = 8:14
    decayed = p_HB2(1) * (i-7) + p_HB2(2);
    c_factor = decayed/record(8).delta;
    record(i).corr_delta = record(i).delta/c_factor;    % Create a corr_delta field in each record, with the corrected amplitude
end

subplot(4,1,2:3)
for i = [8 10 12 14]        % these are the events in which the bundle was in the laser beam
    h1 = plot(i-7, record(i).delta,'k.','MarkerSize',24);
    hold on
    h2 = plot(i-7, record(i).corr_delta,'r.','MarkerSize',24);
end
xlabel('Event #')
ylabel('Displacement (nm)')
title('HB2 - Displacements within beam, corrected for decay')
axis([0 8 0 90])
legend([h1 h2], 'Original','Corrected','location','SouthWest')

%% HB3 - Now that we have the decay equation we correct each of the displacements with it.
clf
for i = 15:27
    decayed = p_HB3(1) * (i-14) + p_HB3(2);
    c_factor = decayed/record(15).delta;        % compare the values gotten fit to the original (non-decayed) to get correction factor
    record(i).corr_delta = record(i).delta/c_factor;
end
subplot(4,1,2:3)
for i = [15:2:27]        % these are the events in which the bundle was in the laser beam
    h1 = plot(i-14, record(i).delta,'k.','MarkerSize',24);
    hold on
    h2 = plot(i-14, record(i).corr_delta,'r.','MarkerSize',24);
end
xlabel('Event #')
ylabel('Displacement (nm)')
title('HB3 - Displacements within beam, corrected for decay')
%axis([0 14 0 80])
legend([h1 h2], 'Original','Corrected','location','SouthWest')

%% HB2 - Plot both corrected and uncorrected delta against distance from laser
clf
set(0, 'DefaultAxesColorOrder', ametrine(7));
subplot(2,1,1)
for i = 8:14
   plot(record(i).distance,record(i).delta,'.','Markersize',24)
   hold all
end
axis([-5 25 0 100])
ylabel('Laser-evoked displacement (nm)')
title('Displacement v. Distance from laser beam, 7/9/15 HB2')

subplot(2,1,2)
for i = 8:14
   plot(record(i).distance,record(i).corr_delta,'.','Markersize',24)
   hold all
end
axis([-5 25 0 100])
xlabel(' Distance from laser (um)')
ylabel('CORRECTED Laser-evoked displacement (nm)')

%% HB3 - Plot both corrected and uncorrected delta against distance from laser
% Didn't plot the last 3 runs because there was almost no mvt, and lots of
% error
clf
set(0, 'DefaultAxesColorOrder', ametrine(10));
subplot(2,1,1)
for i = 15:24
   plot(record(i).distance,record(i).delta,'.','Markersize',24)
   hold all
end
axis([-5 35 -250 400])
ylabel('Laser-evoked displacement (nm)')
title('Displacement v. Distance from laser beam, 7/9/15 HB3')

subplot(2,1,2)
for i = 15:24
   plot(record(i).distance,record(i).corr_delta,'.','Markersize',24)
   hold all
end
axis([-5 35 -250 400])
xlabel(' Distance from laser (um)')
ylabel('CORRECTED Laser-evoked displacement (nm)')

%% HB2 - Calculate what % of maximum amplitude each event represents, then plot it
for i = [8 9 11 13]
   record(i).corr_delta_percent = record(i).corr_delta / record(8).corr_delta; 
end

clf
subplot(2,1,1)
for i = [8 9 11 13]
   plot(record(i).distance , record(i).corr_delta_percent ,'.k','Markersize',24)
   hold all
end
axis([-5 16 0 1.1])

%% HB3 - Calculate what % of maximum amplitude each event represents, then plot it
for i = [15 [16:2:24]]
   record(i).corr_delta_percent = record(i).corr_delta / record(15).corr_delta; 
end

subplot(2,1,2)
for i = [15 [16:2:24]]
   plot(record(i).distance , record(i).corr_delta_percent ,'.k','Markersize',24)
   hold all
end

%% Plot corrected delta percents for both bundles
clf
subplot(4,1,2:3)
for i = [8 9 11 13]
   h1 = plot(record(i).distance , record(i).corr_delta_percent ,'.k','Markersize',24);
   hold all
end

for i = [15 [16:2:24]]
   h2 = plot(record(i).distance , record(i).corr_delta_percent ,'.r','Markersize',24);
   hold all
end
axis([-5 35 0 1.6])
legend([h1 h2],'HB2','HB3','location','SouthEast')
title('Fraction of initial displacement v. Distance')
xlabel('Distance (um)')
ylabel('Fraction of initial displacement')

%% Aggregate the data
clf
counter = 1;
for i = [8 9 11 13 15 16 18 20 22 24]
    aggregate_data(counter,1) = record(i).distance;
    aggregate_data(counter,2) = record(i).corr_delta_percent;
    counter = counter + 1;
end

plot(aggregate_data(:,1),aggregate_data(:,2),'.k','markersize',24)

%% Here I combine the values from above with those from 7/21
% Order:
% 7/21 HB1 - first 6 rows
% 7/21 HB2 - next 4 rows
% 7/21 HB3 - next 4 rows
% 7/9 HB2  - next 4 rows
% 7/9 HB3  - next 6 rows

aggregate = [0.32511646	1
20.46658396	0.075558172
32.18005952	0.087878071
40.20220263	0.045219883
46.54007422	0.076024618
52.31355676	0.100444842
0.116554774	1
10.01771633	1.198181287
13.7699037	0.550417978
16.44506988	0.146223788
1.403985507	1
11.03081272	1.265535125
18.08788201	0.206284536
23.86165691	0.484953459
0.27173913	1
7.800724638	0.598214409
11.47463768	0.554990639
15.00905797	0.674114907
0	1
8.630952381	0.762092184
12.0923913	0.973517446
15.62303088	1.310051157
19.83695652	1.126512213
28.29710145	0.769630823];

clf
subplot(4,1,1:2)
h1 = plot(aggregate(1:6,1),aggregate(1:6,2),'.','markersize',24,'color',[1 0 0.1])
hold on
h2 = plot(aggregate(7:10,1),aggregate(7:10,2),'.',  'markersize',24,'color',[0   0.9  0.1])
h3 = plot(aggregate(11:14,1),aggregate(11:14,2),'.','markersize',24,'color',[0   0.2  0.9])
h4 = plot(aggregate(15:18,1),aggregate(15:18,2),'.','markersize',24,'color',[0.7 0.9  0])
h5 = plot(aggregate(19:24,1),aggregate(19:24,2),'.','markersize',24,'color',[0.6 0.1  0.4])

legend([h1, h2, h3, h4, h5], '7/21/15 HB1','7/21/15 HB2','7/21/15 HB3','7/9/15 HB2','7/9/15 HB3')
title('AGGREGATE - Fraction of displacement at beam center vs. Distance from beam')
ylabel('Fraction of movement')
%xlabel('Distance from beam (um)')

% - Same as above, without 7/9 HB3
subplot(4,1,3:4)
h1 = plot(aggregate(1:6,1),aggregate(1:6,2),'.','markersize',24,'color',[1 0 0.1])
hold on
h2 = plot(aggregate(7:10,1),aggregate(7:10,2),'.',  'markersize',24,'color',[0   0.9  0.1])
h3 = plot(aggregate(11:14,1),aggregate(11:14,2),'.','markersize',24,'color',[0   0.2  0.9])
h4 = plot(aggregate(15:18,1),aggregate(15:18,2),'.','markersize',24,'color',[0.7 0.9  0])
%h5 = plot(aggregate(19:24,1),aggregate(19:24,2),'.','markersize',24,'color',[0.6 0.1  0.4])

legend([h1, h2, h3, h4], '7/21/15 HB1','7/21/15 HB2','7/21/15 HB3','7/9/15 HB2')
%title('AGGREGATE - Fraction of displacement at beam center vs. Distance from beam')
ylabel('Fraction of movement')
xlabel('Distance from beam (um)')

saveas(gcf,strcat('Aggregate_fraction_7_9_16_and_7_21_15','fig'));
saveas(gcf,strcat('Aggregate_fraction_7_9_16_and_7_21_15','eps'),'epsc');












