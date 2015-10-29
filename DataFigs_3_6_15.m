% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-03-06.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%% Get all the laser-evoked amplitudes from all appropriate records
deltas = zeros(100,36);
for r = 2:37;
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

    for i = 2:101 % Go through each of the 100 waveforms for each run
       a = mean(struct_data(r).data(1:Fs*0.02,i));               % baseline for pd
       x_pd = mean(struct_data(r).data(Fs*0.037:Fs*0.057,i));    % pd value
       pd = x_pd - a;                                           % p magnitude
       scaling_factor = pd/30;                                  % scaling factor for x
       b = mean(struct_data(r).data(Fs*0.085:Fs*0.120,i));       % baseline for x
       x = mean(struct_data(r).data(Fs*0.126:Fs*0.159,i));       % x value
       delta = abs(x-b);
       delta_scaled = delta/scaling_factor;
       deltas(i-1,r-1) = delta_scaled;
    end
end

%% Plot amplitudes as a function of repetition number
clf
subplot_tight(3,1,1,[0.005 0.03])
% HB 1
plot([1:100] , deltas(:,1),'.','Color',[0 0.9 0]); hold on;
plot([101:200],deltas(:,2),'.','Color',[0 0.9 0]);
plot([201:300],deltas(:,3),'.','Color',[0 0.9 0]);
% HB 2
plot([1:100] , deltas(:,4),'.','Color',[0.1 0.7 0.5]);
plot([101:200],deltas(:,5),'.','Color',[0.1 0.7 0.5]);
plot([201:300],deltas(:,6),'.','Color',[0.1 0.7 0.5]);
plot([301:400],deltas(:,7),'.','Color',[0.1 0.7 0.5]);
% HB 3
plot([1:100] , deltas(:,8),'.','Color', [0 0.5 0]);
plot([101:200],deltas(:,9),'.','Color', [0 0.5 0]);
plot([201:300],deltas(:,10),'.','Color',[0 0.5 0]);
plot([301:400],deltas(:,11),'.','Color',[0 0.5 0]);
axis([0 800 0 100])
set(gca,'XTickLabel',[])
text(400,90,'3/6/15 Decay of Laser-Evoked Mvts','HorizontalAlignment','center','fontsize',16)
text(400,80,'Full Power, 40 ms Pulse','HorizontalAlignment','center','color',[0 0.7 0],'fontsize',16)
ylabel('Magnitude (nm)')

subplot_tight(3,1,2,[0.005 0.03])
% HB 4 - 20 ms
plot([1:100] , deltas(:,12),'.','Color',[1 0 0]); hold on;
plot([101:200],deltas(:,13),'.','Color',[1 0 0]);
plot([201:300],deltas(:,14),'.','Color',[1 0 0]);
plot([301:400],deltas(:,15),'.','Color',[1 0 0]);
plot([401:500],deltas(:,16),'.','Color',[1 0 0]);
% HB 5
plot([1:100] , deltas(:,17),'.','Color',[1 0.4 0]); 
plot([101:200],deltas(:,18),'.','Color',[1 0.4 0]);
% HB 6
plot([1:100] , deltas(:,19),'.','Color',[1 0.8 0]); hold on;
plot([101:200],deltas(:,20),'.','Color',[1 0.8 0]);
plot([201:300],deltas(:,21),'.','Color',[1 0.8 0]);
plot([301:400],deltas(:,22),'.','Color',[1 0.8 0]);
plot([401:500],deltas(:,23),'.','Color',[1 0.8 0]);
plot([501:600],deltas(:,24),'.','Color',[1 0.8 0]);
axis([0 800 0 70])
set(gca,'XTickLabel',[])
text(400,63,'Full Power, 20 ms Pulse','HorizontalAlignment','center','color',[1 0.4 0],'fontsize',16)
ylabel('Magnitude (nm)')

subplot_tight(3,1,3,[0.02 0.03])
% HB 7
plot([1:100] , deltas(:,25),'.','Color',[.5 0.2 .8]); hold on;
plot([101:200],deltas(:,26),'.','Color',[.5 0.2 .8]);
plot([201:300],deltas(:,27),'.','Color',[.5 0.2 .8]);
plot([301:400],deltas(:,28),'.','Color',[.5 0.2 .8]);
% HB 8
plot([1:100] , deltas(:,29),'.','Color',[.2 0.1 1]); hold on;
plot([101:200],deltas(:,30),'.','Color',[.2 0.1 1]);
plot([201:300],deltas(:,31),'.','Color',[.2 0.1 1]);
plot([301:400],deltas(:,32),'.','Color',[.2 0.1 1]);
plot([401:500],deltas(:,33),'.','Color',[.2 0.1 1]);
plot([501:600],deltas(:,34),'.','Color',[.2 0.1 1]);
plot([601:700],deltas(:,35),'.','Color',[.2 0.1 1]);
plot([701:800],deltas(:,36),'.','Color',[.2 0.1 1]);
axis([0 800 0 60])
text(400,53,'Half Power, 40 ms Pulse','HorizontalAlignment','center','color',[0.2 0.1 1],'fontsize',16)
xlabel('Repetitions')
ylabel('Magnitude (nm)')

