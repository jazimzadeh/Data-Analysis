% This imports all data files from a single day into one data structure
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-04-22.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a nested structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

% To call one experiment, use the following as the name of the data file:
% struct_data.dataN.data, where N is the run number
% for example: plot(struct_data.data1.data(:,2))

%% This figure shows 3 mechanically-evoked currents evoked by the same stimulus, and their average
clf

B(:,1) = struct_data.data18.data(8001:10000,3);
B(:,2) = struct_data.data18.data(18001:20000,3);
B(:,3) = struct_data.data18.data(28001:30000,3);
B(:,4) = mean(B(:,1:3),2);

Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data18.data(8001:10000,3));
t = (0:L-1)*T;

set(gcf,'DefaultAxesColorOrder',[0 0.9 0 ; 0 0.7 0 ; 0 0.5 0 ; 0 0 0 ])
plot(t,B(:,1))
hold all
plot(t,B(:,2)+80)
plot(t,B(:,3)+160)
plot(t,B(:,4)+240)
title('4/22/14 Recording 18')
text(0.1,2000,'Black trace is average of the 3 other traces.')
text(0.1,1800,'Traces are offset by 80 mV for easy viewing.')
text(0.12,600,'500 nm.')
plot(t,-struct_data.data18.data(28001:30000,2),'k')
xlabel('Seconds')
ylabel('pA')

%% This shows increasing mechanical stimuli and the corresponding receptor currents
% Second of the three runs that can be averaged
clf
set(gcf,'DefaultAxesColorOrder',[1 0.8 0 ; 1 0.7 0 ; 1 0.5 0 ; 1 0.3 0 ; 1 0.1 0])
plot(t,struct_data.data18.data(10001:12000,3)-40)
hold all
plot(t,struct_data.data18.data(12001:14000,3)+50)
plot(t,struct_data.data18.data(14001:16000,3)+140)
plot(t,struct_data.data18.data(16001:18000,3)+230)
plot(t,struct_data.data18.data(18001:20000,3)+300)
hold on
plot(t,-struct_data.data18.data(10001:12000,2)+1300,'k')
plot(t,-struct_data.data18.data(12001:14000,2)+1300,'k')
plot(t,-struct_data.data18.data(14001:16000,2)+1300,'k')
plot(t,-struct_data.data18.data(16001:18000,2)+1300,'k')
plot(t,-struct_data.data18.data(18001:20000,2)+1300,'k')
title('4/22/14 Recording 18; Repeat 2 of 3')
axis([0 0.2 -500 2000])
text(0.112, 1810, '500 nm')

saveas(gcf,'Record18 2 of 3.pdf');

%% First of three runs
clf
Fs = 10000;         %sampling rate
    T = 1/Fs;
    L = length(struct_data.data18.data(2001:4000,3));
    t = (0:L-1)*T;

set(gcf,'DefaultAxesColorOrder',[1 0.8 0 ; 1 0.7 0 ; 1 0.5 0 ; 1 0.3 0 ; 1 0.1 0])
plot(t,struct_data.data18.data(1:2000,3)-40)
hold all
plot(t,struct_data.data18.data(2001:4000,3)+50)
plot(t,struct_data.data18.data(4001:6000,3)+140)
plot(t,struct_data.data18.data(6001:8000,3)+230)
plot(t,struct_data.data18.data(8001:10000,3)+300)
hold on
plot(t,-struct_data.data18.data(10001:12000,2)+1300,'k')
plot(t,-struct_data.data18.data(12001:14000,2)+1300,'k')
plot(t,-struct_data.data18.data(14001:16000,2)+1300,'k')
plot(t,-struct_data.data18.data(16001:18000,2)+1300,'k')
plot(t,-struct_data.data18.data(18001:20000,2)+1300,'k')
title('4/22/14 Recording 18; Repeat 1 of 3')
axis([0 0.2 -500 2000])
text(0.112, 1810, '500 nm')

%% Third of three runs
clf
set(gcf,'DefaultAxesColorOrder',[1 0.8 0 ; 1 0.7 0 ; 1 0.5 0 ; 1 0.3 0 ; 1 0.1 0])
plot(t,struct_data.data18.data(20001:22000,3)-40)
hold all
plot(t,struct_data.data18.data(22001:24000,3)+50)
plot(t,struct_data.data18.data(24001:26000,3)+140)
plot(t,struct_data.data18.data(26001:28000,3)+230)
plot(t,struct_data.data18.data(28001:30000,3)+300)
hold on
plot(t,-struct_data.data18.data(20001:22000,2)+1300,'k')
plot(t,-struct_data.data18.data(22001:24000,2)+1300,'k')
plot(t,-struct_data.data18.data(24001:26000,2)+1300,'k')
plot(t,-struct_data.data18.data(26001:28000,2)+1300,'k')
plot(t,-struct_data.data18.data(28001:30000,2)+1300,'k')
title('4/22/14 Recording 18; Repeat 3 of 3')
axis([0 0.2 -500 2000])
text(0.112, 1810, '500 nm')

%% Plot average of the 3 runs
first= struct_data.data18.data(1:2000,3) + struct_data.data18.data(10001:12000,3) + struct_data.data18.data(12001:14000,3) / 3;
second= struct_data.data18.data(2001:4000,3) + struct_data.data18.data(12001:14000,3) + struct_data.data18.data(22001:24000,3) / 3;
third = struct_data.data18.data(4001:6000,3) + struct_data.data18.data(14001:16000,3) + struct_data.data18.data(24001:26000,3) / 3;
fourth= struct_data.data18.data(6001:8000,3) + struct_data.data18.data(16001:18000,3) + struct_data.data18.data(26001:28000,3) / 3;
fifth = struct_data.data18.data(8001:10000,3) + struct_data.data18.data(18001:20000,3) + struct_data.data18.data(28001:30000,3) / 3;

Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data18.data(8001:10000,3));
t = (0:L-1)*T;

set(gcf,'DefaultAxesColorOrder',[1 0.8 0 ; 1 0.7 0 ; 1 0.5 0 ; 1 0.3 0 ; 1 0.1 0])

plot(t,first)
hold all
plot(t,second + 200)
plot(t,third + 400)
plot(t,fourth + 600)
plot(t,fifth + 800)

title('4/22/14 Recording 18 averaged (3 runs)')
axis([0 0.2 -1000 4500])
text(0.112, 1810, '500 nm')

saveas(gcf,'Record18 Averaged.pdf');
saveas(gcf,'Record18 Averaged.eps');

% plot(t,first)
% hold all
% plot(t,second)
% plot(t,third)
% plot(t,fourth)
% plot(t,fifth)











