function Find_tau(trace,a,b,c,d)
% Times are inputed in millseconds

% Convert sampling rate to time
Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(trace);
t = (0:L-1)*T;

% Convert to sample number:
A = a * Fs / 1000;
B = b * Fs / 1000;
C = c * Fs / 1000;
D = d * Fs / 1000;
%
%%%%%%%%%%%%%%%
% SMOOTHING
% initialize
x = 0;
smoothed = zeros(size(trace));

% Create z, a smoothed version of the trace, average 9 points
for i = 5:length(trace)-4;
    x = [trace(i-4), trace(i-3),trace(i-2), trace(i-1), trace(i), trace(i+1), trace(i+2), trace(i+3), trace(i+4)];
    smoothed(i)=mean(x);
end
% Adding the beginning and ending values
smoothed(1:4) = smoothed(5);
smoothed(2996:3000) = smoothed(2995);

% Average 13 points
% for i = 7:length(trace)-6;
%     x = [trace(i-6), trace(i-5), trace(i-4), trace(i-3),trace(i-2), trace(i-1), trace(i), trace(i+1), trace(i+2), trace(i+3), trace(i+4), trace(i+5), trace(i+6)];
%     extra_smoothed(i)=mean(x);
% end
% extra_smoothed(1:6) = extra_smoothed(7);
% extra_smoothed(2994:3000) = extra_smoothed(2993);

%%%%%%%%%%%%%%%%

% FIND START AND END VALUES, DRAW BARS
start = mean(smoothed(A:B));
ending = mean(smoothed(C:D));

% Plot the unadultered and the smoothed traces.
figure
subplot(2,1,1)
plot(t, trace)
xlabel('Seconds')
subplot(2,1,2)
plot(t, smoothed)
xlabel('Seconds')
hold on
line([A/Fs,B/Fs],[start,start],'color', 'r', 'LineWidth',2)
line([C/Fs,D/Fs],[ending,ending],'color', 'r', 'LineWidth',2)

% subplot(3,1,3)
% plot(t, extra_smoothed)

% FIND TAU
tau_amount = 0.632 * (ending - start);
tau_value = start + tau_amount;
subplot(2,1,2)
line([.09,.11],[tau_value,tau_value],'color', 'r', 'LineWidth',2)

% Find intersection
tau_y(1:401) = tau_value;   %make an array of same length as the other, with repeating tau's
% find intersection of trace, and horizontal line at tau; tau is in points
[X,Y] = intersections([950:1300], [trace(950:1300)], [900:1300], [tau_y]);
tau = (X(end) / 10) - 100; % take last intersection as tau, convert to msec
%text(0.02, tau_value, sprintf('tau = %s msec.',tau))
title(sprintf('tau = %s msec.',tau))




