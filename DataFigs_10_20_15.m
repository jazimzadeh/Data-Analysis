% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-10-20.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%% Plot resistance calibration, find slope of relation
temp = [35 32 29 26 23 20 45];
res = [9.44 9.77 10.21 10.69 11.3 12.0 8.2];
plot(res,temp,'.','markersize',20)
axis([7.5 13 18 47])
P = polyfit(res,temp,1);    % P(1) is the slope (degrees per megaohm)
xrange = get(gca,'xlim');
x = linspace(xrange(1),xrange(2));
y = x*P(1) + P(2);
hold on
h1 = plot(x,y,'k');         % Plot best fit line
legend(h1,['Slope = ', num2str(P(1)),' ',char(176), 'C/MOhm'])

saveas(gcf,strcat('Resistance_v_Temperature','fig'));
saveas(gcf,strcat('Resistance_v_Temperature'),'epsc');

%% Plot recs 1:8
saveyn = 0;
warning off
for r = 1:8
    clf
logfile_name        = getfield(dir('*.log'),'name');
logfile_name_clean  = logfile_name(1:end-7);            % remove excess numbers from filename, for use in figure titles below
logfile             = importdata(logfile_name);
wavetrain           = logfile.data(r,8);                % get number of wavetrains [actually waveforms] for that run
laser_delay         = logfile.data(r,43)*.001;          % in milliseconds
laser_duration      = logfile.data(r,44)*.001;          % in milliseconds
laser_voltage       = logfile.data(r,63);
probe_pzt_delay     = logfile.data(r,22)*0.001;         % in seconds
probe_pzt_duration  = logfile.data(r,23)*0.001;         % in seconds
beta                = logfile.data(4,106);
Fs                  = logfile.data(r,12);               % sampling rate
T                   = 1/Fs;
L                   = length(struct_data(r).data(:,2));    
t                   = (0:L-1)*T; 

voltage(:,r) = struct_data(r).data(:,3); voltage(:,r) = medfilt1(voltage(:,r),20);
current(:,r) = struct_data(r).data(:,2); current(:,r) = medfilt1(current(:,r),20);
laser = struct_data(r).data(:,4);
resistance(:,r) = (voltage(:,r)*10^-3)./(current(:,r)*10^-12);

subplot(4,1,1)
plot(t,voltage(:,r))
axis([0 0.4 -1 12])
ylim = get(gca, 'YLim');
    x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
    y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 
    ylabel('Voltage (mV')
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',10)
subplot(4,1,2)
plot(t,current(:,r))
    ylabel('Current (pA)')
    axis([0 0.4 1500 2500])
    ylim = get(gca, 'YLim');
    x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
    y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 
subplot(4,1,3:4)
    plot(t,resistance(:,r))
    ylabel('Resistance (MOhm)')
    axis([0 0.4 4.5e6 6e6])
    ylim = get(gca, 'YLim');
    x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
    y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 
res_pre = mean(resistance(0.028*Fs:0.041*Fs,r));
res_post = mean(resistance(0.26*Fs:0.29*Fs,r));
delta_r = res_post - res_pre;
temp2(r) = delta_r*(1e-6) * P(1);  % Multiply resistance by slope (deg/MOhm); Didn't include y-int since resistance is much lower than during calibration and the tempeature is clearly not ~90C
text(0.1, 5.8e6, ['\DeltaT   ',num2str(temp2(r)),' ',char(176),'C'])

if saveyn == 1
    saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end
end

%% Plot recs 9:42
warning off
saveyn = 0;
for r = 9:42
logfile_name        = getfield(dir('*.log'),'name');
logfile_name_clean  = logfile_name(1:end-7);            % remove excess numbers from filename, for use in figure titles below
logfile             = importdata(logfile_name);
wavetrain           = logfile.data(r,8);                % get number of wavetrains [actually waveforms] for that run
laser_delay         = logfile.data(r,43)*.001;          % in milliseconds
laser_duration      = logfile.data(r,44)*.001;          % in milliseconds
laser_voltage       = logfile.data(r,63);
probe_pzt_delay     = logfile.data(r,22)*0.001;         % in seconds
probe_pzt_duration  = logfile.data(r,23)*0.001;         % in seconds
beta                = logfile.data(4,106);
Fs                  = logfile.data(r,12);               % sampling rate
T                   = 1/Fs;
L                   = length(struct_data(r).data(:,2));    
t                   = (0:L-1)*T; 

voltage2(:,r) = struct_data(r).data(:,3); voltage2(:,r) = medfilt1(voltage2(:,r),20);
current2(:,r) = struct_data(r).data(:,2); current2(:,r) = medfilt1(current2(:,r),20);
laser2 = struct_data(r).data(:,4);
resistance2(:,r) = (voltage2(:,r)*10^-3)./(current2(:,r)*10^-12);

