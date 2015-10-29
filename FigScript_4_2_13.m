% This script generates a figure for the data on 4/2/13

% This imports all data files from a single day into one data structure
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2013-04-02.01/Ear 1/Cell 1')
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
plot(t(1:15000),struct_data.data1.data(1:15000,2)-350, 'Color','k')
plot(t(1:15000),struct_data.data3.data(1:15000,2)+835, 'Color','c')
plot(t(1:15000),struct_data.data5.data(1:15000,2)+370, 'Color','k')
plot(t(1:15000),struct_data.data7.data(1:15000,2)+310, 'Color','b')
plot(t(1:15000),struct_data.data9.data(1:15000,2)+900, 'Color','k')
plot(t(1:15000),struct_data.data11.data(1:15000,2)+850, 'Color','m')
plot(t(1:15000),struct_data.data13.data(1:15000,2)+1200, 'Color','k')
plot(t(1:15000),struct_data.data14.data(1:15000,2)+1340, 'Color','k')
plot(t(1:15000),struct_data.data15.data(1:15000,2)+2070, 'Color','g')
plot(t(1:15000),struct_data.data16.data(1:15000,2)+1770, 'Color','k')
axis([0 3 -100 2100])

set(gca,'ytick',[])
set(gca,'yticklabel',[])

text(-0.4, 0, 'Endolymph')
text(-0.4, 300, '800nM Endolymph')
text(-0.4, 500, 'Endolymph')
text(-0.4, 700, '600nM Endolymph')
text(-0.4, 1000, 'Endolymph')
text(-0.4, 1150, '400nM Endolymph')
text(-0.4, 1400, 'Endolymph')
text(-0.4, 1650, 'Endolymph 8 min later')
text(-0.4, 1850, '200nM Endolymph')
text(-0.4, 2000, 'Endolymph')

xlabel('Time (sec)')










