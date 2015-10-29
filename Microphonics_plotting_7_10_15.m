% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Microphonics/Vinny/2015-07-10.01/')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%%
r=8;
clf
logfile_name        = getfield(dir('*.log'),'name');
logfile_name_clean  = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile             = importdata(logfile_name);

n_amplitudes = 20;
run_length = Fs*0.09;   % number of points in each run (each amplitude)
Fs                  = 20000;                                % sampling rate
T                   = 1/Fs;
L                   = Fs*0.09;    
t                   = (0:L-1)*T;

set(0, 'DefaultAxesColorOrder', ametrine(n_amplitudes));
subplot(2,1,1)
for i = 1:n_amplitudes
    j = i-1;
    plot(t,struct_data(1,r).data(j*run_length+1:run_length*i,1),'LineWidth',2);
    hold all
end
axis([0 0.09 -0.5 5.5])
ylabel('Voltage Command (V)')


subplot(2,1,2)
for i = 1:n_amplitudes
    j = i-1;
    plot(t,struct_data(1,r).data(j*run_length+1:run_length*i,2),'LineWidth',1.0001);
    hold all
end
axis([0 0.09 0.05 0.5])
ylabel('Response (V)')
xlabel('Time (sec)')

