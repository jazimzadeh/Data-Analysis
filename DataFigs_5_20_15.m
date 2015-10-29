% This imports all data files from a single day into one data structure
clear;clc;clf;
close(gcf);
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-05-20.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});

%%
for r = 1: length(fileList2)
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

subplot(4,1,1)
plot(t,struct_data(r).data(:,0*wavetrain+2:1*wavetrain+1))
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
axis([0 0.4 -150 150])
ylabel('Ionto (nA)')
offset = 0;
subplot(4,1,2:3)
    for j = 1*wavetrain+2 : 2*wavetrain+1
    plot(t,-struct_data(r).data(:,j) + offset)
    offset = offset + 30;
    hold all
    end
ylabel('Displacement (nm)')
subplot(4,1,4)
plot(t,struct_data(r).data(:,5*wavetrain+2:6*wavetrain+1))
ylabel('Laser pick-off')

saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end