%% Import all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-10-21.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%% Plot resistance calibration, find slope of relation
temp = [20 25 30 35];
res = [5.83 5.43 4.98 4.71];
plot(res,temp,'.','markersize',20)
axis([4.5 6 15 40])
P = polyfit(res,temp,1);    % P(1) is the slope (degrees per megaohm)
xrange = get(gca,'xlim');
x = linspace(xrange(1),xrange(2));
y = x*P(1) + P(2);
hold on
h1 = plot(x,y,'k');
legend(h1,['Slope = ', num2str(P(1)),' ',char(176), 'C/MOhm'])

saveas(gcf,strcat('Resistance_v_Temperature','fig'));
saveas(gcf,strcat('Resistance_v_Temperature'),'epsc');

%% Plot recs 1:29
saveyn = 0;
for r = 1:29
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
resistance(:,r) = (voltage(:,r)*10^-3)./(current(:,r)*10^-12); % Store resistance in a new variable

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
    axis([0 0.4 1500 2000])
    ylim = get(gca, 'YLim');
    x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
    y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 
subplot(4,1,3:4)
    plot(t,resistance(:,r))
    ylabel('Resistance (MOhm)')
    axis([0 0.4 4.5e6 7e6])
    ylim = get(gca, 'YLim');
    x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
    y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 
res_pre = mean(resistance(0.028*Fs:0.041*Fs,r));
res_post = mean(resistance(0.26*Fs:0.29*Fs,r));
delta_r = res_post - res_pre;
temp(r) = delta_r*(1e-6) * P(1);  % Multiply resistance by slope (deg/MOhm)
text(0.1, 5.8e6, ['\DeltaT   ',num2str(temp(r)),' ',char(176),'C'])
    if saveyn == 1
        saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
        saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
    end
end

%% Mask distance from beam vs. Temperature change
%warning off
saveyn = 1;
clf
distance = [20 17 14 11 8 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -10 -11]; % distance of electrode; Positive is to the right of the beam
distance = distance + 2;        % Add 2 to get location of mask's center
distance = distance * 1.667;    % Converted to um
for l = 2:23
   temperature(l-1) = temp(l); 
end
for d = 1:22
    plot(distance(d),temperature(d),'.k','markersize',20);
    text(distance(d)-0.1,temperature(d)+1,num2str(d+1));    % Add record number on top of point
    hold on
end
yl = get(gca,'ylim');
line([6 6],[yl(1) yl(2)],'color',[0.8 0.1 0.8],'linewidth',2,'linestyle','--')
line([-6 -6],[yl(1) yl(2)],'color',[0.8 0.1 0.8],'linewidth',2,'linestyle','--')

title_str1 = '10/21/15 - Distance of mask from center of beam vs. Temperature';
title_str2 = 'Electrode 1.7 um from mask; Solid-core mask';
title({title_str1, title_str2})
xlabel('Distance from mask (um)')
ylabel(['Temperature (', char(176), 'C)'])

% saveyn = input('Save? (1=yes): ');

if saveyn == 1
    saveas(gcf,strcat('Temp_v_Distance_fromBeam','fig'));
    saveas(gcf,strcat('Temp_v_Distance_fromBeam'),'epsc');
end

%% Combine 10/20/15 (hollow mask) with 10/21/15 (solid mask) temp. vs. location
% Data from 10/20/15
saveyn = 1;
clf
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-10-20.01/Ear 1/Cell 1')
S = load('10_20_15_DistTempFile.mat');      % Load 10/20/15 data

subplot(2,1,1)
    h1 = plot(S.distance,S.temperature,'.r','markersize',20);
    hold on
    h2 = plot(distance,temperature,'.k','markersize',20);
    legend([h1 h2],'Hollow mask','Solid mask')
    ylabel(['Temperature change (', char(176), 'C)'])
    title_str1 = '10/20/15 & 10/21/15 - Distance of mask from center of beam vs. Temp';
    title_str2 = 'Electrode 1.7 um from mask';
    title({title_str1, title_str2})
subplot(2,1,2)
    h1 = plot(S.distance,S.temperature/max(S.temperature),'.r','markersize',20);
    hold on
    h2 = plot(distance,temperature/max(temperature),'.k','markersize',20);
    axis([-20 40 -0.1 1.1])
    legend([h1 h2],'Hollow mask','Solid mask')
    xlabel('Distance of mask center from beam center (um)')
    ylabel('Normalized \DeltaT')

cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-10-21.01/Ear 1/Cell 1')
if saveyn == 1
    saveas(gcf,strcat('Temp_v_Distance_fromBeam_HollowVSolid','fig'));
    saveas(gcf,strcat('Temp_v_Distance_fromBeam_HollowVSolid'),'epsc');
