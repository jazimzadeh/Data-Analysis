% This imports all data files from a single day into one data structure
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-03-26.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a nested structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

% To call one experiment, use the following as the name of the data file:
% struct_data.dataN.data, where N is the run number
% for example: plot(struct_data.data1.data(:,2))



runs = size(fileList,1);


for n = 1:runs
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(eval(['struct_data.data' num2str(n) '.data(:,4)']));
t = (0:L-1)*T;

subplot(2,1,1)
plot(t,eval(['struct_data.data' num2str(n) '.data(:,2:6)']))
ylabel('mV'); xlabel('Seconds')
title(['Recording ' num2str(n)])
subplot(2,1,2)
plot(t,eval(['struct_data.data' num2str(n) '.data(:,17:21)']))
ylabel('pA'); xlabel('Seconds')
saveas(gcf,strcat('figure',num2str(n),'.pdf'));
clf
end
