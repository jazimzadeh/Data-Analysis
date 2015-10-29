% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-07-21.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list



%% Plot laser displacements as function of power, to find threshold of motion
for r = 1:8;
clf
logfile_name        = getfield(dir('*.log'),'name');
logfile_name_clean  = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile             = importdata(logfile_name);
wavetrain           = logfile.data(r,8);              % get number of wavetrains [actually waveforms] for that run
laser_delay         = logfile.data(r,43)*.001;      % in milliseconds
laser_duration      = logfile.data(r,44)*.001;   % in milliseconds
laser_voltage       = logfile.data(r,63);
probe_pzt_delay     = logfile.data(r,22)*0.001; % in seconds
probe_pzt_duration  = logfile.data(r,23)*0.001;  % in seconds
beta                = logfile.data(4,106);
Fs                  = logfile.data(r,12);                                 % sampling rate
T                   = 1/Fs;
L                   = length(struct_data(r).data(:,2));    
t                   = (0:L-1)*T;

set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));

subplot(2,5,2:4)
laser_start_pts = laser_delay*Fs;
laser_end_pts   = (laser_delay + laser_duration) * Fs;

for i = 2:wavetrain+1
    power(i-1) = voltage_to_power(mean(struct_data(r).data(laser_start_pts:laser_end_pts,i+wavetrain)));
end

for i = 2:wavetrain+1
    dc_offset = mean(struct_data(r).data(laser_start_pts-(0.01*Fs):laser_start_pts,i));
    h = plot(power(i-1), abs(mean(struct_data(r).data(laser_start_pts:laser_end_pts,i))-dc_offset),'.','MarkerSize',16);
    hold all
end
ylabel('Displacement avg (nm)')
xlabel('Power (mW)')

title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',13)

subplot(2,2,3)
for i = 2:wavetrain+1
    dc_offset = mean(struct_data(r).data(laser_start_pts-(0.01*Fs):laser_start_pts,i));
    plot(t(1:10:end),struct_data(r).data(1:10:end,i)-dc_offset);
    hold all
end
%axis([0 0.4 -0.5 5.5])
ylabel('Bundle displacement (nm)')
xlabel('Time (sec)')

subplot(2,2,4)
plot(t(1:10:end),struct_data(r).data(1:10:end,wavetrain+2:2*wavetrain+1))
ylabel('Voltage command (V)')
xlabel('Time (sec)')

saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

%%
for r = 1;
clf
logfile_name        = getfield(dir('*.log'),'name');
logfile_name_clean  = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile             = importdata(logfile_name);
wavetrain           = logfile.data(r,8);              % get number of wavetrains [actually waveforms] for that run
laser_delay         = logfile.data(r,43)*.001;      % in milliseconds
laser_duration      = logfile.data(r,44)*.001;   % in milliseconds
laser_voltage       = logfile.data(r,63);
probe_pzt_delay     = logfile.data(r,22)*0.001; % in seconds
probe_pzt_duration  = logfile.data(r,23)*0.001;  % in seconds
beta                = logfile.data(4,106);
Fs                  = logfile.data(r,12);                                 % sampling rate
T                   = 1/Fs;
L                   = length(struct_data(r).data(:,2));    
t                   = (0:L-1)*T;

set(0, 'DefaultAxesColorOrder', ametrine(5));

laser_start_pts = laser_delay*Fs;
laser_end_pts   = (laser_delay + laser_duration) * Fs;

for i = [6 8 12 16 20]
    subplot(2,2,1)
    dc_offset = mean(struct_data(r).data(laser_start_pts-(0.01*Fs):laser_start_pts,i));
    d = struct_data(r).data(:,i)-dc_offset;
    dnorm = (struct_data(r).data(:,i)-dc_offset)/(min(struct_data(r).data(:,i)-dc_offset));
    h1 = plot(t(4400:6400),dnorm(4400:6400),'linewidth',1);
    axis([0.22 0.32 -0.2 1.2])
    hold all
    subplot(2,2,2)
    h2 = plot(t(4400:6400),abs(d(4400:6400)),'linewidth',1);
    hold all
    xlim([0.22 0.32])
end

ylabel('Bundle displacement (nm)')
xlabel('Time (sec)')
subplot(2,2,1) % Just added this here so the title would go over this plot
title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',13)

saveas(gcf,strcat('DataFig_normalized_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_normalized_e',num2str(r),'eps'),'epsc');
end
%%
for r = 2;
clf
logfile_name        = getfield(dir('*.log'),'name');
logfile_name_clean  = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile             = importdata(logfile_name);
wavetrain           = logfile.data(r,8);              % get number of wavetrains [actually waveforms] for that run
laser_delay         = logfile.data(r,43)*.001;      % in milliseconds
laser_duration      = logfile.data(r,44)*.001;   % in milliseconds
laser_voltage       = logfile.data(r,63);
probe_pzt_delay     = logfile.data(r,22)*0.001; % in seconds
probe_pzt_duration  = logfile.data(r,23)*0.001;  % in seconds
beta                = logfile.data(4,106);
Fs                  = logfile.data(r,12);                                 % sampling rate
T                   = 1/Fs;
L                   = length(struct_data(r).data(:,2));    
t                   = (0:L-1)*T;

set(0, 'DefaultAxesColorOrder', ametrine(5));

laser_start_pts = laser_delay*Fs;
laser_end_pts   = (laser_delay + laser_duration) * Fs;

for i =  [20 24 28 32 36]
    subplot(2,2,1)
    dc_offset = mean(struct_data(r).data(laser_start_pts-(0.01*Fs):laser_start_pts,i));
    d = struct_data(r).data(:,i)-dc_offset;
    dnorm = (struct_data(r).data(:,i)-dc_offset)/(min(struct_data(r).data(4400:6400,i)-dc_offset));
    h1 = plot(t(4400:6400),dnorm(4400:6400),'linewidth',1);
    axis([0.22 0.32 -0.2 1.1])
    hold all
    subplot(2,2,2)
    h2 = plot(t(4400:6400),abs(d(4400:6400)),'linewidth',1);
    hold all
    xlim([0.22 0.32])
end

ylabel('Bundle displacement (nm)')
xlabel('Time (sec)')
subplot(2,2,1) % Just added this here so the title would go over this plot
title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',13)

saveas(gcf,strcat('DataFig_normalized_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_normalized_e',num2str(r),'eps'),'epsc');
end
%%
for r = 4;
clf
logfile_name        = getfield(dir('*.log'),'name');
logfile_name_clean  = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile             = importdata(logfile_name);
wavetrain           = logfile.data(r,8);              % get number of wavetrains [actually waveforms] for that run
laser_delay         = logfile.data(r,43)*.001;      % in milliseconds
laser_duration      = logfile.data(r,44)*.001;   % in milliseconds
laser_voltage       = logfile.data(r,63);
probe_pzt_delay     = logfile.data(r,22)*0.001; % in seconds
probe_pzt_duration  = logfile.data(r,23)*0.001;  % in seconds
beta                = logfile.data(4,106);
Fs                  = logfile.data(r,12);                                 % sampling rate
T                   = 1/Fs;
L                   = length(struct_data(r).data(:,2));    
t                   = (0:L-1)*T;

set(0, 'DefaultAxesColorOrder', ametrine(3));

laser_start_pts = laser_delay*Fs;
laser_end_pts   = (laser_delay + laser_duration) * Fs;

for i =  [ 16 20 28 ]
    subplot(2,2,1)
    dc_offset = mean(struct_data(r).data(laser_start_pts-(0.01*Fs):laser_start_pts,i));
    d = struct_data(r).data(:,i)-dc_offset;
    dnorm = (struct_data(r).data(:,i)-dc_offset)/(min(struct_data(r).data(2400:4400,i)-dc_offset));
    h1 = plot(t(2400:4400),dnorm(2400:4400),'linewidth',1);
    axis([0.12 0.22 -0.2 1.1])
    hold all
    subplot(2,2,2)
    h2 = plot(t(2400:4400),abs(d(2400:4400)),'linewidth',1);
    hold all
    xlim([0.12 0.22])
end

ylabel('Bundle displacement (nm)')
xlabel('Time (sec)')
subplot(2,2,1) % Just added this here so the title would go over this plot
title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',13)

saveas(gcf,strcat('DataFig_normalized_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_normalized_e',num2str(r),'eps'),'epsc');
end
%%
for r = 7;
clf
logfile_name        = getfield(dir('*.log'),'name');
logfile_name_clean  = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile             = importdata(logfile_name);
wavetrain           = logfile.data(r,8);              % get number of wavetrains [actually waveforms] for that run
laser_delay         = logfile.data(r,43)*.001;      % in milliseconds
laser_duration      = logfile.data(r,44)*.001;   % in milliseconds
laser_voltage       = logfile.data(r,63);
probe_pzt_delay     = logfile.data(r,22)*0.001; % in seconds
probe_pzt_duration  = logfile.data(r,23)*0.001;  % in seconds
beta                = logfile.data(4,106);
Fs                  = logfile.data(r,12);                                 % sampling rate
T                   = 1/Fs;
L                   = length(struct_data(r).data(:,2));    
t                   = (0:L-1)*T;

set(0, 'DefaultAxesColorOrder', ametrine(4));

laser_start_pts = laser_delay*Fs;
laser_end_pts   = (laser_delay + laser_duration) * Fs;

for i =  [4 6 8 10]
    subplot(2,2,1)
    dc_offset = mean(struct_data(r).data(laser_start_pts-(0.01*Fs):laser_start_pts,i));
    d = struct_data(r).data(:,i)-dc_offset;
    dnorm = (struct_data(r).data(:,i)-dc_offset)/(min(struct_data(r).data(2400:4400,i)-dc_offset));
    h1 = plot(t(2400:4400),dnorm(2400:4400),'linewidth',1);
    axis([0.12 0.22 -0.2 1.1])
    hold all
    subplot(2,2,2)
    h2 = plot(t(2400:4400),abs(d(2400:4400)),'linewidth',1);
    hold all
    xlim([0.12 0.22])
end

ylabel('Bundle displacement (nm)')
xlabel('Time (sec)')
subplot(2,2,1) % Just added this here so the title would go over this plot
title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',13)

saveas(gcf,strcat('DataFig_normalized_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_normalized_e',num2str(r),'eps'),'epsc');
end
%%
for r = 8;
clf
logfile_name        = getfield(dir('*.log'),'name');
logfile_name_clean  = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile             = importdata(logfile_name);
wavetrain           = logfile.data(r,8);              % get number of wavetrains [actually waveforms] for that run
laser_delay         = logfile.data(r,43)*.001;      % in milliseconds
laser_duration      = logfile.data(r,44)*.001;   % in milliseconds
laser_voltage       = logfile.data(r,63);
probe_pzt_delay     = logfile.data(r,22)*0.001; % in seconds
probe_pzt_duration  = logfile.data(r,23)*0.001;  % in seconds
beta                = logfile.data(4,106);
Fs                  = logfile.data(r,12);                                 % sampling rate
T                   = 1/Fs;
L                   = length(struct_data(r).data(:,2));    
t                   = (0:L-1)*T;

set(0, 'DefaultAxesColorOrder', ametrine(4));

laser_start_pts = laser_delay*Fs;
laser_end_pts   = (laser_delay + laser_duration) * Fs;

for i =  [20 27 36 40]
    subplot(2,2,1)
    dc_offset = mean(struct_data(r).data(laser_start_pts-(0.01*Fs):laser_start_pts,i));
    d = struct_data(r).data(:,i)-dc_offset;   
    dnorm = (struct_data(r).data(:,i)-dc_offset)/(min(struct_data(r).data(2400:4400,i)-dc_offset));
    h1 = plot(t(2400:4400),dnorm(2400:4400),'linewidth',1);
    axis([0.12 0.22 -0.2 1.1])
    hold all
    subplot(2,2,2)
    h2 = plot(t(2400:4400),abs(d(2400:4400)),'linewidth',1);
    hold all
    xlim([0.12 0.22])
end

ylabel('Bundle displacement (nm)')
xlabel('Time (sec)')
subplot(2,2,1) % Just added this here so the title would go over this plot
title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',13)

saveas(gcf,strcat('DataFig_normalized_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_normalized_e',num2str(r),'eps'),'epsc');
end
%%
for r = 8;
clf
logfile_name        = getfield(dir('*.log'),'name');
logfile_name_clean  = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile             = importdata(logfile_name);
wavetrain           = logfile.data(r,8);              % get number of wavetrains [actually waveforms] for that run
laser_delay         = logfile.data(r,43)*.001;      % in milliseconds
laser_duration      = logfile.data(r,44)*.001;   % in milliseconds
laser_voltage       = logfile.data(r,63);
probe_pzt_delay     = logfile.data(r,22)*0.001; % in seconds
probe_pzt_duration  = logfile.data(r,23)*0.001;  % in seconds
beta                = logfile.data(4,106);
Fs                  = logfile.data(r,12);                                 % sampling rate
T                   = 1/Fs;
L                   = length(struct_data(r).data(:,2));    
t                   = (0:L-1)*T;

set(0, 'DefaultAxesColorOrder', hsv(3));

laser_start_pts = laser_delay*Fs;
laser_end_pts   = (laser_delay + laser_duration) * Fs;

for i =  [26 27 28]
    subplot(2,2,1)
    dc_offset = mean(struct_data(r).data(laser_start_pts-(0.01*Fs):laser_start_pts,i));
    d = struct_data(r).data(:,i)-dc_offset;   
    dnorm = (struct_data(r).data(:,i)-dc_offset)/(min(struct_data(r).data(2400:4400,i)-dc_offset));
    h1 = plot(t(2400:4400),dnorm(2400:4400),'linewidth',1);
    axis([0.12 0.22 -0.2 1.1])
    hold all
    subplot(2,2,2)
    h2 = plot(t(2400:4400),abs(d(2400:4400)),'linewidth',1);
    hold all
    xlim([0.12 0.22])
end

ylabel('Bundle displacement (nm)')
xlabel('Time (sec)')
subplot(2,2,1) % Just added this here so the title would go over this plot
title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',13)

saveas(gcf,strcat('DataFig_kinetic_changes_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_kinetic_changes_e',num2str(r),'eps'),'epsc');
end