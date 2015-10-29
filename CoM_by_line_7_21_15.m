% Open movie files,ask user to select bundle of interest in each, get
% displacement waveform 
 clear;clc;clf
cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/7_21_15/')

%% Calculate CoM, CoM_avg, xpos, ypos, delta
% NOTE: First run the script Import_subframe_dimensions on data I wish to
% analyze. This will prompt the user to create regions of interest around
% the bundle, and to select the center point to be used in the analysis.
% The appropriate coordinates are saved by that script and loaded below, so
% that the coordinates only need to be gathered once.
tic
% Load subframe position and click coordinates gotten from previous script
load('Record_coordinates.mat');
for r = 1:31
    clear subframe
    % *** Import movie ***
    eval(['mov = aviread(''Event' num2str(r) '.avi'');']);
    
    % *** Crop every frame using the dimensions gotten from the loaded record structure ***
    for i = 1:size(mov,2)       
        eval(['subframe(:,:,' num2str(i) ') = imcrop(mov(1,i).cdata,record(r).rect_rounded);']);
    end
    
    for i = 1:size(mov,2)       
        subframe(:,:,i) = imcrop(mov(1,i).cdata,record(r).rect_rounded);
    end
    
    
    % *** Use the coordinates of the click to get a CoM for 9 horizontal
    % lines for each frame (3 above, 3 below, and the line that was
    % clicked) ***
    record(r).CoM = zeros(1,size(mov,2));
    for i = 1:size(mov,2)           % The i steps through the frames
        CoM = zeros(9,1);
        CoM(1) = linear_CoM(subframe(record(r).y_click-3, record(r).x_click-6:record(r).x_click+6,i), 1*mean(subframe(record(r).y_click-3, record(r).x_click-6:record(r).x_click+6,i)));
        CoM(2) = linear_CoM(subframe(record(r).y_click-2, record(r).x_click-6:record(r).x_click+6,i), 1*mean(subframe(record(r).y_click-2, record(r).x_click-6:record(r).x_click+6,i)));
        CoM(3) = linear_CoM(subframe(record(r).y_click-1, record(r).x_click-6:record(r).x_click+6,i), 1*mean(subframe(record(r).y_click-1, record(r).x_click-6:record(r).x_click+6,i)));
        CoM(4) = linear_CoM(subframe(record(r).y_click  , record(r).x_click-6:record(r).x_click+6,i), 1*mean(subframe(record(r).y_click  , record(r).x_click-6:record(r).x_click+6,i)));
        CoM(5) = linear_CoM(subframe(record(r).y_click+1, record(r).x_click-6:record(r).x_click+6,i), 1*mean(subframe(record(r).y_click+1, record(r).x_click-6:record(r).x_click+6,i)));
        CoM(6) = linear_CoM(subframe(record(r).y_click+2, record(r).x_click-6:record(r).x_click+6,i), 1*mean(subframe(record(r).y_click+2, record(r).x_click-6:record(r).x_click+6,i)));
        CoM(7) = linear_CoM(subframe(record(r).y_click+3, record(r).x_click-6:record(r).x_click+6,i), 1*mean(subframe(record(r).y_click+3, record(r).x_click-6:record(r).x_click+6,i)));
        CoM(8) = linear_CoM(subframe(record(r).y_click+4, record(r).x_click-6:record(r).x_click+6,i), 1*mean(subframe(record(r).y_click+4, record(r).x_click-6:record(r).x_click+6,i)));
        CoM(9) = linear_CoM(subframe(record(r).y_click-4, record(r).x_click-6:record(r).x_click+6,i), 1*mean(subframe(record(r).y_click-4, record(r).x_click-6:record(r).x_click+6,i)));

        CoM_vert(1) = linear_CoM(subframe(record(r).x_click-3, record(r).y_click-6:record(r).y_click+6,i), 1*mean(subframe(record(r).y_click-3, record(r).x_click-6:record(r).x_click+6,i)));
        CoM_vert(2) = linear_CoM(subframe(record(r).x_click-2, record(r).y_click-6:record(r).y_click+6,i), 1*mean(subframe(record(r).y_click-2, record(r).x_click-6:record(r).x_click+6,i)));
        CoM_vert(3) = linear_CoM(subframe(record(r).x_click-1, record(r).y_click-6:record(r).y_click+6,i), 1*mean(subframe(record(r).y_click-1, record(r).x_click-6:record(r).x_click+6,i)));
        CoM_vert(4) = linear_CoM(subframe(record(r).x_click, record(r).y_click-6:record(r).y_click+6,i), 1*mean(subframe(record(r).y_click, record(r).x_click-6:record(r).x_click+6,i)));
        CoM_vert(5) = linear_CoM(subframe(record(r).x_click+1, record(r).y_click-6:record(r).y_click+6,i), 1*mean(subframe(record(r).y_click+1, record(r).x_click-6:record(r).x_click+6,i)));
        CoM_vert(6) = linear_CoM(subframe(record(r).x_click+2, record(r).y_click-6:record(r).y_click+6,i), 1*mean(subframe(record(r).y_click+2, record(r).x_click-6:record(r).x_click+6,i)));
        CoM_vert(7) = linear_CoM(subframe(record(r).x_click+3, record(r).y_click-6:record(r).y_click+6,i), 1*mean(subframe(record(r).y_click+3, record(r).x_click-6:record(r).x_click+6,i)));
        
        record(r).standev(i) = std(CoM);        % Store stdev before removing CoM's outside 2*SD
        % Don't include CoM values that are outside of 2 std dev from the mean
        CoM(CoM > mean(CoM) + 2*std(CoM)) = NaN;
        CoM(CoM < mean(CoM) - 2*std(CoM)) = NaN;
        record(r).CoM(i) = nanmean(CoM);        % Average the centers of mass that are within 2 stdev
        record(r).standev_post(i) = std(CoM);   % Std Dev after removing any CoM's outside 2*SD
        
        record(r).standev_vert(i) = std(CoM_vert);        % Store stdev before removing CoM's outside 2*SD
        % Don't include CoM values that are outside of 2 std dev from the mean
        CoM_vert(CoM_vert > mean(CoM_vert) + 2*std(CoM_vert)) = NaN;
        CoM_vert(CoM_vert < mean(CoM_vert) - 2*std(CoM_vert)) = NaN;
        record(r).CoM_vert(i) = nanmean(CoM_vert);        % Average the centers of mass that are within 2 stdev
        record(r).standev_vert_post(i) = std(CoM_vert);   % Std Dev after removing any CoM's outside 2*SD
        
    end
    
    % *** Median filtering
    record(r).CoM = medfilt1(record(r).CoM, 5);
    record(r).CoM_vert = medfilt1(record(r).CoM_vert, 5);
    
    % *** Average the 20 repeats of the stimulus to get a cleaner trace ***
    x1 = record(r).CoM(1:200);
    x2 = record(r).CoM(201:400);
    x3 = record(r).CoM(401:600);
    x4 = record(r).CoM(601:800);
    x5 = record(r).CoM(801:1000);
    x6 = record(r).CoM(1001:1200);
    x7 = record(r).CoM(1201:1400);
    x8 = record(r).CoM(1401:1600);
    x9 = record(r).CoM(1601:1800);
    x10 = record(r).CoM(1801:2000);
    x11 = record(r).CoM(2001:2200);
    x12 = record(r).CoM(2201:2400);
    x13 = record(r).CoM(2401:2600);
    x14 = record(r).CoM(2601:2800);
    x15 = record(r).CoM(2801:3000);
    x16 = record(r).CoM(3001:3200);
    x17 = record(r).CoM(3201:3400);
    x18 = record(r).CoM(3401:3600);
    x19 = record(r).CoM(3601:3800);
    x20 = record(r).CoM(3801:4000);
    x_average = (x1+x2+x3+x4+x5+x6+x7+x8+x9+x10+x11+x12+x13+x14+x15+x16+x17+x18+x19+x20) / 20; 
    baseline = mean(x_average(5:50));
    x_displ = x_average - baseline;   % subtract baseline
    record(r).CoM_avg = x_displ * (50/138);   % Save the average displacement, in um (50 um/ 138 pi)
    
    % *** Average the 20 repeats of the stimulus to get a cleaner trace (vertical displ) ***
    y1 = record(r).CoM_vert(1:200);
    y2 = record(r).CoM_vert(201:400);
    y3 = record(r).CoM_vert(401:600);
    y4 = record(r).CoM_vert(601:800);
    y5 = record(r).CoM_vert(801:1000);
    y6 = record(r).CoM_vert(1001:1200);
    y7 = record(r).CoM_vert(1201:1400);
    y8 = record(r).CoM_vert(1401:1600);
    y9 = record(r).CoM_vert(1601:1800);
    y10 = record(r).CoM_vert(1801:2000);
    y11 = record(r).CoM_vert(2001:2200);
    y12 = record(r).CoM_vert(2201:2400);
    y13 = record(r).CoM_vert(2401:2600);
    y14 = record(r).CoM_vert(2601:2800);
    y15 = record(r).CoM_vert(2801:3000);
    y16 = record(r).CoM_vert(3001:3200);
    y17 = record(r).CoM_vert(3201:3400);
    y18 = record(r).CoM_vert(3401:3600);
    y19 = record(r).CoM_vert(3601:3800);
    y20 = record(r).CoM_vert(3801:4000);
    y_average           = (y1+y2+y3+y4+y5+y6+y7+y8+y9+y10+y11+y12+y13+y14+y15+y16+y17+y18+y19+y20) / 20; 
    baseline            = mean(y_average(5:50));
    y_displ             = y_average - baseline;   % subtract baseline
    record(r).CoM_vert_avg   = y_displ * (50/138);   % Save the average displacement, in um (50 um/ 138 pi)
    record(r).CoM_vert_pixels= y_average + rect(2);

    % *** Obtain and store the position of the bundle ***
    record(r).xpos = record(r).rect(1) + x_average(1,1);     % Store the HB's x position, in pixels
    record(r).ypos = record(r).rect(2) + record(r).y_click;
    % Create a distance field with the current HB's distance from laser in um
    record(r).distance = (abs(record(1).xpos - record(r).xpos)) * (50/138) ; 
    
    pre  = mean(record(r).CoM_avg(5:60));
    step = mean(record(r).CoM_avg(100:140));
    post = mean(record(r).CoM_avg(160:200));
    delta= abs(step - mean([pre post])) ; % Calculate delta size, convert to nm
    record(r).delta = delta;
