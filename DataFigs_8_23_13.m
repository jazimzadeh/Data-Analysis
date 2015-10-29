% 8/23/13 - Oscilloscope is in same orientation as bundle; (+) is (+).

% --- Import Data --- %
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2013-08-23.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a nested structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

%% Rec. 6 - Control - No NPE - 4V
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data6.data(:,4));
t = (0:L-1)*T;
figure
subplot_tight(3,1,1,[0.05 0.05]);
plot(t,struct_data.data6.data(:,4))
set(gca,'XTickLabel',[],'XTick',[])
title('8/23/13 Rec. 6, Control (No NPE), 4V, some artifact','fontsize',16)
subplot_tight(3,1,2,[0.03 0.05]);
plot(t,struct_data.data6.data(:,3))
set(gca,'XTickLabel',[],'XTick',[])
subplot_tight(3,1,3,[0.03 0.05]);
plot(t,struct_data.data6.data(:,2))

%% Rec. 7 - Control - No NPE - 2V
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data7.data(:,4));
t = (0:L-1)*T;
figure
subplot_tight(3,1,1,[0.05 0.05]);
plot(t,struct_data.data7.data(:,4))
set(gca,'XTickLabel',[],'XTick',[])
title('8/23/13 Rec. 7, Control (No NPE), 2V, less ringing','fontsize',16)
subplot_tight(3,1,2,[0.03 0.05]);
plot(t,struct_data.data7.data(:,3))
set(gca,'XTickLabel',[],'XTick',[])
subplot_tight(3,1,3,[0.03 0.05]);
plot(t,struct_data.data7.data(:,2))

%% Rec. 9 - NPE - 2V
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data9.data(:,4));
t = (0:L-1)*T;
figure
subplot_tight(3,1,1,[0.05 0.05]);
plot(t,struct_data.data9.data(:,4))
set(gca,'XTickLabel',[],'XTick',[])
title('8/23/13 Rec. 9, NPE, 2V','fontsize',16)
subplot_tight(3,1,2,[0.03 0.05]);
plot(t,struct_data.data9.data(:,3))
set(gca,'XTickLabel',[],'XTick',[])
subplot_tight(3,1,3,[0.03 0.05]);
plot(t,struct_data.data9.data(:,2))

%% Rec. 10 - NPE - 4V - INTERESTING ***
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data10.data(:,4));
t = (0:L-1)*T;
figure;
plot(t,1.5*struct_data.data10.data(:,4)+30,'r')
hold on
plot(t,struct_data.data10.data(:,2),'k')
title('8/23/13 Rec. 10, NPE, 4V','fontsize',16)
axis([0 0.16 30 110])

figure
subplot_tight(2,1,1,[0.05 0.05]);
plot(t,struct_data.data10.data(:,4))
set(gca,'XTickLabel',[],'XTick',[])
title('8/23/13 Rec. 10, NPE, 4V','fontsize',16)
subplot_tight(2,1,2,[0.03 0.05]);
plot(t,struct_data.data10.data(:,2))

%% Rec. 12 - NPE - 5V 
clf;
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data12.data(:,4));
t = (0:L-1)*T;
figure;
plot(t,1.5*struct_data.data12.data(:,4)+40,'r')
hold on
plot(t,struct_data.data12.data(:,2),'k')
axis([0 0.16 30 110])
title('8/23/13 Rec. 12, NPE, 5V','fontsize',16)

figure
subplot_tight(2,1,1,[0.05 0.05]);
plot(t,struct_data.data12.data(:,4))
set(gca,'XTickLabel',[],'XTick',[])
title('8/23/13 Rec. 12, NPE, 5V','fontsize',16)
subplot_tight(2,1,2,[0.03 0.05]);
plot(t,struct_data.data12.data(:,2))

%% Rec. 13 - NPE - 2V 
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data12.data(:,4));
t = (0:L-1)*T;
figure;
plot(t,1.5*struct_data.data13.data(:,4)+40,'r')
hold on
plot(t,struct_data.data13.data(:,2),'k')
title('8/23/13 Rec. 13, NPE, 2V','fontsize',16)
figure
subplot_tight(2,1,1,[0.05 0.05]);
plot(t,struct_data.data13.data(:,4))
set(gca,'XTickLabel',[],'XTick',[])
title('8/23/13 Rec. 13, NPE, 5V','fontsize',16)
subplot_tight(2,1,2,[0.03 0.05]);
plot(t,struct_data.data13.data(:,2))

