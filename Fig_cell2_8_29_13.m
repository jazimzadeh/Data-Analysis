% 8/29/13 Cell 2

Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data13.data(:,2));
t = (0:L-1)*T;

subplot_tight(4,1,1,[0.05 0.05])
% 10 nA
plot(t,struct_data.data13.data(:,2))
line([5 10],[40 40])
title('8/29/13 Cell 2 10-40 nA 80 mM BAPTA','fontsize',16)
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 -10 45])
%set(gca,'Color',[1 0 0])

subplot_tight(4,1,2,[0.03 0.05])
plot(t,struct_data.data14.data(:,2))
line([5 10],[40 40])
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 -10 45])


subplot_tight(4,1,3,[0.03 0.05])
plot(t,struct_data.data15.data(:,2))
line([5 10],[40 40])
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 -10 45])


subplot_tight(4,1,4,[0.05 0.05])
plot(t,struct_data.data16.data(:,2))
line([5 10],[40 40])
xlabel('Time (sec)','fontsize',16)
axis([0 15 -10 45])

