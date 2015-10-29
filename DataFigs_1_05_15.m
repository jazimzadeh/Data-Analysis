% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-01-05.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list
% Now to plot: plot(struct_data(4).data)

% % Make a nested structure with 
% for i = 1:length(fileList)
%     FileName = fileList(i).name;    % Pull out the name of the file
% %     struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
%     helpvar = importdata(FileName);
%     struct_data(i).data = helpvar.data;
%     struct_data(i).textdata = helpvar.textdata;
% end


% To call one experiment, use the following as the name of the data file:
% struct_data.dataN.data, where N is the run number
% for example: plot(struct_data.data1.data(:,2))

%%
for r = 1:2;
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

h1 = subplot(2,2,1);
plot(t(1:1:end),struct_data(r).data(1:1:end,5*wavetrain+2:6*wavetrain+1),'k');
ylabel('Laser Voltage Command')
axis([0 0.2 -0.5 6])


title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',13)

h2 = subplot(2,2,3)
plot(t(1:1:end),struct_data(r).data(1:1:end,6*wavetrain+2:7*wavetrain+1),'k');
ylabel('Picked-off power')
axis([0 0.2 -0.5 10])

linkaxes([h1 h2],'x');

h3 = subplot(2,2,2);
plot(t(1:1:end),struct_data(r).data(1:1:end,5*wavetrain+2:6*wavetrain+1),'k');
ylabel('Laser Voltage Command')
axis([0.099 0.1015 -0.5 6])

title('Blow-up around ramp region')

h4 = subplot(2,2,4)
plot(t(1:1:end),struct_data(r).data(1:1:end,6*wavetrain+2:7*wavetrain+1),'k');
ylabel('Picked-off power')
axis([0.099 0.1015 -0.5 10])

linkaxes([h3 h4],'x');

saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end




%% Plot records 6-9
r = 6;

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

h1 = subplot(4,2,1);
plot(t(1:1:end),struct_data(r).data(1:1:end,6*wavetrain+2:7*wavetrain+1),'m');
ylabel('Laser Pick-off')
axis([0 0.2 -0.5 7])
title('1/5/2015 - Records 6-9')

h2 = subplot(4,2,2);
dc = mean(struct_data(r).data(1:100,wavetrain+2:2*wavetrain+1));
plot(t(1:1:end),struct_data(r).data(1:1:end,wavetrain+2:2*wavetrain+1)-dc,'k');
ylabel('Displacement (nm)')
axis([0 0.2 -20 45])


%
r = 7;
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

h3 = subplot(4,2,3);
plot(t(1:1:end),struct_data(r).data(1:1:end,6*wavetrain+2:7*wavetrain+1),'m');
ylabel('Laser Pick-off')
axis([0 0.2 -0.5 7])

h4 = subplot(4,2,4);
dc = mean(struct_data(r).data(1:100,wavetrain+2:2*wavetrain+1));
plot(t(1:1:end),struct_data(r).data(1:1:end,wavetrain+2:2*wavetrain+1)-dc,'k');
ylabel('Displacement (nm)')
axis([0 0.2 -20 45])

%
r = 8;
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

h5 = subplot(4,2,5);
plot(t(1:1:end),struct_data(r).data(1:1:end,6*wavetrain+2:7*wavetrain+1),'m');
ylabel('Laser Pick-off')
axis([0 0.2 -0.5 7])

h6 = subplot(4,2,6);
dc = mean(struct_data(r).data(1:100,wavetrain+2:2*wavetrain+1));
plot(t(1:1:end),struct_data(r).data(1:1:end,wavetrain+2:2*wavetrain+1)-dc,'k');
ylabel('Displacement (nm)')
axis([0 0.2 -20 45])


%
r = 9;
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

h7 = subplot(4,2,7);
plot(t(1:1:end),struct_data(r).data(1:1:end,6*wavetrain+2:7*wavetrain+1),'m');
ylabel('Laser Pick-off')
axis([0 0.2 -0.5 7])

h8 = subplot(4,2,8);
dc = mean(struct_data(r).data(1:100,wavetrain+2:2*wavetrain+1));
plot(t(1:1:end),struct_data(r).data(1:1:end,wavetrain+2:2*wavetrain+1)-dc,'k');
ylabel('Displacement (nm)')
axis([0 0.2 -20 45])

    
    
