% 9/5/13 Cell 2

Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data1.data(:,3));
t = (0:L-1)*T;

subplot_tight(7,1,1,[0.04 0.05])
% 10 nA
plot(t,struct_data.data8.data(:,2)+5)
line([5 10],[14 14])
title('9/5/13 Cell 2 1,3,5,7,9,18,28 nA 500 mM BAPTA','fontsize',14)
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 10 32])
%set(gca,'Color',[1 0 0])

subplot_tight(7,1,2,[0.02 0.05])
plot(t,struct_data.data9.data(:,2)+3)
line([5 10],[15 15])
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 10 32])

subplot_tight(7,1,3,[0.02 0.05])
plot(t,struct_data.data10.data(:,2)+5)
line([5 10],[30 30])
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 10 32])

subplot_tight(7,1,4,[0.02 0.05])
plot(t,struct_data.data11.data(:,2)+13)
line([5 10],[28 28])
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 10 32])

subplot_tight(7,1,5,[0.02 0.05])
plot(t,struct_data.data12.data(:,2)+22)
line([5 10],[28 28])
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 10 32])

subplot_tight(7,1,6,[0.02 0.05])
plot(t,struct_data.data13.data(:,2)+23)
line([5 10],[20 20])
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 5 35])

subplot_tight(7,1,7,[0.05 0.05])
plot(t,struct_data.data14.data(:,2)+22)
line([5 6],[20 20])
xlabel('Time (sec)','fontsize',16)
axis([0 15 5 35])
xlabel('Time (sec)','fontsize',16)


