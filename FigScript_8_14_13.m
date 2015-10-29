%8/14/13 Data
% Left Column, from top down: Rec7 stimulus, Rec7 mvt, Rec8 mvt, Rec10 mvt
% Right Column, from top down: Rec20 stim, blank, Rec20 mvt, Rec21 mvt

%Axis was scaled to make the noise approximately the same in all rec's
% (No calibration was done on this day, so a real axis is meaningless, only
% the mvt relative to noise can be interpreted)

Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data6.data(:,4));
t = (0:L-1)*T;

subplot_tight(4,2,1,[0.05 0.05]);
plot(t,struct_data.data7.data(:,4));
axis([0 0.1 -5 35])
subplot_tight(4,2,3,[0.05 0.05]);
plot(t,struct_data.data7.data(:,2));
axis([0 0.1 -450 -250])
subplot_tight(4,2,5,[0.05 0.05]);
plot(t,struct_data.data8.data(:,2));
subplot_tight(4,2,7,[0.05 0.05]);
plot(t,struct_data.data10.data(:,2));

subplot_tight(4,2,2,[0.05 0.05]);
plot(t,struct_data.data20.data(:,4));
axis([0 0.1 -5 35])

subplot_tight(4,2,6,[0.05 0.05]);
plot(t,struct_data.data20.data(:,2));
axis([0 0.1 -300 -160])

subplot_tight(4,2,8,[0.05 0.05]);
plot(t,struct_data.data21.data(:,2));
axis([0 0.1 -300 -160])

