% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-09-09.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%% 
for r = 1:9;
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

%% Overlaid plots - HB2
clf
annotation('textbox',[0.05 0.9 0.2 0.05],'String','9/9/15 HB2','FontSize',18)

subplot_tight(4,3,2,[0.05 0.05])
r = 2;
wavetrain           = logfile.data(r,8);
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
for j = 2:wavetrain+1
    h1 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
ylabel('Displacement (nm)');
title('Rec 2 - Top masked, Im. bottom')
axis([0 0.25 -20 50])
set(gca,'XTickLabel',[])

r = 3;
wavetrain           = logfile.data(r,8);
subplot_tight(4,3,3,[0.05 0.05])
for j = 2:wavetrain+1
    h2 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
%legend([h1 h2],'Top masked - imaged bottom', 'No mask - imaged bottom','location','NorthWest')
axis([0 0.25 -20 50])
set(gca,'XTickLabel',[])
title('Rec 3 - No mask, Im. bottom')

subplot_tight(4,3,12,[0.05 0.05])
r = 4;
wavetrain           = logfile.data(r,8);
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
for j = 2:wavetrain+1
    h1 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
%ylabel('Displacement (nm)');
title('Rec 4 - No mask, Im. top')
axis([0 0.25 -50 40])
%set(gca,'XTickLabel',[])
xlabel('Time (sec)')

subplot_tight(4,3,5,[0.05 0.05])
r = 5;
wavetrain           = logfile.data(r,8);
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
for j = 2:wavetrain+1
    h1 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
ylabel('Displacement (nm)');
title('Rec 5 - Bottom masked, Im. top')
axis([0 0.25 -50 40])
set(gca,'XTickLabel',[])

r = 6;
wavetrain           = logfile.data(r,8);
subplot_tight(4,3,6,[0.05 0.05])
for j = 2:wavetrain+1
    h2 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
%legend([h1 h2],'Top masked - imaged bottom', 'No mask - imaged bottom','location','NorthWest')
axis([0 0.25 -50 40])
set(gca,'XTickLabel',[])
title('Rec 6 - No mask, Im. top')

subplot_tight(4,3,8,[0.05 0.05])
r = 7;
wavetrain           = logfile.data(r,8);
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
for j = 2:wavetrain+1
    h1 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
ylabel('Displacement (nm)');
title('Rec 7 - Top masked, Im. bottom')
axis([0 0.25 -20 40])
set(gca,'XTickLabel',[])

r = 8;
wavetrain           = logfile.data(r,8);
subplot_tight(4,3,9,[0.05 0.05])
for j = 2:wavetrain+1
    h2 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
%legend([h1 h2],'Top masked - imaged bottom', 'No mask - imaged bottom','location','NorthWest')
axis([0 0.25 -20 40])
set(gca,'XTickLabel',[])
title('Rec 8 - No mask, Im. bottom')

subplot_tight(4,3,11,[0.05 0.05])
r = 9;
wavetrain           = logfile.data(r,8);
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
for j = 2:wavetrain+1
    h1 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
ylabel('Displacement (nm)');
title('Rec 9 - No mask, Im. top')
axis([0 0.25 -50 40])
xlabel('Time (sec)')

saveas(gcf,strcat('Overlaid_9_9_15_HB2_mfig'));
saveas(gcf,strcat('Overlaid_9_9_15_HB2_e'),'epsc');


