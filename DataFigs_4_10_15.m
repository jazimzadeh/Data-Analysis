% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-04-10.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%% Iontophoresis
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
    
    % Iontophoresis, gentamicin
    subplot(7,1,1)
    plot(t,struct_data(r).data(:,0*wavetrain+2:1*wavetrain+1));
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',12)
    ylabel('Iontophoresis current (nA)')
    
    % Displacement
    subplot(7,1,2:5)
    plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1));
    ylabel('Displacement (nm)');
    
    
    % Voltage steps (Vm)
    subplot(7,1,6)
    plot(t,struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1));
    ylabel('Voltage (mV)');
    
    % Laser command
    subplot(7,1,7)
    plot(t,struct_data(r).data(:,3*wavetrain+2:4*wavetrain+1));
    ylabel('Laser Voltage');
    
    saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

%%  Plot ionto, displacement, & displacements as a function of ionto
logfile_name = getfield(dir('*.log'),'name');
logfile_name_clean = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile = importdata(logfile_name);


for r = 1:8      % Select the record numbers to plot

    logfile_name = getfield(dir('*.log'),'name');
    logfile_name_clean = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
    logfile = importdata(logfile_name);
    clf
    wavetrain = logfile.data(r,8); % get number of wavetrains [actually waveforms] for that run
    laser_delay = logfile.data(r,43)*.001;      % in milliseconds
    laser_duration = logfile.data(r,44)*.001;   % in milliseconds
    laser_voltage = logfile.data(r,63);
    Fs = 20000;         %sampling rate
    T = 1/Fs;
    L = length(struct_data(r).data(:,2));    
    t = (0:L-1)*T;
    
    % Plot iontophoresis current
h1 = subplot(6,1,1);
    set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
    plot(t(1:100:end),struct_data(r).data((1:100:end),2:(1*wavetrain+1)));
    ylabel('Iontophoresis (nA)')
    xlabel('Time (sec)')
    
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    
    % Plot Displacement         
    set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
    offset = 0;
h2 = subplot(6,1,2:4);
    for i= (wavetrain+2) : (2*wavetrain+1)
        dc = mean(struct_data(r).data(1:100,i));
        plot(t,-struct_data(r).data(:,i)-dc+offset)
        hold all
        offset = offset+120;
    end
    
    linkaxes([h1 h2],'x');
      
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
    
    ylabel('Displacement (nm)')
 
    % Calculate delta displacements
    baseline = zeros((2*wavetrain+1)-(wavetrain+2),1);  % Initialize baseline vector.
    peak = zeros((2*wavetrain+1)-(wavetrain+2),1);      % Initialize peak vector.
    steady = zeros((2*wavetrain+1)-(wavetrain+2),1);    % Initialize steady-state vector.
    
    for i= (wavetrain+2) : (2*wavetrain+1)
        baseline(i-wavetrain-1,1) = mean(struct_data(r).data(laser_delay*20000-300:laser_delay*20000-100,i));   % mean position before laser pulse                  % mean right before pulse (85-95 ms);
        peak(i-wavetrain-1,1) = mean(struct_data(r).data(laser_delay*20000+40:laser_delay*20000+240,i));        % mean position during laser, early
        steady(i-wavetrain-1,1) = mean(struct_data(r).data(laser_delay*20000+560:laser_delay*20000+760,i));     % mean position during laser, late
    end
        displacements = abs(baseline-peak);
        
    % Calculate delta PD displacements
    pd_delay = (Fs/1000)*logfile.data(r,15);            % delay prior to PD PZT calibration pulse (in samples)
    pd_duration = (Fs/1000)*logfile.data(r,16);         % duration of PD PZT calibration pulse; logfile gives values in ms
    pd_command_amplitude = logfile.data(r,55);          % amplitude of PD PZT calibration pulse
    
    pd_start = pd_delay + 20*(Fs/1000);                 % Since the mvt of PD piezo is delayed, add 20 msec delay to starting sample
    pd_end = pd_start + 0.5*pd_duration;
    pd_length = pd_end - pd_start;
    
    pre_pd_start = pd_start - pd_length;
    pre_pd_end = pre_pd_start + pd_length;
    
    pd_mean_pre = zeros(wavetrain,1);                   % Initialize vector
    pd_mean_during = zeros(wavetrain,1);                % Initialize vector
    correction_factor = zeros(wavetrain,1);             % Initialize vector
    
    for i = (wavetrain+2) : (2*wavetrain+1)
        pd_mean_pre(i-wavetrain-1,1) = mean(struct_data(r).data(pre_pd_start:pre_pd_end,i));
        pd_mean_during(i-wavetrain-1,1) = mean(struct_data(r).data(pd_start:pd_end,i));
        correction_factor(i-wavetrain-1,1) = abs(pd_mean_pre(i-wavetrain-1) - pd_mean_during(i-wavetrain-1))/pd_command_amplitude;
    end
        
    % Plot delta displacement as a function of ionto current
    ionto_half_time = length(struct_data(r).data(:,2:(1*wavetrain+1)))/2;   % CHANGE THIS, it relies on the ionto pulse being in middle of the recording
    ionto = struct_data(r).data(ionto_half_time,2:(1*wavetrain+1));         % Get ionto current, for ionto vs displ. plot
    
