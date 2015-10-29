% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-09-30.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%% Plot individual records, scale
for r = 1:36;
    clf
    logfile_name        = getfield(dir('*.log'),'name');
    logfile_name_clean  = logfile_name(1:end-7);            % remove excess numbers from filename, for use in figure titles below
    logfile             = importdata(logfile_name);
    wavetrain           = logfile.data(r,8);                % get number of wavetrains [actually waveforms] for that run
    laser_delay         = logfile.data(r,43)*.001;          % in milliseconds
    laser_duration      = logfile.data(r,44)*.001;          % in milliseconds
    laser_voltage       = logfile.data(r,63);
    probe_pzt_delay     = logfile.data(r,22)*0.001;         % in seconds
    probe_pzt_duration  = logfile.data(r,23)*0.001;         % in seconds
    pd_pzt_delay        = logfile.data(r,15)*0.001;
    pd_pzt_duration     = logfile.data(r,16)*0.001;
    beta                = logfile.data(4,106);
    Fs                  = logfile.data(r,12);               % sampling rate
    T                   = 1/Fs;
    L                   = length(struct_data(r).data(:,2));    
    t                   = (0:L-1)*T;        
    % Displacement
    subplot(2,1,1)
    plot(t,struct_data(r).data(:,2:5));
    for wt = 2:5
        dc_offset = mean(struct_data(r).data(1:0.01*Fs,wt));     % get baseline offset
        pd_pulse_peak = mean(struct_data(r).data(0.034*Fs:0.059*Fs,wt));
        pd_pulse_ampl = pd_pulse_peak - dc_offset;
        cfactor = pd_pulse_ampl / 30;
        struct_data(r).data_zeroed_scaled(:,wt) = (struct_data(r).data(:,wt) - dc_offset)/cfactor;
    end
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    
    subplot(2,1,2)
    plot(t,struct_data(r).data_zeroed_scaled(:,2:5));
    ylabel('Displacement (nm)');
    
    saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

