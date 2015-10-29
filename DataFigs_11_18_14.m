% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-11-18.01/Ear 1/Cell 1')
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



%% Plot picked-off laser power - 5V (Recs 1 & 4)
r=1;
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


h1 = subplot(2,1,1);plot(t(1:1:end),struct_data(1).data(1:1:end,6));
hold on
plot(t,struct_data(1).data(:,5)*0.001+0.002,'k')
axis([0 0.3 0 13e-3])

title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',13)
    
h2 = subplot(2,1,2);plot(t,struct_data(4).data(:,6));
hold on
plot(t,struct_data(4).data(:,5)*0.001+0.002,'k')
linkaxes([h1 h2],'xy');
title('Picked-off Power')

%% Plot picked-off laser power - 3V (Recs 2 & 3)
r=2;
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


h1 = subplot(2,1,1);plot(t(1:1:end),struct_data(2).data(1:1:end,6));
hold on
plot(t,struct_data(1).data(:,5)*0.001+0.002,'k')
axis([0 0.3 0 13e-3])

title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',13)
    
h2 = subplot(2,1,2);plot(t,struct_data(3).data(:,6));
hold on
plot(t,struct_data(4).data(:,5)*0.001+0.002,'k')
linkaxes([h1 h2],'xy');
title('Picked-off Power')

%%
for r = 6:length(fileList2)
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

h1 = subplot(4,1,1);
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
plot(t(1:1:end),struct_data(r).data(1:1:end,3*wavetrain+2:4*wavetrain+1));
ylabel('Laser Voltage')

title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',13)

h2 = subplot(4,1,2);
plot(t(1:1:end),struct_data(r).data(1:1:end,4*wavetrain+2:5*wavetrain+1));
ylabel('Pick-off')

h3 = subplot(4,1,3:4);
offset = 0;
    for i = (1*wavetrain+2):(2*wavetrain+1)
    plot(t(1:1:end),struct_data(r).data(1:1:end,i)+offset);
    offset = offset + 50;
    hold all
    xlabel('Time (sec)')
    ylabel('Displacement (nm)')
    end
    
 linkaxes([h1 h2 h3],'x');
    
saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

%% Plotting the short laser pulses - these are 30 ms long recordings, but I'm plotting only the first 5 ms
for r = 18:23
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


plot(t(1:1:0.005*Fs),5*struct_data(r).data(1:1:0.005*Fs,3*wavetrain+2:4*wavetrain+1)-15,'m');

title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',13)

hold on
plot(t(1:1:0.005*Fs),struct_data(r).data(1:1:0.005*Fs,4*wavetrain+2:5*wavetrain+1)*1000,'r');

offset = 0;
    for i = (1*wavetrain+2):(2*wavetrain+1)
    dc = mean(struct_data(r).data(1:100,i));
    plot(t(1:1:0.005*Fs),struct_data(r).data(1:1:0.005*Fs,i)+offset-dc,'k');
    offset = offset + 50;
    hold all
    xlabel('Time (sec)')
    ylabel('Displacement (nm)')
    end
    
    
saveas(gcf,strcat('DataFig_together',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_together_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_together_e',num2str(r),'eps'),'epsc');
end







