% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-09-18.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%% Plot records
for r = 3:11;
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
    pd_pzt_delay        = logfile.data(r,15)*0.001;
    pd_pzt_duration     = logfile.data(r,16)*0.001;
    beta                = logfile.data(4,106);
    Fs                  = logfile.data(r,12);               % sampling rate
    T                   = 1/Fs;
    L                   = length(struct_data(r).data(:,2));    
    t                   = (0:L-1)*T;        
    % Displacement
    subplot(2,1,1)
    plot(t,struct_data(r).data(:,2:wavetrain+1));
    for wt = 2: wavetrain+1
        dc_offset = mean(struct_data(r).data(1:0.01*Fs,wt));     % get baseline offset
        pd_pulse_peak = mean(struct_data(r).data(0.034*Fs:0.059*Fs,wt));
        pd_pulse_ampl = pd_pulse_peak - dc_offset;
        cfactor = pd_pulse_ampl / 30;
        struct_data(r).data_zeroed_scaled(:,wt) = (struct_data(r).data(:,wt) - dc_offset)/cfactor;
    end
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    
    subplot(2,1,2)
    plot(t,struct_data(r).data_zeroed_scaled(:,2:wavetrain+1));
    ylabel('Displacement (nm)');
    
    saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end
%% Overlaid plots - HB3
clf
annotation('textbox',[0.12 0.4 0.25 0.08],'String','9/18/15 HB3','FontSize',16)

for r = 4:5
    subplot_tight(2,2,r-3,[0.09 0.09])
    wavetrain           = logfile.data(r,8);
    set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
    for j = 2:wavetrain+1
        h1 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
        hold all
    end
    ylabel('Displacement (nm)');
    title(logfile.textdata(r,3))
    axis([0 0.3 -20 40])
    %set(gca,'XTickLabel',[])
end
saveas(gcf,strcat('Overlaid_9_18_15_HB3_mfig'));
saveas(gcf,strcat('Overlaid_9_18_15_HB3_e'),'epsc');

%% Overlaid plots - HB4
clf
annotation('textbox',[0.64 0.24 0.26 0.05],'String','9/18/15 HB4','FontSize',16)

for r = 6:11
    subplot_tight(3,2,r-5,[0.05 0.08])
    wavetrain           = logfile.data(r,8);
    set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
    for j = 2:wavetrain+1
        h1 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
        hold all
    end
    ylabel('Displacement (nm)');
    title(logfile.textdata(r,3))
    axis([0 0.3 -35 60])
    if r < 10
        set(gca,'XTickLabel',[])
    end
end
saveas(gcf,strcat('Overlaid_9_18_15_HB4_mfig'));
saveas(gcf,strcat('Overlaid_9_18_15_HB4_e'),'epsc');

%% HB1 - Lasered spontaneously oscillating bundle
r = 1;
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
pd_pzt_delay        = logfile.data(r,15)*0.001;
pd_pzt_duration     = logfile.data(r,16)*0.001;
beta                = logfile.data(4,106);
Fs                  = logfile.data(r,12);               % sampling rate
T                   = 1/Fs;
L                   = length(struct_data(r).data(:,2));    
t                   = (0:L-1)*T; 

shift = 0;
for wt = 1:wavetrain
   dc_offset = mean(struct_data(r).data(:,wt+1));
   plot(t,-(struct_data(r).data(:,wt+1)-dc_offset)+shift);
   hold on
   shift = shift + 200;
end
title(logfile.textdata(r,3))

saveas(gcf,strcat('LaseringSpOsc_HB',num2str(r),'fig'));
saveas(gcf,strcat('LaseringSpOsc_HB',num2str(r),'eps'),'epsc');

%% HB2 - Lasered spontaneously oscillating bundle
r = 2;
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
pd_pzt_delay        = logfile.data(r,15)*0.001;
pd_pzt_duration     = logfile.data(r,16)*0.001;
beta                = logfile.data(4,106);
Fs                  = logfile.data(r,12);               % sampling rate
T                   = 1/Fs;
L                   = length(struct_data(r).data(:,2));    
t                   = (0:L-1)*T; 

shift = 0;
for wt = 1:wavetrain
   dc_offset = mean(struct_data(r).data(:,wt+1));
   plot(t,(struct_data(r).data(:,wt+1)-dc_offset)+shift);
   hold on
   shift = shift + 150;
end
title(logfile.textdata(r,3))

saveas(gcf,strcat('LaseringSpOsc_HB',num2str(r),'fig'));
saveas(gcf,strcat('LaseringSpOsc_HB',num2str(r),'eps'),'epsc');

