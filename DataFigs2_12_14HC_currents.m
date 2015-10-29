% This imports all data files from a single day into one data structure
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-02-12.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a nested structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data1.data(:,4));
t = (0:L-1)*T;

subplot(2,1,1)
plot(t,struct_data.data1.data(:,2:6))
ylabel('mV'); xlabel('Seconds')
subplot(2,1,2)
plot(t,struct_data.data1.data(:,17:21))
ylabel('pA'); xlabel('Seconds')

%%
subplot(2,1,1)
plot(t,struct_data.data2.data(:,2:6))
ylabel('mV'); xlabel('Seconds')
subplot(2,1,2)
plot(t,struct_data.data2.data(:,17:21))
ylabel('pA'); xlabel('Seconds')


%%
subplot(2,1,1)
plot(t,struct_data.data3.data(:,2:6))
ylabel('mV'); xlabel('Seconds')
subplot(2,1,2)
plot(t,struct_data.data3.data(:,17:21))
ylabel('pA'); xlabel('Seconds')