%% HB1 - Moving HB through beam
clf
annotation('textbox',[0.15 0.96 0.25 0.04],'String','9/30/15 HB1','FontSize',14)
subplot_tight(5,3,2,[0.05 0.1])
plot(t,struct_data(4).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', []);
axis([0 0.4 -100 400])
subplot_tight(5,3,5,[0.03 0.1])
plot(t,struct_data(5).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', []);
axis([0 0.4 -100 400])
subplot_tight(5,3,8,[0.03 0.1])
plot(t,struct_data(6).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', []);
axis([0 0.4 -100 400])
subplot_tight(5,3,11,[0.03 0.1])
plot(t,struct_data(7).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', []);
axis([0 0.4 -100 400])
subplot_tight(5,3,14,[0.05 0.1])
plot(t,struct_data(8).data_zeroed_scaled(:,2:5))
%set(gca, 'XTick', []);
axis([0 0.4 -100 400])

subplot_tight(5,3,3,[0.05 0.1])
m = max(max(struct_data(4).data_zeroed_scaled(:,2:5)));
plot(t,struct_data(4).data_zeroed_scaled(:,2:5)/m)
set(gca, 'XTick', []);
axis([0 0.4 -0.2 1.1])
subplot_tight(5,3,6,[0.03 0.1])
m = max(max(struct_data(5).data_zeroed_scaled(:,2:5)));
plot(t,struct_data(5).data_zeroed_scaled(:,2:5)/m)
set(gca, 'XTick', []);
axis([0 0.4 -0.2 1.1])
subplot_tight(5,3,9,[0.03 0.1])
m = max(max(struct_data(6).data_zeroed_scaled(:,2:5)));
plot(t,struct_data(6).data_zeroed_scaled(:,2:5)/m)
set(gca, 'XTick', []);
axis([0 0.4 -0.2 1.1])
subplot_tight(5,3,12,[0.03 0.1])
m = max(max(struct_data(7).data_zeroed_scaled(:,2:5)));
plot(t,struct_data(7).data_zeroed_scaled(:,2:5)/m)
set(gca, 'XTick', []);
axis([0 0.4 -0.2 1.1])
subplot_tight(5,3,15,[0.05 0.1])
m = max(max(struct_data(8).data_zeroed_scaled(:,2:5)));
plot(t,struct_data(8).data_zeroed_scaled(:,2:5)/m)
%set(gca, 'XTick', []);
axis([0 0.4 -0.2 1.1])

cd('/Users/Julien/Google Drive/Hudspeth/Data/Photos')
B = imread('capture_20150930_190120.jpg');
subplot_tight(5,3,1,[0.05 0.05])
A = imread('capture_20150930_153358.jpg');
image((A/2) + (B/3))
axis image
set(gca, 'XTick', [], 'YTick', []);
subplot_tight(5,3,4,[0.05 0.05])
A = imread('capture_20150930_153514.jpg');
image((A/2) + (B/3))
axis image
set(gca, 'XTick', [], 'YTick', []);
subplot_tight(5,3,7,[0.05 0.05])
A = imread('capture_20150930_153734.jpg');
image((A/2) + (B/3))
axis image
set(gca, 'XTick', [], 'YTick', []);
subplot_tight(5,3,10,[0.05 0.05])
A = imread('capture_20150930_153946.jpg');
image((A/2) + (B/3))
axis image
set(gca, 'XTick', [], 'YTick', []);
subplot_tight(5,3,13,[0.05 0.05])
A = imread('capture_20150930_154458.jpg');
image((A/2) + (B/3))
axis image
set(gca, 'XTick', [], 'YTick', []);

cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-09-30.01/Ear 1/Cell 1')
saveas(gcf,strcat('Compiled_9_30_15_HB1_mfig'));
saveas(gcf,strcat('Compiled_9_30_15_HB1_e'),'epsc');

%% HB2 - Moving HB through beam
clf
annotation('textbox',[0.12 0.96 0.23 0.04],'String','9/30/15 HB2','FontSize',14)
subplot_tight(5,3,2,[0.03 0.1])
plot(t,struct_data(9).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', []);
axis([0 0.4 -10 42])
subplot_tight(5,3,5,[0.03 0.1])
plot(t,struct_data(10).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', []);
axis([0 0.4 -10 42])
subplot_tight(5,3,8,[0.03 0.1])
plot(t,struct_data(11).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', []);
axis([0 0.4 -10 42])
subplot_tight(5,3,11,[0.03 0.1])
plot(t,struct_data(12).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', []);
axis([0 0.4 -10 42])
subplot_tight(5,3,14,[0.05 0.1])
plot(t,struct_data(13).data_zeroed_scaled(:,2:5))
%set(gca, 'XTick', []);
axis([0 0.4 -10 42])

subplot_tight(5,3,3,[0.03 0.1])
m = max(max(struct_data(9).data_zeroed_scaled(:,2:5)));
plot(t,struct_data(9).data_zeroed_scaled(:,2:5)/m)
set(gca, 'XTick', []);
axis([0 0.4 -0.3 1.1])
subplot_tight(5,3,6,[0.03 0.1])
m = max(max(struct_data(10).data_zeroed_scaled(:,2:5)));
plot(t,struct_data(10).data_zeroed_scaled(:,2:5)/m);
set(gca, 'XTick', []);
axis([0 0.4 -0.3 1.1])
subplot_tight(5,3,9,[0.03 0.1])
m = max(max(struct_data(11).data_zeroed_scaled(:,2:5)));
plot(t,struct_data(11).data_zeroed_scaled(:,2:5)/m)
set(gca, 'XTick', []);
axis([0 0.4 -0.2 1.1])
subplot_tight(5,3,12,[0.03 0.1])
m = max(max(struct_data(12).data_zeroed_scaled(:,2:5)));
plot(t,struct_data(12).data_zeroed_scaled(:,2:5)/m)
set(gca, 'XTick', []);
axis([0 0.4 -0.2 1.1])
subplot_tight(5,3,15,[0.03 0.1])
m = max(max(struct_data(13).data_zeroed_scaled(:,2:5)));
plot(t,struct_data(13).data_zeroed_scaled(:,2:5)/m);
%set(gca, 'XTick', []);
axis([0 0.4 -0.2 1.1])

cd('/Users/Julien/Google Drive/Hudspeth/Data/Photos')
B = imread('capture_20150930_190120.jpg');  % Image of lasered marker
subplot_tight(5,3,1,[0.05 0.05])
A = imread('capture_20150930_155211.jpg');
image((A/2) + (B/3))
axis image
set(gca, 'XTick', [], 'YTick', []);
subplot_tight(5,3,4,[0.05 0.05])
A = imread('capture_20150930_155449.jpg');
image((A/2) + (B/3))
axis image
set(gca, 'XTick', [], 'YTick', []);
subplot_tight(5,3,7,[0.05 0.05])
A = imread('capture_20150930_155700.jpg');
image((A/2) + (B/3))
axis image
set(gca, 'XTick', [], 'YTick', []);
subplot_tight(5,3,10,[0.05 0.05])
A = imread('capture_20150930_155958.jpg');
image((A/2) + (B/3))
axis image
set(gca, 'XTick', [], 'YTick', []);
subplot_tight(5,3,13,[0.05 0.05])
A = imread('capture_20150930_160300.jpg');
image((A/2) + (B/3))
axis image
set(gca, 'XTick', [], 'YTick', []);

cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-09-30.01/Ear 1/Cell 1')
saveas(gcf,strcat('Compiled_9_30_15_HB2_mfig'));
saveas(gcf,strcat('Compiled_9_30_15_HB2_e'),'epsc');

%% HB4 - Kinocilium removal
clf
annotation('textbox',[0.35 0.95 0.25 0.04],'String','9/30/15 HB4','FontSize',14)
annotation('textbox',[0.62 0.94 0.22 0.03],'String','Normalized','FontSize',12)
subplot_tight(3,2,1,[0.07 0.1])
plot(t,struct_data(18).data_zeroed_scaled(:,2:5))
ylabel('Kinocilium')
m1 = max(max(struct_data(18).data_zeroed_scaled(:,2:5)));   % Get maximum
subplot_tight(3,2,3,[0.07 0.1])
plot(t,struct_data(19).data_zeroed_scaled(:,2:5))
ylabel('No Kinocilium')
xlabel('Time (sec)')
m2 = max(max(struct_data(19).data_zeroed_scaled(:,2:5)));   % Get maximum
subplot_tight(3,2,2,[0.07 0.1])
plot(t,struct_data(18).data_zeroed_scaled(:,2:5)/m1);
axis([0 0.4 -0.1 1.1])
subplot_tight(3,2,4,[0.07 0.1])
plot(t,struct_data(19).data_zeroed_scaled(:,2:5)/m2);
axis([0 0.4 -0.1 1.1])
xlabel('Time (sec)')

cd('/Users/Julien/Google Drive/Hudspeth/Data/Photos')
A = imread('capture_20150930_174740.jpg');
subplot_tight(3,3,8,[0.03 0.03])
image(A)
set(gca,'XTickLabel',[],'YTickLabel',[])
axis image

cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-09-30.01/Ear 1/Cell 1')
saveas(gcf,strcat('Kinocilium_9_30_15_HB4_mfig'));
saveas(gcf,strcat('Kinocilium_9_30_15_HB4_e'),'epsc');

%% HB5 - Moving mask around HB
clf
annotation('textbox',[0.15 0.96 0.25 0.04],'String','9/30/15 HB5','FontSize',14)
subplot_tight(7,2,2,[0.01 0.1])
plot(t,struct_data(20).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', []);
axis([0 0.4 -100 200])
subplot_tight(7,2,4,[0.01 0.1])
plot(t,struct_data(21).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', [],'YTick', []);
axis([0 0.4 -100 200])
subplot_tight(7,2,6,[0.01 0.1])
plot(t,struct_data(22).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', [],'YTick', []);
axis([0 0.4 -100 200])
subplot_tight(7,2,8,[0.01 0.1])
plot(t,struct_data(23).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', [],'YTick', []);
axis([0 0.4 -100 200])
subplot_tight(7,2,10,[0.01 0.1])
plot(t,struct_data(24).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', [],'YTick', []);
axis([0 0.4 -100 200])
subplot_tight(7,2,12,[0.01 0.1])
plot(t,struct_data(25).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', [],'YTick', []);
axis([0 0.4 -100 200])
subplot_tight(7,2,14,[0.01 0.1])
plot(t,struct_data(26).data_zeroed_scaled(:,2:5))
set(gca, 'YTick', []);
axis([0 0.4 -100 200])

annotation('textbox',[0.15 0.85 0.2 0.08],'String','No mask, no pic','FontSize',14)
cd('/Users/Julien/Google Drive/Hudspeth/Data/Photos')
subplot_tight(7,2,3,[0.02 0.02])
A = imread('capture_20150930_181014.jpg');
image(A);
axis image
set(gca, 'XTick', [], 'YTick', []);
subplot_tight(7,2,5,[0.02 0.02])
A = imread('capture_20150930_181334.jpg');
image(A);
axis image
set(gca, 'XTick', [], 'YTick', []);
subplot_tight(7,2,7,[0.02 0.02])
A = imread('capture_20150930_181352.jpg');
image(A);
axis image
set(gca, 'XTick', [], 'YTick', []);
subplot_tight(7,2,9,[0.02 0.02])
A = imread('capture_20150930_181628.jpg');
image(A);
axis image
set(gca, 'XTick', [], 'YTick', []);
subplot_tight(7,2,11,[0.02 0.02])
A = imread('capture_20150930_181647.jpg');
image(A);
axis image
set(gca, 'XTick', [], 'YTick', []);
subplot_tight(7,2,13,[0.02 0.02])
A = imread('capture_20150930_182053.jpg');
image(A);
axis image
set(gca, 'XTick', [], 'YTick', []);

cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-09-30.01/Ear 1/Cell 1')
saveas(gcf,strcat('Compiled_9_30_15_HB5_mfig'));
saveas(gcf,strcat('Compiled_9_30_15_HB5_e'),'epsc');

%% HB6 - Moving mask around HB
clf
annotation('textbox',[0.15 0.96 0.25 0.04],'String','9/30/15 HB6','FontSize',14)

subplot_tight(6,2,2,[0.01 0.1])
plot(t,struct_data(27).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', []);
axis([0 0.4 -450 150])
subplot_tight(6,2,4,[0.01 0.1])
plot(t,struct_data(28).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', [],'YTick', []);
axis([0 0.4 -450 150])
subplot_tight(6,2,6,[0.01 0.1])
plot(t,struct_data(29).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', [],'YTick', []);
axis([0 0.4 -450 150])
subplot_tight(6,2,8,[0.01 0.1])
plot(t,struct_data(30).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', [],'YTick', []);
axis([0 0.4 -450 150])
subplot_tight(6,2,10,[0.01 0.1])
plot(t,struct_data(31).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', [],'YTick', []);
axis([0 0.4 -450 150])
subplot_tight(6,2,12,[0.01 0.1])
plot(t,struct_data(32).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', [],'YTick', []);
axis([0 0.4 -450 150])


annotation('textbox',[0.15 0.85 0.2 0.1],'String','No mask','FontSize',12)
annotation('textbox',[0.15 0.52 0.2 0.1],'String','Same as above, closer to HB','FontSize',12)
annotation('textbox',[0.15 0.2 0.2 0.1],'String','No mask','FontSize',12)
annotation('textbox',[0.15 0.04 0.2 0.1],'String','No mask','FontSize',12)
cd('/Users/Julien/Google Drive/Hudspeth/Data/Photos')
subplot_tight(6,2,3,[0.02 0.02])
A = imread('capture_20150930_183016.jpg');
image(A);
axis image
set(gca, 'XTick', [], 'YTick', []);
subplot_tight(6,2,7,[0.02 0.02])
A = imread('capture_20150930_183433.jpg');
image(A);
axis image
set(gca, 'XTick', [], 'YTick', []);


cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-09-30.01/Ear 1/Cell 1')
saveas(gcf,strcat('Compiled_9_30_15_HB6_mfig'));
saveas(gcf,strcat('Compiled_9_30_15_HB6_e'),'epsc');

%% HB7 - Moving faux mask around HB
clf
annotation('textbox',[0.15 0.96 0.25 0.04],'String','9/30/15 HB7','FontSize',14)

subplot_tight(4,2,2,[0.01 0.1])
plot(t,struct_data(33).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', []);
axis([0 0.4 -60 40])
subplot_tight(4,2,4,[0.01 0.1])
plot(t,struct_data(34).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', [],'YTick', []);
axis([0 0.4 -60 40])
subplot_tight(4,2,6,[0.01 0.1])
plot(t,struct_data(35).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', [],'YTick', []);
axis([0 0.4 -60 40])
subplot_tight(4,2,8,[0.01 0.1])
plot(t,struct_data(36).data_zeroed_scaled(:,2:5))
set(gca, 'XTick', [],'YTick', []);
axis([0 0.4 -60 40])

annotation('textbox',[0.15 0.81 0.2 0.1],'String','No mask','FontSize',12)
cd('/Users/Julien/Google Drive/Hudspeth/Data/Photos')
subplot_tight(4,2,3,[0.02 0.02])
A = imread('capture_20150930_185318.jpg');
image(A);
axis image
set(gca, 'XTick', [], 'YTick', []);
subplot_tight(4,2,5,[0.02 0.02])
A = imread('capture_20150930_185608.jpg');
image(A);
axis image
set(gca, 'XTick', [], 'YTick', []);
subplot_tight(4,2,7,[0.02 0.02])
A = imread('capture_20150930_185628.jpg');
image(A);
axis image
set(gca, 'XTick', [], 'YTick', []);

cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-09-30.01/Ear 1/Cell 1')
saveas(gcf,strcat('Compiled_9_30_15_HB7_mfig'));
saveas(gcf,strcat('Compiled_9_30_15_HB7_e'),'epsc');

%% HB5 Recs 20 & 21 subtraction
clf
subplot_tight(3,1,1,[0.05 0.1]); plot(t,struct_data(21).data_zeroed_scaled(:,2:5))
    set(gca, 'XTick', []);
    axis([0 0.4 -100 200])
    text(0.05,150,'Rec 21, Mask')
    title('9/30/15 HB5 - Mask next to HB')
subplot_tight(3,1,2,[0.05 0.1]); plot(t,struct_data(20).data_zeroed_scaled(:,2:5))
    set(gca, 'XTick', []);
    axis([0 0.4 -100 200])
    text(0.05,150,'Rec 20, No mask')
    
for p = 2:5
    difference(:,p) = struct_data(21).data_zeroed_scaled(:,p) - struct_data(20).data_zeroed_scaled(:,p);
end
subplot_tight(3,1,3,[0.05 0.1]); plot(t,difference(:,2:5))
    text(0.05,150,'Difference')
    
    saveas(gcf,strcat('9_30_15_HB5_MaskSubtraction_Recs20_21_mfig'));
    saveas(gcf,strcat('9_30_15_HB5_MaskSubtraction_Recs20_21_e'),'epsc');
    
%% HB5 Recs 20 & 22 subtraction
clf
subplot_tight(3,1,1,[0.05 0.1]); plot(t,struct_data(22).data_zeroed_scaled(:,2:5))
    set(gca, 'XTick', []);
    axis([0 0.4 -100 200])
    text(0.05,150,'Rec 22, Mask')
    title('9/30/15 HB5 - Mask next to HB')
subplot_tight(3,1,2,[0.05 0.1]); plot(t,struct_data(20).data_zeroed_scaled(:,2:5))
    set(gca, 'XTick', []);
    axis([0 0.4 -100 200])
    text(0.05,150,'Rec 20, No mask')
    
for p = 2:5
    difference(:,p) = struct_data(22).data_zeroed_scaled(:,p) - struct_data(20).data_zeroed_scaled(:,p);
end
subplot_tight(3,1,3,[0.05 0.1]); plot(t,difference(:,2:5))
    text(0.05,150,'Difference')
    
    saveas(gcf,strcat('9_30_15_HB5_MaskSubtraction_Recs20_22_mfig'));
    saveas(gcf,strcat('9_30_15_HB5_MaskSubtraction_Recs20_22_e'),'epsc');
