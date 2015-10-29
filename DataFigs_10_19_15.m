% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-10-19.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%%
for r = [1 2 3 4 5 6 7 8 9 10 11 12 13 15 16 17]
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

voltage(:,r) = struct_data(r).data(:,5); voltage(:,r) = medfilt1(voltage(:,r),20);
current(:,r) = struct_data(r).data(:,4); current(:,r) = medfilt1(current(:,r),20);
laser = struct_data(r).data(:,6);
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
    axis([0 0.4 1200 2000])
    ylim = get(gca, 'YLim');
    x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
    y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 
subplot(4,1,3:4)
    plot(t,resistance(:,r))
    ylabel('Resistance (MOhm)')
    axis([0 0.4 5e6 7.4e6])
    ylim = get(gca, 'YLim');
    x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
    y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 

saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

%% Plot record 14
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

r = 14;

for w = 1:10
current(:,w) = struct_data(r).data(:,21+w);   
current(:,w) = medfilt1(current(:,w),20);   % Used median filtering to be able to resolve resistance
end

for w = 1:10
voltage(:,w) = struct_data(r).data(:,31+w); 
voltage(:,w) = medfilt1(voltage(:,w),20);   % Used median filtering to be able to resolve resistance
end

for w = 1:10
laser(:,w) = struct_data(r).data(:,41+w);    
end

for w = 1:10
   resistance(:,w) = (voltage(:,w)*10^-3)./(current(:,w)*10^-12);
end

subplot(5,1,1); plot(t,voltage,'k')
    axis([0 0.4 0 12])
    ylabel('Voltage (mV)')
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',10)
subplot(5,1,2); plot(t,current,'k')
    axis([0 0.4 1500 1900])
    ylabel('Current (pA)')
subplot(5,1,3:4); plot(t,resistance,'k')
    ylabel('Resistance (MOhm)')
    axis([0 0.4 5.5*10^6 7.5*10^6])
subplot(5,1,5); plot(t,laser,'k')
    ylabel('Laser Command')
    xlabel('Time (sec)')
    
saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');

%% Plot Power vs. Resistance drop for rec. 14
baseline_start  = 0.024 * Fs;
baseline_end    = 0.04 * Fs;
peak_start      = 0.2 * Fs;
peak_end        = 0.25 * Fs;
for w = 1:10
   baseline_r   = mean(resistance(baseline_start:baseline_end,w));
   peak_r       = mean(resistance(peak_start:peak_end,w));
   res(w)= baseline_r - peak_r; 
end

for w = 1:10
   l(w) = mean(laser(peak_start:peak_end,w)); 
   power(w) = voltage_to_power(l(w));
end

clf
plot(power,res/(10^6),'.k','markersize',20)
axis([-0.5 6 -0.1 1.2])
xlabel('Power (mW)')
ylabel('Resistance drop (MOhm)')
title('Record 14')

saveas(gcf,strcat('Rec14_Power_v_heat','fig'));
saveas(gcf,strcat('Rec14_Power_v_heat'),'epsc');

%% Effect of mask
clf
h1 = plot(t,resistance(:,2),'color',[0.9 0.1 0.2]);
holplod on
h2 = plot(t,resistance(:,4),'color',[0.4 0.9 0.2]);
h3 = plot(t,resistance(:,9),'color',[0.2 0.4 0.9]) 
axis([0 0.4 5e6 7.4e6])
legend([h1 h2 h3],'No mask','Mask 5 um from tip','Non-silvered mask 5um','location','southeast')
title('Mask Heat effect - Records 2, 4, 9')
xlabel('Time (sec)')
ylabel('Resistance (MOhm)')

ylim = get(gca, 'YLim');
x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch

saveas(gcf,strcat('Mask_effect_10_19_15','fig'));
saveas(gcf,strcat('Mask_effect_10_19_15'),'epsc');