%% Rec. 14 - NPE - 3V 
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data14.data(:,4));
t = (0:L-1)*T;
figure;
plot(t,1.5*struct_data.data14.data(:,4)+40,'r')
hold on
plot(t,struct_data.data14.data(:,2),'k')
title('8/23/13 Rec. 14, NPE, 3V','fontsize',16)
axis([0 0.16 30 110])

figure
subplot_tight(2,1,1,[0.05 0.05]);
plot(t,struct_data.data14.data(:,4))
set(gca,'XTickLabel',[],'XTick',[])
title('8/23/13 Rec. 14, NPE, 5V','fontsize',16)
subplot_tight(2,1,2,[0.03 0.05]);
plot(t,struct_data.data14.data(:,2))

%% Rec. 20 - Laser 2 ms after mechanical offsets || INTERESTING ||
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data20.data(:,4));
t = (0:L-1)*T;
figure
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data20.data(:,12),'k')
title('8/23/13 Rec. 20, NPE, 4V,offsets','fontsize',16)
subplot_tight(3,1,2,[0.03 0.05])
plot(t,struct_data.data20.data(:,7:11))
subplot_tight(3,1,3,[0.03 0.05])
plot(t,struct_data.data20.data(:,2:6))

%% Rec. 21 - No Offset
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data21.data(:,4));
t = (0:L-1)*T;
figure
subplot_tight(2,1,1,[0.05 0.05])
plot(t,struct_data.data21.data(:,12),'k')
title('8/23/13 Rec. 21, NPE, 4V No offsets','fontsize',16)
subplot_tight(2,1,2,[0.03 0.05])
plot(t,struct_data.data21.data(:,2:6))

%% Rec. 27 
subplot_tight(2,1,1,[0.05 0.05])
plot(t,struct_data.data27.data(:,2:6))
title('8/23/13 Rec. 27 Post-Offset Laser','fontsize',16)
set(gca,'XTick',[],'XTickLabel',[]);
subplot_tight(2,1,2,[0.04 0.05])
plot(t,struct_data.data27.data(:,12),'k')

%% Recs. 32,33,34,36 - NEW CELL
subplot_tight(5,1,1,[0.04 0.05])
plot(t,struct_data.data32.data(:,4))
axis([0 .160 -10 50])
set(gca,'XTick',[],'XTickLabel',[])
title('8/23/13 Recs 32,33,34,36 - NEW CELL','fontsize',14)
subplot_tight(5,1,2,[0.02 0.05])
plot(t,struct_data.data32.data(:,2))
axis([0 .160 170 400])
text(0.102,240,'2V')
set(gca,'XTick',[],'XTickLabel',[])
subplot_tight(5,1,3,[0.02 0.05])
plot(t,struct_data.data33.data(:,2))
axis([0 .160 170 400])
text(0.102,270,'3V')
set(gca,'XTick',[],'XTickLabel',[])
subplot_tight(5,1,4,[0.02 0.05])
plot(t,struct_data.data34.data(:,2))
axis([0 .160 170 400])
text(0.102,360,'4V')
set(gca,'XTick',[],'XTickLabel',[])
subplot_tight(5,1,5,[0.04 0.05])
plot(t,struct_data.data36.data(:,2))
axis([0 .160 170 400])
text(0.102,360,'5V')

%%
clf
plot(t,struct_data.data32.data(:,4)+150,'k')
hold all
title('8/23/13 Recs 32,33,34,36 - NEW CELL','fontsize',14)

plot(t,struct_data.data32.data(:,2))
text(0.102,231,'2V')

plot(t,struct_data.data33.data(:,2)+16)
text(0.102,274,'3V')

plot(t,struct_data.data34.data(:,2)-28)
text(0.102,322,'4V')

set(gca,'XTick',[],'XTickLabel',[])
plot(t,struct_data.data36.data(:,2)+13)
text(0.102,361,'5V')