linkaxes([h1 h2 h3 h4 h5 h6 h7 h8],'x');
    
saveas(gcf,strcat('DataFig_Recs6-9','.pdf'));
saveas(gcf,strcat('DataFig_m_Recs6-9','fig'));
saveas(gcf,strcat('DataFig_e_Recs6-9','eps'),'epsc');

%% Plot records 10-13
r = 10;

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

h1 = subplot(4,2,1);
plot(t(1:1:end),struct_data(r).data(1:1:end,6*wavetrain+2:7*wavetrain+1),'m');
ylabel('Laser Pick-off')
axis([0 0.2 -0.5 7])
title('1/5/2015 - Records 10-13')

h2 = subplot(4,2,2);
dc = mean(struct_data(r).data(1:100,wavetrain+2:2*wavetrain+1));
plot(t(1:1:end),struct_data(r).data(1:1:end,wavetrain+2:2*wavetrain+1)-dc,'k');
ylabel('Displacement (nm)')
axis([0 0.2 -30 140])


%
r = 11;
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

h3 = subplot(4,2,3);
plot(t(1:1:end),struct_data(r).data(1:1:end,6*wavetrain+2:7*wavetrain+1),'m');
ylabel('Laser Pick-off')
axis([0 0.2 -0.5 7])

h4 = subplot(4,2,4);
dc = mean(struct_data(r).data(1:100,wavetrain+2:2*wavetrain+1));
plot(t(1:1:end),struct_data(r).data(1:1:end,wavetrain+2:2*wavetrain+1)-dc,'k');
ylabel('Displacement (nm)')
axis([0 0.2 -30 140])

%
r = 12;
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

h5 = subplot(4,2,5);
plot(t(1:1:end),struct_data(r).data(1:1:end,6*wavetrain+2:7*wavetrain+1),'m');
ylabel('Laser Pick-off')
axis([0 0.2 -0.5 7])

h6 = subplot(4,2,6);
dc = mean(struct_data(r).data(1:100,wavetrain+2:2*wavetrain+1));
plot(t(1:1:end),struct_data(r).data(1:1:end,wavetrain+2:2*wavetrain+1)-dc,'k');
ylabel('Displacement (nm)')
axis([0 0.2 -30 140])


%
r = 13;
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

h7 = subplot(4,2,7);
plot(t(1:1:end),struct_data(r).data(1:1:end,6*wavetrain+2:7*wavetrain+1),'m');
ylabel('Laser Pick-off')
axis([0 0.2 -0.5 7])

h8 = subplot(4,2,8);
dc = mean(struct_data(r).data(1:100,wavetrain+2:2*wavetrain+1));
plot(t(1:1:end),struct_data(r).data(1:1:end,wavetrain+2:2*wavetrain+1)-dc,'k');
ylabel('Displacement (nm)')
axis([0 0.2 -30 140])
    
    
linkaxes([h1 h2 h3 h4 h5 h6 h7 h8],'x');
    
saveas(gcf,strcat('DataFig_Recs10-13','.pdf'));
saveas(gcf,strcat('DataFig_m_Recs10-13','fig'));
saveas(gcf,strcat('DataFig_e_Recs10-13','eps'),'epsc');

%% Plot records 14-16
r = 14;

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

h1 = subplot(3,2,1);
plot(t(1:1:end),struct_data(r).data(1:1:end,6*wavetrain+2:7*wavetrain+1),'m');
ylabel('Laser Pick-off')
axis([0 0.2 -0.5 7])
title('1/5/2015 - Records 14-16')

h2 = subplot(3,2,2);
dc = mean(struct_data(r).data(1:100,wavetrain+2:2*wavetrain+1));
plot(t(1:1:end),struct_data(r).data(1:1:end,wavetrain+2:2*wavetrain+1)-dc,'k');
ylabel('Displacement (nm)')
axis([0 0.2 -15 65])


%
r = 15;
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

h3 = subplot(3,2,3);
plot(t(1:1:end),struct_data(r).data(1:1:end,6*wavetrain+2:7*wavetrain+1),'m');
ylabel('Laser Pick-off')
axis([0 0.2 -0.5 7])

h4 = subplot(3,2,4);
dc = mean(struct_data(r).data(1:100,wavetrain+2:2*wavetrain+1));
plot(t(1:1:end),struct_data(r).data(1:1:end,wavetrain+2:2*wavetrain+1)-dc,'k');
ylabel('Displacement (nm)')
axis([0 0.2 -15 65])

