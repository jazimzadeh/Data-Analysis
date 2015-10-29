% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-09-14.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%% 
for r = 2:29;
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
    plot(t,struct_data(r).data(:,2:wavetrain+1));
    xlabel('Time (sec)')
    ylabel('Displacement (nm)')
   
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)

    saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

%% Plot of HB's A-D in sacculus 2
clf
set(0, 'DefaultAxesColorOrder', copper(wavetrain+1));
    subplot_tight(5,4,1,[0.05 0.05])
    dc_offset = mean(mean(struct_data(9).data(:,2:4)));
    plot(t,struct_data(9).data(:,2:4)-dc_offset)
    set(gca,'XTickLabel',[])
    axis([0 1 -40 50])
    title('HB A')
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(5,4,2,[0.05 0.05])
    dc_offset = mean(mean(struct_data(10).data(:,2:4)));
    plot(t,struct_data(10).data(:,2:4)-dc_offset)
    set(gca,'XTickLabel',[])
    axis([0 1 -60 100])
    title('HB B')
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(5,4,3,[0.05 0.05])
    dc_offset = mean(mean(struct_data(11).data(:,2:4)));
    plot(t,struct_data(11).data(:,2:4)-dc_offset)
    set(gca,'XTickLabel',[])
    axis([0 1 -110 210])
    title('HB C')
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(5,4,4,[0.05 0.05])
    dc_offset = mean(mean(struct_data(12).data(:,2:4)));
    plot(t,struct_data(12).data(:,2:4)-dc_offset)
    set(gca,'XTickLabel',[])
    axis([0 1 -30 100])
    title('HB D (Small)')
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(5,4,5,[0.05 0.05])
    dc_offset = mean(mean(struct_data(13).data(:,2:4)));
    plot(t,struct_data(13).data(:,2:4)-dc_offset)
    set(gca,'XTickLabel',[])
    axis([0 1 -40 50])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(5,4,6,[0.05 0.05])
    dc_offset = mean(mean(struct_data(14).data(:,2:4)));
    plot(t,struct_data(14).data(:,2:4)-dc_offset)
    set(gca,'XTickLabel',[])
    axis([0 1 -60 100])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(5,4,7,[0.05 0.05])
    dc_offset = mean(mean(struct_data(15).data(:,2:4)));
    plot(t,struct_data(15).data(:,2:4)-dc_offset)
    set(gca,'XTickLabel',[])
    axis([0 1 -110 210])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(5,4,8,[0.05 0.05])
    dc_offset = mean(mean(struct_data(16).data(:,2:4)));
    plot(t,struct_data(16).data(:,2:4)-dc_offset)  
    set(gca,'XTickLabel',[])
    axis([0 1 -30 100])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(5,4,9,[0.05 0.05])
    dc_offset = mean(mean(struct_data(18).data(:,2:4)));
    plot(t,struct_data(18).data(:,2:4)-dc_offset)
    set(gca,'XTickLabel',[])
    axis([0 1 -40 50])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(5,4,10,[0.05 0.05])
    dc_offset = mean(mean(struct_data(19).data(:,2:4)));
    plot(t,struct_data(19).data(:,2:4)-dc_offset)
    set(gca,'XTickLabel',[])
    axis([0 1 -60 100])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(5,4,11,[0.05 0.05])
    dc_offset = mean(mean(struct_data(20).data(:,2:4)));
    plot(t,struct_data(20).data(:,2:4)-dc_offset)
    set(gca,'XTickLabel',[])
    axis([0 1 -110 210])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(5,4,12,[0.05 0.05])
    dc_offset = mean(mean(struct_data(21).data(:,2:4)));
    plot(t,struct_data(21).data(:,2:4)-dc_offset)
    set(gca,'XTickLabel',[])
    axis([0 1 -30 100])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(5,4,13,[0.05 0.05])
    dc_offset = mean(mean(struct_data(22).data(:,2:4)));
    plot(t,struct_data(22).data(:,2:4)-dc_offset)
    axis([0 1 -40 50])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(5,4,14,[0.05 0.05])
    dc_offset = mean(mean(struct_data(23).data(:,2:4)));
    plot(t,struct_data(23).data(:,2:4)-dc_offset)
    axis([0 1 -60 100])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(5,4,15,[0.05 0.05])
    dc_offset = mean(mean(struct_data(24).data(:,2:4)));
    plot(t,struct_data(24).data(:,2:4)-dc_offset)
    axis([0 1 -110 210])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(5,4,16,[0.05 0.05])
    dc_offset = mean(mean(struct_data(25).data(:,2:4)));
    plot(t,struct_data(25).data(:,2:4)-dc_offset)
    axis([0 1 -30 100])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(5,4,17,[0.05 0.05])
    dc_offset = mean(mean(struct_data(26).data(:,2:4)));
    plot(t,struct_data(26).data(:,2:4)-dc_offset)
    axis([0 1 -40 50])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(5,4,18,[0.05 0.05])
    dc_offset = mean(mean(struct_data(27).data(:,2:4)));
    plot(t,struct_data(27).data(:,2:4)-dc_offset)
    axis([0 1 -60 100])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(5,4,19,[0.05 0.05])
    dc_offset = mean(mean(struct_data(28).data(:,2:4)));
    plot(t,struct_data(28).data(:,2:4)-dc_offset)
    axis([0 1 -110 210])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(5,4,20,[0.05 0.05])
    dc_offset = mean(mean(struct_data(29).data(:,2:4)));
    plot(t,struct_data(29).data(:,2:4)-dc_offset)
    axis([0 1 -30 100])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    annotation('textbox',[0.001 0.9 0.02 0.02],'string','FNS')
    annotation('textbox',[0.001 0.7 0.02 0.04],'string','FNS')
    annotation('textbox',[0.001 0.5 0.02 0.04],'string','1% DMSO')
    annotation('textbox',[0.001 0.3 0.02 0.04],'string','10uM PClP')
    annotation('textbox',[0.001 0.1 0.02 0.04],'string','10uM PClP')
    
    saveas(gcf,strcat('PClP_AllHBs_9_14_15'));
    saveas(gcf,strcat('PClP_AllHBs_9_14_15'),'epsc');
    