end
toc

%% Plot each event, offset by its distance from the first one, HB1
for r = 2:17
    plot(record(1).time,record(r).CoM_avg + record(r).distance)
    hold on
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
ylabel('um')
title('HB1 - Amplitudes of records in center of beam v. Event number')

p_HB1 = polyfit(event_HB1, delta_HB1,1);    % Fit a linear polynomial 
xl = xlim;
x_fit = linspace(xl(1),xl(2),100);
y_fit = polyval(p_HB1,x_fit);
h1 = plot(x_fit,y_fit);
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

saveas(gcf,strcat('Decay_Correction_7_21_15_HB1','fig'));
saveas(gcf,strcat('Decay_Correction_7_21_15_HB1','eps'),'epsc');

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
axis([0 8 0 0.08])
ylabel('um')
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
ylabel('Displacement (um)')
title('HB2 - Displacements within beam, corrected for decay')
axis([0 8 0 0.08])
legend([h1 h2], 'Original','Corrected','location','SouthWest')

saveas(gcf,strcat('Decay_Correction_7_21_15_HB2','fig'));
saveas(gcf,strcat('Decay_Correction_7_21_15_HB2','eps'),'epsc');

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
axis([0 8  0 0.08])
ylabel('um')
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
ylabel('Displacement (um)')
title('HB3 - Displacements within beam, corrected for decay')
axis([0 8 0 0.08])
legend([h1 h2], 'Original','Corrected','location','NorthEast')

