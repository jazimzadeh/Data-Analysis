% This imports all data files from a single day into one data structure
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-07-16.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a nested structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

% To call one experiment, use the following as the name of the data file:
% struct_data.dataN.data, where N is the run number
% for example: plot(struct_data.data1.data(:,2))

%%
Fs = 20000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data1.data(:,2));
t = (0:L-1)*T;

%%
plot(t,struct_data.data5.data(:,30:36))
hold on
plot(t,struct_data.data5.data(:,23:29))

%%
clf
subplot(2,1,1)
plot(t,struct_data.data5.data(:,16:22))
subplot(2,1,2)
plot(struct_data.data5.data(:,23:29))

%% Plot a rudimentary i_x curve - seems like the last point is not as high as it should be. Maybe it slipped off the bundle?
clf;
i_x = [0:100:600]';
for i = 23:29
    data = eval(['struct_data.data5.data(:,' num2str(i) ')']);
    min = mean(data(330:380));
    max = mean(data(425:440));
    current = abs(max - min);
    i_x(i-22,2) = current;
end
plot(i_x(:,1),i_x(:,2),'.')
xlabel('Displacement (nm)')
ylabel('Current (pA)')
title('I(X) Curve for a dissociated hair cell')
axis([-100 700 -50 300])

%%
m = 0;
clf
    set(gca, 'ColorOrder', [1 0.9 0 ; 1 0.8 0 ; 1 0.6 0 ; 1 0.5 0 ; 1 0.4 0 ; 1 0.3 0 ; 1 0.1 0], 'NextPlot', 'replacechildren');

%for n = 23:29

hold on
plot(struct_data.data5.data(:,23:29))
m = m + 20;
%end
    