%
r = 16;
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

h5 = subplot(3,2,5);
plot(t(1:1:end),struct_data(r).data(1:1:end,6*wavetrain+2:7*wavetrain+1),'m');
ylabel('Laser Pick-off')
axis([0 0.2 -0.5 7])

h6 = subplot(3,2,6);
dc = mean(struct_data(r).data(1:100,wavetrain+2:2*wavetrain+1));
plot(t(1:1:end),struct_data(r).data(1:1:end,wavetrain+2:2*wavetrain+1)-dc,'k');
ylabel('Displacement (nm)')
axis([0 0.2 -15 65])
    
    
linkaxes([h1 h2 h3 h4 h5 h6],'x');
    
saveas(gcf,strcat('DataFig_Recs14-16','.pdf'));
saveas(gcf,strcat('DataFig_m_Recs14-16','fig'));
saveas(gcf,strcat('DataFig_e_Recs14-16','eps'),'epsc');

%% Plot records 17-18
r = 17;

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

h1 = subplot(2,2,1);
plot(t(1:1:end),struct_data(r).data(1:1:end,6*wavetrain+2:7*wavetrain+1),'m');
ylabel('Laser Pick-off')
axis([0 0.2 -0.5 7])
title('1/5/2015 - Records 17-18')

h2 = subplot(2,2,2);
dc = mean(struct_data(r).data(1:100,wavetrain+2:2*wavetrain+1));
plot(t(1:1:end),struct_data(r).data(1:1:end,wavetrain+2:2*wavetrain+1)-dc,'k');
ylabel('Displacement (nm)')
axis([0 0.2 -15 55])


%
r = 18;
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

h3 = subplot(2,2,3);
plot(t(1:1:end),struct_data(r).data(1:1:end,6*wavetrain+2:7*wavetrain+1),'m');
ylabel('Laser Pick-off')
axis([0 0.2 -0.5 7])

h4 = subplot(2,2,4);
dc = mean(struct_data(r).data(1:100,wavetrain+2:2*wavetrain+1));
plot(t(1:1:end),struct_data(r).data(1:1:end,wavetrain+2:2*wavetrain+1)-dc,'k');
ylabel('Displacement (nm)')
axis([0 0.2 -15 55])
    
    
linkaxes([h1 h2 h3 h4 h5 h6],'x');
    
saveas(gcf,strcat('DataFig_Recs17-18','.pdf'));
saveas(gcf,strcat('DataFig_m_Recs17-18','fig'));
saveas(gcf,strcat('DataFig_e_Recs17-18','eps'),'epsc');

%% Plot records 19-20
r = 19;

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

h1 = subplot(2,2,1);
plot(t(1:1:end),struct_data(r).data(1:1:end,6*wavetrain+2:7*wavetrain+1),'m');
ylabel('Laser Pick-off')
axis([0 0.2 -0.5 7])
title('1/5/2015 - Records 19-20')

h2 = subplot(2,2,2);
dc = mean(struct_data(r).data(1:100,wavetrain+2:2*wavetrain+1));
plot(t(1:1:end),struct_data(r).data(1:1:end,wavetrain+2:2*wavetrain+1)-dc,'k');
ylabel('Displacement (nm)')
axis([0 0.2 -15 85])


%
r = 20;
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

h3 = subplot(2,2,3);
plot(t(1:1:end),struct_data(r).data(1:1:end,6*wavetrain+2:7*wavetrain+1),'m');
ylabel('Laser Pick-off')
axis([0 0.2 -0.5 7])

h4 = subplot(2,2,4);
dc = mean(struct_data(r).data(1:100,wavetrain+2:2*wavetrain+1));
plot(t(1:1:end),struct_data(r).data(1:1:end,wavetrain+2:2*wavetrain+1)-dc,'k');
ylabel('Displacement (nm)')
axis([0 0.2 -15 85])
    
    
linkaxes([h1 h2 h3 h4],'x');
    
saveas(gcf,strcat('DataFig_Recs19-20','.pdf'));
saveas(gcf,strcat('DataFig_m_Recs19-20','fig'));
saveas(gcf,strcat('DataFig_e_Recs19-20','eps'),'epsc');