saveas(gcf,strcat('Decay_Correction_7_21_15_HB3','fig'));
saveas(gcf,strcat('Decay_Correction_7_21_15_HB3','eps'),'epsc');

%% HB1 - Plot both corrected and uncorrected delta against distance from laser
clf
set(0, 'DefaultAxesColorOrder', ametrine(12));
subplot(2,1,1)
for i = 1:13
   plot(record(i).distance,record(i).delta*1000,'.','Markersize',24)
   hold all
end
axis([-5 60 0 350])
ylabel('Laser-evoked displacement (nm)')
title('Displacement v. Distance from laser beam, 7/21/15 HB1')

subplot(2,1,2)
for i = 1:12
   plot(record(i).distance,record(i).corr_delta*1000,'.','Markersize',24)
   hold all
end
axis([-5 60 0 350])
xlabel(' Distance from laser (um)')
ylabel('CORRECTED Laser-evoked displacement (nm)')

saveas(gcf,strcat('Decay_Corrected_v_Uncorrected_7_21_15_HB1','fig'));
saveas(gcf,strcat('Decay_Corrected_v_Uncorrected_7_21_15_HB1','eps'),'epsc');

%% HB2 - Plot both corrected and uncorrected delta against distance from laser
clf
set(0, 'DefaultAxesColorOrder', ametrine(7));
subplot(2,1,1)
for i = 18:24
   plot(record(i).distance,record(i).delta*1000,'.','Markersize',24)
   hold all
