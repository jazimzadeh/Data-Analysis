% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-11-25.02/Ear 1/Cell 1')
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
for r = 1:length(fileList2)

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
plot(t(1:1:end),struct_data(r).data(1:1:end,5*wavetrain+2:6*wavetrain+1));
ylabel('Laser Pick-off')

title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',13)

h2 = subplot(4,1,2);
plot(t(1:1:end),struct_data(r).data(1:1:end,wavetrain+2:2*wavetrain+1));
ylabel('Probe Offset')

h3 = subplot(4,1,3:4);
offset = 0;
    for i = (2):(wavetrain+1)
    plot(t(1:1:end),struct_data(r).data(1:1:end,i)+offset);
    %offset = offset + 50;
    hold all
    xlabel('Time (sec)')
    ylabel('Displacement (nm)')
    end
    
 linkaxes([h1 h2 h3],'x');
    
saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

%%
r = 11;

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
pd_delay            = logfile.data(r,15)*0.001;         % delay prior to PD PZT calibration pulse
pd_duration         = logfile.data(r,16)*0.001;         % duration of PD PZT calibration pulse; logfile gives values in ms
pd_end              = pd_delay + pd_duration;           % the end (off) time of the PD PZT calibration pulse;
pd_command_amplitude= logfile.data(r,55);               % amplitude of PD PZT calibration pulse
beta                = logfile.data(4,106);
Fs                  = logfile.data(r,12);               % sampling rate
T                   = 1/Fs;
L                   = length(struct_data(r).data(:,2));    
t                   = (0:L-1)*T;

set(0, 'DefaultAxesColorOrder', ametrine(wavetrain+2));
% Plot displacement trace
h1 = subplot(2,1,1);

for i = 2:(wavetrain+1)
    dc_offset = mean(struct_data(r).data(1:pd_delay*Fs,i));
    plot(t(1:1:end),struct_data(r).data(1:1:end,i)-dc_offset);
    hold all
    xlabel('Time (sec)')
    ylabel('Displacement (nm)')
end

% Add shaded and label region for laser
if laser_voltage ~= 0
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.3 ylim(2)-0.3 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    %set(gca,'XTick',[])
    %line([laser_delay; (laser_delay + laser_duration)],[-30; -30],'color','r','linewidth',1.8)
    %line([laser_delay; laser_delay],[-30;30],'color','k')
    textXpos = laser_delay + 0.3*laser_duration;
    textstring = strcat(num2str(laser_voltage), ' Volts');
    text(textXpos,ypos, textstring,'color','r','fontsize',12);
end

% Add comments and run number at top
title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',13)
    
% Calculate amplitudes of laser-evoked movements
baseline    = zeros((2*wavetrain+1)-(wavetrain+2),1);       % Initialize baseline vector.
peak        = zeros((2*wavetrain+1)-(wavetrain+2),1);       % Initialize peak vector.
steady      = zeros((2*wavetrain+1)-(wavetrain+2),1);       % Initialize steady-state vector.

for i = 2 : (wavetrain+1)
    baseline(i-1,1)   = mean(struct_data(r).data(ceil((0.5*(laser_delay - probe_pzt_delay) + probe_pzt_delay)*Fs)   : ceil((0.9*(laser_delay - probe_pzt_delay) + probe_pzt_delay)*Fs) ,i));    % mean position before laser pulse                  % mean right before pulse (85-95 ms);
    peak(i-1,1)       = mean(struct_data(r).data(ceil((laser_delay + 0.001)*Fs)                       : ceil((laser_delay+0.005)*Fs) ,i));                                                % mean position during laser, early
    steady(i-1,1)     = mean(struct_data(r).data(ceil((laser_delay + 0.4*laser_duration)*Fs)          : ceil((laser_delay + 0.8*laser_duration)*Fs) ,i));                   % mean position during laser, late
end

displacements_peak = peak - baseline;
displacements_steady = steady - baseline;

% Draw lines where I take the means
line([(0.5*(laser_delay - probe_pzt_delay) + probe_pzt_delay) (0.9*(laser_delay - probe_pzt_delay) + probe_pzt_delay)] , [-60 -60],'linewidth',2)
line([((laser_delay + 0.001)) ((laser_delay+0.005))] , [-60 -60],'color','g','linewidth',2)
line([(laser_delay + 0.4*laser_duration) (laser_delay + 0.8*laser_duration)] , [-60 -60],'color','r','linewidth',2)

% Find probe offset values
offsets = struct_data(r).data(ceil((probe_pzt_delay + (0.5 * probe_pzt_duration))*Fs) , wavetrain + 2 : 2*wavetrain+1);

subplot(2,5,7:9)
plot(offsets,displacements_peak,'.g','MarkerSize',24)
hold on
plot(offsets,displacements_steady,'.r','MarkerSize',24)
axis([-340 340 -20 70])
ylabel('Displacement (nm)')

saveas(gcf,strcat('DataFig_Rec6_Offsets_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_Rec6_Offsets_e',num2str(r),'eps'),'epsc');





