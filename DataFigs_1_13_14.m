%% 1/13/13 Uncaging Experiment

% Direction is opposite convention, so I've put a (-) in front of all the
% probe traces to flip the polarity back to normal

cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-01-13.02/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a  structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

%% Run 1 - Control, 1V (ie: permeabilized, but no NP-EGTA)
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data1.data(:,4));
t = (0:L-1)*T;

subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data1.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data1.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data1.data(:,4))

%% Run 2 - Control, 2V - ringy
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data2.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data2.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data2.data(:,4))

%% Run 3 - Control, 2V 
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data3.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data3.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data3.data(:,4))

%% Run 4 - Control, 2V, alternating offsets - GOOD control 
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data1.data(:,4));
t = (0:L-1)*T;
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data4.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data4.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data4.data(:,4))

%% Run 5 - Uncaging, 2V - LARGE MOVEMENTS ***
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data5.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data5.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data5.data(:,4))

%% Putting 4 and 5 together
clf
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data1.data(:,4));
t = (0:L-1)*T;

plot(t,0.05*struct_data.data4.data(:,2)+180,'k')
hold on
plot(t,-0.2*struct_data.data4.data(:,4)+140)
plot(t,-struct_data.data4.data(:,3),'r')
plot(t,-struct_data.data5.data(:,3)-100,'r')
text(0.01,45,'Control: No NPE')
text(0.01,-160,'NPE Present')
title('Records 4 & 5, 1/13/14, 4 mW')








%% Run 7 - Uncaging, 1V - NEW CELL, last one was run-into by gunk
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data7.data(:,4));
t = (0:L-1)*T;

subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data7.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data7.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data7.data(:,4))

%% Run 10 - Uncaging, 3V - nothing
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data10.data(:,4));
t = (0:L-1)*T;
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data10.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data10.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data10.data(:,4))

%% Run 11 - Uncaging, 3V - nothing
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data11.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data11.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data11.data(:,4))

%% Run 12 - Uncaging, 3V - nothing
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data12.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data12.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data12.data(:,4))