subplot(4,1,1)
plot(t,voltage2(:,r))
axis([0 0.4 -1 12])
ylim = get(gca, 'YLim');
    x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
    y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 
    ylabel('Voltage (mV')
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',10)

subplot(4,1,2)
plot(t,current2(:,r))
    ylabel('Current (pA)')
    axis([0 0.4 1500 2500])
    ylim = get(gca, 'YLim');
    x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
    y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 
subplot(4,1,3:4)
    plot(t,resistance2(:,r))
    ylabel('Resistance (MOhm)')
    axis([0 0.4 4.3e6 5.8e6])
    ylim = get(gca, 'YLim');
    x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
    y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 
res_pre = mean(resistance2(0.028*Fs:0.041*Fs,r));
res_post = mean(resistance2(0.26*Fs:0.29*Fs,r));
delta_r = res_post - res_pre;
temp(r) = delta_r*(1e-6) * P(1);  % Multiply resistance by slope (deg/MOhm)
text(0.1, 5.6e6, ['\DeltaT   ',num2str(temp(r)),' ',char(176),'C'])
    
    if saveyn == 1
        saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
        saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
    end
end

%% Plot temperature change vs. distance from probe
distance = [5 4 3 2 1];         % In divs; took these from log file notes
distance = distance * 1.667;    % Converted to um
temperature = [temp2(3) temp2(4) temp2(5) temp2(6) temp2(7)];
clf
plot(distance,temperature,'.k','markersize',25)
xlabel('Distance from mask (um)')
ylabel(['Temperature (', char(176), 'C)'])
title('10/19/15 - Mask in beam, electrode at various distances')
axis([0 10 0 5])

saveas(gcf,strcat('Temp_v_Distance_fromProbe','fig'));
saveas(gcf,strcat('Temp_v_Distance_fromProbe'),'epsc');

%% Mask distance from beam vs. Temperature change
clf
distance = [10 5 6 7 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11]; % distance of electrode; Positive is to the right of the beam
distance = distance + 2;        % Add 1 to get distance of mask's center
distance = distance * 1.667;    % Converted to um
temperature = [temp(9) temp(10) temp(11) temp(12) temp(13) temp(14) temp(15) temp(16) temp(17) temp(18) temp(19) temp(20) temp(21) temp(22) temp(23) temp(24) temp(25) temp(26) temp(27) temp(28)];
%plot(distance,temperature,'.k','markersize',20)
for d = 9:28    % To number the points
    plot(distance(d-8),temperature(d-8),'.k','markersize',20);
    text(distance(d-8)-0.1,temperature(d-8)+0.5,num2str(d));    % Add record number on top of point
    hold on
end
yl = get(gca,'ylim');
line([6 6],[yl(1) yl(2)],'color',[0.8 0.1 0.8],'linewidth',2,'linestyle','--')
line([-6 -6],[yl(1) yl(2)],'color',[0.8 0.1 0.8],'linewidth',2,'linestyle','--')

axis([-20 25 -1 8]);
title('10/20/15 - Distance of mask left edge from center of beam vs. Temperature')
xlabel('Distance from mask (um)')
ylabel(['Temperature (', char(176), 'C)'])

save('10_20_15_DistTempFile.mat','distance','temperature'); % Save distance and temperature data

saveas(gcf,strcat('Temp_v_Distance_fromBeam','fig'));
saveas(gcf,strcat('Temp_v_Distance_fromBeam'),'epsc');

%% Compare kinetics w/ electrode in and out of beam: Recs 17, 24, 25
clf
set(0, 'DefaultAxesColorOrder',[0.2 0.2 0.9; 0.2 0.8 0.2 ; 0.9 0.1 0.2 ] );
for r = [17 24 25]
    baseline = mean(resistance2(0.022*Fs:0.025*Fs,r));
    peak = mean(-(resistance2(0.28*Fs:0.3*Fs,r)-baseline));
    delta = abs(peak - baseline);
    plot(t(0.022*Fs:0.38*Fs),medfilt1(-(resistance2(0.022*Fs:0.38*Fs,r)-baseline)/peak,1) )
    hold all
end
ylim = get(gca, 'YLim');
x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 

legend('Rec 17 (Elec. in beam)','Rec 24 (Elec. out of beam)','Rec 25 (Elec. out of beam)','location','southwest')
axis([0 0.4 -0.5 1.3])
title('10/20/15 - Resistance kinetics: Electrode in/out of beam')
ylabel('Resistance (normalized)')
xlabel('Time (sec)')

saveas(gcf,strcat('KineticsOverlaid_Recs17,24,25','fig'));
saveas(gcf,strcat('KineticsOverlaid_Recs17,24,25'),'epsc');

