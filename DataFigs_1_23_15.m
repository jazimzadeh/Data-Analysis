% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-01-23.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%% Plot Resistance vs. Temperature 
Temp = [45 40 35 30 25 20];
Res = [6 6.45 6.95 7.6 8.25 9.1];
Temp2 = 40;
Res2 = 6.48;

plot(Temp,Res,'k.','MarkerSize',25)
hold on
plot(Temp2,Res2,'.r','MarkerSize',25)
axis([15 50 5 10]);
title('Resistance vs. Temperature','FontSize',18)
xlabel('Temperature (C)','FontSize',16)
ylabel('Resistance (M Ohm)','FontSize',16)

saveas(gcf,strcat('TempVsRes.pdf'));
saveas(gcf,strcat('TempVsRes','fig'));
saveas(gcf,strcat('TempVsRes','eps'),'epsc');

%%
for r = 4:length(fileList2);
    logfile_name        = getfield(dir('*.log'),'name');
    logfile_name_clean  = logfile_name(1:end-7);            % remove excess numbers from filename, for use in figure titles below
    logfile             = importdata(logfile_name);
    wavetrain           = logfile.data(r,8);                % get number of wavetrains [actually waveforms] for that run
    laser_delay         = logfile.data(r,43)*.001;          % in milliseconds
    laser_duration      = logfile.data(r,44)*.001;          % in milliseconds
    laser_voltage       = logfile.data(r,63);
    probe_pzt_delay     = logfile.data(r,22)*0.001;         % in seconds
    probe_pzt_duration  = logfile.data(r,23)*0.001;         % in seconds
    beta                = logfile.data(4,106);
    Fs                  = logfile.data(r,12);               % sampling rate
    T                   = 1/Fs;
    L                   = length(struct_data(r).data(:,2));    
    t                   = (0:L-1)*T;        
    
    subplot(3,1,1)
    plot(t,struct_data(r).data(:,0*wavetrain+2:1*wavetrain+1));
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',12)
    ylabel('Current (pA)');
    subplot(3,1,2)
    plot(t,struct_data(r).data(:,1*wavetrain+2:2*wavetrain+1));
    ylabel('Voltage Step (mV)');
    subplot(3,1,3)
    plot(t,struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1));
    ylabel('Laser Command (V)');
    xlabel('Time (seconds)');
    
    saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

%%
r = 4;
logfile_name        = getfield(dir('*.log'),'name');
logfile_name_clean  = logfile_name(1:end-7);            % remove excess numbers from filename, for use in figure titles below
logfile             = importdata(logfile_name);
wavetrain           = logfile.data(r,8);                % get number of wavetrains [actually waveforms] for that run
laser_delay         = logfile.data(r,43)*.001;          % in milliseconds
laser_duration      = logfile.data(r,44)*.001;          % in milliseconds
laser_voltage       = logfile.data(r,63);
probe_pzt_delay     = logfile.data(r,22)*0.001;         % in seconds
probe_pzt_duration  = logfile.data(r,23)*0.001;         % in seconds
beta                = logfile.data(4,106);
Fs                  = logfile.data(r,12);               % sampling rate
T                   = 1/Fs;
L                   = length(struct_data(r).data(:,2));    
t                   = (0:L-1)*T;  

base_start = 1/Fs;  % first point
base_end = 0.0090;
a_start = 0.04;     % in seconds
a_end   = 0.05;
b_start = 0.08;
b_end   = 0.09;
c_start = 0.12;
c_end   = 0.13;

res_matrix = zeros(wavetrain,9);

for i = 1:wavetrain
    res_matrix(i,1) = mean(struct_data(r).data(Fs*a_start:Fs*a_end,i+1)) - mean(struct_data(r).data(Fs*base_start:Fs*base_end,i+1));   % currents in pA
    res_matrix(i,2) = mean(struct_data(r).data(Fs*a_start:Fs*a_end,i+11));  % voltages in mV
    res_matrix(i,3) = mean(struct_data(r).data(Fs*b_start:Fs*b_end,i+1)) - mean(struct_data(r).data(Fs*base_start:Fs*base_end,i+1));   % currents
    res_matrix(i,4) = mean(struct_data(r).data(Fs*b_start:Fs*b_end,i+11));  % voltages
    res_matrix(i,5) = mean(struct_data(r).data(Fs*c_start:Fs*c_end,i+1)) - mean(struct_data(r).data(Fs*base_start:Fs*base_end,i+1));   % currents
    res_matrix(i,6) = mean(struct_data(r).data(Fs*c_start:Fs*c_end,i+11));  % voltages
end

