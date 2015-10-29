% Comparing traces from 10/28 to 8/14. THe top 2 are from 8/21/13

% This imports all data files from a single day into one data structure
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2013-10-28.02/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a nested structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data14.data(:,4));
t = (0:L-1)*T;

subplot_tight(3,1,1,[0.05 0.05]);
plot(t(5500:6500),struct_data.data14.data(5500:6500,2))
axis([0.55 0.65 -50 40])
title('10/28/13 Rec.13 3rd pulse')

subplot_tight(3,1,2,[0.05 0.05]);
plot(t(7500:8500),struct_data.data14.data(7500:8500,2))
axis([0.75 0.85 -50 40])
title('10/28/13 Rec.13 4th pulse')

% This imports all data files from a single day into one data structure
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2013-08-14.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a nested structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end
Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data18.data(:,4));
t = (0:L-1)*T;

subplot_tight(3,1,3,[0.05 0.05]);
plot(t,struct_data.data8.data(:,2))
axis([0 0.1 -80 40])
title('8/14/13 Rec 8 pulse')

