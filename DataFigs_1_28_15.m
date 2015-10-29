% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-01-28.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%% Plot current, voltage, laser command, laser pick-off
for r = 1:length(fileList2);
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
    
    subplot(6,1,1:2)
    plot(t,struct_data(r).data(:,0*wavetrain+2:1*wavetrain+1));
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',12)
    ylabel('Current (pA)');
    subplot(6,1,3:4)
    plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1));
    ylabel('Voltage Step (mV)');
    subplot(6,1,5)
    plot(t,struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1));
    ylabel('Laser Command (V)');
    xlabel('Time (seconds)');
    subplot(6,1,6)
    plot(t,struct_data(r).data(:,3*wavetrain+2:4*wavetrain+1));
    ylabel('Laser Pick-off');
    xlabel('Time (seconds)');
    
    saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

%% Plot resistance
for r = 1:length(fileList2);
logfile_name        = getfield(dir('*.log'),'name');
logfile_name_clean  = logfile_name(1:end-7);            % remove excess numbers from filename, for use in figure titles below
logfile             = importdata(logfile_name);
wavetrain           = logfile.data(r,8);                % get number of wavetrains [actually waveforms] for that run
laser_delay         = logfile.data(r,43)*.001;          % in milliseconds
laser_duration      = logfile.data(r,44)*.001;          % in milliseconds
vstep_delay         = logfile.data(r,29)*.001;
vstep_duration      = logfile.data(r,30)*.001;
laser_voltage       = logfile.data(r,63);
probe_pzt_delay     = logfile.data(r,22)*0.001;         % in seconds
probe_pzt_duration  = logfile.data(r,23)*0.001;         % in seconds
beta                = logfile.data(4,106);
Fs                  = logfile.data(r,12);               % sampling rate
T                   = 1/Fs;
L                   = length(struct_data(r).data(:,2));    
t                   = (0:L-1)*T;  

band_width = 40;                                        % number of points in each time band
n_bands = vstep_duration * Fs / band_width;             % number of time bands
base_start = 1;                                         % first point of teh trace
base_end = vstep_delay * Fs;                            % point at which voltage step comes on

res_matrix = zeros(wavetrain,n_bands);                  % initialize resistance matrix

for i = 1:wavetrain
    base_current = mean(struct_data(r).data(base_start : base_end,i+1));
    for n = 1:n_bands
        current = mean(struct_data(r).data(Fs*vstep_delay + (n-1)*band_width : Fs*vstep_delay + n*band_width,i+1)) - base_current;
        voltage = mean(struct_data(r).data(Fs*vstep_delay + (n-1)*band_width : Fs*vstep_delay + n*band_width,i+1+wavetrain));
        res_matrix(i,n) = voltage / current * 1000;
    end
end
 
clf
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));

subplot(6,1,1)
plot(t,struct_data(r).data(:,0*wavetrain+2:1*wavetrain+1));
title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',12)
axis([0 t(end) min(min(struct_data(r).data(:,0*wavetrain+2:1*wavetrain+1))) 1.2*max(max(struct_data(r).data(:,0*wavetrain+2:1*wavetrain+1)))])
ylabel('Current (pA)');

subplot(6,1,2:4)
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
x_samples = [vstep_delay*Fs + band_width/2 : 40 : Fs*(vstep_delay + vstep_duration) - band_width/2];    % sample values in the middle of each band
x = x_samples/Fs;       % the time values against which resistances will be plotted
plot(x,res_matrix(:,:),'LineWidth',2)
axis([0 t(end) mean(mean(res_matrix))-5*std(res_matrix(end,:)) mean(mean(res_matrix))+5*std(res_matrix(end,:))])
ylim = get(gca, 'YLim');
x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 
ylabel('Resistance (MOhm)')  

subplot(6,1,5)
plot(t,struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1),'LineWidth',2);
axis([0 t(end) min(min(struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1))) 1.2*max(max(struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1)))])
ylabel('Laser Command (V)');
xlabel('Time (seconds)');

subplot(6,1,6)
plot(t,struct_data(r).data(:,3*wavetrain+2:4*wavetrain+1),'LineWidth',2);
axis([0 t(end) min(min(struct_data(r).data(:,3*wavetrain+2:4*wavetrain+1))) 1.2*max(max(struct_data(r).data(:,3*wavetrain+2:4*wavetrain+1)))])
ylabel('Laser Pick-off');
xlabel('Time (seconds)');

saveas(gcf,strcat('Res_hirate_Record',num2str(r),'.pdf'));
saveas(gcf,strcat('Res_hirate_Record_m',num2str(r),'fig'));
saveas(gcf,strcat('Res_hirate_Record_e',num2str(r),'eps'),'epsc');
end

