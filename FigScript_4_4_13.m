% This script generates a figure for the data on 4/4/13

% This imports all data files from a single day into one data structure
cd('/Users/Julien/Documents/Research/Hudspeth/Data/Orange Room/2013-04-04.02/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a nested structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end



close all
figure
Fs = 5000;                                         % Sampling frequency
sampling_interval = 1/Fs;                        % Sample time
L = length(struct_data.data1.data);               % Length of signal
t = (0:L-1)*sampling_interval;

hold on
plot(t(1:15000),struct_data.data2.data(1:15000,2), 'Color','k')
plot(t(1:15000),struct_data.data3.data(1:15000,2)+170, 'Color','c')
plot(t(1:15000),struct_data.data4.data(1:15000,2)+240, 'Color','k')
plot(t(1:15000),struct_data.data5.data(1:15000,2)+322, 'Color','k')
plot(t(1:15000),struct_data.data6.data(1:15000,2)+290, 'Color','b')
plot(t(1:15000),struct_data.data7.data(1:15000,2)+182, 'Color','k')


set(gca,'ytick',[])
set(gca,'yticklabel',[])

text(-0.4, 190, 'Endolymph')
text(-0.4, 230, '600nM Endolymph')
text(-0.4, 265, 'Endolymph')
text(-0.4, 300, 'Endolymph 5min later')
text(-0.4, 325, '400 nM Endolymph')
text(-0.4, 345, 'Endolymph')


xlabel('Time (sec)')