res_matrix(:,7) = res_matrix(:,2) ./ res_matrix(:,1) * 1000;                % resistances in MOhm
res_matrix(:,8) = res_matrix(:,4) ./ res_matrix(:,3) * 1000;
res_matrix(:,9) = res_matrix(:,6) ./ res_matrix(:,5) * 1000;
 
clf
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
subplot(3,1,1)
plot(t,struct_data(r).data(:,0*wavetrain+2:1*wavetrain+1));
title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',12)
ylabel('Current (pA)');
subplot(3,1,2)
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
for i = 1:wavetrain
    plot(a_start + i*0.001,res_matrix(i,7),'.','MarkerSize',20)
    hold all
end

for i = 1:wavetrain
    plot(b_start + i*0.001,res_matrix(i,8),'.','MarkerSize',20)
    hold all
end

for i = 1:wavetrain
    plot(c_start + i*0.001,res_matrix(i,9),'.','MarkerSize',20)
    hold all
end

axis([0 0.2 9.2 9.35])
ylabel('Resistance (MOhm)')
    
subplot(3,1,3)
plot(t,struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1));
ylabel('Laser Command (V)');
xlabel('Time (seconds)');

ylim = get(gca, 'YLim');
x = [a_start a_start a_end a_end a_start]; 
y = [ylim(1)+0.1 ylim(2)-0.1 ylim(2)-0.1 ylim(1)+0.1 ylim(1)+0.1]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch for area a
xb = [b_start b_start b_end b_end b_start]; 
yb = [ylim(1)+0.1 ylim(2)-0.1 ylim(2)-0.1 ylim(1)+0.1 ylim(1)+0.1];  
patch(xb, yb, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')   % Area b
xc = [c_start c_start c_end c_end c_start]; 
yc = [ylim(1)+0.1 ylim(2)-0.1 ylim(2)-0.1 ylim(1)+0.1 ylim(1)+0.1]; 
patch(xc, yc, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')   % Area b

saveas(gcf,strcat('Res_Record',num2str(r),'.pdf'));
saveas(gcf,strcat('Res_Record_m',num2str(r),'fig'));
saveas(gcf,strcat('Res_Record_e',num2str(r),'eps'),'epsc');

%%
r = 8;
logfile_name        = getfield(dir('*.log'),'name');
logfile_name_clean  = logfile_name(1:end-7);            % remove excess numbers from filename, for use in figure titles below
logfile             = importdata(logfile_name);
wavetrain           = logfile.data(r,8);                % get number of wavetrains [actually waveforms] for that run
laser_delay         = logfile.data(r,43)*.001;          % in milliseconds
laser_duration      = logfile.data(r,44)*.001;          % in milliseconds
laser_voltage       = logfile.data(r,63);
probe_pzt_delay     = logfile.data(r,22)*0.001;         % in seconds
probe_pzt_duration  = logfile.data(r,23)*0.001;         % in seconds
beta                = logfile.data(4,106);
Fs                  = logfile.data(r,12);               % sampling rate
T                   = 1/Fs;
L                   = length(struct_data(r).data(:,2));    
t                   = (0:L-1)*T;  

a_start = 0.13;     % in seconds
a_end   = 0.14;
b_start = 0.22;
b_end   = 0.23;
c_start = 1.72;
c_end   = 1.73;

res_matrix = zeros(1,9);

res_matrix(1,1) = mean(struct_data(r).data(Fs*a_start:Fs*a_end,2));     % currents in pA
res_matrix(1,2) = mean(struct_data(r).data(Fs*a_start:Fs*a_end,3));     % voltages in mV
res_matrix(1,3) = mean(struct_data(r).data(Fs*b_start:Fs*b_end,2));     % currents in pA
res_matrix(1,4) = mean(struct_data(r).data(Fs*b_start:Fs*b_end,3));     % voltages in mV
res_matrix(1,5) = mean(struct_data(r).data(Fs*c_start:Fs*c_end,2));     % currents in pA
res_matrix(1,6) = mean(struct_data(r).data(Fs*c_start:Fs*c_end,3));     % voltages in mV
res_matrix(1,7) = res_matrix(:,2) ./ res_matrix(:,1) * 1000;            % resistance in MOhm
res_matrix(1,8) = res_matrix(:,4) ./ res_matrix(:,3) * 1000;            % resistance in MOhm
res_matrix(1,9) = res_matrix(:,4) ./ res_matrix(:,3) * 1000;            % resistance in MOhm

 
clf
set(0, 'DefaultAxesColorOrder', hsv(wavetrain));
subplot(3,1,1)
plot(t,struct_data(r).data(:,0*wavetrain+2:1*wavetrain+1));
title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',12)
ylabel('Current (pA)');
subplot(3,1,2)
for i = 1:wavetrain
    plot(a_start, res_matrix(i,7),'.','MarkerSize',20)
    hold all
end

for i = 1:wavetrain
    plot(b_start, res_matrix(i,8),'.','MarkerSize',20)
    hold all
end

for i = 1:wavetrain
    plot(c_start, res_matrix(i,9),'.','MarkerSize',20)
    hold all
end

axis([0 2 9.35 9.5])
ylabel('Resistance (MOhm)')
    
subplot(3,1,3)
plot(t,struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1));
ylabel('Laser Command (V)');
xlabel('Time (seconds)');

ylim = get(gca, 'YLim');
x = [a_start a_start a_end a_end a_start]; 
y = [ylim(1)+0.1 ylim(2)-0.1 ylim(2)-0.1 ylim(1)+0.1 ylim(1)+0.1]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch for area a
xb = [b_start b_start b_end b_end b_start]; 
yb = [ylim(1)+0.1 ylim(2)-0.1 ylim(2)-0.1 ylim(1)+0.1 ylim(1)+0.1];  
patch(xb, yb, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')   % Area b
xc = [c_start c_start c_end c_end c_start]; 
yc = [ylim(1)+0.1 ylim(2)-0.1 ylim(2)-0.1 ylim(1)+0.1 ylim(1)+0.1]; 
patch(xc, yc, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')   % Area b

saveas(gcf,strcat('Res_Record',num2str(r),'.pdf'));
saveas(gcf,strcat('Res_Record_m',num2str(r),'fig'));
saveas(gcf,strcat('Res_Record_e',num2str(r),'eps'),'epsc');





%%
r = 5;
logfile_name        = getfield(dir('*.log'),'name');
logfile_name_clean  = logfile_name(1:end-7);            % remove excess numbers from filename, for use in figure titles below
logfile             = importdata(logfile_name);
wavetrain           = logfile.data(r,8);                % get number of wavetrains [actually waveforms] for that run
laser_delay         = logfile.data(r,43)*.001;          % in milliseconds
laser_duration      = logfile.data(r,44)*.001;          % in milliseconds
vstep_delay         = logfile.data(r,29)*.001;
vstep_duration      = logfile.data(r,30)*.001;
laser_voltage       = logfile.data(r,63);
probe_pzt_delay     = logfile.data(r,22)*0.001;         % in seconds
probe_pzt_duration  = logfile.data(r,23)*0.001;         % in seconds
beta                = logfile.data(4,106);
Fs                  = logfile.data(r,12);               % sampling rate
T                   = 1/Fs;
L                   = length(struct_data(r).data(:,2));    
t                   = (0:L-1)*T;  

band_width = 40;                                        % number of points in each time band
n_bands = vstep_duration * Fs / band_width;             % number of time bands
base_start = 1;                                         % first point of teh trace
base_end = vstep_delay * Fs;                            % point at which voltage step comes on


res_matrix = zeros(wavetrain,n_bands);                  % initialize resistance matrix

for i = 1:wavetrain
    base_current = mean(struct_data(r).data(base_start : base_end,i+1));
    for n = 1:n_bands
        current = mean(struct_data(r).data(Fs*vstep_delay + (n-1)*band_width : Fs*vstep_delay + n*band_width,i+1)) - base_current;
        voltage = mean(struct_data(r).data(Fs*vstep_delay + (n-1)*band_width : Fs*vstep_delay + n*band_width,i+1+wavetrain));
        res_matrix(i,n) = voltage / current * 1000;
    end
end

 
clf
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
subplot(4,1,1)
plot(t,struct_data(r).data(:,0*wavetrain+2:1*wavetrain+1));
title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',12)
ylabel('Current (pA)');

subplot(4,1,2:3)
set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
x_samples = [vstep_delay*Fs + band_width/2 : 40 : Fs*(vstep_delay + vstep_duration) - band_width/2];    % sample values in the middle of each band
x = x_samples/Fs;       % the time values against which resistances will be plotted

plot(x,res_matrix(:,:),'LineWidth',2)

axis([0 0.2 8.9 9.6])
ylim = get(gca, 'YLim');
x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 
ylabel('Resistance (MOhm)')
    

subplot(4,1,4)
plot(t,struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1),'LineWidth',2);
ylabel('Laser Command (V)');
xlabel('Time (seconds)');

% ylim = get(gca, 'YLim');
% x = [a_start a_start a_end a_end a_start]; 
% y = [ylim(1)+0.1 ylim(2)-0.1 ylim(2)-0.1 ylim(1)+0.1 ylim(1)+0.1]; 
% patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch for area a
% xb = [b_start b_start b_end b_end b_start]; 
% yb = [ylim(1)+0.1 ylim(2)-0.1 ylim(2)-0.1 ylim(1)+0.1 ylim(1)+0.1];  
% patch(xb, yb, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')   % Area b
% xc = [c_start c_start c_end c_end c_start]; 
% yc = [ylim(1)+0.1 ylim(2)-0.1 ylim(2)-0.1 ylim(1)+0.1 ylim(1)+0.1]; 
% patch(xc, yc, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')   % Area b
saveas(gcf,strcat('Res_hirate_Record',num2str(r),'.pdf'));
saveas(gcf,strcat('Res_hirate_Record_m',num2str(r),'fig'));
saveas(gcf,strcat('Res_hirate_Record_e',num2str(r),'eps'),'epsc');

%%
r = 8;
logfile_name        = getfield(dir('*.log'),'name');
logfile_name_clean  = logfile_name(1:end-7);            % remove excess numbers from filename, for use in figure titles below
logfile             = importdata(logfile_name);
wavetrain           = logfile.data(r,8);                % get number of wavetrains [actually waveforms] for that run
laser_delay         = logfile.data(r,43)*.001;          % in milliseconds
laser_duration      = logfile.data(r,44)*.001;          % in milliseconds
vstep_delay         = logfile.data(r,29)*.001;
vstep_duration      = logfile.data(r,30)*.001;
laser_voltage       = logfile.data(r,63);
probe_pzt_delay     = logfile.data(r,22)*0.001;         % in seconds
probe_pzt_duration  = logfile.data(r,23)*0.001;         % in seconds
beta                = logfile.data(4,106);
Fs                  = logfile.data(r,12);               % sampling rate
T                   = 1/Fs;
L                   = length(struct_data(r).data(:,2));    
t                   = (0:L-1)*T;  

band_width = 40;                                        % number of points in each time band
n_bands = vstep_duration * Fs / band_width;             % number of time bands
base_pre_start = 1;                                     % first point of teh trace
base_pre_end = vstep_delay * Fs;                        % point at which voltage step comes on

res_matrix = zeros(wavetrain,n_bands);                  % initialize resistance matrix

for i = 1:wavetrain
    base_current = mean(struct_data(r).data(base_pre_start : base_pre_end,i+1));
    for n = 1:n_bands
        current = mean(struct_data(r).data(Fs*vstep_delay + (n-1)*band_width : Fs*vstep_delay + n*band_width,i+1)) - base_current;
        voltage = mean(struct_data(r).data(Fs*vstep_delay + (n-1)*band_width : Fs*vstep_delay + n*band_width,i+1+wavetrain));
        res_matrix(i,n) = voltage / current * 1000;
    end
end

 
clf
subplot(4,1,1)
plot(t,struct_data(r).data(:,0*wavetrain+2:1*wavetrain+1),'k');
title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',12)
ylabel('Current (pA)');

subplot(4,1,2:3)
x_samples = [vstep_delay*Fs + band_width/2 : 40 : Fs*(vstep_delay + vstep_duration) - band_width/2];    % sample values in the middle of each band
x = x_samples/Fs;       % the time values against which resistances will be plotted

plot(x,res_matrix(:,:),'r','LineWidth',1.5)
axis([0 length(struct_data(r).data)/Fs 8.9 9.5])

ylim = get(gca, 'YLim');
x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 

ylabel('Resistance (MOhm)')
    

subplot(4,1,4)
plot(t,struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1),'m','LineWidth',2);
ylabel('Laser Command (V)');
xlabel('Time (seconds)');

% ylim = get(gca, 'YLim');
% x = [a_start a_start a_end a_end a_start]; 
% y = [ylim(1)+0.1 ylim(2)-0.1 ylim(2)-0.1 ylim(1)+0.1 ylim(1)+0.1]; 
% patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch for area a
% xb = [b_start b_start b_end b_end b_start]; 
% yb = [ylim(1)+0.1 ylim(2)-0.1 ylim(2)-0.1 ylim(1)+0.1 ylim(1)+0.1];  
% patch(xb, yb, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')   % Area b
% xc = [c_start c_start c_end c_end c_start]; 
% yc = [ylim(1)+0.1 ylim(2)-0.1 ylim(2)-0.1 ylim(1)+0.1 ylim(1)+0.1]; 
% patch(xc, yc, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')   % Area b
saveas(gcf,strcat('Res_hirate_Record',num2str(r),'.pdf'));
saveas(gcf,strcat('Res_hirate_Record_m',num2str(r),'fig'));
saveas(gcf,strcat('Res_hirate_Record_e',num2str(r),'eps'),'epsc');

