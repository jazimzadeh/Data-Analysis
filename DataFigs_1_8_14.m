%% 1/8/13 Uncaging Experiment

% Direction is opposite convention, so I've put a (-) in front of all the
% probe traces to flip the polarity back to normal

% For MS (mech stim) runs, the run number recorded in my lab notebook is
% n+1, where n is the run's number in the data structure imported by the
% following commands:

cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-01-08.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a  structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

%% Run 1 (labelled as run 2 in notebook) - bad stim. timing
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data1.data(:,4));
t = (0:L-1)*T;

subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data1.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data1.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data1.data(:,4))

%% RUN 4; Control 5V
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data4.data(:,4));
t = (0:L-1)*T;
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data4.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data4.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data4.data(:,4))
%% Run 4; overlay of laser pulse + displ. trace -> some slight movement due to laser
clf
plot(t,0.1*struct_data.data4.data(:,2))
hold on
plot(t,200-struct_data.data4.data(:,3),'r')

%% RUN 5; Uncaging 3V
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data5.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data5.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data5.data(:,4))
%% Run 5; overlay -> no movement
clf
plot(t,-250+0.15*struct_data.data5.data(:,2))
hold on
plot(t,-struct_data.data5.data(:,3),'r')

%% RUN 7; Uncaging 5V
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data7.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data7.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data7.data(:,4))
%% Run 7; overlay -> mvt artifact on 4th & 5th pulse?
clf
plot(t,-160+0.15*struct_data.data7.data(:,2))
hold on
plot(t,-struct_data.data7.data(:,3),'r')

%% RUN 11; Uncaging 1V - mvt on 3rd pulse *
% New bundle
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data11.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data11.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data11.data(:,4))
%% Run 11; overlay -> mvt on 3rd pulse *
clf
plot(t,-260+0.5*struct_data.data11.data(:,2))
hold on
plot(t,-struct_data.data11.data(:,3),'r')

%% RUN 12; Uncaging 1.5 V - nothing
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data12.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data12.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data12.data(:,4))
%% Run 12; overlay - nothing
clf
plot(t,-250+0.2*struct_data.data12.data(:,2))
hold on
plot(t,-struct_data.data12.data(:,3),'r')

%% RUN 13; Uncaging 1.5 V 
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data13.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data13.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data13.data(:,4))
%% Run 13; overlay - mvt on last pulse right after laser
clf
plot(t,-200+0.8*struct_data.data13.data(:,2))
hold on
plot(t,-struct_data.data13.data(:,3),'r')



%% %%%%%%% NEW PROTOCOL FOR TRACES BELOW, RUN THIS Fs CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fs = 10000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data14.data(:,4));
t = (0:L-1)*T;



%% RUN 14; Uncaging 1.5 V, 200 nm, nothing
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data14.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data14.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data14.data(:,4))
%% Run 14; overlay 
clf
plot(t,-370+0.8*struct_data.data14.data(:,2))
hold on
plot(t,-struct_data.data14.data(:,3),'r')

%% RUN 15; Uncaging 1.5 V, 200 nm, push towards kino - nothing
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data15.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data15.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data15.data(:,4))
%% Run 15; overlay 
clf
plot(t,-100+0.4*struct_data.data15.data(:,2))
hold on
plot(t,-struct_data.data15.data(:,3),'r')

%% RUN 16; Uncaging 2 V, 200 nm, push towards kino - nothing
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data16.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data16.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data16.data(:,4))
%% Run 16; overlay 
clf
plot(t,-150+0.2*struct_data.data16.data(:,2))
hold on
plot(t,-struct_data.data16.data(:,3),'r')

%% RUN 18; Uncaging 2 V - Movement: negative then positive  **
% New Bundle %
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data18.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data18.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data18.data(:,4))
%% Run 18; overlay 
clf
plot(t,40+0.02*struct_data.data18.data(:,2))
hold on
plot(t,-struct_data.data18.data(:,3),'r')

%% RUN 19; Uncaging 3 V - Movement: (-) then (+); Tau = 2ms for last one ***
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data19.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data19.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data19.data(:,4))
%% Run 19; overlay - Movement ***
clf
plot(t,255+0.01*struct_data.data19.data(:,2))
hold on
plot(t,-struct_data.data19.data(:,3),'r')
% Tau_1st_twitch = 4.8 ms
% Tau_6th_twitch = 2 ms or 3ms, depending if starting in middle or at end
% of peak

%% RUN 20; Uncaging 3 V - movement changed polarity ***
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data20.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data20.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data20.data(:,4))
%% Run 20; overlay - Movement changed polarity ***
clf
plot(t,-55+0.01*struct_data.data20.data(:,2))
hold on
plot(t,-struct_data.data20.data(:,3),'r')

%% RUN 21; Uncaging 2 V - movement much reduced, still changed polarity ***
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data21.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data21.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data21.data(:,4))
%% Run 21; overlay 
clf
plot(t,-60+0.1*struct_data.data21.data(:,2))
hold on
plot(t,-struct_data.data21.data(:,3),'r')

%% RUN 22; Probe only, 2V, no motion; Probe not next to bundle, up in mid-fluid
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data22.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data22.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data22.data(:,4))
%% Run 22; overlay 
clf
plot(t,0.1*struct_data.data22.data(:,2))
hold on
plot(t,-struct_data.data22.data(:,3),'r')

%% RUN 23; Probe only, 3V, no motion
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data23.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data23.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data23.data(:,4))
%% Run 23; overlay 
clf
plot(t,0.1*struct_data.data23.data(:,2))
hold on
plot(t,-struct_data.data23.data(:,3),'r')

%% RUN 24; Probe only, 4V, no motion
subplot_tight(3,1,1,[0.05 0.05])
plot(t,struct_data.data24.data(:,2))
subplot_tight(3,1,2,[0.05 0.05])
plot(t,-struct_data.data24.data(:,3))
subplot_tight(3,1,3,[0.05 0.05])
plot(t,-struct_data.data24.data(:,4))
%% Run 24; overlay 
clf
plot(t,-250+0.13*struct_data.data24.data(:,2))
hold on
plot(t,-struct_data.data24.data(:,3),'r')





