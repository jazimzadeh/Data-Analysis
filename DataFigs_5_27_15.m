% This imports all data files from a single day into one data structure
clear;clc;clf;
close(gcf);
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-05-27.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});

%% Simply plot each bundle's laser-evoked response
for r = 1:length(fileList2)
logfile_name = getfield(dir('*.log'),'name');
logfile_name_clean = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile = importdata(logfile_name);
clf
wavetrain = logfile.data(r,8); % get number of wavetrains [actually waveforms] for that run
laser_delay = logfile.data(r,43)*.001;      % in milliseconds
laser_duration = logfile.data(r,44)*.001;   % in milliseconds
laser_voltage = logfile.data(r,63);

Fs = 20000;         %sampling rate
T = 1/Fs;
L = length(struct_data(r).data(:,2));    
t = (0:L-1)*T;

subplot(4,1,1:3)
plot(t,struct_data(r).data(:,0*wavetrain+2:1*wavetrain+1))
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
ylabel('Displacement (Xd)')

subplot(4,1,4)
plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1))
ylabel('Laser command')

saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

%% Find amplitude of laser-evoked mvt for strongest laser pulse (column 5)
% Calculate delta PD displacements
pd_delay = (Fs/1000)*logfile.data(r,15);            % delay prior to PD PZT calibration pulse (in samples)
pd_duration = (Fs/1000)*logfile.data(r,16);         % duration of PD PZT calibration pulse; logfile gives values in ms
pd_command_amplitude = logfile.data(r,55);          % amplitude of PD PZT calibration pulse
pd_start = pd_delay + 30*(Fs/1000);                 % Since the mvt of PD piezo is delayed, add 20 msec delay to starting sample
pd_end = pd_start + 0.5*pd_duration;
pd_length = pd_end - pd_start;
pre_pd_start = 1;
pre_pd_end = pre_pd_start + 0.8*pd_length;

i=5;
pd_mean_pre     = mean(struct_data(r).data(pre_pd_start:pre_pd_end,i));
pd_mean_during  = mean(struct_data(r).data(pd_start:pd_end,i));
correction_factor = abs(pd_mean_pre - pd_mean_during) / pd_command_amplitude;
   

summary_table = zeros(length(fileList2),2);     % Initialize summary_table 

for r = 1: length(fileList2)
baseline    = mean(struct_data(r).data(laser_delay*Fs-300:laser_delay*Fs-100,5));
peak        = mean(struct_data(r).data(laser_delay*Fs:(laser_delay+laser_duration)*Fs,5));
displacement= abs(peak-baseline) / correction_factor;   % Displacement amplitude scaled by PD pulse

summary_table(r,1) = r;
summary_table(r,2) = displacement;
end

%% Make subplot from smallest to largest Xd
% Sort by amplitude
clf
pd_delay = (Fs/1000)*logfile.data(r,15);            % delay prior to PD PZT calibration pulse (in samples)
pd_duration = (Fs/1000)*logfile.data(r,16);         % duration of PD PZT calibration pulse; logfile gives values in ms
pd_command_amplitude = logfile.data(r,55);          % amplitude of PD PZT calibration pulse
pd_start = pd_delay + 30*(Fs/1000);                 % Since the mvt of PD piezo is delayed, add 20 msec delay to starting sample
pd_end = pd_start + 0.5*pd_duration;
pd_length = pd_end - pd_start;
pre_pd_start = 1;
pre_pd_end = pre_pd_start + 0.8*pd_length;
Xd_sort = sortrows(summary_table,2);

i=5;
for m = 3:length(Xd_sort) % start at index 3 if I only want to plot 36; otherwise start at 1 to plot all; also need to change subplot settings
    r = Xd_sort(m,1);
    pd_mean_pre     = mean(struct_data(r).data(pre_pd_start:pre_pd_end,i));
    pd_mean_during  = mean(struct_data(r).data(pd_start:pd_end,i));
    correction_factor = abs(pd_mean_pre - pd_mean_during) / pd_command_amplitude;

    dc_offset = mean(struct_data(r).data(1:100,i)); % The first 100 points give the dc offset
    subplot_tight(6,6,m-2,[0.0 0.015]);
    displ = struct_data(r).data(Fs*(laser_delay+0.5*laser_duration),i);
    baseline = struct_data(r).data(Fs*(laser_delay)-10,i);
    if displ > baseline
        plot(t,(struct_data(r).data(:,i)-dc_offset)/correction_factor,'k');
    else
        plot(t,-((struct_data(r).data(:,i)-dc_offset)/correction_factor),'k');  
    end
    hold on
    
    j=line([0.2 0.24],[-40 -40]);
    set(j,'LineWidth',[2],'Color',[1,0.2,0.2]);
    set(gca,'XTick',[],'YTick',[]);
    xlim([0 0.3])
    ylim([-40 142])
    
    axis off
end
h=line([0.1 0.1],[20 50]);
    set(h,'LineWidth',[2],'Color',[0.3,0.2,1]);
    set(gca,'XTick',[],'YTick',[]);

saveas(gcf,strcat('DataFig_38records',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_38records_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_38records_e',num2str(r),'eps'),'epsc');
