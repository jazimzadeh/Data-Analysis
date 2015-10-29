% 9/5/13 Cell 3

Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data16.data(:,3));
t = (0:L-1)*T;

subplot_tight(8,1,1,[0.02 0.05])
% 10 nA
plot(t,struct_data.data16.data(:,2)+20)
line([5 10],[30 30])
title('9/5/13 Cell 3 1,3,5,7,9,15,20 nA 500 mM BAPTA','fontsize',14)
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 10 32])
%set(gca,'Color',[1 0 0])

subplot_tight(8,1,2,[0.01 0.05])
plot(t,struct_data.data18.data(:,2)+25)
line([5 10],[25 25])
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 10 32])

subplot_tight(8,1,3,[0.01 0.05])
plot(t,struct_data.data19.data(:,2)+30)
line([5 10],[28 28])
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 10 32])

subplot_tight(8,1,4,[0.01 0.05])
plot(t,struct_data.data21.data(:,2)+40)
line([5 10],[15 15])
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 10 32])

subplot_tight(8,1,5,[0.01 0.05])
plot(t,struct_data.data22.data(:,2)+40)
line([5 10],[28 28])
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 10 32])

subplot_tight(8,1,6,[0.01 0.05])
plot(t,struct_data.data23.data(:,2)+40)
line([5 10],[27 27])
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 5 35])

subplot_tight(8,1,7,[0.01 0.05])
plot(t,struct_data.data24.data(:,2)+35)
line([5 6],[28 28])
axis([0 15 5 35])
set(gca,'XTickLabel',[],'XTick',[])

subplot_tight(8,1,8,[0.02 0.05])
plot(t,struct_data.data25.data(:,2)+35)
line([5 10],[28 28])
xlabel('Time (sec)','fontsize',16)
axis([0 15 5 35])
xlabel('Time (sec)','fontsize',16)