end
axis([-5 20 0 80])
ylabel('Laser-evoked displacement (nm)')
title('Displacement v. Distance from laser beam, 7/21/15 HB2')

subplot(2,1,2)
for i = 18:24
   plot(record(i).distance,record(i).corr_delta*1000,'.','Markersize',24)
   hold all
end
axis([-5 20 0 80])
xlabel(' Distance from laser (um)')
ylabel('CORRECTED Laser-evoked displacement (nm)')

saveas(gcf,strcat('Decay_Corrected_v_Uncorrected_7_21_15_HB2','fig'));
saveas(gcf,strcat('Decay_Corrected_v_Uncorrected_7_21_15_HB2','eps'),'epsc');

%% HB3 - Plot both corrected and uncorrected delta against distance from laser
% Didn't plot the last 3 runs because there was almost no mvt, and lots of
% error
clf
set(0, 'DefaultAxesColorOrder', ametrine(7));
subplot(2,1,1)
for i = 25:31
   plot(record(i).distance,record(i).delta*1000,'.','Markersize',24)
   hold all
end
axis([-2 30 0 60])
ylabel('Laser-evoked displacement (nm)')
title('Displacement v. Distance from laser beam, 7/21/15 HB3')

subplot(2,1,2)
for i = 25:31
   plot(record(i).distance,record(i).corr_delta*1000,'.','Markersize',24)
   hold all
end
axis([-2 30 0 60])
xlabel(' Distance from laser (um)')
ylabel('CORRECTED Laser-evoked displacement (nm)')

saveas(gcf,strcat('Decay_Corrected_v_Uncorrected_7_21_15_HB3','fig'));
saveas(gcf,strcat('Decay_Corrected_v_Uncorrected_7_21_15_HB3','eps'),'epsc');

%% HB1 - Calculate what % of maximum amplitude each event represents, then plot it
for i = [3 2 4 6 8 10]
   record(i).corr_delta_percent = record(i).corr_delta / record(3).corr_delta; 
end
subplot(3,1,1)
for i = [3 2 4 6 8 10]
   plot(record(i).distance , record(i).corr_delta_percent ,'.k','Markersize',24)
   hold all
end
%axis([-5 16 0 1.1])

% HB2 - Calculate what % of maximum amplitude each event represents, then plot it
for i = [18:24]
   record(i).corr_delta_percent = record(i).corr_delta / record(18).corr_delta; 
end
subplot(3,1,2)
for i = [18 19 21 23]
   plot(record(i).distance , record(i).corr_delta_percent ,'.k','Markersize',24)
   hold all
end
%axis([-5 16 0 1.1])

% HB3 - Calculate what % of maximum amplitude each event represents, then plot it
for i = [25:31]
   record(i).corr_delta_percent = record(i).corr_delta / record(25).corr_delta; 
end
subplot(3,1,3)
for i = [25 26 28 30]
   plot(record(i).distance , record(i).corr_delta_percent ,'.k','Markersize',24)
   hold all
end

%% Plot corrected delta percents for all three bundles
clf
subplot(4,1,2:3)
for i = [3 2 4 6 8]
   h1 = plot(record(i).distance , record(i).corr_delta_percent ,'.','color',[0 0.9 0],'Markersize',24);
   hold all
end

for i = [18 19 21 23]
   h2 = plot(record(i).distance , record(i).corr_delta_percent ,'.','color',[0 0.4 1],'Markersize',24);
   hold all
end

for i = [25 26 28 30]
   h3 = plot(record(i).distance , record(i).corr_delta_percent ,'.','color',[0.6 0 1],'Markersize',24);
   hold all
