% 8/29/13 Cell 1

Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data9.data(:,2));
t = (0:L-1)*T;

subplot_tight(4,1,1,[0.05 0.05])
% 10 nA
plot(t,struct_data.data9.data(:,2))
line([5 10],[-50 -50])
title('8/29/13 Cell 1 10-40 nA 80 mM BAPTA','fontsize',16)
set(gca,'XTickLabel',[],'XTick',[])
%set(gca,'Color',[1 0 0])

subplot_tight(4,1,2,[0.03 0.05])
plot(t,struct_data.data10.data(:,2))
line([5 10],[-46 -46])
set(gca,'XTickLabel',[],'XTick',[])

subplot_tight(4,1,3,[0.03 0.05])
plot(t,struct_data.data11.data(:,2))
line([5 10],[-48 -48])
set(gca,'XTickLabel',[],'XTick',[])

subplot_tight(4,1,4,[0.05 0.05])
plot(t,struct_data.data12.data(:,2))
line([5 10],[-40 -40])
xlabel('Time (sec)','fontsize',16)
