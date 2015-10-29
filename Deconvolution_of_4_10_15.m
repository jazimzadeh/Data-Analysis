% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-04-10.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%%
r=16;
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



%dc_offset = mean(struct_data(r).data(0.11*Fs,2*wavetrain+1));
dc_offset=0;
conv_response = struct_data(r).data(0.11*Fs:0.2*Fs,2*wavetrain+1) - dc_offset;
input_pulse = struct_data(r).data(0.11*Fs:0.2*Fs,4*wavetrain+1);
t = t(0.11*Fs:0.2*Fs);
points = length(t);


subplot(3,1,1)
plot(t,input_pulse)
ylabel('Laser Command')
axis([0.08 0.4 -2 6])
title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',12);
subplot(3,1,2)
plot(t,conv_response)
ylabel('Displacement (nm)')
axis([0.08 0.4 150 250])


%% Deconvolution
lam = 10;
H = convmtx(input_pulse,points);
H = H(1:points,:);
g = ((H'*H + lam*eye(points)))\(H'*conv_response);      % deconvolution
subplot(3,1,3)
plot(t,g)
axis([0.08 0.4 -2 2])
title('Deconvolved Kernel')
xlabel('Time (sec)')

saveas(gcf,strcat('DataFig_PrePulseDeconvolution',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_PrePulseDeconvolution_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_PrePulseDeconvolution_e',num2str(r),'eps'),'epsc');
