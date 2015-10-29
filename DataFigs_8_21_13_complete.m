%% 8/21/13 Data Analysis
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2013-08-21.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a nested structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

%% Rec. 4
Fs = 10000;       %sampling rate
T = 1/Fs;
L = length(struct_data.data4.data(:,4));
t = (0:L-1)*T;

subplot(2,1,1)
plot(t,struct_data.data4.data(:,4),'r')
title('8/21/13 Rec. 4 - No NPE', 'fontsize',16)
subplot(2,1,2)
plot(t,struct_data.data4.data(:,2),'k')

%% Rec. 5
Fs = 10000;       %sampling rate
T = 1/Fs;
L = length(struct_data.data5.data(:,4));
t = (0:L-1)*T;

subplot(2,1,1)
plot(t,struct_data.data5.data(:,4),'r')
title('8/21/13 Rec. 5 - No NPE', 'fontsize',16)
subplot(2,1,2)
plot(t,struct_data.data5.data(:,2),'k')

%% Rec. 6
Fs = 10000;       %sampling rate
T = 1/Fs;
L = length(struct_data.data6.data(:,4));
t = (0:L-1)*T;

subplot(2,1,1)
plot(t,struct_data.data6.data(:,4),'r')
title('8/21/13 Rec. 6 - No NPE', 'fontsize',16)
subplot(2,1,2)
plot(t,struct_data.data6.data(:,2),'k')

%% Fourier for Rec. 6
Fs = 10000;                                % Sampling rate
N = length(struct_data.data6.data(:,2));    % Number of points
T = N/Fs;                                   % Duration in seconds
t = T*(0:N-1)'/N;                           % Time point of each point

p = abs(fft(struct_data.data6.data(:,2)))/(N/2);
p = p(1:N/2).^2;
freq = (0:N/2-1)'/T;
figure;
semilogy(freq,p);
xlabel('Frenquency (Hz)', 'fontsize',16)
ylabel('Power','fontsize',16)
% Peak at 480 Hz!

%% Rec. 7
Fs = 10000;       %sampling rate
T = 1/Fs;
L = length(struct_data.data7.data(:,4));
t = (0:L-1)*T;

subplot(2,1,1)
plot(t,struct_data.data7.data(:,4),'r')
title('8/21/13 Rec. 7 - No NPE - 2.96 mW', 'fontsize',16)
subplot(2,1,2)
plot(t,struct_data.data7.data(:,2),'k')

%% Fourier for Rec. 7
Fs = 10000;                                % Sampling rate
N = length(struct_data.data7.data(:,2));    % Number of points
T = N/Fs;                                   % Duration in seconds
t = T*(0:N-1)'/N;                           % Time point of each point

p = abs(fft(struct_data.data7.data(:,2)))/(N/2);
p = p(1:N/2).^2;
freq = (0:N/2-1)'/T;
figure;
semilogy(freq,p);
xlabel('Frenquency (Hz)', 'fontsize',16)
ylabel('Power','fontsize',16)
title('8/21/13 Rec. 7 FFT','fontsize',16)
% Peak at 480 Hz again!

%% Rec. 8
Fs = 10000;       %sampling rate
T = 1/Fs;
L = length(struct_data.data8.data(:,4));
t = (0:L-1)*T;

subplot(2,1,1)
plot(t,struct_data.data8.data(:,4),'r')
title('8/21/13 Rec. 8 - NPE Present - 2 msec, 2.96 mW ', 'fontsize',16)
set(gca,'XTicklabel',[],'XTick',[])
subplot(2,1,2)
plot(t,struct_data.data8.data(:,2),'k')
% Just ringing noise

%% Fourier for Rec. 8
Fs = 10000;                                % Sampling rate
N = length(struct_data.data8.data(:,2));    % Number of points
T = N/Fs;                                   % Duration in seconds
t = T*(0:N-1)'/N;                           % Time point of each point

p = abs(fft(struct_data.data8.data(:,2)))/(N/2);
p = p(1:N/2).^2;
freq = (0:N/2-1)'/T;
figure;
semilogy(freq,p);
xlabel('Frenquency (Hz)', 'fontsize',16)
ylabel('Power','fontsize',16)
title('8/21/13 Rec. 8 FFT','fontsize',16)

