% This script generates a figure for the data on 4/5/13 - Sacculus 1

% This imports all data files from a single day into one data structure
cd('/Users/Julien/Documents/Research/Hudspeth/Data/Orange Room/2013-04-05.01/Ear 1/Cell 1')
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
plot(t(1:15000),struct_data.data1.data(1:15000,2), 'Color','k')
plot(t(1:15000),struct_data.data2.data(1:15000,2)+60, 'Color','c')
plot(t(1:15000),struct_data.data3.data(1:15000,2)+110, 'Color','c')
plot(t(1:15000),struct_data.data5.data(1:15000,2)+222, 'Color','k')
plot(t(1:15000),struct_data.data7.data(1:15000,2)+250, 'Color','b')
plot(t(1:15000),struct_data.data8.data(1:15000,2)+275, 'Color','k')

set(gca,'ytick',[])
set(gca,'yticklabel',[])

text(-0.4, 75, 'Endolymph')
text(-0.4, 165, '600nM Endolymph')
text(-0.4, 290, '600nM Endolymph')
text(-0.4, 380, 'Endolymph')
text(-0.4, 440, '500 nM Endolymph')
text(-0.4, 468, 'Endolymph')



xlabel('Time (sec)')










