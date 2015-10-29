% 9/5/13 Cell 4 - Polarity is inverted

Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data26.data(:,3));
t = (0:L-1)*T;

subplot_tight(6,1,1,[0.03 0.05])
% 10 nA
plot(t,struct_data.data26.data(:,2)+15)
line([5 10],[30 30])
title('9/5/13 Cell 4 1,3,5,7,9,15 nA 500 mM BAPTA','fontsize',16)
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 -8 37])
%set(gca,'Color',[1 0 0])

subplot_tight(6,1,2,[0.01 0.05])
plot(t,struct_data.data27.data(:,2)+15)
line([5 10],[8 8])
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 -8 37])

subplot_tight(6,1,3,[0.01 0.05])
plot(t,struct_data.data28.data(:,2)+15)
line([5 10],[10 10])
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 -8 37])

subplot_tight(6,1,4,[0.01 0.05])
plot(t,struct_data.data29.data(:,2)+15)
line([5 10],[8 8])
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 -8 37])

subplot_tight(6,1,5,[0.01 0.05])
plot(t,struct_data.data30.data(:,2)+15)
line([5 10],[8 8])
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 -8 37])

subplot_tight(6,1,6,[0.02 0.05])
plot(t,struct_data.data31.data(:,2)+15)
line([5 10],[33 33])
xlabel('Time (sec)','fontsize',16)
axis([0 15 -8 37])


