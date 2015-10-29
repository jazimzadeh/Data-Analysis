% 9/5/13 Iontophoresing BAPTA on oscillating cells to break tip links
% 500 mM BAPTA in pipette
clf
Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data27.data(:,4));
t = (0:L-1)*T;

plot(t,struct_data.data27.data(:,2))
hold on
plot(t,struct_data.data28.data(:,2)-25)
plot(t,struct_data.data29.data(:,2)-43)
plot(t,struct_data.data30.data(:,2)-63)
plot(t,struct_data.data31.data(:,2)-78)
plot(t,struct_data.data32.data(:,2)-80)
line([5 10],[19 19])
title('9/5/13 BAPTA ionto: -1, -3, -5, -7, -9, -15, -15 nA')