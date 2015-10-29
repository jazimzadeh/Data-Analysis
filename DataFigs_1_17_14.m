%% 1/17/13 Uncaging Experiment - No Movements today

cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-01-17.02/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a  structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

%% Run 1 - Control, 2V 5ms
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data1.data(:,4));
t = (0:L-1)*T;

subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data1.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,struct_data.data1.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,struct_data.data1.data(:,4))

%% Run 4 - Control, 4V 5ms
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data1.data(:,4));
t = (0:L-1)*T;

subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data4.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,struct_data.data4.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,struct_data.data4.data(:,4))

%% Run 7 - Uncaging, 3V 5ms - nothing
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data1.data(:,4));
t = (0:L-1)*T;

subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data7.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,struct_data.data7.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,struct_data.data7.data(:,4))

%% Run 8 - Uncaging, 4V 5ms - (-) offsets, very slight movemnet
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data1.data(:,4));
t = (0:L-1)*T;

subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data8.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,struct_data.data8.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,struct_data.data8.data(:,4))

%% Run 9 - Uncaging, 4V 5ms - (+) offsets, nothing
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data1.data(:,4));
t = (0:L-1)*T;

subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data9.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,struct_data.data9.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,struct_data.data9.data(:,4))

%% Run 10 - Uncaging, 4V 5ms - (+) offset 200 nm, slight mvt
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data10.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,struct_data.data10.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,struct_data.data10.data(:,4))

%% Run 11 - Uncaging, 4V 5ms - (-) offset 200 nm, slight mvt
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data11.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,struct_data.data11.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,struct_data.data11.data(:,4))