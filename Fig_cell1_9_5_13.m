% 9/5/13 Cell 1

Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data1.data(:,3));
t = (0:L-1)*T;

subplot_tight(5,1,1,[0.05 0.05])
% 10 nA
plot(t,struct_data.data3.data(:,2)+5)
line([5 10],[30 30])
title('9/5/13 Cell 1 1,4,5,7,10 nA 500 mM BAPTA','fontsize',16)
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 10 32])
%set(gca,'Color',[1 0 0])

subplot_tight(5,1,2,[0.03 0.05])
plot(t,struct_data.data4.data(:,2)+5)
line([5 10],[15 15])
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 10 32])

subplot_tight(5,1,3,[0.03 0.05])
plot(t,struct_data.data6.data(:,2))
line([5 10],[30 30])
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 10 32])

subplot_tight(5,1,4,[0.03 0.05])
plot(t,struct_data.data5.data(:,2))
line([5 10],[28 28])
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 10 32])

subplot_tight(5,1,5,[0.05 0.05])
plot(t,struct_data.data7.data(:,2)+5)
line([5 10],[28 28])
xlabel('Time (sec)','fontsize',16)
axis([0 15 10 32])

