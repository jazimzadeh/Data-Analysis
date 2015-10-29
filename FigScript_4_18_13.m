%% this prints out the figure for 4/18/13 (the data is in 4/17 folder)

% This imports all data files from a single day into one data structure
cd('/Users/Julien/Documents/Research/Hudspeth/Data/Orange Room/2013-04-17.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a nested structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data3.data(:,2));
t = (0:L-1)*T;
hold on
plot(t,struct_data.data12.data(:,2)+600,'k')
plot(t,struct_data.data13.data(:,2)-750,'r')
plot(t,struct_data.data14.data(:,2)+870,'c')

text(-0.6, -80, 'Endolymph')
text(-0.7, 65, '1 uM Ca DF')
text(-0.6, 160, 'Endolymph')