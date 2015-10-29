% Open movie files,ask user to select bundle of interest in each, get
% displacement waveform 
clear;clc;clf
cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/9_4_15/')
%% Calculate CoM, CoM_avg, xpos, ypos, delta
% NOTE: First run the script Find_subframe_dimensions on data I wish to
% analyze. This will prompt the user to create regions of interest around
% the bundle, and to select the center point to be used in the analysis.
% The appropriate coordinates are saved by that script and loaded below, so
% that the coordinates only need to be gathered once.

tic
% Load subframe position and click coordinates gotten from previous script
% called Find_subframe_dimensions
load('Record_coordinates.mat');

% used
for r = 3:4
    clear subframe
    % *** Import movie ***
    eval(['mov = aviread(''Event' num2str(r) '.avi'');']);
    
    % *** Crop every frame using the dimensions gotten from the loaded record structure ***
    for i = 1:size(mov,2)       
        eval(['subframe(:,:,' num2str(i) ') = imcrop(mov(1,i).cdata,record(r).rect_rounded);']);
    end
    
    for i = 1:size(mov,2)       
        subframe(:,:,i) = imcrop(mov(1,i).cdata,record(r).rect_rounded);
    end
    
    for j = 1:size(mov,2)
       subframe(:,:,j) = 257 - subframe(:,:,j);
    end
    
    
    % *** Use the coordinates of the click to get a CoM for 9 horizontal
    % lines for each frame (3 above, 3 below, and the line that was
    % clicked) ***
    record(r).CoM = zeros(1,size(mov,2));
    for i = 1:size(mov,2)           % The i steps through the frames
        CoM = zeros(9,1);
        CoM(1) = linear_CoM(subframe(record(r).y_click-3, record(r).x_click-6:record(r).x_click+6,i), 1*mean(subframe(record(r).y_click-3, record(r).x_click-6:record(r).x_click+6,i)));
        CoM(2) = linear_CoM(subframe(record(r).y_click-2, record(r).x_click-6:record(r).x_click+6,i), 1*mean(subframe(record(r).y_click-2, record(r).x_click-6:record(r).x_click+6,i)));
        CoM(3) = linear_CoM(subframe(record(r).y_click-1, record(r).x_click-6:record(r).x_click+6,i), 1*mean(subframe(record(r).y_click-1, record(r).x_click-6:record(r).x_click+6,i)));
        CoM(4) = linear_CoM(subframe(record(r).y_click  , record(r).x_click-6:record(r).x_click+6,i), 1*mean(subframe(record(r).y_click  , record(r).x_click-6:record(r).x_click+6,i)));
        CoM(5) = linear_CoM(subframe(record(r).y_click+1, record(r).x_click-6:record(r).x_click+6,i), 1*mean(subframe(record(r).y_click+1, record(r).x_click-6:record(r).x_click+6,i)));
        CoM(6) = linear_CoM(subframe(record(r).y_click+2, record(r).x_click-6:record(r).x_click+6,i), 1*mean(subframe(record(r).y_click+2, record(r).x_click-6:record(r).x_click+6,i)));
        CoM(7) = linear_CoM(subframe(record(r).y_click+3, record(r).x_click-6:record(r).x_click+6,i), 1*mean(subframe(record(r).y_click+3, record(r).x_click-6:record(r).x_click+6,i)));
        CoM(8) = linear_CoM(subframe(record(r).y_click+4, record(r).x_click-6:record(r).x_click+6,i), 1*mean(subframe(record(r).y_click+4, record(r).x_click-6:record(r).x_click+6,i)));
        CoM(9) = linear_CoM(subframe(record(r).y_click-4, record(r).x_click-6:record(r).x_click+6,i), 1*mean(subframe(record(r).y_click-4, record(r).x_click-6:record(r).x_click+6,i)));

        CoM_vert(1) = linear_CoM(subframe(record(r).x_click-3, record(r).y_click-6:record(r).y_click+6,i), 1*mean(subframe(record(r).y_click-3, record(r).x_click-6:record(r).x_click+6,i)));
        CoM_vert(2) = linear_CoM(subframe(record(r).x_click-2, record(r).y_click-6:record(r).y_click+6,i), 1*mean(subframe(record(r).y_click-2, record(r).x_click-6:record(r).x_click+6,i)));
        CoM_vert(3) = linear_CoM(subframe(record(r).x_click-1, record(r).y_click-6:record(r).y_click+6,i), 1*mean(subframe(record(r).y_click-1, record(r).x_click-6:record(r).x_click+6,i)));
        CoM_vert(4) = linear_CoM(subframe(record(r).x_click, record(r).y_click-6:record(r).y_click+6,i), 1*mean(subframe(record(r).y_click, record(r).x_click-6:record(r).x_click+6,i)));
        CoM_vert(5) = linear_CoM(subframe(record(r).x_click+1, record(r).y_click-6:record(r).y_click+6,i), 1*mean(subframe(record(r).y_click+1, record(r).x_click-6:record(r).x_click+6,i)));
        CoM_vert(6) = linear_CoM(subframe(record(r).x_click+2, record(r).y_click-6:record(r).y_click+6,i), 1*mean(subframe(record(r).y_click+2, record(r).x_click-6:record(r).x_click+6,i)));
        CoM_vert(7) = linear_CoM(subframe(record(r).x_click+3, record(r).y_click-6:record(r).y_click+6,i), 1*mean(subframe(record(r).y_click+3, record(r).x_click-6:record(r).x_click+6,i)));
        
        record(r).standev(i)                = std(CoM);         % Store stdev before removing CoM's outside 2*SD
        % Don't include CoM values that are outside of 2 std dev from the mean
        CoM(CoM > mean(CoM) + 2*std(CoM))   = NaN;
        CoM(CoM < mean(CoM) - 2*std(CoM))   = NaN;
        record(r).CoM(i)                    = nanmean(CoM);     % Average the centers of mass that are within 2 stdev
        record(r).standev_post(i) = std(CoM);                   % Std Dev after removing any CoM's outside 2*SD
        record(r).num_lines(i)              = nansum(sign(CoM));% Count & store the number of CoM's that are used in calculating the mean
        
        record(r).standev_vert(i) = std(CoM_vert);        % Store stdev before removing CoM's outside 2*SD
        % Don't include CoM values that are outside of 2 std dev from the mean
        CoM_vert(CoM_vert > mean(CoM_vert) + 2*std(CoM_vert)) = NaN;
        CoM_vert(CoM_vert < mean(CoM_vert) - 2*std(CoM_vert)) = NaN;
        record(r).CoM_vert(i) = nanmean(CoM_vert);        % Average the centers of mass that are within 2 stdev
        record(r).standev_vert_post(i) = std(CoM_vert);   % Std Dev after removing any CoM's outside 2*SD
        
    end
    
    % *** Median filtering
    %record(r).CoM = medfilt1(record(r).CoM, 5);
    %record(r).CoM_vert = medfilt1(record(r).CoM_vert, 5);
    
    % *** Average the 20 repeats of the stimulus to get a cleaner trace ***
    x1 = record(r).CoM(1:200);
    x2 = record(r).CoM(201:400);
    x3 = record(r).CoM(401:600);
    x4 = record(r).CoM(601:800);
    x5 = record(r).CoM(801:1000);
    x6 = record(r).CoM(1001:1200);
    x7 = record(r).CoM(1201:1400);
    x8 = record(r).CoM(1401:1600);
    x9 = record(r).CoM(1601:1800);
    x10 = record(r).CoM(1801:2000);
    x11 = record(r).CoM(2001:2200);
    x12 = record(r).CoM(2201:2400);
    x13 = record(r).CoM(2401:2600);
    x14 = record(r).CoM(2601:2800);
    x15 = record(r).CoM(2801:3000);
    x16 = record(r).CoM(3001:3200);
    x17 = record(r).CoM(3201:3400);
    x18 = record(r).CoM(3401:3600);
    x19 = record(r).CoM(3601:3800);
    x20 = record(r).CoM(3801:4000);
    x_average           = (x1+x2+x3+x4+x5+x6+x7+x8+x9+x10+x11+x12+x13+x14+x15+x16+x17+x18+x19+x20) / 20; 
    baseline            = mean(x_average(5:50));
    x_displ             = x_average - baseline;     % subtract baseline
    record(r).CoM_avg   = x_displ * (50/138);       % Save the average displacement, in um (50 um/ 138 pi)
    record(r).CoM_pixels= x_average + rect(1);
    
    % *** Average the 20 repeats of the stimulus to get a cleaner trace (vertical displ) ***
    y1 = record(r).CoM_vert(1:200);
    y2 = record(r).CoM_vert(201:400);
    y3 = record(r).CoM_vert(401:600);
    y4 = record(r).CoM_vert(601:800);
    y5 = record(r).CoM_vert(801:1000);
    y6 = record(r).CoM_vert(1001:1200);
    y7 = record(r).CoM_vert(1201:1400);
    y8 = record(r).CoM_vert(1401:1600);
    y9 = record(r).CoM_vert(1601:1800);
    y10 = record(r).CoM_vert(1801:2000);
    y11 = record(r).CoM_vert(2001:2200);
    y12 = record(r).CoM_vert(2201:2400);
    y13 = record(r).CoM_vert(2401:2600);
    y14 = record(r).CoM_vert(2601:2800);
    y15 = record(r).CoM_vert(2801:3000);
    y16 = record(r).CoM_vert(3001:3200);
    y17 = record(r).CoM_vert(3201:3400);
    y18 = record(r).CoM_vert(3401:3600);
    y19 = record(r).CoM_vert(3601:3800);
    y20 = record(r).CoM_vert(3801:4000);
    y_average           = (y1+y2+y3+y4+y5+y6+y7+y8+y9+y10+y11+y12+y13+y14+y15+y16+y17+y18+y19+y20) / 20; 
    baseline            = mean(y_average(5:50));
    y_displ             = y_average - baseline;   % subtract baseline
    record(r).CoM_vert_avg   = y_displ * (50/138);   % Save the average displacement, in um (50 um/ 138 pi)
    record(r).CoM_vert_pixels= y_average + rect(2);

    % *** Obtain and store the position of the bundle ***
    record(r).xpos      = record(r).rect(1) + x_average(1,1);     % Store the HB's x position, in pixels
    record(r).ypos      = record(r).rect(2) + y_average(1,1);
    % Create a distance field with the current HB's distance from laser in um
    ref_pos             = record(1).x_click+record(1).rect(1); % This is the center of the laser
    record(r).distance  = (abs(ref_pos - record(r).xpos)) * (50/138) ; 
    
    pre  = mean(record(r).CoM_avg(5:60));
    step = mean(record(r).CoM_avg(100:140));
    post = mean(record(r).CoM_avg(160:200));
    delta= abs(step - mean([pre post])) ; % Calculate delta size, convert to nm
    record(r).delta = delta;
end
toc

%% Plot events 3 and 4
clf
for r = 3:4
    plot(record(3).time/1000,abs(record(r).CoM_avg))
    hold on
end

%% Import LabVIEW data
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-09-04.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list
%% Plot the 100nm and 200 nm movements
clf
for r = [2 8]
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

    dc_offset = mean(struct_data(r).data(1:100,2));
    h1=plot(t,struct_data(r).data(:,2)-dc_offset,'k');
    hold on
end

% Add high-speed video traces
for r = 3:4
    h2=plot(record(3).time/1000,1000*abs(record(r).CoM_avg),'r');
    hold on
end
legend([h1 h2],'High-Speed Camera, 2 kHz','Photodiode, 20 kHz')
xlabel('Time (sec)');
ylabel('Displacement (nm)');
title('9/4/15 Probe Control')

saveas(gcf,strcat('ProbeControl_PD_and_Video','fig'));
saveas(gcf,strcat('ProbeControl_PD_and_Video'),'epsc');
