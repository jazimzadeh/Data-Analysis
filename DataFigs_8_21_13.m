% 8/21/13 - Downward deflection is towards kinocilium

% --- Import Data --- %
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2013-08-21.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a nested structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

%% Rec. 7 - Control - No NPE
Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data7.data(:,4));
t = (0:L-1)*T;
figure
subplot_tight(3,1,1,[0.05 0.05]);
plot(t,struct_data.data7.data(:,4))
set(gca,'XTickLabel',[],'XTick',[])
title('8/21/13 Rec. 7, No NPE','fontsize',16)
subplot_tight(3,1,2,[0.03 0.05]);
plot(t,struct_data.data7.data(:,3))
set(gca,'XTickLabel',[],'XTick',[])
subplot_tight(3,1,3,[0.03 0.05]);
plot(t,struct_data.data7.data(:,2))

%% Fourier for Rec. 7
Fs = 5000;                                  % Sampling rate
N = length(struct_data.data7.data(:,2));    % Number of points
T = N/Fs;                                   % Duration in seconds
t = T*(0:N-1)'/N;                           % Time point of each point

p = abs(fft(struct_data.data7.data(:,2)))/(N/2);
p = p(1:N/2).^2;
freq = (0:N/2-1)'/T;
figure;
semilogy(freq,p);
xlabel('Frequency (Hz)', 'fontsize',16)
ylabel('Power','fontsize',16)
title('8/21/13 Rec. 7 FFT','fontsize',16)

%% Rec. 12 - NPE, 2V, 2ms
Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data12.data(:,4));
t = (0:L-1)*T;

plot(t,struct_data.data12.data(:,4)+220,'r')
hold on
plot(t,struct_data.data12.data(:,2),'k')

figure;
subplot_tight(2,1,1,[0.04 0.05])
plot(t,struct_data.data12.data(:,4),'r')
set(gca,'XTickLabel',[],'XTick',[])
title('8/21/13 Rec. 12 - NPE Present, 2V, 2 msec', 'fontsize',16)
subplot_tight(2,1,2,[0.03 0.05])
plot(t,struct_data.data12.data(:,2),'k')

%% Rec. 23 - New Bundle - 5V - some movement
Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data23.data(:,4));
t = (0:L-1)*T;

figure;
plot(t,struct_data.data23.data(:,4)+180,'r')
hold on
plot(t,struct_data.data23.data(:,2),'k')
title('8/21/13 Rec. 23 - New Bundle', 'fontsize',16)
xlabel('Time (sec)');
figure;
subplot(2,1,1)
plot(t,struct_data.data23.data(:,4),'r')
title('8/21/13 Rec. 23 - New Bundle', 'fontsize',16)
subplot(2,1,2)
plot(t,struct_data.data23.data(:,2),'k')

