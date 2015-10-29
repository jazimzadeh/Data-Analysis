% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-02-17.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%% Plot Displacement, Current, Vm holding, Laser command
for r = 1:length(fileList2);
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
    
    set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));

    h1 = subplot(6,1,1:2);
    plot(t,struct_data(r).data(:,2*wavetrain+2:3*wavetrain+1));
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',12)
    ylabel('Current (pA)');
        ylim = get(gca, 'YLim');
        x = [laser_delay laser_delay laser_delay+laser_duration laser_delay+laser_duration laser_delay]; 
        y = [ylim(1)+0.01 ylim(2)-0.01 ylim(2)-0.01 ylim(1)+0.01 ylim(1)+0.01]; 
        patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')     % Make patch 
        
         % Create the blow-up region in a box:
%         P = get(h1,'Position');  % get position information for subplot
%         F = P(3)/(t(end)-t(1));  % divide width of subplot by its duration to get a scaling factor that converts between the two
%         box_left = P(1) + laser_delay*F;
%         box_bottom = P(2) + 0.5*(P(4));         % add a fraction of the height to the bottom parameter of the subplot to generate the bottom coordinate for the box
%         box_width = 1.2*laser_duration*F;       % box width should be a little wider than the laser_duration
%         box_height = 0.4*P(4);
%         axes('Position',[box_left box_bottom box_width box_height],'Box','on')
%         plot(t(laser_delay*Fs:(laser_delay + 1.2*laser_duration)*Fs),struct_data(r).data(laser_delay*Fs:(laser_delay + 1.2*laser_duration)*Fs,2*wavetrain+2:3*wavetrain+1));
%         maximum = max(max(struct_data(r).data(laser_delay*Fs:(laser_delay + 1.2*laser_duration)*Fs,2*wavetrain+2:3*wavetrain+1))); % find maximum value within the blown-up region
%         minimum = min(min(struct_data(r).data(laser_delay*Fs:(laser_delay + 1.2*laser_duration)*Fs,2*wavetrain+2:3*wavetrain+1))); % find maximum value within the blown-up region
%         axis([laser_delay laser_delay+1.2*laser_duration 1.1*minimum 1.1*maximum])
%         set(gca,'xtick',[])
%         set(gca,'xticklabel',[])
    
    subplot(6,1,3:4)
    plot(t,struct_data(r).data(:,3*wavetrain+2:4*wavetrain+1));
    ylabel('Holding Command (mV)');

    subplot(6,1,5)
    plot(t,struct_data(r).data(:,4*wavetrain+2:5*wavetrain+1));
    ylabel('Laser (V)');

    subplot(6,1,6)
    plot(t,struct_data(r).data(:,5*wavetrain+2:6*wavetrain+1));
    ylabel('Laser Pick-Off');
    xlabel('Time (seconds)');
    
    saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

%% Get data for an i-v curve
%hold on
r=5;    % Records 5 or 6
t_pre_start = 0.08;
t_pre_stop = 0.09;
t_dur_start = 0.091;
t_dur_stop = 0.11;
i_v_data = zeros(10,2);    % Initialize
for wt = 2*wavetrain+2:3*wavetrain+1
    i_pre = mean(struct_data(r).data(t_pre_start*Fs:t_pre_stop*Fs,wt));
    i_dur = mean(struct_data(r).data(t_dur_start*Fs:t_dur_stop*Fs,wt));
    i_v_data(wt-21,1) = i_dur - i_pre;
end

for wt = 3*wavetrain+2:4*wavetrain+1
    v_dur = mean(struct_data(r).data(t_dur_start*Fs:t_dur_stop*Fs,wt));
    i_v_data(wt-31,2) = v_dur ;
end

%clf
plot(i_v_data(:,2),i_v_data(:,1),'b.','markersize',18)
axis([-100 100 -40 200])
hold on
plot([0 0],ylim,'k')
plot(xlim, [0 0],'k')
xlabel('Voltage (mv)')
ylabel('Current (pA)')