%% Compare kinetics w/ electrode in and out of beam: Recs 14 & 26
clf
for r = [14 26]
    baseline = mean(resistance2(0.022*Fs:0.025*Fs,r));
    peak = mean(-(resistance2(0.28*Fs:0.3*Fs,r)-baseline));
    delta = abs(peak - baseline);
    plot(t(0.022*Fs:0.38*Fs),medfilt1(-(resistance2(0.022*Fs:0.38*Fs,r)-baseline)/peak,1) )
    hold all
end
ylim = get(gca, 'YLim');
x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 

legend('Rec 14 (Elec. in beam)','Rec 26 (Elec. out of beam)','location','southwest')
axis([0 0.4 -0.5 1.3])
title('10/20/15 - Resistance kinetics: Electrode in/out of beam')
ylabel('Resistance (normalized)')
xlabel('Time (sec)')

saveas(gcf,strcat('KineticsOverlaid_Recs14,26','fig'));
saveas(gcf,strcat('KineticsOverlaid_Recs14,26'),'epsc');

%% Distance along beam (which passes in center) vs. Temperature change
clf
distance = [0 -2 -4 -6 -8 -10 -12 -15 -18 -21 -24 -26 21 26]; % In divs
distance = distance * 1.667;
temperature = [temp(29) temp(30) temp(31) temp(32) temp(33) temp(34) temp(35) temp(36) temp(37) temp(38) temp(39) temp(40) temp(41) temp(42)];
%plot(distance,temperature,'.k','markersize',20)
    for d = 29:42
        plot(distance(d-28),temperature(d-28),'.k','markersize',20);
        text(distance(d-28)-1,temperature(d-28)+0.3,num2str(d));    % Add record number on top of point
        hold on
    end
    xl = get(gca,'xlim');
    line([3 3],[xl(1) xl(2)],'color',[0.8 0.1 0.8],'linewidth',2,'linestyle','--')
    line([-3 -3],[xl(1) xl(2)],'color',[0.8 0.1 0.8],'linewidth',2,'linestyle','--')
    
axis([-50 50 0 7])
title('10/20/15 - Electrode dist. from beam center (mask is through beam) vs. Temp')
xlabel('Distance from beam center (um)')
ylabel(['Temperature (', char(176), 'C)'])

saveas(gcf,strcat('Temp_v_Distance_alongBeam','fig'));
saveas(gcf,strcat('Temp_v_Distance_alongBeam'),'epsc');

%% Compare kinetics as electrode moves down beam
clf
set(0, 'DefaultAxesColorOrder',[0.5 0.2 0.8; 0.2 0.2 0.9; 0.2 0.8 0.2 ; 0.8 0.5 0.1; 1 0.1 0.2 ] );
for r = [29 31 33 35 37]
    baseline = mean(resistance2(0.022*Fs:0.025*Fs,r));
    peak = mean(-(resistance2(0.28*Fs:0.3*Fs,r)-baseline));
    delta = abs(peak - baseline);
    plot(t(0.022*Fs:0.38*Fs),medfilt1(-(resistance2(0.022*Fs:0.38*Fs,r)-baseline)/peak,10) )
    hold all
end
ylim = get(gca, 'YLim');
x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 

legend('Rec 29','Rec 31','Rec 33','Rec 35','Rec 37','location','southwest')
axis([0 0.4 -0.5 1.3])
title('10/20/15 - Resistance kinetics: Electrode in/out of beam')
ylabel('Resistance (normalized)')
xlabel('Time (sec)')

saveas(gcf,strcat('KineticsOverlaid_Recs29,31,33,35,37','fig'));
saveas(gcf,strcat('KineticsOverlaid_Recs29,31,33,35,37'),'epsc');

%% Exponential fit to normalized resistance traces
r = 35;
clf
time = t(0.022*Fs:0.38*Fs)';                    % Column vector for time
tem = ((resistance2 * (1e-6)) * P(1)) + P(2);   % Convert resistances to temperatures
tem = tem(0.022*Fs:0.38*Fs,:);                  % Column vectors for temperatures

ft = fittype( 'a - b*exp(c*x) - d*exp(e*x)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( ft );                        % Create default fit options
opts.Upper = [Inf Inf 0 Inf 0];                 % Constrain the maximum of 'c' and 'e' to negative numbers
opts.Lower = [0 -Inf -Inf -Inf -Inf];           % 'a' must be positive
%opts.algorithm = 'Levenberg-Marquardt';
opts.normalize = 'on';
opts.MaxIter = 10000;
opts.MaxFunEvals = 1000;
%opts.robust = 'LAR';

% Fit model to data.
%[fitresult, gof] = fit( time(560:5559), tem(560:5559,r), ft,opts);
[fitresult, gof] = fit(time(560:5559), tem(560:5559,r), ft, opts);
%plot(fitresult,time,tem(:,r))
plot(time(560:5559), tem(560:5559,r));
hold on
plot(fitresult)

axis([0 0.4 58 70])
fitresult
% Tau1 = 1/fitresult.c
% Tau2 = fitresult.e

