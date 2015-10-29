% 9/5/13 Cell 5 

Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data32.data(:,3));
t = (0:L-1)*T;

% 10 nA
plot(t,struct_data.data32.data(:,2))
line([5 10],[-30 -30])
title('9/5/13 Cell 5 15 nA 500 mM BAPTA','fontsize',16)
xlabel('Time (sec)','fontsize',16)
