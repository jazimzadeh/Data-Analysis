% 9/9/13 Uncaging, with some attempts at prepulses. (+) on oscilloscope is
% (-) for hair bundle


cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2013-09-09.01/Ear 1/Cell 1')
fileList = dir('*.txt'); 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end


%% 9/9/13 Rec. 4 - 4V control
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data4.data(:,2));
t = (0:L-1)*T;

subplot_tight(2,1,1,[0.04 0.05])
plot(t,struct_data.data4.data(:,3))
title('9/9/13 Rec. 4 4V Control','fontsize',15)
subplot_tight(2,1,2,[0.03 0.05])
plot(t,struct_data.data4.data(:,2))

%% 9/9/13 Rec. 5 - 5V control - saw potential artifact
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data5.data(:,2));
t = (0:L-1)*T;
figure
subplot_tight(2,1,1,[0.04 0.05])
plot(t,struct_data.data5.data(:,3))
title('9/9/13 Rec. 5 5V Control','fontsize',15)
subplot_tight(2,1,2,[0.03 0.05])
plot(t,struct_data.data5.data(:,2))

%% 9/9/13 Rec. 8 - 5V NPE 
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data8.data(:,2));
t = (0:L-1)*T;
figure
subplot_tight(2,1,1,[0.04 0.05])
plot(t,struct_data.data8.data(:,3))
title('9/9/13 Rec. 8 4V NPE','fontsize',15)
subplot_tight(2,1,2,[0.03 0.05])
plot(t,struct_data.data8.data(:,2))

%% 9/9/13 Rec. 9 - 5V NPE - weird, (+) movemement?
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data9.data(:,2));
t = (0:L-1)*T;
figure
subplot_tight(2,1,1,[0.04 0.05])
plot(t,struct_data.data9.data(:,3))
title('9/9/13 Rec. 9 5V NPE','fontsize',15)
subplot_tight(2,1,2,[0.03 0.05])
plot(t,struct_data.data9.data(:,2))

%% 9/9/13 Rec. 21 - 5V NPE Prepulses - no apparent effect
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data21.data(:,2));
t = (0:L-1)*T;

plot(t,0.2*struct_data.data21.data(:,3)-20,'r')
hold on
plot(t,struct_data.data21.data(:,2),'k')
title('9/9/13 Rec. 21 5V NPE','fontsize',15)

figure
subplot_tight(2,1,1,[0.04 0.05])
plot(t,struct_data.data21.data(:,3))
title('9/9/13 Rec. 21 5V NPE','fontsize',15)
subplot_tight(2,1,2,[0.03 0.05])
plot(t,struct_data.data21.data(:,2))

%% 9/9/13 Rec. 22 - 5V NPE Prepulses - no apparent effect
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data22.data(:,2));
t = (0:L-1)*T;

plot(t,0.2*struct_data.data22.data(:,3)-10,'r')
hold on
plot(t,struct_data.data22.data(:,2),'k')
title('9/9/13 Rec. 22 5V NPE','fontsize',15)