h3 = subplot(3,2,5);
    for i = 1:wavetrain
    plot(ionto(i), displacements(i),'.', 'markersize',20)
    hold all
    xlabel('Current (nA)')
    ylabel('Displacement (nm)')
    end
    title('Displacement vs. Iontophoresis current')
    
h4 = subplot(3,2,6);
    for i = 1:wavetrain
    plot(ionto(i), correction_factor(i)*displacements(i),'.', 'markersize',20)
    hold all
    xlabel('Current (nA)')
    ylabel('Corrected Displ. (nm)')
    end
    title('Corrected Displ. vs. Iontophoresis current')        
        
    saveas(gcf,strcat('DataFig_Ionto',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_Ionto_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_Ionto_e',num2str(r),'eps'),'epsc');
end

%% Prepulses - to look at convolution-type effects
for r = 9:39
    clf
    logfile_name = getfield(dir('*.log'),'name');
    logfile_name_clean = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
    logfile = importdata(logfile_name);
    wavetrain = logfile.data(r,8); % get number of wavetrains [actually waveforms] for that run
    laser_delay = logfile.data(r,43)*.001;      % in milliseconds
    laser_duration = logfile.data(r,44)*.001;   % in milliseconds
    laser_voltage = logfile.data(r,63);
    Fs = 20000;         %sampling rate
    T = 1/Fs;
    L = length(struct_data(r).data(:,2));    
    t = (0:L-1)*T;
    
    set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
    
    % Displacement
    hred(1) = subplot(7,1,1:6);
    plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1));
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',12);
    ylabel('Displacement (nm)')
    
    % Laser Pickoff
    hred(2) = subplot(7,1,7);
    plot(t,struct_data(r).data(:,3*wavetrain+2:4*wavetrain+1));
    ylabel('Laser Command');
    xlim = get(gca,'XLim');
    axis([xlim(1) xlim(2) -1 6]);
    
    linkaxes(hred,'x')
    
    saveas(gcf,strcat('DataFig_PrePulses',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_PrePulses_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_PrePulses_e',num2str(r),'eps'),'epsc');
end


%% Open the second folder, with the decay experiments
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-04-10.02/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%% Get the laser-evoked Xd values for the decay experiments
for r=1:10;
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
    pd_ampl_command     = logfile.data(r,55);               % in nm
    beta                = logfile.data(4,106);
    Fs                  = logfile.data(r,12);               % sampling rate
    T                   = 1/Fs;
    L                   = length(struct_data(r).data(:,2));    
    t                   = (0:L-1)*T;   
    
    baseline_start      = floor(0 * Fs)+1;                  % input beginning of segment for pd displacement calculation
    baseline_end        = floor(0.01 * Fs);                 % input end of segment for pd displacement calculation
    pd_start            = floor(0.04 * Fs);
    pd_end              = floor(0.05 * Fs);
    Xd_baseline_start   = floor(0.07 *Fs);                  % time at which to start measuring Xd baseline
    Xd_baseline_end     = floor(0.08 * Fs);                 % time at which to end measuring Xd baseline
    Xd_start            = floor((laser_delay+laser_duration-0.005) * Fs);       % time at which to start measuring Xd
    Xd_end              = floor((laser_delay + laser_duration) * Fs);           % time at which to end measuring Xd
    
    % set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
    
    for i = 1:wavetrain     % Calculate Xd for each run. Each column is one HB, each row is a repeat.
    j = i+1;
    baseline_pos    = mean(struct_data(r).data(baseline_start:baseline_end,j));  
    pd_pos          = mean(struct_data(r).data(pd_start:pd_end,j));  
    pd_ampl         = abs(pd_pos - baseline_pos);
    
    Xd_baseline_pos = mean(struct_data(r).data(Xd_baseline_start:Xd_baseline_end,j)); 
    Xd_pos          = mean(struct_data(r).data(Xd_start:Xd_end,j)); 
    Xd_ampl         = abs(Xd_baseline_pos - Xd_pos);
    
    scaling_factor = pd_ampl / pd_ampl_command;     % get a ratio of obtain displ. vs. commanded displ.
    Xd_ampl_scaled = Xd_ampl / scaling_factor;      % scale Xd by the scaling factor    
    Xd(i,r) = Xd_ampl_scaled;
    end
end
%%
% Records 4 and 8 had wild fluctuations in the late repeats, here I set
% them to zero:
Xd(201:end,4)=0;
Xd(301:end,8)=0;

% Verify that the amplitudes are correct, plot the scaled displacements
clf
% Plot the amplitudes vs. wavetrains
for i = 1:10
   subplot(4,3,i)
   plot(Xd(:,i),'.k')
end
subplot(4,3,1); title('HB18 3V 20 ms');
subplot(4,3,2); title('HB19 3V 20 ms');
subplot(4,3,3); title('HB20 2V 30 ms');
subplot(4,3,4); title('HB21 4V 30 ms');
subplot(4,3,5); title('HB22 3V 10 ms');
subplot(4,3,6); title('HB23 3V 30 ms');
subplot(4,3,7); title('HB24 4V 20 ms');
subplot(4,3,8); title('HB25 4V 20 ms');
subplot(4,3,9); title('HB26 3V 40 ms');
subplot(4,3,10); title('HB27 2V 40 ms');

saveas(gcf,strcat('DataFig_Xd_decay_scaled',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_Xd_decay_scaled_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_Xd_decay_scaled_e',num2str(r),'eps'),'epsc');

%% Plot the first trace for each record
figure
for r = 1:10
   subplot(4,3,r)
   plot(t,struct_data(r).data(:,2),'k')
end
title('4/10/15 Decay experiments - First trace of each HB')
subplot(4,3,1); title('HB18 3V 20 ms');
subplot(4,3,2); title('HB19 3V 20 ms');
subplot(4,3,3); title('HB20 2V 30 ms');
subplot(4,3,4); title('HB21 4V 30 ms');
subplot(4,3,5); title('HB22 3V 10 ms');
subplot(4,3,6); title('HB23 3V 30 ms');
subplot(4,3,7); title('HB24 4V 20 ms');
subplot(4,3,8); title('HB25 4V 20 ms');
subplot(4,3,9); title('HB26 3V 40 ms');
subplot(4,3,10); title('HB27 2V 40 ms');

saveas(gcf,strcat('DataFig_Xd_decay_firstTrace',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_Xd_decay_firstTrace_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_Xd_decay_firstTrace_e',num2str(r),'eps'),'epsc');

%% Normalize each of the bundles to their max and plot

for i = 1:size(Xd,2)
   maximum = max(Xd(:,i));      % Find the maximum in each column (each repeat)
   Xd(:,i) = Xd(:,i)/maximum;   % Normalize each entry to the maximum in its column
end

for i = 1:10
   subplot(4,3,i)
   plot(Xd(:,i),'.k')
end

subplot(4,3,1); title('HB18 3V 20 ms');
subplot(4,3,2); title('HB19 3V 20 ms');
subplot(4,3,3); title('HB20 2V 30 ms');
subplot(4,3,4); title('HB21 4V 30 ms');
subplot(4,3,5); title('HB22 3V 10 ms');
subplot(4,3,6); title('HB23 3V 30 ms');
subplot(4,3,7); title('HB24 4V 20 ms');
subplot(4,3,8); title('HB25 4V 20 ms');
subplot(4,3,9); title('HB26 3V 40 ms');
subplot(4,3,10); title('HB27 2V 40 ms');

saveas(gcf,strcat('DataFig_Xd_decay_scaled_normd',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_Xd_decay_scaled_normd_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_Xd_decay_scaled_normd_e',num2str(r),'eps'),'epsc');

%% Subplots by TOTAL ENERGY delivered (Power x Duration) 
subplot_tight(3,5,1,[0.06,0.04]);
plot(Xd(:,5),'.k'); title('HB22 3V 10 ms'); set(gca,'YTickLabel',[]);

subplot_tight(3,5,2,[0.06,0.04]);
plot(Xd(:,1),'.k'); title('HB18 3V 20 ms'); set(gca,'YTickLabel',[]);
subplot_tight(3,5,7,[0.06,0.04]);
plot(Xd(:,2),'.k'); title('HB19 3V 20 ms'); set(gca,'YTickLabel',[]);
subplot_tight(3,5,12,[0.06,0.04]);
plot(Xd(:,3),'.k'); title('HB20 2V 30 ms'); set(gca,'YTickLabel',[]);

subplot_tight(3,5,3,[0.06,0.04]);
plot(Xd(:,7),'.k'); title('HB24 4V 20 ms'); set(gca,'YTickLabel',[]);
subplot_tight(3,5,8,[0.06,0.04]);
plot(Xd(:,8),'.k'); title('HB25 4V 20 ms'); set(gca,'YTickLabel',[]);
subplot_tight(3,5,13,[0.06,0.04]);
plot(Xd(:,10),'.k'); title('HB27 2V 40 ms'); set(gca,'YTickLabel',[]);

subplot_tight(3,5,4,[0.06,0.04]);
plot(Xd(:,6),'.k'); title('HB23 3V 30 ms'); set(gca,'YTickLabel',[]);

subplot_tight(3,5,5,[0.06,0.04]);
plot(Xd(:,4),'.k'); title('HB21 4V 30 ms'); set(gca,'YTickLabel',[]);
subplot_tight(3,5,10,[0.06,0.04]);
plot(Xd(:,9),'.k'); title('HB26 3V 40 ms'); set(gca,'YTickLabel',[]);

saveas(gcf,strcat('DataFig_Xd_decay_scaled_normd_byTotalEnergy',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_Xd_decay_scaled_normd_byTotalEnergy_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_Xd_decay_scaled_normd_byTotalEnergy_e',num2str(r),'eps'),'epsc');

%% Subplots by DURATION of laser pulse
subplot_tight(4,4,1,[0.06,0.04]);
plot(Xd(:,5),'.k'); title('HB22 3V 10 ms'); set(gca,'YTickLabel',[]);

subplot_tight(4,4,2,[0.06,0.04]);
plot(Xd(:,1),'.k'); title('HB18 3V 20 ms'); set(gca,'YTickLabel',[]);
subplot_tight(4,4,6,[0.06,0.04]);
plot(Xd(:,2),'.k'); title('HB19 3V 20 ms'); set(gca,'YTickLabel',[]);
subplot_tight(4,4,10,[0.06,0.04]);
plot(Xd(:,7),'.k'); title('HB24 4V 20 ms'); set(gca,'YTickLabel',[]);
subplot_tight(4,4,14,[0.06,0.04]);
plot(Xd(:,8),'.k'); title('HB25 4V 20 ms'); set(gca,'YTickLabel',[]);

subplot_tight(4,4,3,[0.06,0.04]);
plot(Xd(:,3),'.k'); title('HB20 2V 30 ms'); set(gca,'YTickLabel',[]);
subplot_tight(4,4,7,[0.06,0.04]);
plot(Xd(:,4),'.k'); title('HB21 4V 30 ms'); set(gca,'YTickLabel',[]);
subplot_tight(4,4,11,[0.06,0.04]);
plot(Xd(:,6),'.k'); title('HB23 3V 30 ms'); set(gca,'YTickLabel',[]);


subplot_tight(4,4,4,[0.06,0.04]);
plot(Xd(:,10),'.k'); title('HB27 2V 40 ms'); set(gca,'YTickLabel',[]);
subplot_tight(4,4,8,[0.06,0.04]);
plot(Xd(:,9),'.k'); title('HB26 3V 40 ms'); set(gca,'YTickLabel',[]);

saveas(gcf,strcat('DataFig_Xd_decay_scaled_normd_byDuration',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_Xd_decay_scaled_normd_byDuration_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_Xd_decay_scaled_normd_byDuration_e',num2str(r),'eps'),'epsc');

%% Subplots by POWER of laser pulse
clf
subplot_tight(5,3,1,[0.06,0.04]);
plot(Xd(:,3),'.k'); title('HB20 2V 30 ms'); set(gca,'YTickLabel',[]);
subplot_tight(5,3,4,[0.06,0.04]);
plot(Xd(:,10),'.k'); title('HB27 2V 40 ms'); set(gca,'YTickLabel',[]);

subplot_tight(5,3,2,[0.06,0.04]);
plot(Xd(:,5),'.k'); title('HB22 3V 10 ms'); set(gca,'YTickLabel',[]);
subplot_tight(5,3,5,[0.06,0.04]);
plot(Xd(:,1),'.k'); title('HB18 3V 20 ms'); set(gca,'YTickLabel',[]);
subplot_tight(5,3,8,[0.06,0.04]);
plot(Xd(:,2),'.k'); title('HB19 3V 20 ms'); set(gca,'YTickLabel',[]);
subplot_tight(5,3,11,[0.06,0.04]);
plot(Xd(:,6),'.k'); title('HB23 3V 30 ms'); set(gca,'YTickLabel',[]);
subplot_tight(5,3,14,[0.06,0.04]);
plot(Xd(:,9),'.k'); title('HB26 3V 40 ms'); set(gca,'YTickLabel',[]);

subplot_tight(5,3,3,[0.06,0.04]);
plot(Xd(:,7),'.k'); title('HB24 4V 20 ms'); set(gca,'YTickLabel',[]);
subplot_tight(5,3,6,[0.06,0.04]);
plot(Xd(:,8),'.k'); title('HB25 4V 20 ms'); set(gca,'YTickLabel',[]);
subplot_tight(5,3,9,[0.06,0.04]);
plot(Xd(:,4),'.k'); title('HB21 4V 30 ms'); set(gca,'YTickLabel',[]);

saveas(gcf,strcat('DataFig_Xd_decay_scaled_normd_byPower',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_Xd_decay_scaled_normd_byPower_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_Xd_decay_scaled_normd_byPower_e',num2str(r),'eps'),'epsc');

%% Study kinetics as a function of decay
r = 4; % HB21
set(0, 'DefaultAxesColorOrder', ametrine(5));
clf
count = 1;
clear hred
for i = 2:40:180
    logfile_name        = getfield(dir('*.log'),'name');
    logfile_name_clean  = logfile_name(1:end-7);            % remove excess numbers from filename, for use in figure titles below
    logfile             = importdata(logfile_name);
    wavetrain           = logfile.data(r,8);                % get number of wavetrains [actually waveforms] for that run
    laser_delay         = logfile.data(r,43)*.001;          % in milliseconds
    laser_duration      = logfile.data(r,44)*.001;          % in milliseconds
    laser_voltage       = logfile.data(r,63);
    probe_pzt_delay     = logfile.data(r,22)*0.001;         % in seconds
    probe_pzt_duration  = logfile.data(r,23)*0.001;         % in seconds
    pd_ampl_command     = logfile.data(r,55);               % in nm
    beta                = logfile.data(4,106);
    Fs                  = logfile.data(r,12);               % sampling rate
    T                   = 1/Fs;
    L                   = length(struct_data(r).data(:,2));    
    t                   = (0:L-1)*T;  
    
    dc_offset = mean(struct_data(4).data(790:800,i));
    subplot(2,2,1)
    d = struct_data(r).data(:,i)-dc_offset;
    dnorm = (struct_data(r).data(:,i)-dc_offset)/(max(struct_data(r).data(800:1200,i)-dc_offset));
    h1 = plot(t(700:1400),dnorm(700:1400));
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    xlabel('Time (ms)')
    ylabel('Displ. Normd')
    axis([0.07 0.14 -0.2 1.2])
    hold all
    
    subplot(2,2,2)
    h2 = plot(t(700:1400),abs(d(700:1400)));
    hold all
    ylabel('Displ. (nm)')
    xlim([0.07 0.14])
    
    subplot(2,5,7:9)
    plot(Xd(2:180,r),'.k','MarkerSize',15); 
    hred(count) = plot(i,Xd(i,r),'.r','MarkerSize',15); 
    xlabel('Repeat #')
    ylabel('Displ. normalized to first repeat')
    count = count+1;
    hold all
end
uistack(hred,'top')

saveas(gcf,strcat('Kinetics_w_Decay_m',num2str(r),'fig'));
saveas(gcf,strcat('Kinetics_w_Decay_e',num2str(r),'eps'),'epsc');

%% Study kinetics as a function of decay
r = 9; % HB26
set(0, 'DefaultAxesColorOrder', ametrine(5));
clf
count = 1;
clear hred
for i = 2:20:100
    logfile_name        = getfield(dir('*.log'),'name');
    logfile_name_clean  = logfile_name(1:end-7);            % remove excess numbers from filename, for use in figure titles below
    logfile             = importdata(logfile_name);
    wavetrain           = logfile.data(r,8);                % get number of wavetrains [actually waveforms] for that run
    laser_delay         = logfile.data(r,43)*.001;          % in milliseconds
    laser_duration      = logfile.data(r,44)*.001;          % in milliseconds
    laser_voltage       = logfile.data(r,63);
    probe_pzt_delay     = logfile.data(r,22)*0.001;         % in seconds
    probe_pzt_duration  = logfile.data(r,23)*0.001;         % in seconds
    pd_ampl_command     = logfile.data(r,55);               % in nm
    beta                = logfile.data(4,106);
    Fs                  = logfile.data(r,12);               % sampling rate
    T                   = 1/Fs;
    L                   = length(struct_data(r).data(:,2));    
    t                   = (0:L-1)*T;  
    
    dc_offset = mean(struct_data(r).data(790:800,i));
    subplot(2,2,1)
    d = struct_data(r).data(:,i)-dc_offset;
    dnorm = (struct_data(r).data(:,i)-dc_offset)/(min(struct_data(r).data(800:1200,i)-dc_offset));
    h1 = plot(t(700:1400),dnorm(700:1400));
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    xlabel('Time (ms)')
    ylabel('Displ. Normd')
    axis([0.07 0.14 -0.2 1.2])
    hold all
    
    subplot(2,2,2)
    h2 = plot(t(700:1400),abs(d(700:1400)));
    hold all
    ylabel('Displ. (nm)')
    xlim([0.07 0.14])
    
    subplot(2,5,7:9)
    plot(Xd(2:180,r),'.k','MarkerSize',15); 
    hred(count) = plot(i,Xd(i,r),'.r','MarkerSize',15); 
    xlabel('Repeat #')
    ylabel('Displ. normalized to first repeat')
    count = count+1;
    hold all
    axis([0 180 0 1])
end
uistack(hred,'top')

saveas(gcf,strcat('Kinetics_w_Decay_m',num2str(r),'fig'));
saveas(gcf,strcat('Kinetics_w_Decay_e',num2str(r),'eps'),'epsc');

%% Study kinetics as a function of decay
r = 1; % HB18
set(0, 'DefaultAxesColorOrder', ametrine(6));
clf
count = 1;
clear hred
for i = 2:45:250
    logfile_name        = getfield(dir('*.log'),'name');
    logfile_name_clean  = logfile_name(1:end-7);            % remove excess numbers from filename, for use in figure titles below
    logfile             = importdata(logfile_name);
    wavetrain           = logfile.data(r,8);                % get number of wavetrains [actually waveforms] for that run
    laser_delay         = logfile.data(r,43)*.001;          % in milliseconds
    laser_duration      = logfile.data(r,44)*.001;          % in milliseconds
    laser_voltage       = logfile.data(r,63);
    probe_pzt_delay     = logfile.data(r,22)*0.001;         % in seconds
    probe_pzt_duration  = logfile.data(r,23)*0.001;         % in seconds
    pd_ampl_command     = logfile.data(r,55);               % in nm
    beta                = logfile.data(4,106);
    Fs                  = logfile.data(r,12);               % sampling rate
    T                   = 1/Fs;
    L                   = length(struct_data(r).data(:,2));    
    t                   = (0:L-1)*T;  
    
    dc_offset = mean(struct_data(r).data(790:800,i));
    subplot(2,2,1)
    d = struct_data(r).data(:,i)-dc_offset;
    dnorm = (struct_data(r).data(:,i)-dc_offset)/(min(struct_data(r).data(800:1200,i)-dc_offset));
    h1 = plot(t(700:1400),dnorm(700:1400));
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    xlabel('Time (ms)')
    ylabel('Displ. Normd')
    axis([0.07 0.14 -0.2 1.2])
    hold all
    
    subplot(2,2,2)
    h2 = plot(t(700:1400),abs(d(700:1400)));
    hold all
    ylabel('Displ. (nm)')
    xlim([0.07 0.14])
    
    subplot(2,5,7:9)
    plot(Xd(2:300,r),'.k','MarkerSize',15); 
    hred(count) = plot(i,Xd(i,r),'.r','MarkerSize',15); 
    xlabel('Repeat #')
    ylabel('Displ. normalized to first repeat')
    count = count+1;
    hold all
    axis([0 300 0 1])
end
uistack(hred,'top')

saveas(gcf,strcat('Kinetics_w_Decay_m',num2str(r),'fig'));
saveas(gcf,strcat('Kinetics_w_Decay_e',num2str(r),'eps'),'epsc');

%% Study kinetics as a function of decay
r = 6; % HB23
set(0, 'DefaultAxesColorOrder', ametrine(5));
clf
count = 1;
clear hred
for i = 2:35:150
    logfile_name        = getfield(dir('*.log'),'name');
    logfile_name_clean  = logfile_name(1:end-7);            % remove excess numbers from filename, for use in figure titles below
    logfile             = importdata(logfile_name);
    wavetrain           = logfile.data(r,8);                % get number of wavetrains [actually waveforms] for that run
    laser_delay         = logfile.data(r,43)*.001;          % in milliseconds
    laser_duration      = logfile.data(r,44)*.001;          % in milliseconds
    laser_voltage       = logfile.data(r,63);
    probe_pzt_delay     = logfile.data(r,22)*0.001;         % in seconds
    probe_pzt_duration  = logfile.data(r,23)*0.001;         % in seconds
    pd_ampl_command     = logfile.data(r,55);               % in nm
    beta                = logfile.data(4,106);
    Fs                  = logfile.data(r,12);               % sampling rate
    T                   = 1/Fs;
    L                   = length(struct_data(r).data(:,2));    
    t                   = (0:L-1)*T;  
    
    dc_offset = mean(struct_data(r).data(790:800,i));
    subplot(2,2,1)
    d = struct_data(r).data(:,i)-dc_offset;
    dnorm = (struct_data(r).data(:,i)-dc_offset)/(min(struct_data(r).data(800:1200,i)-dc_offset));
    h1 = plot(t(700:1400),dnorm(700:1400));
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    xlabel('Time (ms)')
    ylabel('Displ. Normd')
    axis([0.07 0.14 -0.2 1.2])
    hold all
    
    subplot(2,2,2)
    h2 = plot(t(700:1400),abs(d(700:1400)));
    hold all
    ylabel('Displ. (nm)')
    xlim([0.07 0.14])
    
    subplot(2,5,7:9)
    plot(Xd(2:200,r),'.k','MarkerSize',15); 
    hred(count) = plot(i,Xd(i,r),'.r','MarkerSize',15); 
    xlabel('Repeat #')
    ylabel('Displ. normalized to first repeat')
    count = count+1;
    hold all
    axis([0 200 0 1])
end
uistack(hred,'top')

saveas(gcf,strcat('Kinetics_w_Decay_m',num2str(r),'fig'));
saveas(gcf,strcat('Kinetics_w_Decay_e',num2str(r),'eps'),'epsc');

%% Study kinetics as a function of decay
r = 8; % HB25
set(0, 'DefaultAxesColorOrder', ametrine(5));
clf
count = 1;
clear hred
for i = 4:40:180
    logfile_name        = getfield(dir('*.log'),'name');
    logfile_name_clean  = logfile_name(1:end-7);            % remove excess numbers from filename, for use in figure titles below
    logfile             = importdata(logfile_name);
    wavetrain           = logfile.data(r,8);                % get number of wavetrains [actually waveforms] for that run
    laser_delay         = logfile.data(r,43)*.001;          % in milliseconds
    laser_duration      = logfile.data(r,44)*.001;          % in milliseconds
    laser_voltage       = logfile.data(r,63);
    probe_pzt_delay     = logfile.data(r,22)*0.001;         % in seconds
    probe_pzt_duration  = logfile.data(r,23)*0.001;         % in seconds
    pd_ampl_command     = logfile.data(r,55);               % in nm
    beta                = logfile.data(4,106);
    Fs                  = logfile.data(r,12);               % sampling rate
    T                   = 1/Fs;
    L                   = length(struct_data(r).data(:,2));    
    t                   = (0:L-1)*T;  
    
    dc_offset = mean(struct_data(r).data(790:800,i));
    subplot(2,2,1)
    d = struct_data(r).data(:,i)-dc_offset;
    dnorm = (struct_data(r).data(:,i)-dc_offset)/(min(struct_data(r).data(800:1200,i)-dc_offset));
    h1 = plot(t(700:1400),dnorm(700:1400));
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    xlabel('Time (ms)')
    ylabel('Displ. Normd')
    axis([0.07 0.14 -0.2 1.2])
    hold all
    
    subplot(2,2,2)
    h2 = plot(t(700:1400),abs(d(700:1400)));
    hold all
    ylabel('Displ. (nm)')
    xlim([0.07 0.14])
    
    subplot(2,5,7:9)
    plot(Xd(2:200,r),'.k','MarkerSize',15); 
    hred(count) = plot(i,Xd(i,r),'.r','MarkerSize',15); 
    xlabel('Repeat #')
    ylabel('Displ. normalized to first repeat')
    count = count+1;
    hold all
    axis([0 200 0 1])
end
uistack(hred,'top')

saveas(gcf,strcat('Kinetics_w_Decay_m',num2str(r),'fig'));
saveas(gcf,strcat('Kinetics_w_Decay_e',num2str(r),'eps'),'epsc');

%% Study kinetics as a function of decay
r = 5; % HB22
set(0, 'DefaultAxesColorOrder', ametrine(5));
clf
count = 1;
clear hred
for i = 2:90:400
    logfile_name        = getfield(dir('*.log'),'name');
    logfile_name_clean  = logfile_name(1:end-7);            % remove excess numbers from filename, for use in figure titles below
    logfile             = importdata(logfile_name);
    wavetrain           = logfile.data(r,8);                % get number of wavetrains [actually waveforms] for that run
    laser_delay         = logfile.data(r,43)*.001;          % in milliseconds
    laser_duration      = logfile.data(r,44)*.001;          % in milliseconds
    laser_voltage       = logfile.data(r,63);
    probe_pzt_delay     = logfile.data(r,22)*0.001;         % in seconds
    probe_pzt_duration  = logfile.data(r,23)*0.001;         % in seconds
    pd_ampl_command     = logfile.data(r,55);               % in nm
    beta                = logfile.data(4,106);
    Fs                  = logfile.data(r,12);               % sampling rate
    T                   = 1/Fs;
    L                   = length(struct_data(r).data(:,2));    
    t                   = (0:L-1)*T;  
    
    dc_offset = mean(struct_data(r).data(790:800,i));
    subplot(2,2,1)
    d = struct_data(r).data(:,i)-dc_offset;
    dnorm = (struct_data(r).data(:,i)-dc_offset)/(min(struct_data(r).data(800:1200,i)-dc_offset));
    h1 = plot(t(700:1400),dnorm(700:1400));
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    xlabel('Time (ms)')
    ylabel('Displ. Normd')
    axis([0.07 0.14 -0.2 1.2])
    hold all
    
    subplot(2,2,2)
    h2 = plot(t(700:1400),abs(d(700:1400)));
    hold all
    ylabel('Displ. (nm)')
    xlim([0.07 0.14])
    
    subplot(2,5,7:9)
    plot(Xd(2:400,r),'.k','MarkerSize',15); 
    hred(count) = plot(i,Xd(i,r),'.r','MarkerSize',15); 
    xlabel('Repeat #')
    ylabel('Displ. normalized to first repeat')
    count = count+1;
    hold all
    axis([0 400 0 1])
end
uistack(hred,'top')

saveas(gcf,strcat('Kinetics_w_Decay_m',num2str(r),'fig'));
saveas(gcf,strcat('Kinetics_w_Decay_e',num2str(r),'eps'),'epsc');