end

%% Fit exponential to resistance changes
clf
start = 0.022*Fs;
finish = 0.38*Fs; 
start_laser = laser_delay * Fs;
finish_laser = (laser_delay + laser_duration)*Fs;

for r = 10
    baseline = mean(resistance(0.022*Fs:0.025*Fs,r));
    peak = mean(-(resistance(0.28*Fs:0.3*Fs,r)-baseline));
    delta = abs(peak - baseline);
    res_norm = (-(resistance(:,r)-baseline)/peak);
    hold all
end
[f,s] = fit(t(start_laser:finish_laser)', res_norm(start_laser:finish_laser),'exp2');
plot(f,t(start:finish), res_norm(start:finish) )

    % Draw laser patch
    ylim = get(gca, 'YLim');
    x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
    y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 

% legend('Rec 17 (Elec. in beam)','Rec 24 (Elec. out of beam)','Rec 25 (Elec. out of beam)','location','southwest')
axis([0 0.4 -0.2 1.3])
title('10/21/15 - Resistance kinetics: Electrode in/out of beam')
ylabel('Resistance (normalized)')
xlabel('Time (sec)')

%% Compare kinetics w/ electrode in and out of beam: Recs 9 and 21
clf
set(0, 'DefaultAxesColorOrder',[0.9 0.1 0.2 ; 0 0 0] );
for r = [9 21]
    baseline = mean(resistance(0.022*Fs:0.025*Fs,r));
    peak = mean(-(resistance(0.28*Fs:0.3*Fs,r)-baseline));
    delta = abs(peak - baseline);
    plot(t(0.022*Fs:0.38*Fs),medfilt1(-(resistance(0.022*Fs:0.38*Fs,r)-baseline)/peak,1) )
    hold all
end
ylim = get(gca, 'YLim');
x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 

legend('Rec 9 (Elec. in beam)','Rec 21 (Elec. out of beam)','location','southwest')
axis([0 0.4 -0.5 1.3])
title('10/21/15 - Resistance kinetics: Electrode in/out of beam')
ylabel('Resistance (normalized)')
xlabel('Time (sec)')

saveas(gcf,strcat('KineticsOverlaid_Recs9,21','fig'));
saveas(gcf,strcat('KineticsOverlaid_Recs9,21'),'epsc');

%% Compare kinetics w/ electrode in and out of beam: Recs 12 and 20
clf
set(0, 'DefaultAxesColorOrder',[0.9 0.1 0.2 ; 0 0 0] );
    for r = [12 20]
        baseline = mean(resistance(0.022*Fs:0.025*Fs,r));
        peak = mean(-(resistance(0.28*Fs:0.3*Fs,r)-baseline));
        delta = abs(peak - baseline);
        plot(t(0.022*Fs:0.38*Fs),medfilt1(-(resistance(0.022*Fs:0.38*Fs,r)-baseline)/peak,1) )
        hold all
    end
ylim = get(gca, 'YLim');
x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 

legend('Rec 12 (Elec. in beam)','Rec 20 (Elec. out of beam)','location','southwest')
axis([0 0.4 -0.5 1.3])
title('10/21/15 - Resistance kinetics: Electrode in/out of beam')
ylabel('Resistance (normalized)')
xlabel('Time (sec)')

saveas(gcf,strcat('KineticsOverlaid_Recs12,20','fig'));
saveas(gcf,strcat('KineticsOverlaid_Recs12,20'),'epsc');

%% Compare kinetics w/ electrode in and out of beam: Recs 14 and 15 - Compare two very similar positions to get an idea of the natural variability in kinetics
clf
set(0, 'DefaultAxesColorOrder',[0.9 0.1 0.2 ; 0 0 0] );
    for r = [14 15]
        baseline = mean(resistance(0.022*Fs:0.025*Fs,r));
        peak = mean(-(resistance(0.28*Fs:0.3*Fs,r)-baseline));
        delta = abs(peak - baseline);
        plot(t(0.022*Fs:0.38*Fs),medfilt1(-(resistance(0.022*Fs:0.38*Fs,r)-baseline)/peak,1) )
        hold all
    end
ylim = get(gca, 'YLim');
x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 

legend('Rec 14 (Elec. in beam)','Rec 15 (Elec. out of beam)','location','southwest')
axis([0 0.4 -0.5 1.3])
title('10/21/15 - Resistance kinetics: Electrode in/out of beam')
ylabel('Resistance (normalized)')
xlabel('Time (sec)')

saveas(gcf,strcat('KineticsOverlaid_Recs14,25','fig'));
saveas(gcf,strcat('KineticsOverlaid_Recs14,25'),'epsc');

%% Plot heat effects at tip of sharp mask



