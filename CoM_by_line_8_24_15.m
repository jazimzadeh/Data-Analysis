% Open movie files,ask user to select bundle of interest in each, get
% displacement waveform 
clear;clc;clf
cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/8_24_15/')
%% Calculate CoM, CoM_avg, xpos, ypos, delta
% NOTE: First run the script Import_subframe_dimensions on data I wish to
% analyze. This will prompt the user to create regions of interest around
% the bundle, and to select the center point to be used in the analysis.
% The appropriate coordinates are saved by that script and loaded below, so
% that the coordinates only need to be gathered once.

tic
% Load subframe position and click coordinates gotten from previous script
% called Find_subframe_dimensions
load('Record_coordinates.mat');

% used
for r = 1:49
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
        
        record(r).standev(i)                = std(CoM);         % Store stdev before removing CoM's outside 2*SD
        % Don't include CoM values that are outside of 2 std dev from the mean
        CoM(CoM > mean(CoM) + 2*std(CoM))   = NaN;
        CoM(CoM < mean(CoM) - 2*std(CoM))   = NaN;
        record(r).CoM(i)                    = nanmean(CoM);     % Average the centers of mass that are within 2 stdev
        record(r).standev_post(i) = std(CoM);                   % Std Dev after removing any CoM's outside 2*SD
        record(r).num_lines(i)              = nansum(sign(CoM));% Count & store the number of CoM's that are used in calculating the mean
        
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
    x_average           = (x1+x2+x3+x4+x5+x6+x7+x8+x9+x10+x11+x12+x13+x14+x15+x16+x17+x18+x19+x20) / 20; 
    baseline            = mean(x_average(5:50));
    x_displ             = x_average - baseline;     % subtract baseline
    record(r).CoM_avg   = x_displ * (50/138);       % Save the average displacement, in um (50 um/ 138 pi)
    record(r).CoM_pixels= x_average + rect(1);
    
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
    record(r).xpos      = record(r).rect(1) + x_average(1,1);     % Store the HB's x position, in pixels
    record(r).ypos      = record(r).rect(2) + y_average(1,1);
    % Create a distance field with the current HB's distance from laser in um
    ref_pos             = record(1).x_click+record(1).rect(1); % This is the center of the laser
    record(r).distance  = (abs(ref_pos - record(r).xpos)) * (50/138) ; 
    
    pre  = mean(record(r).CoM_avg(5:60));
    step = mean(record(r).CoM_avg(100:140));
    post = mean(record(r).CoM_avg(160:200));
    delta= abs(step - mean([pre post])) ; % Calculate delta size, convert to nm
    record(r).delta = delta;
end
toc

%% Plot each event, offset by its distance from the first one, HB1
clf
for r = 39:49
    plot(record(3).time,record(r).CoM_avg + record(r).distance)
    hold on
end

%% Plot decay of response as a function of event number, HB1
clf
counter = 1;
subplot(4,1,1:2)
for i = [1 5 7 9]        % these are the events in which the bundle was in the laser beam
    event_HB1(counter) = i;
    delta_HB1(counter) = record(i).delta;
    counter = counter + 1;
    plot(i, record(i).delta,'.','MarkerSize',24);
    hold on
end
axis([0 11 0.0 0.1])
ylabel('um')
title('HB1 - Amplitudes of records in center of beam v. Event number')

p_HB1 = polyfit(event_HB1, delta_HB1,1);    % Fit a linear polynomial 
xl = xlim;
x_fit = linspace(xl(1),xl(2),100);
y_fit = polyval(p_HB1,x_fit);
h1 = plot(x_fit,y_fit);
legend(h1,['slope = ' num2str(p_HB1(1)) ])

% Now plot corrected records from inside the beam 
for i = 1:9
    decayed = p_HB1(1) * (i) + p_HB1(2);
    c_factor = decayed/record(1).delta; % Use record 3 as the baseline
    record(i).corr_delta = record(i).delta/c_factor;    % Create a corr_delta field in each record, with the corrected amplitude
end

subplot(4,1,3:4)
for i = [1 5 7 9]        % these are the events in which the bundle was in the laser beam
    h1 = plot(i, record(i).delta,'k.','MarkerSize',24);
    hold on
    h2 = plot(i, record(i).corr_delta,'r.','MarkerSize',24);
end
xlabel('Event #')
ylabel('Displacement (nm)')
title('HB1 - Displacements within beam, corrected for decay')
axis([0 11 0.0 0.1])
legend([h1 h2], 'Original','Corrected','location','SouthWest')

saveas(gcf,strcat('Decay_Correction_8_24_15_HB1','fig'));
saveas(gcf,strcat('Decay_Correction_8_24_15_HB1','eps'),'epsc');

%% Plot decay of response as a function of event number, HB2
clf
counter = 1;
subplot(4,1,1:2)
for i = [10 13 15]        % these are the events in which the bundle was in the laser beam
    event_HB2(counter) = i-9;
    delta_HB2(counter) = record(i).delta;
    counter = counter + 1;
    plot(i-9, record(i).delta,'.','MarkerSize',24);
    hold on
end
axis([0 7 0 0.08])
ylabel('um')
title('HB2 - Amplitudes of records in center of beam v. Event number')

p_HB2 = polyfit(event_HB2, delta_HB2,1);    % Fit a linear polynomial 
xl = xlim;
x_fit = linspace(xl(1),xl(2),100);
y_fit = polyval(p_HB2,x_fit);
h1 = plot(x_fit,y_fit)
legend(h1, ['slope = ' num2str(p_HB2(1)) ])

% Now plot corrected records from inside the beam 
for i = [10:15]
    decayed = p_HB2(1) * (i-9) + p_HB2(2);
    c_factor = decayed/record(10).delta;
    record(i).corr_delta = record(i).delta/c_factor;    % Create a corr_delta field in each record, with the corrected amplitude
end

subplot(4,1,3:4)
for i = [10 13 15]       % these are the events in which the bundle was in the laser beam
    h1 = plot(i-9, record(i).delta,'k.','MarkerSize',24);
    hold on
    h2 = plot(i-9, record(i).corr_delta,'r.','MarkerSize',24);
end
xlabel('Event #')
ylabel('Displacement (um)')
title('HB2 - Displacements within beam, corrected for decay')
axis([0 7 0 0.08])
legend([h1 h2], 'Original','Corrected','location','SouthWest')

saveas(gcf,strcat('Decay_Correction_8_24_15_HB2','fig'));
saveas(gcf,strcat('Decay_Correction_8_24_15_HB2','eps'),'epsc');

%% Plot decay of response as a function of event number, HB3
clf
counter = 1;
subplot(4,1,1:2)
for i = [16 18 20 22]  
    event_HB3(counter) = i-15;
    delta_HB3(counter) = record(i).delta;
    counter = counter + 1;
    plot(i-15, record(i).delta,'.','MarkerSize',24);
    hold on
