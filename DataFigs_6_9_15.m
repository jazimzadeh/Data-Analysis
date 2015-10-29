% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-06-09.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt
struct_data = cellfun(@importdata,{fileList2.name});
close(gcf);

%%
for r = 1:length(fileList2)
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

 
ylabel('Ionto (nA)')
offset = 0;
subplot(4,1,1:3)
    for j = 1*wavetrain+2 : 2*wavetrain+1
    plot(t,struct_data(r).data(:,j) + offset)
    offset = offset + 40;
    hold all
    end
ylabel('Displacement (nm)')
title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',13)

% Make patch over laser pulse:
ylim = get(gca, 'YLim');
x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 

% subplot(4,1,4)
% plot(t,struct_data(r).data(:,4*wavetrain+2:5*wavetrain+1))
% ylabel('Laser command')

saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

%% Overlay plots of recs 14,15,16 (HB5)
clf

r=15;
Fs = 20000;         %sampling rate
T = 1/Fs;
L = length(struct_data(r).data(:,2));    
t = (0:L-1)*T;
offset = mean(struct_data(r).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1)-offset,'r');
hold on

r=14;
Fs = 20000;         %sampling rate
T = 1/Fs;
L = length(struct_data(r).data(:,2));    
t = (0:L-1)*T;
offset = mean(struct_data(r).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1)-offset);

% r=16;
% Fs = 20000;         %sampling rate
% T = 1/Fs;
% L = length(struct_data(r).data(:,2));    
% t = (0:L-1)*T;
% offset = mean(struct_data(r).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
% plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1)-offset,'m');

title('6/9/15 - HB5 - Overlaid Recs 14 & 15 (40 ms, 500 ms)','FontSize',16);
xlabel('Time (sec)');
ylabel('Displacement (nm)');

saveas(gcf,strcat('DataFig_14_15_overlaid',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_14_15_overlaid_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_14_15_overlaid_e',num2str(r),'eps'),'epsc');

%% 6/10/15 Mask experiment
clf
cmap = ametrine(10);

r=35;
Fs = 20000;         %sampling rate
T = 1/Fs;
L = length(struct_data(r).data(:,2));    
t = (0:L-1)*T;
offset = mean(struct_data(r).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1)-offset,'color',cmap(1,:));
hold all

r=36;
Fs = 20000;         %sampling rate
T = 1/Fs;
L = length(struct_data(r).data(:,2));    
t = (0:L-1)*T;
offset = mean(struct_data(r).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1)-offset,'color',cmap(9,:));

r=37;
Fs = 20000;         %sampling rate
T = 1/Fs;
L = length(struct_data(r).data(:,2));    
t = (0:L-1)*T;
offset = mean(struct_data(r).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1)-offset,'color',cmap(2,:));

r=38;
Fs = 20000;         %sampling rate
T = 1/Fs;
L = length(struct_data(r).data(:,2));    
t = (0:L-1)*T;
offset = mean(struct_data(r).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1)-offset,'color',cmap(8,:));

r=39;
Fs = 20000;         %sampling rate
T = 1/Fs;
L = length(struct_data(r).data(:,2));    
t = (0:L-1)*T;
offset = mean(struct_data(r).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1)-offset,'color',cmap(3,:));

r=40;
Fs = 20000;         %sampling rate
T = 1/Fs;
L = length(struct_data(r).data(:,2));    
t = (0:L-1)*T;
offset = mean(struct_data(r).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1)-offset-40,'color',cmap(7,:));

r=41;
Fs = 20000;         %sampling rate
T = 1/Fs;
L = length(struct_data(r).data(:,2));    
t = (0:L-1)*T;
offset = mean(struct_data(r).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1)-offset-40,'color',cmap(4,:));

r=42;
Fs = 20000;         %sampling rate
T = 1/Fs;
L = length(struct_data(r).data(:,2));    
t = (0:L-1)*T;
offset = mean(struct_data(r).data(.19*Fs:.2*Fs,1*wavetrain+2:2*wavetrain+1));
plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1)-offset-40,'color',cmap(6,:));

set(gca,'FontSize',14);
xlabel('Time (sec)');
ylabel('Displacement (nm)');
title('6/10/15 - Masking hair bundle')

legend( 'Rec35 - Tip covered, imaging base', 'Rec36 - No mask, imaging base','Rec37 - Tip and half HB covered', 'Rec38 - No mask, imaging base', 'Rec39 - No mask, imaging base', 'Rec40 - Base covered, imaging tip', 'Rec41 - No mask, imaging tip','Rec42 - No mask, imaging tip')

saveas(gcf,strcat('DataFig_mask',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_mask_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_mask_e',num2str(r),'eps'),'epsc');