end
axis([0 50 0 1.2])
legend([h1 h2 h3],'HB1','HB2','HB3','location','NorthEast')
title('7/21/15 - Fraction of initial displacement v. Distance')
xlabel('Distance (um)')
ylabel('Fraction of initial displacement')

saveas(gcf,strcat('Normalized_Displacements_7_21_15_HBs1_2_3','fig'));
saveas(gcf,strcat('Normalized_Displacements_7_21_15_HBs1_2_3','eps'),'epsc');

%% Overlay to look at kinetics - HB1
clf
subplot(2,1,1)
set(0, 'DefaultAxesColorOrder', ametrine(5));
h1 = plot(record(3).time(5:end), record(3).CoM_avg(5:end)/max(record(3).CoM_avg(10:end)),'linewidth',2);
hold all
h2 = plot(record(2).time(5:end), record(2).CoM_avg(5:end)/max(record(2).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(4).time(5:end), record(4).CoM_avg(5:end)/max(record(4).CoM_avg(10:end)),'linewidth',2);
h4 = plot(record(6).time(5:end), record(6).CoM_avg(5:end)/max(record(6).CoM_avg(10:end)),'linewidth',2);
h5 = plot(record(8).time(5:end), record(8).CoM_avg(5:end)/max(record(8).CoM_avg(10:end)),'linewidth',2);
%h6 = plot(record(10).time(5:end), record(10).CoM_avg(5:end)/max(record(10).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3 h4 h5], ...
sprintf('%d um, %d nm', round(record(3).distance), round(record(3).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(2).distance), round(record(2).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(4).distance), round(record(4).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(6).distance), round(record(6).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(8).distance), round(record(8).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(10).distance), round(record(10).corr_delta*1000)),...
'location','northwest');
%legend([h1 h2 h3 h4 h5 h6], sprintf('%d um', round(record(3).distance)),sprintf('%d um', round(record(2).distance)),sprintf('%d um', round(record(4).distance)),sprintf('%d um', round(record(6).distance)),sprintf('%d um', round(record(8).distance)),'location','northwest')
title('7/21/15 - HB1')
axis([0 100 -0.4 1.2])

subplot(2,1,2)
set(0, 'DefaultAxesColorOrder', ametrine(5));
h1 = plot(record(3).time(5:end), record(3).CoM_avg(5:end)/max(record(3).CoM_avg(10:end)),'linewidth',2);
    hold all
h2 = plot(record(5).time(5:end), record(5).CoM_avg(5:end)/max(record(5).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(7).time(5:end), record(7).CoM_avg(5:end)/max(record(7).CoM_avg(10:end)),'linewidth',2);
h4 = plot(record(9).time(5:end), record(9).CoM_avg(5:end)/max(record(9).CoM_avg(10:end)),'linewidth',2);
h5 = plot(record(11).time(5:end), record(11).CoM_avg(5:end)/max(record(11).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3 h4 h5], ...
sprintf('%d um, %d nm', round(record(3).distance), round(record(3).corr_delta*1000)), ...
sprintf('%d um, %d nm', round(record(5).distance), round(record(5).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(7).distance), round(record(7).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(9).distance), round(record(9).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(11).distance), round(record(11).corr_delta*1000)),...
'location','northwest');
xlabel('Time (ms)')
axis([0 100 -0.4 1.2])

saveas(gcf,strcat('Overlaid_Kinetics_7_21_15_HB1','fig'));
saveas(gcf,strcat('Overlaid_Kinetics_7_21_15_HB1','eps'),'epsc');

%% Overlay to look at kinetics - HB2
clf
subplot(2,1,1)
set(0, 'DefaultAxesColorOrder', ametrine(4));
h1 = plot(record(18).time(5:end), record(18).CoM_avg(5:end)/max(record(18).CoM_avg(10:end)),'linewidth',2);
hold all
h2 = plot(record(19).time(5:end), record(19).CoM_avg(5:end)/max(record(19).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(21).time(5:end), record(21).CoM_avg(5:end)/max(record(21).CoM_avg(10:end)),'linewidth',2);
h4 = plot(record(23).time(5:end), record(23).CoM_avg(5:end)/max(record(23).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3 h4], ...
sprintf('%d um, %d nm', round(record(18).distance), round(record(18).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(19).distance), round(record(19).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(21).distance), round(record(21).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(23).distance), round(record(23).corr_delta*1000)),...
'location','northwest');
title('7/21/15 - HB2')
axis([0 100 -0.4 1.2])

subplot(2,1,2)
h1 = plot(record(18).time(5:end), record(18).CoM_avg(5:end)/max(record(18).CoM_avg(10:end)),'linewidth',2);
    hold all
h2 = plot(record(20).time(5:end), record(20).CoM_avg(5:end)/max(record(20).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(22).time(5:end), record(22).CoM_avg(5:end)/max(record(22).CoM_avg(10:end)),'linewidth',2);
h4 = plot(record(24).time(5:end), record(24).CoM_avg(5:end)/max(record(24).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3 h4], ...
sprintf('%d um, %d nm', round(record(18).distance), round(record(18).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(20).distance), round(record(20).corr_delta*1000)), ...
sprintf('%d um, %d nm', round(record(22).distance), round(record(22).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(24).distance), round(record(24).corr_delta*1000)),...
'location','northwest');
xlabel('Time (ms)')
axis([0 100 -0.4 1.2])

saveas(gcf,strcat('Overlaid_Kinetics_7_21_15_HB2','fig'));
saveas(gcf,strcat('Overlaid_Kinetics_7_21_15_HB2','eps'),'epsc');

%% Overlay to look at kinetics - HB3
clf
subplot(2,1,1)
set(0, 'DefaultAxesColorOrder', ametrine(4));
h1 = plot(record(25).time(5:end), -record(25).CoM_avg(5:end)/max(-record(25).CoM_avg(10:end)),'linewidth',2);
hold all
h2 = plot(record(26).time(5:end), -record(26).CoM_avg(5:end)/max(-record(26).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(28).time(5:end), -record(28).CoM_avg(5:end)/max(-record(28).CoM_avg(10:end)),'linewidth',2);
h4 = plot(record(30).time(5:end), -record(30).CoM_avg(5:end)/max(-record(30).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3 h4], ...
sprintf('%d um, %d nm', round(record(25).distance), round(record(25).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(26).distance), round(record(26).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(28).distance), round(record(28).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(30).distance), round(record(30).corr_delta*1000)),...
'location','northwest');
title('7/21/15 - HB3')
axis([0 100 -0.4 1.2])

subplot(2,1,2)
h1 = plot(record(25).time(5:end), -record(25).CoM_avg(5:end)/max(-record(25).CoM_avg(10:end)),'linewidth',2);
    hold all
h2 = plot(record(27).time(5:end), -record(27).CoM_avg(5:end)/max(-record(27).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(29).time(5:end), -record(29).CoM_avg(5:end)/max(-record(29).CoM_avg(10:end)),'linewidth',2);
h4 = plot(record(31).time(5:end), -record(31).CoM_avg(5:end)/max(-record(31).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3 h4], ...
sprintf('%d um, %d nm', round(record(25).distance), round(record(25).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(27).distance), round(record(27).corr_delta*1000)), ...
sprintf('%d um, %d nm', round(record(29).distance), round(record(29).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(31).distance), round(record(31).corr_delta*1000)),...
'location','northwest');
xlabel('Time (ms)')
axis([0 100 -0.4 1.2])

saveas(gcf,strcat('Overlaid_Kinetics_7_21_15_HB3','fig'));
saveas(gcf,strcat('Overlaid_Kinetics_7_21_15_HB3','eps'),'epsc');

%% Put the normalized data for all 3 bundles in one variable, so I can combine it with 7/9/15
clf
counter = 1;
for i = [3 2 4 6 8 18 19 21 23 25 26 28 30]
    aggregate_data(counter,1) = record(i).distance;
    aggregate_data(counter,2) = record(i).corr_delta_percent;
    counter = counter + 1;
end

plot(aggregate_data(:,1),aggregate_data(:,2),'.k','markersize',24)












 % %% Test the CoM calculation, plot each line's CoM on top of HB image
    % image(subframe(:,:,1))
    % hold on
    % plot(CoM(1),y_click-3,'xr','markersize',10)
    % plot(CoM(2),y_click-2,'xr','markersize',10)
    % plot(CoM(3),y_click-1,'xr','markersize',10)
    % plot(CoM(4),y_click,'xr','markersize',10)
    % plot(CoM(5),y_click+1,'xr','markersize',10)
    % plot(CoM(6),y_click+2,'xr','markersize',10)
    % plot(CoM(7),y_click+3,'xr','markersize',10)