end
axis([0 8 0 0.35])
ylabel('um')
title('HB3 - Amplitudes of records in center of beam v. Event number')

p_HB3 = polyfit(event_HB3, delta_HB3,1);    % Fit a linear polynomial 
xl = xlim;
x_fit = linspace(xl(1),xl(2),100);
y_fit = polyval(p_HB3,x_fit);
plot(x_fit,y_fit)
legend(['slope = ' num2str(p_HB3(1)) ])

% Now plot corrected records from inside the beam 

for i = 16:22
    decayed = p_HB3(1) * (i-15) + p_HB3(2);
    c_factor = decayed/record(16).delta;        % compare the values gotten fit to the original (non-decayed) to get correction factor
    record(i).corr_delta = record(i).delta/c_factor;
end
subplot(4,1,3:4)
for i = [16 18 20 22]        % these are the events in which the bundle was in the laser beam
    h1 = plot(i-15, record(i).delta,'k.','MarkerSize',24);
    hold on
    h2 = plot(i-15, record(i).corr_delta,'r.','MarkerSize',24);
end
xlabel('Event #')
ylabel('Displacement (um)')
title('HB3 - Displacements within beam, corrected for decay')
axis([0 8 0 0.35])
legend([h1 h2], 'Original','Corrected','location','Southwest')

saveas(gcf,strcat('Decay_Correction_8_24_15_HB3','fig'));
saveas(gcf,strcat('Decay_Correction_8_24_15_HB3','eps'),'epsc');

%% Plot decay of response as a function of event number, HB4
clf
counter = 1;
subplot(4,1,1:2)
for i = [23 25 27 29 31]  
    event_HB4(counter) = i-22;
    delta_HB4(counter) = record(i).delta;
    counter = counter + 1;
    plot(i-22, record(i).delta,'.','MarkerSize',24);
    hold on
end
axis([0 10 0 0.27])
ylabel('um')
title('HB4 - Amplitudes of records in center of beam v. Event number')

p_HB4 = polyfit(event_HB4, delta_HB4,1);    % Fit a linear polynomial 
xl = xlim;
x_fit = linspace(xl(1),xl(2),100);
y_fit = polyval(p_HB4,x_fit);
plot(x_fit,y_fit)
legend(['slope = ' num2str(p_HB4(1)) ])

% Now plot corrected records from inside the beam 

for i = 23:31
    decayed = p_HB4(1) * (i-22) + p_HB4(2);
    c_factor = decayed/record(23).delta;        % compare the values gotten fit to the original (non-decayed) to get correction factor
    record(i).corr_delta = record(i).delta/c_factor;
end
subplot(4,1,3:4)
for i = [23 25 27 29 31]        % these are the events in which the bundle was in the laser beam
    h1 = plot(i-22, record(i).delta,'k.','MarkerSize',24);
    hold on
    h2 = plot(i-22, record(i).corr_delta,'r.','MarkerSize',24);
end
xlabel('Event #')
ylabel('Displacement (um)')
title('HB4 - Displacements within beam, corrected for decay')
axis([0 10 0 0.27])
legend([h1 h2], 'Original','Corrected','location','Southwest')

saveas(gcf,strcat('Decay_Correction_8_24_15_HB4','fig'));
saveas(gcf,strcat('Decay_Correction_8_24_15_HB4','eps'),'epsc');

%% Plot decay of response as a function of event number, HB5
clf
counter = 1;
subplot(4,1,1:2)
for i = [32 36 38]  % Didn't include rec 34 here because it is an outlier
    event_HB5(counter) = i-31;
    delta_HB5(counter) = record(i).delta;
    counter = counter + 1;
    plot(i-31, record(i).delta,'.','MarkerSize',24);
    hold on
end
axis([0 8 0 0.15])
ylabel('um')
title('HB5 - Amplitudes of records in center of beam v. Event number')

p_HB5 = polyfit(event_HB5, delta_HB5,1);    % Fit a linear polynomial 
xl = xlim;
x_fit = linspace(xl(1),xl(2),100);
y_fit = polyval(p_HB5,x_fit);
plot(x_fit,y_fit)
legend(['slope = ' num2str(p_HB5(1)) ])

% Now plot corrected records from inside the beam 

for i = 32:38
    decayed = p_HB5(1) * (i-31) + p_HB5(2);
    c_factor = decayed/record(32).delta;        % compare the values gotten fit to the original (non-decayed) to get correction factor
    record(i).corr_delta = record(i).delta/c_factor;
end
subplot(4,1,3:4)
for i = [32 36 38]        % these are the events in which the bundle was in the laser beam
    h1 = plot(i-31, record(i).delta,'k.','MarkerSize',24);
    hold on
    h2 = plot(i-31, record(i).corr_delta,'r.','MarkerSize',24);
end
xlabel('Event #')
ylabel('Displacement (um)')
title('HB5 - Displacements within beam, corrected for decay')
axis([0 8 0 0.15])
legend([h1 h2], 'Original','Corrected','location','Southwest')

saveas(gcf,strcat('Decay_Correction_8_24_15_HB5','fig'));
saveas(gcf,strcat('Decay_Correction_8_24_15_HB5','eps'),'epsc');

%% Plot decay of response as a function of event number, HB6
clf
counter = 1;
subplot(4,1,1:2)
for i = [39 41 43 45 47 49]  
    event_HB6(counter) = i-38;
    delta_HB6(counter) = record(i).delta;
    counter = counter + 1;
    plot(i-38, record(i).delta,'.','MarkerSize',24);
    hold on
end
%axis([0 10 0 0.27])
ylabel('um')
title('HB6 - Amplitudes of records in center of beam v. Event number')

p_HB6 = polyfit(event_HB6, delta_HB6,1);    % Fit a linear polynomial 
xl = xlim;
x_fit = linspace(xl(1),xl(2),100);
y_fit = polyval(p_HB6,x_fit);
plot(x_fit,y_fit)
legend(['slope = ' num2str(p_HB6(1)) ])

% Now plot corrected records from inside the beam 

for i = 39:49
    decayed = p_HB6(1) * (i-38) + p_HB6(2);
    c_factor = decayed/record(39).delta;        % compare the values gotten fit to the original (non-decayed) to get correction factor
    record(i).corr_delta = record(i).delta/c_factor;
end
subplot(4,1,3:4)
for i = [39 41 43 45 47 49]        % these are the events in which the bundle was in the laser beam
    h1 = plot(i-38, record(i).delta,'k.','MarkerSize',24);
    hold on
    h2 = plot(i-38, record(i).corr_delta,'r.','MarkerSize',24);
end
xlabel('Event #')
ylabel('Displacement (um)')
title('HB6 - Displacements within beam, corrected for decay')
%axis([0 10 0 0.27])
legend([h1 h2], 'Original','Corrected','location','Southwest')

