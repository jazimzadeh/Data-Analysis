% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-08-28.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%% 
for r = 1:7;
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
    beta                = logfile.data(4,106);
    Fs                  = logfile.data(r,12);               % sampling rate
    T                   = 1/Fs;
    L                   = length(struct_data(r).data(:,2));    
    t                   = (0:L-1)*T;        
    % Displacement
    dc_offset = mean(struct_data(r).data(1:0.01*Fs,2));
    pd_pulse_peak = mean(struct_data(r).data(0.034*Fs:0.059*Fs,2));
    pd_pulse_ampl = pd_pulse_peak - dc_offset;
    cfactor = pd_pulse_ampl / 30;
    struct_data(r).data_zeroed_scaled = (struct_data(r).data(:,2) - dc_offset)/cfactor;
    plot(t,struct_data(r).data_zeroed_scaled(:,1),'k');
    ylabel('Displacement (nm)');
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    
    saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

%%
subplot_tight(1,3,1,[0.3 0.04])
h1 = plot(t,struct_data(1).data_zeroed_scaled(:,1),'color',[0.6 0.6 0.6]);
hold on
h2 = plot(t,struct_data(2).data_zeroed_scaled(:,1),'color',[1 0.2 0.2]);
h3 = plot(t,struct_data(3).data_zeroed_scaled(:,1),'color',[0 0.3 1]);
legend([h1 h2 h3 ],'No mask - imaged top', 'Top masked - imaged bottom', 'No mask - imaged bottom','Image bottom, top masked','Image bottom, no mask','location','NorthWest')
axis([0 0.22 -10 70])
ylabel('Displacement (nm)');
xlabel('Time (s)');
title('Recs 1-3')

subplot_tight(1,3,2,[0.3 0.04])
h4 = plot(t,struct_data(4).data_zeroed_scaled(:,1),'color',[1 0.2 0.2]);
hold on
h5 = plot(t,struct_data(5).data_zeroed_scaled(:,1),'color',[0 0.3 1]);
legend([h4 h5],'Top masked - imaged bottom','No mask - imaged bottom','location','NorthWest')
axis([0 0.22 -10 70])
xlabel('Time (s)');
title('Recs 4-5')

subplot_tight(1,3,3,[0.3 0.04])
h6 = plot(t,struct_data(6).data_zeroed_scaled(:,1),'color',[1 0.2 0.2]);
hold on
h7 = plot(t,struct_data(7).data_zeroed_scaled(:,1),'color',[0 0.3 1]);
legend([h6 h7],'Bottom masked - imaged top','No mask - imaged top','location','NorthWest')
axis([0 0.22 -10 70])
xlabel('Time (s)');
title('Recs 6-7')

saveas(gcf,strcat('Overlaid_8_28_15_mfig'));
saveas(gcf,strcat('Overlaid_8_28_15_e'),'epsc');
