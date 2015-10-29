% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-07-15.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%% Individual Plots
for r=1:length(fileList2);
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

set(0, 'DefaultAxesColorOrder', ametrine(100));

subplot(2,5,2:4)
laser_start_pts = laser_delay*Fs;
laser_end_pts   = (laser_delay + laser_duration) * Fs;
for i = 2:wavetrain+1
plot(mean(struct_data(r).data(laser_start_pts:laser_end_pts,i)), mean(struct_data(r).data(laser_start_pts:laser_end_pts,i+wavetrain)),'r.','MarkerSize',10);
hold all
end

ylabel('Power (mW)')
xlabel('Command Voltage (V)')

title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',13)

subplot(2,2,3)
plot(t(1:10:end),struct_data(r).data(1:10:end,2:wavetrain+1),'k')
ylabel('Command Voltage')
xlabel('Time (sec)')

subplot(2,2,4)
plot(t(1:10:end),struct_data(r).data(1:10:end,wavetrain+2:2*wavetrain+1),'b')
ylabel('Power (mW)')
xlabel('Time (sec)')

saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

%% Compare power at objective with and without Semrock filter
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


laser_start_pts = laser_delay*Fs;
laser_end_pts   = (laser_delay + laser_duration) * Fs;
clf
r=1;
for i = 2:wavetrain+1
h1 = plot(mean(struct_data(r).data(laser_start_pts:laser_end_pts,i)), mean(struct_data(r).data(laser_start_pts:laser_end_pts,i+wavetrain)),'r.','MarkerSize',10);
hold all
end

r=2;
for i = 2:wavetrain+1
h2 = plot(mean(struct_data(r).data(laser_start_pts:laser_end_pts,i)), mean(struct_data(r).data(laser_start_pts:laser_end_pts,i+wavetrain)),'k.','MarkerSize',10);
hold all
end

legend([h1 h2], 'Filter in', 'Filter out','location','NorthWest')
title('Effect of Semrock UV filter on power at objective')
xlabel('Command Voltage')
ylabel('Power (mW)')
set(gca,'FontSize',16)

%% Look for any change in measured power due to wavelength correction
clf
power_visual = [0 0.501 1.876 3.265 4.608 5.455];

% This is the analog out value, which is not wavelength corrected
r=3;
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

for i = 2:wavetrain+1
h1 = plot(mean(struct_data(r).data(laser_start_pts:laser_end_pts,i)), mean(struct_data(r).data(laser_start_pts:laser_end_pts,i+wavetrain)),'k.','MarkerSize',22);
hold all
end

hold on
% This is the wavelength corrected value, which I read off of the power
% meter:
h2 = plot(mean(struct_data(r).data(laser_start_pts:laser_end_pts,2:wavetrain+1)), power_visual,'.r','MarkerSize',22)

legend([h1 h2], 'Analog out (not wavelength-corrected)', 'Wavelength-corrected','location','NorthWest')
title('Effect of wavelength correction on power reading')
xlabel('Command Voltage')
ylabel('Power (mW)')
set(gca,'FontSize',15)

%% Fit the power v. V data and make a function
r=2;
logfile_name        = getfield(dir('*.log'),'name');
logfile_name_clean  = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile             = importdata(logfile_name);
wavetrain           = logfile.data(r,8);   
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

laser_start_pts = laser_delay*Fs;
laser_end_pts   = (laser_delay + laser_duration) * Fs;
for i = 2:wavetrain+1
v(i) = mean(struct_data(r).data(laser_start_pts:laser_end_pts,i));
end

for i = 2:wavetrain+1
p(i) = mean(struct_data(r).data(laser_start_pts:laser_end_pts,i+wavetrain));
end

% Trim the vectors so that the mostly linear region remains. 
% This yields a better fit
pp = p(12:96);
vv = v(12:96);

% Fit a 9th degree polynomial to pp and vv
[xData, yData] = prepareCurveData( vv, pp );

% Set up fittype and options.
ft = fittype( 'poly9' );
opts = fitoptions( ft );
opts.Lower = [-Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf];
opts.Upper = [Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

coefficients = coeffvalues(fitresult);

%% Check the function against the original data
clf
h1 = plot(v,p,'.k')              % Original data
v_test = [0:0.1:5];
for i = 1:length(v_test)
p_test(i) = voltage_to_power(v_test(i));
end
hold on
h2 = plot(v_test,p_test,'.r')    % Power obtained from function

legend([h1 h2], 'Collected power', 'Calculated power','location','NorthWest')
ylabel('Power (mW)')
xlabel('Voltage Command (V)')
title('Verifying the function that calculates power')




