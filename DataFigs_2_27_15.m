% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-02-27.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list


%% Plot Ionto, Displacement, Current, Vm holding, Laser command
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
    h1 = subplot(7,1,4:5)
    plot(t,struct_data(r).data(:,3*wavetrain+2:4*wavetrain+1));
    ylabel('Current (pA)');
        % Create the blow-up region in a box:
        P = get(h1,'Position');  % get position information for subplot
        F = P(3)/(t(end)-t(1));  % divide width of subplot by its duration to get a scaling factor that converts between the two
        box_left = P(1) + laser_delay*F;
        box_bottom = P(2) + 0.5*(P(4));         % add a fraction of the height to the bottom parameter of the subplot to generate the bottom coordinate for the box
        box_width = 1.2*laser_duration*F;       % box width should be a little wider than the laser_duration
        box_height = 0.4*P(4);
        axes('Position',[box_left box_bottom box_width box_height],'Box','on')
        plot(t(laser_delay*Fs:(laser_delay + 1.2*laser_duration)*Fs),struct_data(r).data(laser_delay*Fs:(laser_delay + 1.2*laser_duration)*Fs,3*wavetrain+2:4*wavetrain+1));
        maximum = max(max(struct_data(r).data(laser_delay*Fs:(laser_delay + 1.2*laser_duration)*Fs,3*wavetrain+2:4*wavetrain+1))); % find maximum value within the blown-up region
        minimum = min(min(struct_data(r).data(laser_delay*Fs:(laser_delay + 1.2*laser_duration)*Fs,3*wavetrain+2:4*wavetrain+1))); % find maximum value within the blown-up region
        axis([laser_delay laser_delay+1.2*laser_duration 1.1*minimum 1.1*maximum])
        set(gca,'xtick',[])
        set(gca,'xticklabel',[])
    
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

%% Plot current as function of genta ionto
for r = 12
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
subplot(7,1,1)
plot(t(Fs*0.105:length(struct_data(r).data)),struct_data(r).data((Fs*0.105:length(struct_data(r).data)),0*wavetrain+2:1*wavetrain+1));
title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',12)
ylabel('Iontophoresis current (nA)')

h1 = subplot(7,1,2:4)
for i = 20:25
dc_i = mean(struct_data(r).data(0.122*Fs:0.130*Fs,i));   % find the dc offset
plot(t(Fs*0.105:length(struct_data(r).data)),struct_data(r).data((Fs*0.105:length(struct_data(r).data)),i)-dc_i);
hold all
end
ylabel('Current (pA)');
% Patch
ylim = get(gca, 'YLim');
x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 
   

Ionto_i = zeros(wavetrain,1);
Max_i = zeros(wavetrain,1);

for i = 2:7
    Ionto_i(i-1) = mean(struct_data(r).data((Fs*0.14:Fs*0.15),i) );
end

for i = 20:25
    Baseline_i = mean(struct_data(r).data((Fs*0.12:Fs*0.13),i));
    Peak_i = mean(struct_data(r).data((Fs*0.133:Fs*0.139),i));
    Max_i(i-19) = abs(Peak_i - Baseline_i);
end

%subplot(7,1,5:7)
subplot(3,4,10:11)
%Plot
for i = 1:length(Ionto_i)
plot(Ionto_i(i),Max_i(i),'.','MarkerSize',20)
hold all
end
ylabel('Peak current (pA)')
xlabel('Iontophoresis Current (nA)')
%axis([-30 60 0 70])

saveas(gcf,strcat('DataFig_Genta',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_Genta_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_Genta_e',num2str(r),'eps'),'epsc');
end


 %% Record 22 just current
    clf
    r=22;
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
    avg_i = mean(struct_data(r).data(:,20:25),2);
    plot(t(0.12*Fs : end),avg_i(0.12*Fs:end,:));
    ylabel('Current (pA)');
    maximum = max(max(struct_data(r).data((0.12*Fs : end),20:25))); % find maximum value within the blown-up region
    minimum = min(min(struct_data(r).data((0.12*Fs : end),20:25))); % find maximum value within the blown-up region
    axis([0.12 0.2 minimum maximum])
     ylim = get(gca, 'YLim');
        ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
        x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
        y = [ylim(1) ylim(2)-0.3 ylim(2)-0.3 ylim(1)+0.2 ylim(1)+0.2]; 
        patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',12)
    
saveas(gcf,strcat('DataFig_Rec22_just_current_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_Rec22_just_current_e',num2str(r),'eps'),'epsc');

 %% Record 7 just current
    clf
    r=7;
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
    avg_i = mean(struct_data(r).data(:,20:25),2);
    plot(t(0.12*Fs : end),avg_i(0.12*Fs:end,:));
    ylabel('Current (pA)');
    maximum = max(max(struct_data(r).data((0.12*Fs : end),20:25))); % find maximum value within the blown-up region
    minimum = min(min(struct_data(r).data((0.12*Fs : end),20:25))); % find maximum value within the blown-up region
    axis([0.12 0.2 -150 maximum])
     ylim = get(gca, 'YLim');
        ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
        x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
        y = [ylim(1) ylim(2)-0.3 ylim(2)-0.3 ylim(1)+0.2 ylim(1)+0.2]; 
        patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',12)
    
saveas(gcf,strcat('DataFig_Rec7_just_current_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_Rec7_just_current_e',num2str(r),'eps'),'epsc');

 %% Record 11 just current
    clf
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

    % Current
    avg_i = mean(struct_data(r).data(:,20:25),2);
    plot(t(0.12*Fs : end),avg_i(0.12*Fs:end,:));
    ylabel('Current (pA)');
    maximum = max(max(struct_data(r).data((0.12*Fs : end),20:25))); % find maximum value within the blown-up region
    minimum = min(min(struct_data(r).data((0.12*Fs : end),20:25))); % find maximum value within the blown-up region
    axis([0.12 0.2 minimum maximum])
     ylim = get(gca, 'YLim');
        ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
        x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
        y = [ylim(1) ylim(2)-0.3 ylim(2)-0.3 ylim(1)+0.2 ylim(1)+0.2]; 
        patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',12)
    
saveas(gcf,strcat('DataFig_Rec11_just_current_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_Rec11_just_current_e',num2str(r),'eps'),'epsc');