%% Normalize the amplitudes
HB1_max = max(max(deltas(:,1:3)));
HB2_max = max(max(deltas(:,4:7)));
HB3_max = max(max(deltas(:,8:11)));
HB4_max = max(max(deltas(:,12:16)));
HB5_max = max(max(deltas(:,17:18)));
HB6_max = max(max(deltas(:,19:24)));
HB7_max = max(max(deltas(:,25:28)));
HB8_max = max(max(deltas(:,29:36)));
deltas_norm = deltas(:,1:3)/HB1_max;
deltas_norm(:,4:7) = deltas(:,4:7)/HB2_max;
deltas_norm(:,8:11) = deltas(:,8:11)/HB3_max;
deltas_norm(:,12:16) = deltas(:,12:16)/HB4_max;
deltas_norm(:,17:18) = deltas(:,17:18)/HB5_max;
deltas_norm(:,19:24) = deltas(:,19:24)/HB6_max;
deltas_norm(:,25:28) = deltas(:,25:28)/HB7_max;
deltas_norm(:,29:36) = deltas(:,29:36)/HB8_max;

%%
clf
subplot_tight(3,1,1,[0.005 0.03])
% HB 1
plot([1:100] , deltas_norm(:,1),'.','Color',[0 0.9 0]); hold on;
plot([101:200],deltas_norm(:,2),'.','Color',[0 0.9 0]);
plot([201:300],deltas_norm(:,3),'.','Color',[0 0.9 0]);
% HB 2
plot([1:100] , deltas_norm(:,4),'.','Color',[0.1 0.7 0.5]);
plot([101:200],deltas_norm(:,5),'.','Color',[0.1 0.7 0.5]);
plot([201:300],deltas_norm(:,6),'.','Color',[0.1 0.7 0.5]);
plot([301:400],deltas_norm(:,7),'.','Color',[0.1 0.7 0.5]);
% HB 3
plot([1:100] , deltas_norm(:,8),'.','Color', [0 0.5 0]);
plot([101:200],deltas_norm(:,9),'.','Color', [0 0.5 0]);
plot([201:300],deltas_norm(:,10),'.','Color',[0 0.5 0]);
plot([301:400],deltas_norm(:,11),'.','Color',[0 0.5 0]);
axis([0 800 0 1])
set(gca,'XTickLabel',[])
text(400,0.9,'3/6/15 Normalized Decay','HorizontalAlignment','center','fontsize',16)
text(400,0.78,'Full Power, 40 ms Pulse','HorizontalAlignment','left','color',[0 0.7 0],'fontsize',16)
ylabel('Normalized Amplitude')

subplot_tight(3,1,2,[0.005 0.03])
% HB 4 - 20 ms
plot([1:100] , deltas_norm(:,12),'.','Color',[1 0 0]); hold on;
plot([101:200],deltas_norm(:,13),'.','Color',[1 0 0]);
plot([201:300],deltas_norm(:,14),'.','Color',[1 0 0]);
plot([301:400],deltas_norm(:,15),'.','Color',[1 0 0]);
plot([401:500],deltas_norm(:,16),'.','Color',[1 0 0]);
% HB 5
%plot([1:100] , deltas_norm(:,17),'o','Color',[1 0.4 0]); 
%plot([101:200],deltas_norm(:,18),'o','Color',[1 0.4 0]);
% HB 6
plot([1:100] , deltas_norm(:,19),'.','Color',[1 0.8 0]); hold on;
plot([101:200],deltas_norm(:,20),'.','Color',[1 0.8 0]);
plot([201:300],deltas_norm(:,21),'.','Color',[1 0.8 0]);
plot([301:400],deltas_norm(:,22),'.','Color',[1 0.8 0]);
plot([401:500],deltas_norm(:,23),'.','Color',[1 0.8 0]);
plot([501:600],deltas_norm(:,24),'.','Color',[1 0.8 0]);
axis([0 800 0 1])
set(gca,'XTickLabel',[])
text(400,0.9,'Full Power, 20 ms Pulse','HorizontalAlignment','left','color',[1 0.4 0],'fontsize',16)
ylabel('Magnitude (nm)')

