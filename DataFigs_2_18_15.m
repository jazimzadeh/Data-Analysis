% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-02-18.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list


%% Plot Ionto, Displacement, Current, Vm holding, Laser command
for r = 1:4;
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
    subplot(7,1,4:5)
    plot(t,struct_data(r).data(:,3*wavetrain+2:4*wavetrain+1));
    ylabel('Current (pA)');
    
    % Voltage steps (Vm)
    subplot(7,1,6)
    plot(t,struct_data(r).data(:,4*wavetrain+2:5*wavetrain+1));
    ylabel('Voltage (mV)');
    
    % Laser command
    subplot(7,1,7)
    plot(t,struct_data(r).data(:,5*wavetrain+2:6*wavetrain+1));
    ylabel('Laser Voltage');
    
    saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

%% Plot just laser stimulus and displacement
for r = 5:length(fileList2);
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
    subplot(3,1,1:2)
    plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1));
    ylabel('Displacement (nm)');
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',12)
    
    % Laser command
    subplot(3,1,3)
    plot(t,struct_data(r).data(:,5*wavetrain+2:6*wavetrain+1));
    ylabel('Laser Command (V)');
    
    saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

%% Plot the sine wave stimuli with the detected power
for r = 37:41

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
    
    subplot(2,1,1)
    plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1));
    ylabel('Displacement (nm)');
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',12)
    
    subplot(2,1,2)
    plot(t,struct_data(r).data(:,6*wavetrain+2:7*wavetrain+1));
    ylabel('Laser Voltage');
    
    saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
    
end

%% Overlay laser pick-off and displacement for sine waves (Records 37:41) and ramps (Recs 42 & 43)
r=43;    
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
    
    dc_X = mean(struct_data(r).data(Fs*0.01:Fs*0.02,1*wavetrain+2:2*wavetrain+1));
    max_X = max(max(struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1)));
    max_power = max(max(struct_data(r).data(:,6*wavetrain+2:7*wavetrain+1)));
    power_scaling = abs(1.2*max_X/max_power);
    plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1)-dc_X);
    ylabel('Displacement (nm)');
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',12)
    hold on
    plot(t,1*power_scaling*struct_data(r).data(:,6*wavetrain+2:7*wavetrain+1),'r');
    
    saveas(gcf,strcat('DataFig_overlay',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_overlay_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_overlay_e',num2str(r),'eps'),'epsc');
    
    %% Plot the delta X from second to first pulse as a function of the first pulse's laser power
    r=11;
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
    subplot(2,1,1)
    plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1));
    ylabel('Displacement (nm)');
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',12)
    
    % Delta d as a function of step 1 amplitude
    subplot(2,1,2)
    for i = wavetrain+2:2*wavetrain+1
        X_step2 = mean(struct_data(r).data(Fs*0.138:Fs*0.140,i));
        X_step1 = mean(struct_data(r).data(Fs*0.128:Fs*0.130,i));
        delta_X(i-(wavetrain+1)) = X_step2 - X_step1;
    end
    
    for i = 5*wavetrain+2:6*wavetrain+1
        power_first(i-(5*wavetrain+1)) = mean(struct_data(r).data(Fs*0.128:Fs*0.130,i));
    end
    
    for i = 1: length(power_first)
    plot(power_first(i),delta_X(i),'.','MarkerSize',20);
    hold all
    end
    xlabel('Power of first pulse')
    ylabel('Delta X (nm)')
    
    %%
for r = 11:16
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

    % Delta d as a function of step 1 amplitude
    for i = wavetrain+2:2*wavetrain+1
        X_step2 = mean(struct_data(r).data(Fs*0.138:Fs*0.140,i));
        X_step1 = mean(struct_data(r).data(Fs*0.128:Fs*0.130,i));
        delta_X(i-(wavetrain+1),r-10) = X_step2 - X_step1;
    end
    
    for i = 5*wavetrain+2:6*wavetrain+1
        power_first(i-(5*wavetrain+1),r-10) = mean(struct_data(r).data(Fs*0.128:Fs*0.130,i));
    end
end
    
    clf

    plot40ms = plot(power_first(:,1),delta_X(:,1),'Color',[1 0.1 0],'LineWidth',2);
    hold on
    plot30ms = plot(power_first(:,2),delta_X(:,2),'Color',[1 0.5 0],'LineWidth',2);
    plot25ms = plot(power_first(:,3),delta_X(:,3),'Color',[1 1 0],'LineWidth',2);
    plot20ms = plot(power_first(:,4),delta_X(:,4),'Color',[0 1 0],'LineWidth',2);
    plot10ms = plot(power_first(:,5),delta_X(:,5),'Color',[0 0.7 0.5],'LineWidth',2);
    plot5ms = plot(power_first(:,6),delta_X(:,6),'Color',[0 0.3 0.9],'LineWidth',2);  
    
    leg = legend([plot40ms,plot30ms,plot25ms,plot20ms,plot10ms,plot5ms],'40 ms','30 ms', '25 ms','20 ms','10 ms','5 ms');
    htitle = get(leg,'Title');
    set(htitle,'String','Duration');
    
    xlabel('Power of first pulse');
    ylabel('Delta X between first and second pulse (nm)');
    title('2/18/15 Records 11-16');
    
    saveas(gcf,strcat('DataFig_deltaX',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_deltaX_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_deltaX_e',num2str(r),'eps'),'epsc');
    
    %%
for r = 17:23
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

        % Delta d as a function of step 1 amplitude
        for i = wavetrain+2:2*wavetrain+1
            X_step2 = mean(struct_data(r).data(Fs*0.138:Fs*0.140,i));
            X_step1 = mean(struct_data(r).data(Fs*0.128:Fs*0.130,i));
            delta_X(i-(wavetrain+1),r-16) = X_step2 - X_step1;
        end

        for i = 5*wavetrain+2:6*wavetrain+1
            power_first(i-(5*wavetrain+1),r-16) = mean(struct_data(r).data(Fs*0.128:Fs*0.130,i));
        end
end
    
    clf

    plot40ms = plot(power_first(:,1),delta_X(:,1),'Color',[1 0.1 0],'LineWidth',2);
    hold on
    plot30ms = plot(power_first(:,2),delta_X(:,2),'Color',[1 0.5 0],'LineWidth',2);
    plot20ms = plot(power_first(:,3),delta_X(:,3),'Color',[1 1 0],'LineWidth',2);
    plot10ms = plot(power_first(:,4),delta_X(:,4),'Color',[0 1 0],'LineWidth',2);
    plot5ms = plot(power_first(:,5),delta_X(:,5),'Color',[0 0.7 0.5],'LineWidth',2);
    plot40_2ms = plot(power_first(:,6),delta_X(:,6),'Color',[0.1 0.1 0.1],'LineWidth',2);  
    plot30_2ms = plot(power_first(:,7),delta_X(:,7),'Color',[0.5 0.4 0.4],'LineWidth',2);  
    
    leg = legend([plot40ms,plot30ms,plot20ms,plot10ms,plot5ms, plot40_2ms,plot30_2ms],'40 ms','30 ms', '20 ms','10 ms','5 ms',' 40 2 ms', '30 2 ms');
    htitle = get(leg,'Title');
    set(htitle,'String','Duration');
    
    xlabel('Power of first pulse');
    ylabel('Delta X between first and second pulse (nm)');
    title('2/18/15 Records 17-23');
    
    saveas(gcf,strcat('DataFig_deltaX',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_deltaX_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_deltaX_e',num2str(r),'eps'),'epsc');
    
    
    

    
    
    