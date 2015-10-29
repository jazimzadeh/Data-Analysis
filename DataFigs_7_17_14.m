clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-07-17.02/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%%
for r = 13:length(fileList2)
clf
logfile_name = getfield(dir('*.log'),'name');
logfile_name_clean = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile = importdata(logfile_name);

wavetrain = logfile.data(r,8); % get number of wavetrains for that run
laser_delay = logfile.data(r,43)*.001;      % in milliseconds
laser_duration = logfile.data(r,44)*.001;   % in milliseconds
laser_voltage = logfile.data(r,63);

Fs = 20000;         %sampling rate
T = 1/Fs;
L = length(struct_data(r).data(:,2));    
t = (0:L-1)*T;

subplot(3,1,1)
plot(t,struct_data(1,r).data(:,30:36))
title('Voltage Step')
ylabel('Voltage')

subplot(3,1,2)
plot(t,struct_data(1,r).data(:,23:29))
ylim = get(gca, 'YLim');
ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
y = [ylim(1) ylim(2)-0.3 ylim(2)-0.3 ylim(1)+0.2 ylim(1)+0.2]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
ylabel('Current (nA)')
title('Current')

subplot(3,1,3)
plot(t,struct_data(1,r).data(:,16:22))
title('Mechanical Stimulus')

saveas(gcf,strcat('DataFig_',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

