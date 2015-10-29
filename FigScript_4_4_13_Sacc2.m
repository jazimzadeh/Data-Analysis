% This script generates a figure for the data on 4/5/13 - Sacculus 2

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
plot(t(1:15000),struct_data.data9.data(1:15000,2)-10, 'Color','k')
plot(t(1:15000),struct_data.data12.data(1:15000,2)-20, 'Color','c')
plot(t(1:15000),struct_data.data13.data(1:15000,2)+252, 'Color','k')
plot(t(1:15000),struct_data.data14.data(1:15000,2)+182, 'Color','k')
plot(t(1:15000),struct_data.data15.data(1:15000,2)+425, 'Color','b')
plot(t(1:15000),struct_data.data17.data(1:15000,2)+352, 'Color','k')
plot(t(1:15000),struct_data.data19.data(1:15000,2)+435, 'Color','g')
plot(t(1:15000),struct_data.data20.data(1:15000,2)+415, 'Color','k')


set(gca,'ytick',[])
set(gca,'yticklabel',[])

text(-0.4, 130, 'Endolymph')
text(-0.4, 230, '600nM Endolymph')
text(-0.4, 290, 'Endolymph')
text(-0.4, 350, 'Endolymph')
text(-0.4, 450, '500 nM Endolymph')
text(-0.4, 490, 'Endolymph')
text(-0.4, 520, '400 nM Endolymph')
text(-0.4, 550, 'Endolymph')





xlabel('Time (sec)')