subplot_tight(3,1,3,[0.02 0.03])
% HB 7
plot([1:100] , deltas_norm(:,25),'.','Color',[.5 0.2 .8]); hold on;
plot([101:200],deltas_norm(:,26),'.','Color',[.5 0.2 .8]);
plot([201:300],deltas_norm(:,27),'.','Color',[.5 0.2 .8]);
plot([301:400],deltas_norm(:,28),'.','Color',[.5 0.2 .8]);
% HB 8
plot([1:100] , deltas_norm(:,29),'.','Color',[.2 0.1 1]); hold on;
plot([101:200],deltas_norm(:,30),'.','Color',[.2 0.1 1]);
plot([201:300],deltas_norm(:,31),'.','Color',[.2 0.1 1]);
plot([301:400],deltas_norm(:,32),'.','Color',[.2 0.1 1]);
plot([401:500],deltas_norm(:,33),'.','Color',[.2 0.1 1]);
plot([501:600],deltas_norm(:,34),'.','Color',[.2 0.1 1]);
plot([601:700],deltas_norm(:,35),'.','Color',[.2 0.1 1]);
plot([701:800],deltas_norm(:,36),'.','Color',[.2 0.1 1]);
axis([0 800 0 1])
text(460,0.9,'Half Power, 40 ms Pulse','HorizontalAlignment','left','color',[0.2 0.1 1],'fontsize',14)
ylabel('Normalized Amplitude')

%% All on one plot, normalized
clf
% HB 1
plot([1:100] , deltas_norm(:,1),'.','Color',[0 0.9 0]); hold on;
plot([101:200],deltas_norm(:,2),'.','Color',[0 0.9 0]);
plot([201:300],deltas_norm(:,3),'.','Color',[0 0.9 0]);
% HB 2
plot([1:100] , deltas_norm(:,4),'.','Color',[0.1 0.7 0.5]);
plot([101:200],deltas_norm(:,5),'.','Color',[0.1 0.7 0.5]);
plot([201:300],deltas_norm(:,6),'.','Color',[0.1 0.7 0.5]);
plot([301:400],deltas_norm(:,7),'.','Color',[0.1 0.7 0.5]);
% HB 3
plot([1:100] , deltas_norm(:,8),'.','Color', [0 0.5 0]);
plot([101:200],deltas_norm(:,9),'.','Color', [0 0.5 0]);
plot([201:300],deltas_norm(:,10),'.','Color',[0 0.5 0]);
plot([301:400],deltas_norm(:,11),'.','Color',[0 0.5 0]);
text(400,0.9,'3/6/15 Normalized Decay','HorizontalAlignment','center','fontsize',16)


% HB 4 - 20 ms
plot([1:100] , deltas_norm(:,12),'.','Color',[1 0 0]); hold on;
plot([101:200],deltas_norm(:,13),'.','Color',[1 0 0]);
plot([201:300],deltas_norm(:,14),'.','Color',[1 0 0]);
plot([301:400],deltas_norm(:,15),'.','Color',[1 0 0]);
plot([401:500],deltas_norm(:,16),'.','Color',[1 0 0]);
% HB 5
plot([1:100] , deltas_norm(:,17),'o','Color',[1 0.4 0]); 
plot([101:200],deltas_norm(:,18),'o','Color',[1 0.4 0]);
% HB 6
plot([1:100] , deltas_norm(:,19),'.','Color',[1 0.8 0]); hold on;
plot([101:200],deltas_norm(:,20),'.','Color',[1 0.8 0]);
plot([201:300],deltas_norm(:,21),'.','Color',[1 0.8 0]);
plot([301:400],deltas_norm(:,22),'.','Color',[1 0.8 0]);
plot([401:500],deltas_norm(:,23),'.','Color',[1 0.8 0]);
plot([501:600],deltas_norm(:,24),'.','Color',[1 0.8 0]);
axis([0 800 0 1])


% HB 7
plot([1:100] , deltas_norm(:,25),'.','Color',[.5 0.2 .8]); hold on;
plot([101:200],deltas_norm(:,26),'.','Color',[.5 0.2 .8]);
plot([201:300],deltas_norm(:,27),'.','Color',[.5 0.2 .8]);
plot([301:400],deltas_norm(:,28),'.','Color',[.5 0.2 .8]);
% HB 8
plot([1:100] , deltas_norm(:,29),'.','Color',[.2 0.1 1]); hold on;
plot([101:200],deltas_norm(:,30),'.','Color',[.2 0.1 1]);
plot([201:300],deltas_norm(:,31),'.','Color',[.2 0.1 1]);
plot([301:400],deltas_norm(:,32),'.','Color',[.2 0.1 1]);
plot([401:500],deltas_norm(:,33),'.','Color',[.2 0.1 1]);
plot([501:600],deltas_norm(:,34),'.','Color',[.2 0.1 1]);
plot([601:700],deltas_norm(:,35),'.','Color',[.2 0.1 1]);
plot([701:800],deltas_norm(:,36),'.','Color',[.2 0.1 1]);
axis([0 800 0 1])
ylabel('Normalized Amplitude')
xlabel('Repetitions')

%%
clf
r = 30;
plot(t,struct_data(r).data(:,2),'Color',[.2 .1 1])




