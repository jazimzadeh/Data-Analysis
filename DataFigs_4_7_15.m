% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-04-07.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%% Basic plotting script
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
    h1 = subplot(7,1,4:5);
    plot(t,struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1));
    ylabel('Current (pA)');
        % Create the blow-up region in a box:
        P = get(h1,'Position');  % get position information for subplot
        F = P(3)/(t(end)-t(1));  % divide width of subplot by its duration to get a scaling factor that converts between the two
        box_left = P(1) + laser_delay*F;
        box_bottom = P(2) + 0.5*(P(4));         % add a fraction of the height to the bottom parameter of the subplot to generate the bottom coordinate for the box
        box_width = 1.2*laser_duration*F;       % box width should be a little wider than the laser_duration
        box_height = 0.4*P(4);
        axes('Position',[box_left box_bottom box_width box_height],'Box','on')
        plot(t(laser_delay*Fs:(laser_delay + 1.2*laser_duration)*Fs),struct_data(r).data(laser_delay*Fs:(laser_delay + 1.2*laser_duration)*Fs,2*wavetrain+2:3*wavetrain+1));
        maximum = max(max(struct_data(r).data(laser_delay*Fs:(laser_delay + 1.2*laser_duration)*Fs,2*wavetrain+2:3*wavetrain+1))); % find maximum value within the blown-up region
        minimum = min(min(struct_data(r).data(laser_delay*Fs:(laser_delay + 1.2*laser_duration)*Fs,2*wavetrain+2:3*wavetrain+1))); % find maximum value within the blown-up region
        axis([laser_delay laser_delay+1.2*laser_duration 1.1*minimum 1.1*maximum])
        set(gca,'xtick',[])
        set(gca,'xticklabel',[])
    
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