%% Mask Distance
clf
h1 = plot(t,resistance(:,7),'color',[0.9 0.1 0.2]);
hold on
h2 = plot(t,resistance(:,4),'color',[0.4 0.9 0.2]);
h3 = plot(t,resistance(:,5),'color',[0.2 0.4 0.9]) 
axis([0 0.4 5e6 7.4e6])
legend([h1 h2 h3],'Mask 2 um from tip','Mask 5 um from tip','Mask 10 um from tip','location','northeast')
title('Effect of dist. from electrode - Records 7, 4, 5')
xlabel('Time (sec)')
ylabel('Resistance (MOhm)')

ylim = get(gca, 'YLim');
x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch

saveas(gcf,strcat('Mask_distance_10_19_15','fig'));
saveas(gcf,strcat('Mask_distance_10_19_15'),'epsc');

%% Mask heat carrying
clf
subplot(2,1,1)
h1 = plot(t,medfilt1(resistance(:,4),10),'color',[0.9 0.1 0.2]);
hold on
h2 = plot(t,medfilt1(resistance(:,15),10),'color',[0.9 0.6 0.2]);
h3 = plot(t,medfilt1(resistance(:,16),10),'color',[0.4 0.9 0.2]);
h4 = plot(t,medfilt1(resistance(:,17),10),'color',[0.2 0.4 0.9]);
axis([0 0.4 5e6 7.4e6])
legend([h1 h2 h3 h4],'In beam','30 um','40 um','60 um','location','southeast')
title('Heat carrying by mask - Records 4, 15, 16, 17')
ylabel('Resistance (MOhm)')

ylim = get(gca, 'YLim');
x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch

set(0, 'DefaultAxesColorOrder',[0.9 0.1 0.2 ; 0.9 0.6 0.2 ; 0.4 0.9 0.2 ; 0.2 0.4 0.9] );
subplot(2,1,2)
for r = [4 15 16 17]
    baseline = mean(resistance(0.022*Fs:0.025*Fs,r));
    peak = mean(-(resistance(0.28*Fs:0.3*Fs,r)-baseline));
    delta = abs(peak - baseline);
    plot(t(0.022*Fs:0.38*Fs),medfilt1(-(resistance(0.022*Fs:0.38*Fs,r)-baseline)/peak,50) )
    hold all
end
axis([0 0.4 -0.5 1.3])
xlabel('Time (sec)')

ylim = get(gca, 'YLim');
x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch

saveas(gcf,strcat('Mask_heat_carrying_10_19_15','fig'));
saveas(gcf,strcat('Mask_heat_carrying_10_19_15'),'epsc');

%% Kinetics of silvered vs. non-silvered mask
clf
subplot(2,1,1)
h1 = plot(t,medfilt1(resistance(:,4),10),'color',[0.9 0.1 0.2]);
hold on
h2 = plot(t,medfilt1(resistance(:,9),10),'color',[0.9 0.6 0.2]);
axis([0 0.4 5e6 7.4e6])
legend([h1 h2 ],'Hollow silvered mask','Hollow non-silvered mask','location','southeast')
title('Kinetics - Silvered vs. Non-silvered mask')
ylabel('Resistance (MOhm)')

ylim = get(gca, 'YLim');
x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch

set(0, 'DefaultAxesColorOrder',[0.9 0.1 0.2 ; 0.9 0.6 0.2 ; 0.4 0.9 0.2 ; 0.2 0.4 0.9] );
subplot(2,1,2)
for r = [4 9]
    baseline = mean(resistance(0.022*Fs:0.025*Fs,r));
    peak = mean(-(resistance(0.28*Fs:0.3*Fs,r)-baseline));
    delta = abs(peak - baseline);
    plot(t(0.022*Fs:0.38*Fs),medfilt1(-(resistance(0.022*Fs:0.38*Fs,r)-baseline)/peak,100))
    hold all
end
axis([0 0.4 -0.5 2])
xlabel('Time (sec)')

ylim = get(gca, 'YLim');
x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch
