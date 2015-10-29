% This imports all data files from a single day into one data structure
clear;clc;clf;
close(gcf);
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-05-07.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});

%% Plots
for r = 1: length(fileList2)
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

subplot(4,1,1:2)
plot(t,struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1))
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
axis([0 0.4 -150 150])
ylabel('Current (pA)')
subplot(4,1,3)
plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1))
ylabel('Displacement (nm)')
subplot(4,1,4)
plot(t,struct_data(r).data(:,5*wavetrain+2:6*wavetrain+1))
ylabel('Laser pick-off')

saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

%% I(X) curve for Record 4
r=4;
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

% Initialize
current_peak    = zeros(wavetrain,0);
displ_peak      = zeros(wavetrain,0);
laser_peak      = zeros(wavetrain,0);

start_time  = 0.251  % mark beginning of region to average [sec]
end_time    = 0.256  % end

for i = 1:wavetrain
    column = 21+i;   % go to the 'current' columns
    current_peak(i,1) = mean(struct_data(r).data(start_time*Fs:end_time*Fs,column));
end
current_peak = current_peak - max(current_peak);

for i = 1:wavetrain
    column = 11+i;   % go to the 'current' columns
    displ_peak(i,1) = -mean(struct_data(r).data(start_time*Fs:end_time*Fs,column));
end

for i = 1:wavetrain
    column = 41+i;   % go to the 'current' columns
    lp              = mean(struct_data(r).data(start_time*Fs:end_time*Fs,column));
    laser_peak(i,1) = voltage_to_power(lp);
end
subplot_tight(3,4,2:3,[0.08,0.15])
plot(laser_peak,displ_peak,'.','MarkerSize',20);
axis([-0.5 6 0 25])
xlabel('Laser power (mW)')
ylabel('Displacement (nm)')
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
subplot_tight(3,4,6:7,[0.08,0.15])
plot(laser_peak,abs(current_peak),'.r','MarkerSize',20)
axis([-0.5 6 -5 55])
xlabel('Laser power (mW)')
ylabel('Current pA')
subplot_tight(3,4,10:11,[0.08,0.15])
plot(displ_peak,abs(current_peak),'.b','MarkerSize',20)
axis([0 25 -5 55])
xlabel('Displacement (nm)')
ylabel('Current (pA)')

saveas(gcf,strcat('I_X_curve',num2str(r),'.pdf'));
saveas(gcf,strcat('I_X_curve_m',num2str(r),'fig'));
saveas(gcf,strcat('I_X_curve_e',num2str(r),'eps'),'epsc');



