% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-02-20.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list


%% Plot Ionto, Displacement, Current, Vm holding, Laser command
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
    
    set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
    
    % Iontophoresis, gentamicin
    subplot(7,1,1)
    plot(t,struct_data(r).data(:,0*wavetrain+2:1*wavetrain+1));
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',12)
    ylabel('Iontophoresis current (nA)')
    
    % Displacement
    subplot(7,1,2:3)
    plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1));
    ylabel('Displacement (nm)');
    
    % Current
    subplot(7,1,4:5)
    plot(t,struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1));
    ylabel('Current (pA)');
    
    % Voltage steps (Vm)
    subplot(7,1,6)
    plot(t,struct_data(r).data(:,3*wavetrain+2:4*wavetrain+1));
    ylabel('Voltage (mV)');
    
    % Laser command
    subplot(7,1,7)
    plot(t,struct_data(r).data(:,4*wavetrain+2:5*wavetrain+1));
    ylabel('Laser Voltage');
    
    saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

%%
r=7;
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
    
    clf
     % Displacement
    plot(t(0.12*Fs:0.2*Fs),-3.8*struct_data(r).data(0.12*Fs:0.2*Fs,1*wavetrain+2:2*wavetrain+1)+2460,'k');
    ylabel('Displacement (nm)');
    hold on
   % current
    plot(t(0.12*Fs:0.2*Fs),-struct_data(r).data(0.12*Fs:0.2*Fs,2*wavetrain+2:3*wavetrain+1),'r');
    ylabel('Current (pA)');

    
    