saveas(gcf,strcat('Decay_Correction_8_24_15_HB6','fig'));
saveas(gcf,strcat('Decay_Correction_8_24_15_HB6','eps'),'epsc');

%% HB1 - Plot both corrected and uncorrected delta against distance from laser
clf
set(0, 'DefaultAxesColorOrder', ametrine(9));
subplot(2,1,1)
for i = 1:9
   plot(record(i).distance,record(i).delta*1000,'.','Markersize',24)
   hold all
end
axis([-1 40 0 100])
ylabel('Laser-evoked displacement (nm)')
title('Displacement v. Distance from laser beam, 8/24/15 HB1')

subplot(2,1,2)
for i = 1:9
   plot(record(i).distance,record(i).corr_delta*1000,'.','Markersize',24)
   hold all
end
axis([-1 40 0 100])
xlabel(' Distance from laser (um)')
ylabel('CORRECTED Laser-evoked displacement (nm)')

saveas(gcf,strcat('Decay_Corrected_v_Uncorrected_8_24_15_HB1','fig'));
saveas(gcf,strcat('Decay_Corrected_v_Uncorrected_8_24_15_HB1','eps'),'epsc');

%% HB2 - Plot both corrected and uncorrected delta against distance from laser
clf
set(0, 'DefaultAxesColorOrder', ametrine(6));
subplot(2,1,1)
for i = 10:15
   plot(record(i).distance,record(i).delta*1000,'.','Markersize',24)
   hold all
end
axis([-2 35 0 100])
ylabel('Laser-evoked displacement (nm)')
title('Displacement v. Distance from laser beam, 8/24/15 HB2')

subplot(2,1,2)
for i = 10:15
   plot(record(i).distance,record(i).corr_delta*1000,'.','Markersize',24)
   hold all
end
axis([-2 35 0 100])
xlabel(' Distance from laser (um)')
ylabel('CORRECTED Laser-evoked displacement (nm)')

saveas(gcf,strcat('Decay_Corrected_v_Uncorrected_8_24_15_HB2','fig'));
saveas(gcf,strcat('Decay_Corrected_v_Uncorrected_8_24_15_HB2','eps'),'epsc');

%% HB3 - Plot both corrected and uncorrected delta against distance from laser
clf
set(0, 'DefaultAxesColorOrder', ametrine(7));
subplot(2,1,1)
for i = 16:22
   plot(record(i).distance,record(i).delta*1000,'.','Markersize',24)
   hold all
end
axis([-2 35 0 300])
ylabel('Laser-evoked displacement (nm)')
title('Displacement v. Distance from laser beam, 8/24/15 HB3')

subplot(2,1,2)
for i = 16:22
   plot(record(i).distance,record(i).corr_delta*1000,'.','Markersize',24)
   hold all
end
axis([-2 35 0 300])
xlabel(' Distance from laser (um)')
ylabel('CORRECTED Laser-evoked displacement (nm)')

saveas(gcf,strcat('Decay_Corrected_v_Uncorrected_8_24_15_HB3','fig'));
saveas(gcf,strcat('Decay_Corrected_v_Uncorrected_8_24_15_HB3','eps'),'epsc');

%% HB4 - Plot both corrected and uncorrected delta against distance from laser
clf
set(0, 'DefaultAxesColorOrder', ametrine(9));
subplot(2,1,1)
for i = 23:31
   plot(record(i).distance,record(i).delta*1000,'.','Markersize',24)
   hold all
end
axis([-2 40 0 260])
ylabel('Laser-evoked displacement (nm)')
title('Displacement v. Distance from laser beam, 8/24/15 HB4')

subplot(2,1,2)
for i = 23:31
   plot(record(i).distance,record(i).corr_delta*1000,'.','Markersize',24)
   hold all
end
axis([-2 40 0 260])
xlabel(' Distance from laser (um)')
ylabel('CORRECTED Laser-evoked displacement (nm)')

saveas(gcf,strcat('Decay_Corrected_v_Uncorrected_8_24_15_HB4','fig'));
saveas(gcf,strcat('Decay_Corrected_v_Uncorrected_8_24_15_HB4','eps'),'epsc');

%% HB5 - Plot both corrected and uncorrected delta against distance from laser
clf
set(0, 'DefaultAxesColorOrder', ametrine(7));
subplot(2,1,1)
for i = 32:38
   plot(record(i).distance,record(i).delta*1000,'.','Markersize',24)
   hold all
end
axis([-2 40 0 130])
ylabel('Laser-evoked displacement (nm)')
title('Displacement v. Distance from laser beam, 8/24/15 HB5')

subplot(2,1,2)
for i = 32:38
   plot(record(i).distance,record(i).corr_delta*1000,'.','Markersize',24)
   hold all
end
axis([-2 40 0 130])
xlabel(' Distance from laser (um)')
ylabel('CORRECTED Laser-evoked displacement (nm)')

saveas(gcf,strcat('Decay_Corrected_v_Uncorrected_8_24_15_HB5','fig'));
saveas(gcf,strcat('Decay_Corrected_v_Uncorrected_8_24_15_HB5','eps'),'epsc');

%% HB6 - Plot both corrected and uncorrected delta against distance from laser
clf
set(0, 'DefaultAxesColorOrder', ametrine(11));
subplot(2,1,1)
for i = 39:49
   plot(record(i).distance,record(i).delta*1000,'.','Markersize',24)
   hold all
end
axis([-2 50 0 155])
ylabel('Laser-evoked displacement (nm)')
title('Displacement v. Distance from laser beam, 8/24/15 HB6')

subplot(2,1,2)
for i = 39:49
   plot(record(i).distance,record(i).corr_delta*1000,'.','Markersize',24)
   hold all
end
axis([-2 50 0 155])
xlabel(' Distance from laser (um)')
ylabel('CORRECTED Laser-evoked displacement (nm)')

saveas(gcf,strcat('Decay_Corrected_v_Uncorrected_8_24_15_HB6','fig'));
saveas(gcf,strcat('Decay_Corrected_v_Uncorrected_8_24_15_HB6','eps'),'epsc');

%% All HBs - Calculate what % of maximum amplitude each event represents, then plot it
for i = [1 6 8]
   record(i).corr_delta_percent = record(i).corr_delta / record(1).corr_delta; 
end
subplot(2,3,1)
for i = [1 6 8]
   plot(record(i).distance , record(i).corr_delta_percent ,'.k','Markersize',24)
   hold all
end
%axis([-5 16 0 1.1])

% HB2 - Calculate what % of maximum amplitude each event represents, then plot it
for i = [10 12 14]
   record(i).corr_delta_percent = record(i).corr_delta / record(10).corr_delta; 
end
subplot(2,3,2)
for i = [10 12 14]
   plot(record(i).distance , record(i).corr_delta_percent ,'.k','Markersize',24)
   hold all
end
%axis([-5 16 0 1.1])

