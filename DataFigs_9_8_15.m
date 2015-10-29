% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-09-08.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%% 
for r = 1:31;
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

%% Overlaid plots - HB4
clf
annotation('textbox',[0.05 0.9 0.2 0.05],'String','9/8/15 HB4','FontSize',18)

subplot_tight(4,3,2,[0.05 0.05])
r = 11;
wavetrain           = logfile.data(r,8);
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
for j = 2:wavetrain+1
    h1 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
ylabel('Displacement (nm)');
title('Rec 11 - Top masked (ish), Im. bottom')
axis([0 0.4 -60 65])
set(gca,'XTickLabel',[])

r = 12;
wavetrain           = logfile.data(r,8);
subplot_tight(4,3,3,[0.05 0.05])
for j = 2:wavetrain+1
    h2 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
%legend([h1 h2],'Top masked - imaged bottom', 'No mask - imaged bottom','location','NorthWest')
axis([0 0.4 -60 65])
set(gca,'XTickLabel',[])
title('Rec 12 - No mask, Im. bottom')

subplot_tight(4,3,5,[0.05 0.05])
r = 13;
wavetrain           = logfile.data(r,8);
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
for j = 2:wavetrain+1
    h1 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
ylabel('Displacement (nm)');
title('Rec 13 - Top masked, Im. bottom')
axis([0 0.4 -20 40])
set(gca,'XTickLabel',[])

r = 14;
wavetrain           = logfile.data(r,8);
subplot_tight(4,3,6,[0.05 0.05])
for j = 2:wavetrain+1
    h2 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
%legend([h1 h2],'Top masked - imaged bottom', 'No mask - imaged bottom','location','NorthWest')
axis([0 0.4 -20 40])
set(gca,'XTickLabel',[])
title('Rec 14 - No mask, Im. bottom (no alpha recal)')

subplot_tight(4,3,8,[0.05 0.05])
r = 15;
wavetrain           = logfile.data(r,8);
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
for j = 2:wavetrain+1
    h1 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
ylabel('Displacement (nm)');
title('Rec 15 - Bottom masked, Im. top')
axis([0 0.4 -60 80])
set(gca,'XTickLabel',[])

r = 16;
wavetrain           = logfile.data(r,8);
subplot_tight(4,3,9,[0.05 0.05])
for j = 2:wavetrain+1
    h2 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
%legend([h1 h2],'Top masked - imaged bottom', 'No mask - imaged bottom','location','NorthWest')
axis([0 0.4 -60 80])
set(gca,'XTickLabel',[])
title('Rec 16 - No mask, Im. top')

subplot_tight(4,3,11,[0.05 0.05])
r = 17;
wavetrain           = logfile.data(r,8);
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
for j = 2:wavetrain+1
    h1 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
ylabel('Displacement (nm)');
title('Rec 17 - Bottom masked, Im. top')
axis([0 0.4 -100 80])
xlabel('Time (sec)')

r = 18;
wavetrain           = logfile.data(r,8);
subplot_tight(4,3,12,[0.05 0.05])
for j = 2:wavetrain+1
    h2 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
%legend([h1 h2],'Top masked - imaged bottom', 'No mask - imaged bottom','location','NorthWest')
axis([0 0.4 -100 80])
title('Rec 18 - Bottom masked (higher), Im. top')
xlabel('Time (sec)')

r = 19;
wavetrain           = logfile.data(r,8);
subplot_tight(4,4,13,[0.06 0.06])
for j = 2:wavetrain+1
    h2 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
%legend([h1 h2],'Top masked - imaged bottom', 'No mask - imaged bottom','location','NorthWest')
axis([0 0.4 -20 40])
title('Rec 19 - Im. side of soma')
xlabel('Time (sec)')

saveas(gcf,strcat('Overlaid_9_8_15_HB4_mfig'));
saveas(gcf,strcat('Overlaid_9_8_15_HB4_e'),'epsc');

%% Overlaid plots - HB5
clf
annotation('textbox',[0.05 0.9 0.2 0.05],'String','9/8/15 HB5','FontSize',18)

subplot_tight(4,3,2,[0.05 0.05])
r = 20;
wavetrain           = logfile.data(r,8);
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
for j = 2:wavetrain+1
    h1 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
ylabel('Displacement (nm)');
title('Rec 20 - Top masked, Im. bottom')
axis([0 0.4 -10 65])
set(gca,'XTickLabel',[])

r = 21;
wavetrain           = logfile.data(r,8);
subplot_tight(4,3,3,[0.05 0.05])
for j = 2:wavetrain+1
    h2 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
%legend([h1 h2],'Top masked - imaged bottom', 'No mask - imaged bottom','location','NorthWest')
axis([0 0.4 -10 65])
set(gca,'XTickLabel',[])
title('Rec 21 - No mask, Im. bottom')

subplot_tight(4,3,5,[0.05 0.05])
r = 22;
wavetrain           = logfile.data(r,8);
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
for j = 2:wavetrain+1
    h1 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
ylabel('Displacement (nm)');
title('Rec 22 - Bottom masked, Im. top')
axis([0 0.4 -50 90])
set(gca,'XTickLabel',[])

r = 23;
wavetrain           = logfile.data(r,8);
subplot_tight(4,3,6,[0.05 0.05])
for j = 2:wavetrain+1
    h2 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
%legend([h1 h2],'Top masked - imaged bottom', 'No mask - imaged bottom','location','NorthWest')
axis([0 0.4 -50 90])
set(gca,'XTickLabel',[])
title('Rec 23 - No mask, Im. top')

subplot_tight(4,3,8,[0.05 0.05])
r = 24;
wavetrain           = logfile.data(r,8);
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
for j = 2:wavetrain+1
    h1 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
ylabel('Displacement (nm)');
title('Rec 24 - Bottom masked, Im. top')
axis([0 0.4 -55 80])
set(gca,'XTickLabel',[])

r = 25;
wavetrain           = logfile.data(r,8);
subplot_tight(4,3,9,[0.05 0.05])
for j = 2:wavetrain+1
    h2 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
%legend([h1 h2],'Top masked - imaged bottom', 'No mask - imaged bottom','location','NorthWest')
axis([0 0.4 -55 80])
set(gca,'XTickLabel',[])
title('Rec 25 - Masked bottom, pulled up mask, Im. top')

subplot_tight(4,3,11,[0.05 0.05])
r = 26;
wavetrain           = logfile.data(r,8);
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
for j = 2:wavetrain+1
    h1 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
ylabel('Displacement (nm)');
title('Rec 26 - Bottom masked, brought down, Im. top')
axis([0 0.4 -25 65])
xlabel('Time (sec)')

r = 27;
wavetrain           = logfile.data(r,8);
subplot_tight(4,3,12,[0.05 0.05])
for j = 2:wavetrain+1
    h2 = plot(t,struct_data(r).data_zeroed_scaled(:,2:j));
    hold all
end
%legend([h1 h2],'Top masked - imaged bottom', 'No mask - imaged bottom','location','NorthWest')
axis([0 0.4 -25 65])
title('Rec 27 - No mask, Im. top')
xlabel('Time (sec)')

saveas(gcf,strcat('Overlaid_9_8_15_HB5_mfig'));
saveas(gcf,strcat('Overlaid_9_8_15_HB5_e'),'epsc');

%%
r = 29;
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
    
    subplot(2,1,1)
    plot(t,struct_data(r).data(:,2:5))
    ylabel('Displacement (nm)')
    subplot(2,1,2)
    plot(t,struct_data(r).data(:,10:13))
    ylabel('Voltage (mV)')
    xlabel('Time (sec)')
    
