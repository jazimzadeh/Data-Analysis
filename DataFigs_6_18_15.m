% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-06-18.01/Ear 1/Cell 1')
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
    
    set(0, 'DefaultAxesColorOrder', jet(3));

    % Displacement
    subplot(3,1,1:2)
    plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1));
    ylabel('Displacement (nm)');
    
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    xlabel('Time (seconds)');
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1}},'fontsize',12)
    
    % Laser Command
    h1 = subplot(3,1,3);
    plot(t,struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1));
    ylabel('Laser Command (V)');        
    
    saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

%% Plot HB 2 Records
clf
r=2;

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

offset = mean(struct_data(r).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));

% Plot laser stim
subplot(4,1,1)
plot(t,struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1));
axis([0 0.4 -1 5])
title('6/18/15 - HB2 - Catalase and Riboflavin')

% Plot displacement responses
subplot(4,1,2:4)
plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1)-offset);
text(0.1,10,'Catalase');
hold on
plot(t,struct_data(3).data(:,1*wavetrain+2:2*wavetrain+1)-offset-100);
text(0.1,-80,'Perilymph');
plot(t,struct_data(4).data(:,1*wavetrain+2:2*wavetrain+1)-offset-150);
text(0.1,-125,'Riboflavin');
plot(t,struct_data(5).data(:,1*wavetrain+2:2*wavetrain+1)-offset-200);
text(0.1,-160,'Riboflavin');
plot(t,struct_data(6).data(:,1*wavetrain+2:2*wavetrain+1)-offset-320);
text(0.1,-195,'Perilymph');

saveas(gcf,strcat('DataFig_HB2_catalase_ribovlavin_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_HB2_catalase_ribovlavin_e',num2str(r),'eps'),'epsc');

%% HB3 - PClP
clf
r=7;

% Plot laser stim
subplot(4,1,1)
plot(t,struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1),'k','LineWidth',2);
axis([0 0.4 -1 5])
title('6/18/15 - HB3 - Pentachloropseudilin','FontSize',15)

% Plot displacement responses
subplot(4,1,2:4)
offset = mean(struct_data(r).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1)-offset,'color',[0.2,0.3,0.9]);
text(0.1,15,'Perilymph','color',[0.2,0.3,0.9]);
hold on

offset = mean(struct_data(9).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
plot(t,struct_data(9).data(:,1*wavetrain+2:2*wavetrain+1)-offset-60,'color',[0.9,0.1,0.1]);
text(0.1,-50,'PClP','color',[0.9,0.1,0.1]);

offset = mean(struct_data(10).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
plot(t,struct_data(10).data(:,1*wavetrain+2:2*wavetrain+1)-offset-100,'color',[0.9,0.1,0.1]);
text(0.1,-90,'PClP','color',[0.9,0.1,0.1]);

offset = mean(struct_data(11).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
plot(t,struct_data(11).data(:,1*wavetrain+2:2*wavetrain+1)-offset-150,'color',[0.9,0.1,0.1]);
text(0.1,-140,'PClP, 4 min','color',[0.9,0.1,0.1]);

offset = mean(struct_data(12).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
plot(t,struct_data(12).data(:,1*wavetrain+2:2*wavetrain+1)-offset-200,'color',[0.9,0.1,0.1]);
text(0.1,-190,'PClP, 5 min','color',[0.9,0.1,0.1]);

offset = mean(struct_data(13).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
plot(t,struct_data(13).data(:,1*wavetrain+2:2*wavetrain+1)-offset-250,'color',[0.2,0.3,0.9]);
text(0.1,-230,'Perilymph','color',[0.2,0.3,0.9]);

% Patch
    ylim = get(gca, 'YLim');
    x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
    y = [ylim(1)+0.01 ylim(2)-0.05 ylim(2)-0.05 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 

xlabel('Time (Sec)','FontSize',14);
ylabel('Displacement (nm)','FontSize',14);

saveas(gcf,strcat('DataFig_HB3_PClP_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_HB3_PClP_e',num2str(r),'eps'),'epsc');

%% HB 5 - PClP

clf
r=22;

% Plot laser stim
subplot(4,1,1)
plot(t,struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1),'k','LineWidth',2);
axis([0 0.4 -1 5])
title('6/18/15 - HB5 - Pentachloropseudilin','FontSize',15)

% Plot displacement responses
subplot(4,1,2:4)
offset = mean(struct_data(r).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1)-offset,'color',[0.2,0.3,0.9]);
text(0.1,15,'Perilymph','color',[0.2,0.3,0.9]);
hold on

offset = mean(struct_data(23).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
plot(t,struct_data(23).data(:,1*wavetrain+2:2*wavetrain+1)-offset-60,'color',[0.9,0.1,0.1]);
text(0.1,-49,'PClP','color',[0.9,0.1,0.1]);

offset = mean(struct_data(25).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
plot(t,struct_data(25).data(:,1*wavetrain+2:2*wavetrain+1)-offset-140,'color',[0.9,0.1,0.1]);
text(0.1,-125,'PClP, 4:40 min','color',[0.9,0.1,0.1]);

offset = mean(struct_data(26).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
plot(t,struct_data(26).data(:,1*wavetrain+2:2*wavetrain+1)-offset-180,'color',[0.9,0.1,0.1]);
text(0.1,-165,'PClP, 10 min','color',[0.9,0.1,0.1]);

% Patch
    ylim = get(gca, 'YLim');
    x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
    y = [ylim(1)+0.01 ylim(2)-0.05 ylim(2)-0.05 ylim(1)+0.01 ylim(1)+0.01]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 

xlabel('Time (Sec)','FontSize',14);
ylabel('Displacement (nm)','FontSize',14);

saveas(gcf,strcat('DataFig_HB5_PClP_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_HB5_PClP_e',num2str(r),'eps'),'epsc');

