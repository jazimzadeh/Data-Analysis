% 8/22/13 Bundle pointing right; (+) on oscilloscope is (-) bundle motion

% --- Import Data --- %
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2013-08-22.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a nested structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

%% 8/22/13 Recording 3 - No NPE - 4V
Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data3.data(:,4));
t = (0:L-1)*T;

subplot(3,1,1);
plot(t,struct_data.data3.data(:,4))
title('8/22/13 Rec. 3, 4V, No NPE','fontsize',18)
subplot(3,1,2);
plot(t,struct_data.data3.data(:,3))
subplot(3,1,3);
plot(t,struct_data.data3.data(:,2))

%% 8/22/13 Recording 4 - No NPE - 4V
Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data4.data(:,4));
t = (0:L-1)*T;

subplot(3,1,1);
plot(t,struct_data.data4.data(:,4))
title('8/22/13 Rec. 4, 4V, No NPE','fontsize',18)
subplot(3,1,2);
plot(t,struct_data.data4.data(:,3))
subplot(3,1,3);
plot(t,struct_data.data4.data(:,2))

figure;
plot(t,struct_data.data4.data(:,4)+100,'r')
hold on
plot(t,-struct_data.data4.data(:,2),'k')
title('8/22/13 Rec. 4 No NPE polarity corrected, 4V','fontsize',18)

%% 8/22/13 Recording 5 - NPE - 4V - movement **
Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data5.data(:,4));
t = (0:L-1)*T;

subplot(3,1,1);
plot(t,struct_data.data5.data(:,4))
title('8/22/13 Rec. 5, 4V','fontsize',18)
subplot(3,1,2);
plot(t,struct_data.data5.data(:,3))
subplot(3,1,3);
plot(t,struct_data.data5.data(:,2))

figure;
plot(t,struct_data.data5.data(:,4)+100,'r')
hold on
plot(t,-struct_data.data5.data(:,2),'k')
title('8/22/13 Rec. 5, 4V','fontsize',18)

%% 8/22/13 Recording 6 - NPE - 4V - movement (sim. to Rec. 5)
Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data6.data(:,4));
t = (0:L-1)*T;

subplot(3,1,1);
plot(t,struct_data.data6.data(:,4))
title('8/22/13 Rec. 6, 4V','fontsize',18)
subplot(3,1,2);
plot(t,struct_data.data6.data(:,3))
subplot(3,1,3);
plot(t,struct_data.data6.data(:,2))
%% 8/22/13 Recording 7 - 1 msec
Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data7.data(:,4));
t = (0:L-1)*T;

plot(t,struct_data.data7.data(:,4)+210,'r')
hold on;
plot(t,struct_data.data7.data(:,2),'k')
title('8/22/13 Rec. 7, 4V, 1 msec','fontsize',18)
figure;
subplot(3,1,1);
plot(t,struct_data.data7.data(:,4))
title('8/22/13 Rec. 7, 4V, 1 msec','fontsize',18)
subplot(3,1,2);
plot(t,struct_data.data7.data(:,3))
subplot(3,1,3);
plot(t,struct_data.data7.data(:,2))


%% 8/22/13 Recording 8 - mid-pulse movement
Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data8.data(:,4));
t = (0:L-1)*T;
figure;
plot(t,struct_data.data8.data(:,4)-300,'r')
hold on;
plot(t,-struct_data.data8.data(:,2),'k')
title('8/22/13 Rec. 8, 4V, 2 msec, FLIPPED right-side-up','fontsize',16)
figure;
subplot(3,1,1);
plot(t,struct_data.data8.data(:,4))
title('8/22/13 Rec. 8, 4V, 2 msec','fontsize',18)
subplot(3,1,2);
plot(t,struct_data.data8.data(:,3))
subplot(3,1,3);
plot(t,struct_data.data8.data(:,2))
xlabel('Remember, displacement polarity is opp. HB polarity!','fontsize',14)

%% 8/22/13 Recording 9

Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data9.data(:,4));
t = (0:L-1)*T;

subplot(3,1,1);
plot(t,struct_data.data9.data(:,4))
title('8/22/13 Rec. 9, 4V, 2 msec','fontsize',18)
set(gca,'XTicklabel',[],'XTick',[])
subplot(3,1,2);
plot(t,struct_data.data9.data(:,3))
set(gca,'XTicklabel',[],'XTick',[])
subplot(3,1,3);
plot(t,struct_data.data9.data(:,2))

%% 8/22/13 Recording 10 - can't make conclusions, laser V was not constant

Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data10.data(:,4));
t = (0:L-1)*T;

subplot(3,1,1);
plot(t,struct_data.data10.data(:,202:210))
title('8/22/13 Rec. 10, 4V, 2 msec','fontsize',18)
set(gca,'XTicklabel',[],'XTick',[])
subplot(3,1,2);
plot(t,struct_data.data10.data(:,102:110))
set(gca,'XTicklabel',[],'XTick',[])
subplot(3,1,3);
plot(t,struct_data.data10.data(:,2:10))

%% 8/22/13 Recording 11 - multiple offsets
Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data11.data(:,4));
t = (0:L-1)*T;
figure;
plot(t,-struct_data.data11.data(:,2:10))
hold on;
plot(t,struct_data.data11.data(:,22)+150,'k')
title('8/22/13 Rec. 11, 4V, 2 msec, flipped for correct polarity','fontsize',16)
%%
figure
subplot_tight(3,1,1,[0.05 0.05]);
plot(t,struct_data.data11.data(:,22:30))
title('8/22/13 Rec. 11, 4V, 2 msec','fontsize',16)
set(gca,'XTicklabel',[],'XTick',[])
subplot_tight(3,1,2,[0.03 0.05]);
plot(t,struct_data.data11.data(:,12:20))
set(gca,'XTicklabel',[],'XTick',[])
subplot_tight(3,1,3,[0.03 0.05]);
plot(t,struct_data.data11.data(:,2:10))