%% Prepulse experiments
for r = 1:8;
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
    
    set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
    
    % Displacement
    h(1) = subplot(5,1,1);
    plot(t,-struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1));
    ylabel('Displacement (nm)');
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',12)
    
    % Displacement spaced out
    h(2) = subplot(5,1,2:3);
    offset = 0;
    for i = wavetrain+2 : 2*wavetrain+1
        plot(t,-struct_data(r).data(:,i)+offset);
        hold all
        offset = offset + 60;
    end
    ylabel('Displacement (nm)')
    
    % Laser command
    h(3) = subplot(5,1,4);
    plot(t,struct_data(r).data(:,4*wavetrain+2:5*wavetrain+1));
    ylabel('Laser Voltage');
    axis([0 2 0 6])
    
     % Laser Pick-off
    h(4) = subplot(5,1,5);
    plot(t,struct_data(r).data(:,5*wavetrain+2:6*wavetrain+1));
    ylabel('Laser Pick-off');
    axis([0 2 0 3])

    
    linkaxes(h,'x')
    
    saveas(gcf,strcat('DataFig_PrePulses',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_PrePulses_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_PrePulses_e',num2str(r),'eps'),'epsc');
end

%% Long pulses
for r = 9:12;
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
    
    set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
    
    % Displacement
    h(1) = subplot(4,1,1:2);
    offset = 0;
    for i = wavetrain+2 : 2*wavetrain+1
        plot(t,struct_data(r).data(:,i)+offset);
        hold all
        offset = offset + 60;
    end
    ylabel('Displacement (nm)');
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',12)
    
    % Laser command
    h(2) = subplot(4,1,3);
    plot(t,struct_data(r).data(:,4*wavetrain+2:5*wavetrain+1));
    ylabel('Laser Voltage');
    axis([0 2 0 6])
    
     % Laser Pick-off
    h(3) = subplot(4,1,4);
    plot(t,struct_data(r).data(:,5*wavetrain+2:6*wavetrain+1));
    ylabel('Laser Pick-off');
    axis([0 2 0 3])
    
    linkaxes(h,'x')
    
    saveas(gcf,strcat('DataFig_LongPulses',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_LongPulses_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_LongPulses_e',num2str(r),'eps'),'epsc');
end

%% Print recs 9 and 10 in large size
r=10;
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
    
    set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
    
    % Displacement
    
    for i = wavetrain+2 : 2*wavetrain+1
        plot(t,struct_data(r).data(:,i),'k');
        hold all
        offset = offset + 60;
    end
    axis([0.1 0.5 140 320])
    ylabel('Displacement (nm)');
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',12)
    
%% Recs 14 & 15 - Effect of EGTA iontophoresis
r = 15;
clf
baseline_start = 0.15;
baseline_end = 0.158;
peak_start = 0.162;
peak_end = 0.170;
peak_start_d = 0.181;
peak_end_d = 0.189;
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
    
    % Iontophoresis, 
    h(3) = subplot_tight(5,3,1:2,[0.07,0.05]);
    plot(t,struct_data(r).data(:,0*wavetrain+2:1*wavetrain+1));
    ylabel('Iontophoresis current (nA)')
    axis([0.14 0.25 -100 40])
    set(gca,'xticklabel',[])
    % Patch
    ylim = get(gca, 'YLim');
    x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
    y = [ylim(1)+0.01 ylim(2)-0.05 ylim(2)-0.05 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',12)
   
    % Current
    h(2) = subplot_tight(5,3,4:5,[0.01,0.05]);
    plot(t,struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1));
    ylabel('Current (pA)');
    axis([0.14 0.25 -80 50])
    set(gca,'xticklabel',[])
    % Patch
    ylim = get(gca, 'YLim');
    x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
    y = [ylim(1)+0.01 ylim(2)-0.05 ylim(2)-0.05 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 
    % Patch showing baseline region
    xx = [baseline_start baseline_start baseline_end baseline_end baseline_start]; 
    yy = [ylim(1)+0.01 ylim(2)-0.05 ylim(2)-0.05 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(xx, yy, -1 * ones(size(x)), [0.9 0.9 1], 'LineStyle', 'none')     % Make patch 
    % Patch showing peak region
    xxx = [peak_start peak_start peak_end peak_end peak_start]; 
    yyy = [ylim(1)+0.01 ylim(2)-0.05 ylim(2)-0.05 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(xxx, yyy, -1 * ones(size(x)), [0.9 0.8 0.8], 'LineStyle', 'none')     % Make patch 

    % Displacement
    h(1) = subplot_tight(5,3,7:8,[0.01,0.05]);
    plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1));
    ylabel('Displacement (nm)');
    ylim = get(gca, 'YLim');
    axis([0.14 0.25 ylim(1) ylim(2)])
    % Patch
    ylim = get(gca, 'YLim');
    x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
    y = [ylim(1)+0.01 ylim(2)-0.05 ylim(2)-0.05 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 
    % Patch showing baseline region
    xx = [baseline_start baseline_start baseline_end baseline_end baseline_start]; 
    yy = [ylim(1)+0.01 ylim(2)-0.05 ylim(2)-0.05 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(xx, yy, -1 * ones(size(x)), [0.9 0.9 1], 'LineStyle', 'none')     % Make patch 
    % Patch showing peak region
    xxx = [peak_start_d peak_start_d peak_end_d peak_end_d peak_start_d]; 
    yyy = [ylim(1)+0.01 ylim(2)-0.05 ylim(2)-0.05 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(xxx, yyy, -1 * ones(size(x)), [0.9 0.8 0.8], 'LineStyle', 'none')     % Make patch 
   
    
    Ionto_i = zeros(wavetrain,1);
    Max_i = zeros(wavetrain,1);

for i = 0*wavetrain+2:1*wavetrain+1     % Make a vector with the iontophoresis currents for each waveform
    Ionto_i(i-(0*wavetrain+1)) = mean(struct_data(r).data((Fs*peak_start:Fs*peak_end),i) );
end

for i = 2*wavetrain+2:3*wavetrain+1     % Make a vector of the current maximums for each wf
    Baseline_i = mean(struct_data(r).data((Fs*baseline_start:Fs*baseline_end),i));
    Peak_i = mean(struct_data(r).data((Fs*peak_start:Fs*peak_end),i));
    Max_i(i-(2*wavetrain+1)) = abs(Peak_i - Baseline_i);
end

for i = 1*wavetrain+2:2*wavetrain+1     % Make a vector of the displacement maximums for each wf
    Baseline_d = mean(struct_data(r).data((Fs*baseline_start:Fs*baseline_end),i));
    Peak_d = mean(struct_data(r).data((Fs*peak_start_d:Fs*peak_end_d),i));
    Max_d(i-(1*wavetrain+1)) = abs(Peak_d - Baseline_d);
end

% Plot current max vs. Iontophoresis current
subplot(3,3,7)
%Plot
for i = 1:length(Ionto_i)
plot(Ionto_i(i),Max_i(i),'.','MarkerSize',20)
hold all
end
ylabel('Peak current (pA)')
xlabel('Ionto Current (nA)')
axis([-100 40 20 50])
title('Peak i vs. Ionto i')

% Plot Xd max vs. Iontophoresis current
subplot(3,3,8)
%Plot
for i = 1:length(Ionto_i)
plot(Ionto_i(i),Max_d(i),'.','MarkerSize',20)
hold all
end
ylabel('Peak displ. (nm)')
xlabel('Ionto Current (nA)')
axis([-100 40 10 40])
title('Peak displ vs. Ionto i')

    
saveas(gcf,strcat('DataFig_peak',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_peak_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_peak_e',num2str(r),'eps'),'epsc');

%% Plot i and Xd together for Recs 14, 15, 16 - OVERLAID and NORMALIZED
    for r = 14:16;
    clf
    avg_i = mean(struct_data(r).data(0.15*Fs:0.24*Fs,2*wavetrain+2:3*wavetrain+1),2);
    avg_x = mean(struct_data(r).data(0.15*Fs:0.24*Fs,1*wavetrain+2:2*wavetrain+1),2);
    dc_i = mean(avg_i(1:0.01*Fs));       % find the dc offset
    dc_x = mean(avg_x(1:0.01*Fs));       % find the dc offset
    avg_i = -(avg_i-dc_i);                     % remove dc offset
    avg_x = avg_x-dc_x;                     % remove dc offset
    avg_i = avg_i/max(avg_i);               % normalize to maximum
    avg_x = avg_x/max(avg_x);               % normalize to maximum
    Fs                  = logfile.data(r,12);               % sampling rate
    T                   = 1/Fs;
    L                   = length(avg_i);    
    t                   = (0:L-1)*T; 
    plot(t, avg_x,'k');
    hold on
    plot(t, avg_i,'r');
    
    ylim = get(gca, 'YLim');
    x = [laser_delay-0.25 laser_delay-0.25 laser_delay+laser_duration-0.25 laser_delay+laser_duration-0.25 laser_delay-0.25]; 
    y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 
    
    %axis([0 0.1 -0.2 1.2])
    
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    xlabel('Time (seconds)');
    ylabel('Amplitudes normalized to maximum');
    title_string2 = logfile.textdata(r,3);
    title_string3 = 'NORMALIZED AND OVERLAID Xd and i';
    title({ title_string1, title_string2{1}, title_string3 },'fontsize',12)
    
    saveas(gcf,strcat('DataFig_i_Xd_Normd',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_i_Xd_Normd_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_i_Xd_Normd_e',num2str(r),'eps'),'epsc');
    end
    
    %% Just current trace for Rec 14
    r=14;
    clf
    avg_i = mean(struct_data(r).data(0.15*Fs:0.24*Fs,2*wavetrain+2:3*wavetrain+1),2);
    avg_x = mean(struct_data(r).data(0.15*Fs:0.24*Fs,1*wavetrain+2:2*wavetrain+1),2);
    dc_i = mean(avg_i(1:0.01*Fs));       % find the dc offset
    dc_x = mean(avg_x(1:0.01*Fs));       % find the dc offset
    avg_i = (avg_i-dc_i);                     % remove dc offset
    
    Fs                  = logfile.data(r,12);               % sampling rate
    T                   = 1/Fs;
    L                   = length(avg_i);    
    t                   = (0:L-1)*T; 
  
    plot(t, avg_i,'k');
    ylim = get(gca, 'YLim');
        ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
        x = [laser_delay-0.15 laser_delay-0.15 (laser_delay + laser_duration-0.15) (laser_delay + laser_duration-0.15) laser_delay-0.15]; 
        y = [ylim(1) ylim(2)-0.3 ylim(2)-0.3 ylim(1)+0.2 ylim(1)+0.2]; 
        patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    axis([0 0.1 -80 20])
    
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    xlabel('Time (seconds)');
    ylabel('Amplitudes normalized to maximum');
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1}},'fontsize',12)
    
    saveas(gcf,strcat('DataFig_Rec14_Current_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_Rec14_Current_e',num2str(r),'eps'),'epsc');
    
    
%% Recs 17 - I(X) curve
r = 17;
clf
baseline_start = 0.15;
baseline_end = 0.158;
peak_start = 0.162;
peak_end = 0.170;
peak_start_d = 0.191;
peak_end_d = 0.199;
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
    
    % Current
    h(1) = subplot_tight(3,5,2:4,[0.08,0.05]);
    plot(t,struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1));
    ylabel('Current (pA)');
    axis([0.14 0.25 -80 50])
    set(gca,'xticklabel',[])
    % Patch
    ylim = get(gca, 'YLim');
    x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
    y = [ylim(1)+0.01 ylim(2)-0.05 ylim(2)-0.05 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 
    % Patch showing baseline region
    xx = [baseline_start baseline_start baseline_end baseline_end baseline_start]; 
    yy = [ylim(1)+0.01 ylim(2)-0.05 ylim(2)-0.05 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(xx, yy, -1 * ones(size(x)), [0.9 0.9 1], 'LineStyle', 'none')     % Make patch 
    % Patch showing peak region
    xxx = [peak_start peak_start peak_end peak_end peak_start]; 
    yyy = [ylim(1)+0.01 ylim(2)-0.05 ylim(2)-0.05 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(xxx, yyy, -1 * ones(size(x)), [0.9 0.8 0.8], 'LineStyle', 'none')     % Make patch 
    
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',12)

    % Displacement
    h(2) = subplot_tight(3,5,7:9,[0.05,0.05]);
    plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1));
    ylabel('Displacement (nm)');
    ylim = get(gca, 'YLim');
    axis([0.14 0.25 ylim(1) ylim(2)])
    % Patch
    ylim = get(gca, 'YLim');
    x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
    y = [ylim(1)+0.01 ylim(2)-0.05 ylim(2)-0.05 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 
    % Patch showing baseline region
    xx = [baseline_start baseline_start baseline_end baseline_end baseline_start]; 
    yy = [ylim(1)+0.01 ylim(2)-0.05 ylim(2)-0.05 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(xx, yy, -1 * ones(size(x)), [0.9 0.9 1], 'LineStyle', 'none')     % Make patch 
    % Patch showing peak region
    xxx = [peak_start_d peak_start_d peak_end_d peak_end_d peak_start_d]; 
    yyy = [ylim(1)+0.01 ylim(2)-0.05 ylim(2)-0.05 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(xxx, yyy, -1 * ones(size(x)), [0.9 0.8 0.8], 'LineStyle', 'none')     % Make patch 
   
    Max_i = zeros(wavetrain,1);
    Max_d = zeros(wavetrain,1);

for i = 2*wavetrain+2:3*wavetrain+1     % Make a vector of the current maximums for each wf
    Baseline_i = mean(struct_data(r).data((Fs*baseline_start:Fs*baseline_end),i));
    Peak_i = mean(struct_data(r).data((Fs*peak_start:Fs*peak_end),i));
    Max_i(i-(2*wavetrain+1)) = abs(Peak_i - Baseline_i);
end

for i = 1*wavetrain+2:2*wavetrain+1     % Make a vector of the displacement maximums for each wf
    Baseline_d = mean(struct_data(r).data((Fs*baseline_start:Fs*baseline_end),i));
    Peak_d = mean(struct_data(r).data((Fs*peak_start_d:Fs*peak_end_d),i));
    Max_d(i-(1*wavetrain+1)) = abs(Peak_d - Baseline_d);
end

subplot_tight(3,4,10:11,[0.07,0.01])
for i= 1:wavetrain
plot(Max_d(i),Max_i(i),'.','MarkerSize',20)
hold all
end
xlabel('Displacement (nm)')
ylabel('Current (pA)')
title('I(X) Curve')

    
saveas(gcf,strcat('DataFig_IX',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_IX_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_IX_e',num2str(r),'eps'),'epsc');

%% Plot current vs. displacement to look for correlation
r=15;
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
    h(1) = subplot(4,1,1);
    %plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1));
    plot(t,struct_data(r).data(:,1*wavetrain+2));
    h(2) = subplot(4,1,2);
    % Current
    %plot(t,struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1));
    plot(t,struct_data(r).data(:,2*wavetrain+2));
    linkaxes(h,'x')


subplot(2,5,7:9)
set(0, 'DefaultAxesColorOrder', ametrine(1000));
for i = 0.25*Fs : 0.3*Fs
   x = struct_data(r).data(i,1*wavetrain+2);
   current = struct_data(r).data(i,2*wavetrain+2);
   plot(x,current,'.','MarkerSize',6)
   hold all
end
xlabel('Displacement (nm)')
ylabel('Current (pA)')
title('Current vs. Displ. at each point between 0.25-0.3 sec')
   
