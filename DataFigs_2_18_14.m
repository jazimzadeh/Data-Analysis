% This imports all data files from a single day into one data structure
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-02-18.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a nested structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

% To call one experiment, use the following as the name of the data file:
% struct_data.dataN.data, where N is the run number
% for example: plot(struct_data.data1.data(:,2))

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
plot(t,struct_data.data2.data(:,2:8))
ylabel('mV'); xlabel('Seconds')
subplot(2,1,2)
plot(t,struct_data.data2.data(:,23:29))
ylabel('pA'); xlabel('Seconds')

%%
subplot(2,1,1)
plot(t,struct_data.data3.data(:,2:8))
ylabel('mV'); xlabel('Seconds')
subplot(2,1,2)
plot(t,struct_data.data3.data(:,23:29))
ylabel('pA'); xlabel('Seconds')

%%
subplot(2,1,1)
plot(t,struct_data.data4.data(:,2:8))
ylabel('mV'); xlabel('Seconds')
subplot(2,1,2)
plot(t,struct_data.data4.data(:,23:29))
ylabel('pA'); xlabel('Seconds')

%% Probe stim no current
subplot(2,1,1)
plot(t,struct_data.data5.data(:,2:8))
ylabel('mV'); xlabel('Seconds')
subplot(2,1,2)
plot(t,struct_data.data5.data(:,23:29))
ylabel('pA'); xlabel('Seconds')

%%
subplot(2,1,1)
plot(t,struct_data.data6.data(:,2:8))
ylabel('mV'); xlabel('Seconds')
subplot(2,1,2)
plot(t,struct_data.data6.data(:,23:29))
ylabel('pA'); xlabel('Seconds')

%% Cell 2 currents
subplot(2,1,1)
plot(t,struct_data.data11.data(:,2:8))
ylabel('mV'); xlabel('Seconds')
subplot(2,1,2)
plot(t,struct_data.data11.data(:,23:29))
ylabel('pA'); xlabel('Seconds')

%% Cell 3 currents
subplot(2,1,1)
plot(t,struct_data.data12.data(:,2:8))
ylabel('mV'); xlabel('Seconds')
subplot(2,1,2)
plot(t,struct_data.data12.data(:,23:29))
ylabel('pA'); xlabel('Seconds')

%% 
subplot(2,1,1)
plot(t,struct_data.data13.data(:,2:8))
ylabel('mV'); xlabel('Seconds')
subplot(2,1,2)
plot(t,struct_data.data13.data(:,23:29))
ylabel('pA'); xlabel('Seconds')