%% Plot probe records
    for r = 30:34;
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
    plot(t,struct_data(r).data(:,2:wavetrain+1));
    xlabel('Time (sec)')
    ylabel('Displacement (nm)')
    
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)

    saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
    end
    
%% Create an array that contains the processed probe mvt and shadowing data
% Processing steps:
% Subtract dc_offset from each trace
% Scale each trace using the 30 nm calibration pulse
data_p = zeros(4000,wavetrain+1,5);
for j = 30:34
   for wt = 2:wavetrain+1
        dc_offset = mean(struct_data(j).data(1:270,wt));
        pd_pulse_peak = mean(struct_data(j).data(0.037*Fs:0.055*Fs,wt));
        pd_pulse_ampl = pd_pulse_peak - dc_offset;
        cfactor = pd_pulse_ampl / 30;
        data_p(:,wt,j-29) = (struct_data(j).data(:,wt) - dc_offset)/cfactor;
   end
end
%% Plot the probe control experiment
clf
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain+1));
subplot(2,3,1)
plot(t,data_p(:,2:wavetrain+1,1))
title('Probe alone')
subplot(2,3,2)
plot(t,data_p(:,2:wavetrain+1,2))
title('Mask far above')
subplot(2,3,3)
plot(t,data_p(:,2:wavetrain+1,3))
title('Mask down and closer to tip')
subplot(2,3,4)
plot(t,data_p(:,2:wavetrain+1,4))
title('Mask virtually touching probe')
subplot(2,3,5)
plot(t,data_p(:,2:wavetrain+1,5))
title('Mask touching probe')

annotation('textbox',[0.7 0.37 0.21 0.08],'string','9/14/15 Probe masking controls')
    
saveas(gcf,strcat('Probe_mask_control_9_14_15'));
saveas(gcf,strcat('Probe_mask_control_9_14_15'),'epsc');