%% Rec. 10
Fs = 10000;       %sampling rate
T = 1/Fs;
L = length(struct_data.data10.data(:,4));
t = (0:L-1)*T;

subplot(2,1,1)
plot(t,struct_data.data10.data(:,4),'r')
title('8/21/13 Rec. 10 - NPE Present, 5V', 'fontsize',16)
set(gca,'XTicklabel',[],'XTick',[])
subplot(2,1,2)
plot(t,struct_data.data10.data(:,2),'k')

figure;
plot(t,struct_data.data10.data(:,4)+50,'r')
title('8/21/13 REc. 10 - Overlayed','fontsize',16)
hold on
plot(t,struct_data.data10.data(:,2),'k')

%% Fourier Rec. 10
Fs = 10000;                                % Sampling rate
N = length(struct_data.data10.data(:,2));    % Number of points
T = N/Fs;                                   % Duration in seconds
t = T*(0:N-1)'/N;                           % Time point of each point

p = abs(fft(struct_data.data10.data(:,2)))/(N/2);
p = p(1:N/2).^2;
freq = (0:N/2-1)'/T;
figure;
semilogy(freq,p);
xlabel('Frenquency (Hz)', 'fontsize',16)
ylabel('Power','fontsize',16)
title('8/21/13 Rec. 10 FFT','fontsize',16)

%% Rec. 12
Fs = 10000;       %sampling rate
T = 1/Fs;
L = length(struct_data.data12.data(:,4));
t = (0:L-1)*T;

subplot(2,1,1)
plot(t,struct_data.data12.data(:,4),'r')
title('8/21/13 Rec. 12 - NPE Present, 2V, 2 msec', 'fontsize',16)
subplot(2,1,2)
plot(t,struct_data.data12.data(:,2),'k')

figure;
plot(t,struct_data.data12.data(:,4)+220,'r')
hold on
plot(t,struct_data.data12.data(:,2),'k')

%% Fourier rec. 12
Fs = 10000;                                % Sampling rate
N = length(struct_data.data12.data(:,2));    % Number of points
T = N/Fs;                                   % Duration in seconds
t = T*(0:N-1)'/N;                           % Time point of each point

p = abs(fft(struct_data.data12.data(:,2)))/(N/2);
p = p(1:N/2).^2;
freq = (0:N/2-1)'/T;
figure;
semilogy(freq,p);
xlabel('Frequency (Hz)', 'fontsize',16)
ylabel('Power','fontsize',16)

%% Rec. 13
Fs = 10000;       %sampling rate
T = 1/Fs;
L = length(struct_data.data12.data(:,4));
t = (0:L-1)*T;

subplot(2,1,1)
plot(t,struct_data.data12.data(:,4),'r')
title('8/21/13 Rec. 13 - NPE Present, 2V, 5 msec', 'fontsize',16)
subplot(2,1,2)
plot(t,struct_data.data12.data(:,2),'k')

%% Rec. 15
Fs = 10000;       %sampling rate
T = 1/Fs;
L = length(struct_data.data15.data(:,4));
t = (0:L-1)*T;

subplot(2,1,1)
plot(t,struct_data.data15.data(:,4),'r')
title('8/21/13 Rec. 15 - Probe Unattached', 'fontsize',16)
subplot(2,1,2)
plot(t,struct_data.data15.data(:,2),'k')

%% Rec. 23 - New Bundle
Fs = 10000;       %sampling rate
T = 1/Fs;
L = length(struct_data.data22.data(:,4));
t = (0:L-1)*T;

subplot(2,1,1)
plot(t,struct_data.data23.data(:,4),'r')
title('8/21/13 Rec. 23 - New Bundle', 'fontsize',16)
subplot(2,1,2)
plot(t,struct_data.data23.data(:,2),'k')

%% Rec. 25 - 5V; Nothing
Fs = 10000;       %sampling rate
T = 1/Fs;
L = length(struct_data.data25.data(:,4));
t = (0:L-1)*T;

subplot(2,1,1)
plot(t,struct_data.data25.data(:,4),'r')
title('8/21/13 Rec. 25 - 5V', 'fontsize',16)
subplot(2,1,2)
plot(t,struct_data.data25.data(:,2),'k')



