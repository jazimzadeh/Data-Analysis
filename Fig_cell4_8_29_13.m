% 8/29/13 Cell 4

Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data31.data(:,2));
t = (0:L-1)*T;

subplot_tight(2,1,1,[0.05 0.05])
% 10 nA
plot(t,struct_data.data31.data(:,2))
line([5 10],[30 30])
title('8/29/13 Cell 4 10-20 nA 80 mM BAPTA','fontsize',16)
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 0 35])
%set(gca,'Color',[1 0 0])

subplot_tight(2,1,2,[0.03 0.05])
plot(t,struct_data.data32.data(:,2))
line([5 10],[30 30])
set(gca,'XTickLabel',[],'XTick',[])
axis([0 15 -15 35])