% HB3 - Calculate what % of maximum amplitude each event represents, then plot it
for i = [16 19 21]
   record(i).corr_delta_percent = record(i).corr_delta / record(16).corr_delta; 
end
subplot(2,3,3)
for i = [16 19 21]
   plot(record(i).distance , record(i).corr_delta_percent ,'.k','Markersize',24)
   hold all
end

% HB4 - Calculate what % of maximum amplitude each event represents, then plot it
for i = [23 26 28 30]
   record(i).corr_delta_percent = record(i).corr_delta / record(23).corr_delta; 
end
subplot(2,3,4)
for i = [23 26 28 30]
   plot(record(i).distance , record(i).corr_delta_percent ,'.k','Markersize',24)
   hold all
end

% HB5 - Calculate what % of maximum amplitude each event represents, then plot it
for i = [32 33 35 37]
   record(i).corr_delta_percent = record(i).corr_delta / record(32).corr_delta; 
end
subplot(2,3,5)
for i = [32 33 35 37]
   plot(record(i).distance , record(i).corr_delta_percent ,'.k','Markersize',24)
   hold all
end

% HB6 - Calculate what % of maximum amplitude each event represents, then plot it
for i = [39 40 42 44 46]
   record(i).corr_delta_percent = record(i).corr_delta / record(39).corr_delta; 
end
subplot(2,3,6)
for i = [39 40 42 44 46]
   plot(record(i).distance , record(i).corr_delta_percent ,'.k','Markersize',24)
   hold all
end

%% Plot corrected delta percents for all six bundles
clf
subplot(4,1,2:3)
for i = [1 6 8]
   h1 = plot(record(i).distance , record(i).corr_delta_percent ,'.','color',[1 0 0 ],'Markersize',24);
   hold all
end

for i = [10 12 14]
   h2 = plot(record(i).distance , record(i).corr_delta_percent ,'.','color',[1 0.5 0 ],'Markersize',24);
   hold all
end

for i = [16 19 21]
   h3 = plot(record(i).distance , record(i).corr_delta_percent ,'.','color',[1 0.8 0 ],'Markersize',24);
   hold all
end

for i = [23 26 28 30]
   h4 = plot(record(i).distance , record(i).corr_delta_percent ,'.','color',[0.5 0.9 0.1 ],'Markersize',24);
   hold all
end

for i = [32 33 35 37]
   h5 = plot(record(i).distance , record(i).corr_delta_percent ,'.','color',[0.2 0.6 0.8],'Markersize',24);
   hold all
end

for i = [39 40 42 44 46]
   h6 = plot(record(i).distance , record(i).corr_delta_percent ,'.','color',[0.4 0 1 ],'Markersize',24);
   hold all
end

cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/7_9_15/')
load('Hamamatsu_variables.mat')
% Add the laser spread plots:
h14 = plot(x(435:end)-188.2,1*(aggregate_x((435:end),12)/max(aggregate_x(:,12))),'Linewidth',2,'color',[0 0 0]);
hold on
h15 = plot(x(435:end)-188.2,1*(aggregate_x(435:end,38)/max(aggregate_x(:,38))),'Linewidth',2,'color',[0.4 0.4 0.4]);

axis([0 50 0 1.8])
legend([h1 h2 h3 h4 h5 h6 h14 h15],'HB1','HB2','HB3','HB4','HB5','HB6','Fluorescein','DiA','location','NorthEast')
title('8/24/15 - Fraction of initial displacement v. Distance')
xlabel('Distance (um)')
ylabel('Fraction of initial displacement')
cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/8_24_15/')
saveas(gcf,strcat('Normalized_Displacements_8_24_15_HBs1-6','fig'));
saveas(gcf,strcat('Normalized_Displacements_8_24_15_HBs1-6','eps'),'epsc');

