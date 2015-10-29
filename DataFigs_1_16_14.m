%% 1/16/13 Uncaging Experiment

% Bundle's polarity is aligned with PD
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-01-16.02/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a  structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

%% Run 1 - Control, 2V 5ms, small artifact, some drift
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

%% Run 2 - Control, 2V 2ms, no artifact
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data2.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,struct_data.data2.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,struct_data.data2.data(:,4))

%% Run 3 - Control, 2V 3ms, (+) artifact
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data3.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,struct_data.data3.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,struct_data.data3.data(:,4))

%% Run 4 - Control, 2V 1ms, no artifact, some drift
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data4.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,struct_data.data4.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,struct_data.data4.data(:,4))

%% Run 5 - Uncaged, 3V 1ms - nothing
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data5.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,struct_data.data5.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,struct_data.data5.data(:,4))

%% Run 7 - NEW BUNDLE, Uncaged, 2V 2ms, (+) offsets, (-) twitch movement
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data7.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,struct_data.data7.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,struct_data.data7.data(:,4))

%% Run 8 - Uncaged              2V 2ms, (-) offsets, (-) twitch movement
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data8.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,struct_data.data8.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,struct_data.data8.data(:,4))

%% Runs 7 and 8
clf
plot(t,struct_data.data7.data(:,3))
hold on
plot(t,struct_data.data8.data(:,3)-170)
plot(t,0.02*struct_data.data8.data(:,2)-10,'r')
title('Records 7 & 8 - 1/16/14')


%% Run 9 - Uncaged              2V 1ms, (-) offset, small (-) mvt
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data9.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,struct_data.data9.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,struct_data.data9.data(:,4))

%% Run 11 - Uncaged             2V 3ms, (-) offset, small (+) mvt (SWITCHED)
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data11.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,struct_data.data11.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,struct_data.data11.data(:,4))

%% Run 12 - Uncaged             3V 3ms, (-) offset, nothing
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data12.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,struct_data.data12.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,struct_data.data12.data(:,4))

%% 9, 11, and 13
clf
plot(t,struct_data.data9.data(:,3)+50,'m')
hold on
plot(t,struct_data.data11.data(:,3),'b')
plot(t,struct_data.data13.data(:,3)-280,'g')
text(0.01,175,'Record 9')
text(0.01,50,'Record 11')
text(0.01,-68,'Record 13')
title('1/16/14 Records 9, 11, 13')
text(0.2,80,'5 min')
text(0.2,-45,'1 min')



%% Run 13 - Uncaged             3V 5ms, (-) offset, small (-) mvt (SWITCHED BACK)
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data13.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,struct_data.data13.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,struct_data.data13.data(:,4))

%% Run 14 - PROBE ONLY - nothing            
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data14.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,struct_data.data14.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,struct_data.data14.data(:,4))

%% Runs 15-18 - Probe only, no movement
subplot_tight(4,1,1,[0.05 0.05])
plot(t,struct_data.data15.data(:,3))
subplot_tight(4,1,2,[0.05 0.05])
plot(t,struct_data.data16.data(:,3))
subplot_tight(4,1,3,[0.05 0.05])
plot(t,struct_data.data17.data(:,3))
subplot_tight(4,1,4,[0.05 0.05])
plot(t,struct_data.data18.data(:,3))

%% Runs 19-22 - Probe only, no movement
subplot_tight(4,1,1,[0.05 0.05])
plot(t,struct_data.data19.data(:,3))
subplot_tight(4,1,2,[0.05 0.05])
plot(t,struct_data.data20.data(:,3))
subplot_tight(4,1,3,[0.05 0.05])
plot(t,struct_data.data21.data(:,3))
subplot_tight(4,1,4,[0.05 0.05])
plot(t,struct_data.data22.data(:,3))