%% Overlay to look at kinetics - HB1
clf
subplot_tight(3,1,1,[0.05 0.1])
set(0, 'DefaultAxesColorOrder', ametrine(3));
h1 = plot(record(1).time(5:end), record(1).CoM_avg(5:end)/max(record(1).CoM_avg(10:end)),'linewidth',2);
hold all
h2 = plot(record(6).time(5:end), record(6).CoM_avg(5:end)/max(record(6).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(8).time(5:end), record(8).CoM_avg(5:end)/max(record(8).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3], ...
sprintf('%d um, %d nm', round(record(1).distance), round(record(1).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(6).distance), round(record(6).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(8).distance), round(record(8).corr_delta*1000)),...
'location','northwest')
title('8/24/15 - HB1')
axis([0 100 -0.2 1.2])

subplot_tight(3,1,2,[0.05 0.1])
set(0, 'DefaultAxesColorOrder', ametrine(3));
h1 = plot(record(1).time(5:end), record(1).CoM_avg(5:end)/max(record(1).CoM_avg(10:end)),'linewidth',2);
hold all
h2 = plot(record(5).time(5:end), record(5).CoM_avg(5:end)/max(record(5).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(7).time(5:end), record(7).CoM_avg(5:end)/max(record(7).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3], ...
sprintf('%d um, %d nm', round(record(1).distance), round(record(1).corr_delta*1000)), ...
sprintf('%d um, %d nm', round(record(5).distance), round(record(5).corr_delta*1000)), ...
sprintf('%d um, %d nm', round(record(7).distance), round(record(7).corr_delta*1000)), ...
sprintf('%d um, %d nm', round(record(9).distance), round(record(9).corr_delta*1000)), ...
'location','northwest')
xlabel('Time (ms)')
axis([0 100 -0.2 1.2])

subplot_tight(3,1,3,[0.05 0.1])
set(0, 'DefaultAxesColorOrder', ametrine(5));
h1 = plot(record(1).time(5:end), record(1).CoM_avg(5:end)/max(record(1).CoM_avg(10:end)),'linewidth',2);
hold all
h2 = plot(record(2).time(5:end), record(2).CoM_avg(5:end)/max(record(2).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(3).time(5:end), record(3).CoM_avg(5:end)/max(record(3).CoM_avg(10:end)),'linewidth',2);
h4 = plot(record(4).time(5:end), record(4).CoM_avg(5:end)/max(record(4).CoM_avg(10:end)),'linewidth',2);
h5 = plot(record(5).time(5:end), record(5).CoM_avg(5:end)/max(record(5).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3 h4 h5], ...
sprintf('%d um, %d nm, 4V',     round(record(1).distance), round(record(1).corr_delta*1000)), ...
sprintf('%d um, %d nm, 3V',     round(record(2).distance), round(record(2).corr_delta*1000)), ...
sprintf('%d um, %d nm, 2V',     round(record(3).distance), round(record(3).corr_delta*1000)), ...
sprintf('%d um, %d nm, 1.5V',   round(record(4).distance), round(record(4).corr_delta*1000)), ...
sprintf('%d um, %d nm, 4V',     round(record(5).distance), round(record(5).corr_delta*1000)), ...
'location','northwest');
xlabel('Time (ms)')
axis([0 100 -0.2 1.2])

saveas(gcf,strcat('Overlaid_Kinetics_8_24_15_HB1','fig'));
saveas(gcf,strcat('Overlaid_Kinetics_8_24_15_HB1','eps'),'epsc');

%% Overlay to look at kinetics - HB2
clf
subplot_tight(3,1,1,[0.05 0.1])
set(0, 'DefaultAxesColorOrder', ametrine(3));
h1 = plot(record(10).time(5:end),  -record(10).CoM_avg(5:end)/max(-record(10).CoM_avg(10:end)),'linewidth',2);
hold all
h2 = plot(record(12).time(5:end),  -record(12).CoM_avg(5:end)/max(-record(12).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(14).time(5:end), -record(14).CoM_avg(5:end)/max(-record(14).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3], ...
sprintf('%d um, %d nm', round(record(10).distance), round(record(10).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(12).distance), round(record(12).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(14).distance), round(record(14).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(19).distance), round(record(19).corr_delta*1000)),...
'location','northwest')
title('8/24/15 - HB2')
axis([0 100 -0.4 1.2])

set(0, 'DefaultAxesColorOrder', ametrine(3));
subplot_tight(3,1,2,[0.05 0.1])
h1 = plot(record(10).time(5:end), -record(10).CoM_avg(5:end)/max(-record(10).CoM_avg(10:end)),'linewidth',2);
    hold all
h2 = plot(record(13).time(5:end), -record(13).CoM_avg(5:end)/max(-record(13).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(15).time(5:end), -record(15).CoM_avg(5:end)/max(-record(15).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3 ], ...
sprintf('%d um, %d nm', round(record(10).distance), round(record(10).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(13).distance), round(record(13).corr_delta*1000)), ...
sprintf('%d um, %d nm', round(record(15).distance), round(record(15).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(20).distance), round(record(10).corr_delta*1000)),...
'location','northwest');
xlabel('Time (ms)')
axis([0 100 -0.2 1.2])

set(0, 'DefaultAxesColorOrder', ametrine(2));
subplot_tight(3,1,3,[0.05 0.1])
h1 = plot(record(10).time(5:end), -record(10).CoM_avg(5:end)/max(-record(10).CoM_avg(10:end)),'linewidth',2);
    hold all
h2 = plot(record(11).time(5:end), -record(11).CoM_avg(5:end)/max(-record(11).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 ], ...
sprintf('%d um, %d nm, 4V',         round(record(10).distance), round(record(10).corr_delta*1000)),...
sprintf('%d um, %d nm, 1.5V',       round(record(11).distance), round(record(11).corr_delta*1000)), ...
sprintf('%d um, %d nm, 4V',         round(record(13).distance), round(record(13).corr_delta*1000)),...
sprintf('%d um, %d nm',             round(record(18).distance), round(record(10).corr_delta*1000)),...
'location','northwest');
xlabel('Time (ms)')
axis([0 100 -0.2 1.2])

saveas(gcf,strcat('Overlaid_Kinetics_8_24_15_HB2','fig'));
saveas(gcf,strcat('Overlaid_Kinetics_8_24_15_HB2','eps'),'epsc');

%% Overlay to look at kinetics - HB3
clf
subplot_tight(3,1,1,[0.05 0.1])
set(0, 'DefaultAxesColorOrder', ametrine(3));
h1 = plot(record(16).time(5:end), record(16).CoM_avg(5:end)/max(record(16).CoM_avg(10:end)),'linewidth',2);
hold all
h2 = plot(record(19).time(5:end), record(19).CoM_avg(5:end)/max(record(19).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(21).time(5:end), record(21).CoM_avg(5:end)/max(record(21).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3 ], ...
sprintf('%d um, %d nm', round(record(16).distance), round(record(16).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(19).distance), round(record(19).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(21).distance), round(record(21).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(30).distance), round(record(30).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(22).distance), round(record(22).corr_delta*1000)),...
'location','northwest')
title('8/24/15 - HB3')
axis([0 100 -0.4 1.2])

set(0, 'DefaultAxesColorOrder', ametrine(4));
subplot_tight(3,1,2,[0.05 0.1])
h1 = plot(record(16).time(5:end), record(16).CoM_avg(5:end)/max(record(16).CoM_avg(10:end)),'linewidth',2);
    hold all
h2 = plot(record(18).time(5:end), record(18).CoM_avg(5:end)/max(record(18).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(20).time(5:end), record(20).CoM_avg(5:end)/max(record(20).CoM_avg(10:end)),'linewidth',2);
h4 = plot(record(22).time(5:end), record(22).CoM_avg(5:end)/max(record(22).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3 h4], ...
sprintf('%d um, %d nm', round(record(16).distance), round(record(16).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(18).distance), round(record(18).corr_delta*1000)), ...
sprintf('%d um, %d nm', round(record(20).distance), round(record(20).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(22).distance), round(record(22).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(31).distance), round(record(31).corr_delta*1000)),...
'location','northwest')
xlabel('Time (ms)')
axis([0 100 -0.4 1.2])

set(0, 'DefaultAxesColorOrder', ametrine(3));
subplot_tight(3,1,3,[0.05 0.1])
h1 = plot(record(16).time(5:end), record(16).CoM_avg(5:end)/max(record(16).CoM_avg(10:end)),'linewidth',2);
    hold all
h2 = plot(record(17).time(5:end), record(17).CoM_avg(5:end)/max(record(17).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(18).time(5:end), record(18).CoM_avg(5:end)/max(record(18).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3], ...
sprintf('%d um, %d nm, 4V',     round(record(16).distance), round(record(16).corr_delta*1000)),...
sprintf('%d um, %d nm, 1.7V',   round(record(17).distance), round(record(17).corr_delta*1000)), ...
sprintf('%d um, %d nm, 4V',     round(record(18).distance), round(record(18).corr_delta*1000)),...
sprintf('%d um, %d nm',         round(record(29).distance), round(record(29).corr_delta*1000)),...
sprintf('%d um, %d nm',         round(record(31).distance), round(record(31).corr_delta*1000)),...
'location','northwest')
xlabel('Time (ms)')
axis([0 100 -0.4 1.2])

saveas(gcf,strcat('Overlaid_Kinetics_8_24_15_HB3','fig'));
saveas(gcf,strcat('Overlaid_Kinetics_8_24_15_HB3','eps'),'epsc');

%% Overlay to look at kinetics - HB4
clf
subplot_tight(3,1,1,[0.05 0.1])
set(0, 'DefaultAxesColorOrder', ametrine(4));
h1 = plot(record(23).time(5:end),  record(23).CoM_avg(5:end)/max(record(23).CoM_avg(10:end)),'linewidth',2);
hold all
h2 = plot(record(26).time(5:end), record(26).CoM_avg(5:end)/max(record(26).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(28).time(5:end), record(28).CoM_avg(5:end)/max(record(28).CoM_avg(10:end)),'linewidth',2);
h4 = plot(record(30).time(5:end), record(30).CoM_avg(5:end)/max(record(30).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3 h4], ...
sprintf('%d um, %d nm', round(record(23).distance), round(record(23).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(26).distance), round(record(26).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(28).distance), round(record(28).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(30).distance), round(record(30).corr_delta*1000)),...
'location','northwest')
title('8/24/15 - HB4')
axis([0 100 -0.4 1.2])

set(0, 'DefaultAxesColorOrder', ametrine(5));
subplot_tight(3,1,2,[0.05 0.1])
h1 = plot(record(23).time(5:end), record(23).CoM_avg(5:end)/max(record(23).CoM_avg(10:end)),'linewidth',2);
    hold all
h2 = plot(record(25).time(5:end), record(25).CoM_avg(5:end)/max(record(25).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(27).time(5:end), record(27).CoM_avg(5:end)/max(record(27).CoM_avg(10:end)),'linewidth',2);
h4 = plot(record(29).time(5:end), record(29).CoM_avg(5:end)/max(record(29).CoM_avg(10:end)),'linewidth',2);
h5 = plot(record(31).time(5:end), record(31).CoM_avg(5:end)/max(record(31).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3 h4 h5],... 
sprintf('%d um, %d nm', round(record(23).distance), round(record(23).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(25).distance), round(record(25).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(27).distance), round(record(27).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(29).distance), round(record(29).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(31).distance), round(record(31).corr_delta*1000)),...
'location','northwest')
xlabel('Time (ms)')
axis([0 100 -0.2 1.2])

set(0, 'DefaultAxesColorOrder', ametrine(3));
subplot_tight(3,1,3,[0.05 0.1])
h1 = plot(record(23).time(5:end), record(23).CoM_avg(5:end)/max(record(23).CoM_avg(10:end)),'linewidth',2);
    hold all
h2 = plot(record(24).time(5:end), record(24).CoM_avg(5:end)/max(record(24).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(25).time(5:end), record(25).CoM_avg(5:end)/max(record(25).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3], ...
sprintf('%d um, %d nm, 4V',     round(record(23).distance), round(record(23).corr_delta*1000)),...
sprintf('%d um, %d nm, 1.5V',   round(record(24).distance), round(record(24).corr_delta*1000)), ...
sprintf('%d um, %d nm, 4V',     round(record(25).distance), round(record(25).corr_delta*1000)),...
sprintf('%d um, %d nm',         round(record(33).distance), round(record(23).corr_delta*1000)),...
'location','northwest');
xlabel('Time (ms)')
axis([0 100 -0.2 1.2])

saveas(gcf,strcat('Overlaid_Kinetics_8_24_15_HB4','fig'));
saveas(gcf,strcat('Overlaid_Kinetics_8_24_15_HB4','eps'),'epsc');

%% Overlay to look at kinetics - HB5
clf
subplot_tight(3,1,1,[0.05 0.1])
set(0, 'DefaultAxesColorOrder', ametrine(4));
h1 = plot(record(32).time(5:end),  record(32).CoM_avg(5:end)/min(record(32).CoM_avg(10:end)),'linewidth',2);
hold all
h2 = plot(record(33).time(5:end), record(33).CoM_avg(5:end)/min(record(33).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(35).time(5:end), record(35).CoM_avg(5:end)/min(record(35).CoM_avg(10:end)),'linewidth',2);
h4 = plot(record(37).time(5:end), record(37).CoM_avg(5:end)/min(record(37).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3 h4], ...
sprintf('%d um, %d nm', round(record(32).distance), round(record(32).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(33).distance), round(record(33).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(35).distance), round(record(35).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(37).distance), round(record(37).corr_delta*1000)),...
'location','northwest')
title('8/24/15 - HB5')
axis([0 100 -0.4 1.2])

set(0, 'DefaultAxesColorOrder', ametrine(4));
subplot_tight(3,1,2,[0.05 0.1])
h1 = plot(record(32).time(5:end), record(32).CoM_avg(5:end)/min(record(32).CoM_avg(10:end)),'linewidth',2);
    hold all
h2 = plot(record(34).time(5:end), record(34).CoM_avg(5:end)/min(record(34).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(36).time(5:end), record(36).CoM_avg(5:end)/min(record(36).CoM_avg(10:end)),'linewidth',2);
h4 = plot(record(38).time(5:end), record(38).CoM_avg(5:end)/min(record(38).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3 h4],... 
sprintf('%d um, %d nm', round(record(32).distance), round(record(32).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(34).distance), round(record(34).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(36).distance), round(record(36).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(38).distance), round(record(38).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(31).distance), round(record(31).corr_delta*1000)),...
'location','northwest')
xlabel('Time (ms)')
axis([0 100 -0.2 1.2])

% set(0, 'DefaultAxesColorOrder', ametrine(3));
% subplot_tight(3,1,3,[0.05 0.1])
% h1 = plot(record(23).time(5:end), record(23).CoM_avg(5:end)/max(record(23).CoM_avg(10:end)),'linewidth',2);
%     hold all
% h2 = plot(record(24).time(5:end), record(24).CoM_avg(5:end)/max(record(24).CoM_avg(10:end)),'linewidth',2);
% h3 = plot(record(25).time(5:end), record(25).CoM_avg(5:end)/max(record(25).CoM_avg(10:end)),'linewidth',2);
% legend([h1 h2 h3], ...
% sprintf('%d um, %d nm, 4V',     round(record(23).distance), round(record(23).corr_delta*1000)),...
% sprintf('%d um, %d nm, 1.5V',   round(record(24).distance), round(record(24).corr_delta*1000)), ...
% sprintf('%d um, %d nm, 4V',     round(record(25).distance), round(record(25).corr_delta*1000)),...
% sprintf('%d um, %d nm',         round(record(33).distance), round(record(23).corr_delta*1000)),...
% 'location','northwest');
% xlabel('Time (ms)')
% axis([0 100 -0.2 1.2])

saveas(gcf,strcat('Overlaid_Kinetics_8_24_15_HB5','fig'));
saveas(gcf,strcat('Overlaid_Kinetics_8_24_15_HB5','eps'),'epsc');

%% Overlay to look at kinetics - HB6
clf
subplot_tight(3,1,1,[0.05 0.1])
set(0, 'DefaultAxesColorOrder', ametrine(5));
h1 = plot(record(39).time(5:end),  record(39).CoM_avg(5:end)/min(record(39).CoM_avg(10:end)),'linewidth',2);
hold all
h2 = plot(record(40).time(5:end), record(40).CoM_avg(5:end)/min(record(40).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(42).time(5:end), record(42).CoM_avg(5:end)/min(record(42).CoM_avg(10:end)),'linewidth',2);
h4 = plot(record(44).time(5:end), record(44).CoM_avg(5:end)/min(record(44).CoM_avg(10:end)),'linewidth',2);
h5 = plot(record(46).time(5:end), record(46).CoM_avg(5:end)/min(record(46).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3 h4 h5], ...
sprintf('%d um, %d nm', round(record(39).distance), round(record(39).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(40).distance), round(record(40).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(42).distance), round(record(42).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(44).distance), round(record(44).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(46).distance), round(record(46).corr_delta*1000)),...
'location','northwest')
title('8/24/15 - HB6')
axis([0 100 -0.2 1.2])

set(0, 'DefaultAxesColorOrder', ametrine(5));
subplot_tight(3,1,2,[0.05 0.1])
h1 = plot(record(39).time(5:end), record(39).CoM_avg(5:end)/min(record(39).CoM_avg(10:end)),'linewidth',2);
    hold all
h2 = plot(record(41).time(5:end), record(41).CoM_avg(5:end)/min(record(41).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(43).time(5:end), record(43).CoM_avg(5:end)/min(record(43).CoM_avg(10:end)),'linewidth',2);
h4 = plot(record(45).time(5:end), record(45).CoM_avg(5:end)/min(record(45).CoM_avg(10:end)),'linewidth',2);
h5 = plot(record(47).time(5:end), record(47).CoM_avg(5:end)/min(record(47).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3 h4 h5],... 
sprintf('%d um, %d nm', round(record(39).distance), round(record(39).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(41).distance), round(record(41).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(43).distance), round(record(43).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(45).distance), round(record(45).corr_delta*1000)),...
sprintf('%d um, %d nm', round(record(47).distance), round(record(47).corr_delta*1000)),...
'location','northwest')
xlabel('Time (ms)')
axis([0 100 -0.2 1.2])

set(0, 'DefaultAxesColorOrder', ametrine(3));
subplot_tight(3,1,3,[0.05 0.1])
h1 = plot(record(47).time(5:end), record(47).CoM_avg(5:end)/min(record(47).CoM_avg(10:end)),'linewidth',2);
    hold all
h2 = plot(record(48).time(5:end), record(48).CoM_avg(5:end)/min(record(48).CoM_avg(10:end)),'linewidth',2);
h3 = plot(record(49).time(5:end), record(49).CoM_avg(5:end)/min(record(49).CoM_avg(10:end)),'linewidth',2);
legend([h1 h2 h3], ...
sprintf('%d um, %d nm, 4V',     round(record(47).distance), round(record(47).corr_delta*1000)),...
sprintf('%d um, %d nm, 2V',     round(record(48).distance), round(record(48).corr_delta*1000)), ...
sprintf('%d um, %d nm, 4V',     round(record(49).distance), round(record(49).corr_delta*1000)),...
sprintf('%d um, %d nm',         round(record(33).distance), round(record(23).corr_delta*1000)),...
'location','northwest');
xlabel('Time (ms)')
axis([0 100 -0.2 1.2])

saveas(gcf,strcat('Overlaid_Kinetics_8_24_15_HB6','fig'));
saveas(gcf,strcat('Overlaid_Kinetics_8_24_15_HB6','eps'),'epsc');

%% Put the normalized data for all 3 bundles in one variable, so I can combine it with 8/20/15
clf
counter = 1;
for i = [1 6 8 10 12 14 16 19 21 23 26 28 30 32 33 35 37 39 40 42 44 46]
    aggregate_data(counter,1) = record(i).distance;
    aggregate_data(counter,2) = record(i).corr_delta_percent;
    counter = counter + 1;
end

plot(aggregate_data(:,1),aggregate_data(:,2),'.k','markersize',24)

%% PLOT 8/24 DATA WITH LASER DECAY PLOT
cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/7_9_15/')
load('Hamamatsu_variables.mat')

ag = [1.8313    1.0000
   20.8821    0.8098
   32.5669    0.6467
    1.5227    1.0000
   18.8519    1.6793
   29.4773    0.6465
    3.5443    1.0000
   22.2745    0.7354
   31.9046    0.4681
    2.4355    1.0000
   18.8203    0.1595
   30.0249    0.1141
   35.7046    0.1354
    1.6682    1.0000
   19.1555    0.8102
   26.1094    0.4980
   36.0813    0.4933
    1.8963    1.0000
   18.9420    0.1970
   21.9406    0.4041
   35.3649    0.6731
   45.3859    0.4566];

clf
set(0, 'DefaultAxesColorOrder', ametrine(6));
h1 = plot(ag(1:3,1),ag(1:3,2),'.','markersize',28);
hold all
h2 = plot(ag(4:6,1),ag(4:6,2),'.','markersize',28);
h3 = plot(ag(7:9,1),ag(7:9,2),'.','markersize',28);
h4 = plot(ag(10:13,1),ag(10:13,2),'.','markersize',28);
h5 = plot(ag(14:17,1),ag(14:17,2),'.','markersize',28);
h6 = plot(ag(18:22,1),ag(18:22,2),'.','markersize',28);

% Add the laser spread plots:
h14 = plot(x(435:end)-188.2,1*(aggregate_x((435:end),12)/max(aggregate_x(:,12))),'Linewidth',2,'color',[0 0 0]);
hold on
h15 = plot(x(435:end)-188.2,1*(aggregate_x(435:end,38)/max(aggregate_x(:,38))),'Linewidth',2,'color',[0.4 0.4 0.4]);
legend([h1 h2 h3 h4 h5 h6 h14 h15],'8/24 HB1','8/24 HB2','8/24 HB3','8/24 HB4','8/24 HB5','8/24 HB6','Fluorescein','DiA');
ylimit = get(gca,'Ylim');
f = line([6 6],[0 ylimit(2)],'Linestyle',':');
set(f,'color',[1 0 0],'linewidth',2);
axis([-10 70 0 1.5])
cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/8_24_15/')
saveas(gcf,strcat('8_24_15_and_laserDecay','fig'));
saveas(gcf,strcat('8_24_15_and_laserDecay','eps'),'epsc');

%% PLOT DATA FROM 7/9, 7/21, 8/20, 8/21, and 8/24
cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/7_9_15/')
load('Hamamatsu_variables.mat')

% Data from 8/20 and 8/21 and 7/9 and 7/21:
clf
ag = [0.8481    1.0000
    21.0030    0.3257   
    24.8217    0.2553
   30.6480    0.2016
    3.3370    1.0000
   19.8318    3.3959
   26.4191    0.9435
    4.3991    1.0050
    15.1411    0.4158
   23.3703    0.3220
    0.3964    1.0000
   16.0170    0.8600
   24.2302    1.3374
   35.9024    0.6062
    1.8778    1.0000
   20.4018    0.5459
   27.2444    0.5247
   43.2614    0.2032
    0.2030    1.0000
   18.7251    0.4960
    0.6249    1.0000
   19.1182    1.0883
   37.8196    0.4291
   49.3717    0.1933
   2.6466    1.0000
   12.3109    0.2911
   17.6020    0.2583
    1.8887    1.0000
   10.4309    1.1726
   13.6345    0.8996
   18.2841    0.8688
    4.3752    1.0000
   11.2367    0.9363
   15.6295    1.0566
   17.7182    1.0989
   22.7580    1.0887
   31.0825    0.2874
    1.2657    1.0000
   18.8407    0.1146
   31.0754    0.0840
   38.7126    0.0438
   44.9017    0.1188
    0.6672    1.0000
   10.5372    0.5196
   13.6697    0.2845
   15.7281    0.3846
    2.8011    1.0000
    9.3710    0.6679
   16.0293    0.4876
   21.7357    0.5190
   1.8313    1.0000
   20.8821    0.8098
   32.5669    0.6467
    1.5227    1.0000
   18.8519    1.6793
   29.4773    0.6465
    3.5443    1.0000
   22.2745    0.7354
   31.9046    0.4681
    2.4355    1.0000
   18.8203    0.1595
   30.0249    0.1141
   35.7046    0.1354
    1.6682    1.0000
   19.1555    0.8102
   26.1094    0.4980
   36.0813    0.4933
    1.8963    1.0000
   18.9420    0.1970
   21.9406    0.4041
   35.3649    0.6731
   45.3859    0.4566];

clf
set(0, 'DefaultAxesColorOrder', ametrine(19));
h1 = plot(ag(1:4,1),ag(1:4,2),'markersize',28,'linewidth',2);
hold all
h2 = plot(ag(5:7,1),ag(5:7,2),'markersize',28,'linewidth',2);
h3 = plot(ag(8:10,1),ag(8:10,2),'markersize',28,'linewidth',2);
h4 = plot(ag(11:14,1),ag(11:14,2),'markersize',28,'linewidth',2);
h5 = plot(ag(15:18,1),ag(15:18,2),'markersize',28,'linewidth',2);
h6 = plot(ag(19:20,1),ag(19:20,2),'markersize',28,'linewidth',2);
h7 = plot(ag(21:24,1),ag(21:24,2),'markersize',28,'linewidth',2);
h8 = plot(ag(25:27,1),ag(25:27,2),'markersize',10,'linewidth',2);
h9 = plot(ag(28:31,1),ag(28:31,2),'markersize',10,'linewidth',2);
h10 = plot(ag(32:37,1),ag(32:37,2),'markersize',10,'linewidth',2);
h11 = plot(ag(38:42,1),ag(38:42,2),'markersize',10,'linewidth',2);
h12 = plot(ag(43:46,1),ag(43:46,2),'markersize',10,'linewidth',2);
h13 = plot(ag(47:50,1),ag(47:50,2),'markersize',10,'linewidth',2);

h14 = plot(ag(51:53,1),ag(51:53,2),'markersize',10,'linewidth',2);
h15 = plot(ag(54:56,1),ag(54:56,2),'markersize',10,'linewidth',2);
h16 = plot(ag(57:59,1),ag(57:59,2),'markersize',10,'linewidth',2);
h17 = plot(ag(60:63,1),ag(60:63,2),'markersize',10,'linewidth',2);
h18 = plot(ag(64:67,1),ag(64:67,2),'markersize',10,'linewidth',2);
h19 = plot(ag(68:72,1),ag(68:72,2),'markersize',10,'linewidth',2);

% h1 = plot(ag(1:4,1),ag(1:4,2),'color',[1 0 0],'markersize',28,'linewidth',2);
% hold on
% h2 = plot(ag(5:7,1),ag(5:7,2),'color',[1 0.6 0],'markersize',28,'linewidth',2);
% h3 = plot(ag(8:10,1),ag(8:10,2),'color',[1 0.9 0],'markersize',28,'linewidth',2);
% h4 = plot(ag(11:14,1),ag(11:14,2),'color',[0 0.9 0],'markersize',28,'linewidth',2);
% h5 = plot(ag(15:18,1),ag(15:18,2),'color',[0 0.4 1],'markersize',28,'linewidth',2);
% h6 = plot(ag(19:20,1),ag(19:20,2),'color',[0.6 0 1],'markersize',28,'linewidth',2);
% h7 = plot(ag(21:24,1),ag(21:24,2),'color',[0.6 0 1],'markersize',28,'linewidth',2);
% h8 = plot(ag(25:27,1),ag(25:27,2),'color',[1 0 0],'markersize',10,'linewidth',2);
% h9 = plot(ag(28:31,1),ag(28:31,2),'color',[1 0.6 0],'markersize',10,'linewidth',2);
% h10 = plot(ag(32:37,1),ag(32:37,2),'color',[1 0.9 0],'markersize',10,'linewidth',2);
% h11 = plot(ag(38:42,1),ag(38:42,2),'color',[0 0.9 0],'markersize',10,'linewidth',2);
% h12 = plot(ag(43:46,1),ag(43:46,2),'color',[0 0.4 1],'markersize',10,'linewidth',2);
% h13 = plot(ag(47:50,1),ag(47:50,2),'color',[0.6 0 1],'markersize',10,'linewidth',2);

% Add the laser spread plots:
h20 = plot(x(435:end)-188.2,1*(aggregate_x((435:end),12)/max(aggregate_x(:,12))),'Linewidth',2,'color',[0 0 0]);
hold on
h21 = plot(x(435:end)-188.2,1*(aggregate_x(435:end,38)/max(aggregate_x(:,38))),'Linewidth',2,'color',[0.4 0.4 0.4]);
legend([h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11 h12 h13 h14 h15 h16 h17 h18 h19 h20 h21],...
'8/20 HB1','8/20 HB2','8/20 HB3','8/21 HB1','8/21 HB2','8/21 HB3','8/21 HB4','7/9 HB1','7/9 HB2','7/9 HB3','7/21 HB1','7/21 HB2','7/21 HB3','8/24 HB1','8/24 HB2','8/24 HB3','8/24 HB4','8/24 HB5','8/24 HB6','Fluorescein','DiA');

% ylimit = get(gca,'Ylim');
% f = line([6 6],[0 ylimit(2)],'Linestyle',':');
% set(f,'color',[1 0 0],'linewidth',2);
title('Overlaid normalized intensity profiles, Max values ~ 3000')
xlabel('Distance from center of beam (\mum)')
ylabel('Intensity and Displacement (normalized)')
axis([-10 70 0 1.5])
cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/8_24_15/')
saveas(gcf,strcat('7_9_and_7_21_and_8_20_8_21_and_8_24_2015_and_laserDecay','fig'));
saveas(gcf,strcat('7_9_and_7_21_and_8_20_8_21_and_8_24_2015_and_laserDecay','eps'),'epsc');

    
    
    
