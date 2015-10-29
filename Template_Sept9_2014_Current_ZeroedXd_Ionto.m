% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-09-09.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list
% Now to plot: plot(struct_data(4).data)

% % Make a nested structure with 
% for i = 1:length(fileList)
%     FileName = fileList(i).name;    % Pull out the name of the file
% %     struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
%     helpvar = importdata(FileName);
%     struct_data(i).data = helpvar.data;
%     struct_data(i).textdata = helpvar.textdata;
% end


% To call one experiment, use the following as the name of the data file:
% struct_data.dataN.data, where N is the run number
% for example: plot(struct_data.data1.data(:,2))





%%  Plot all variables on one figure per run 
logfile_name = getfield(dir('*.log'),'name');
logfile_name_clean = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile = importdata(logfile_name);

for r = 1:length(fileList2)       % Select the record numbers to plot
    clf
    wavetrain = logfile.data(r,8); % get number of wavetrains for that run
    laser_delay = logfile.data(r,43)*.001;      % in milliseconds
    laser_duration = logfile.data(r,44)*.001;   % in milliseconds
    laser_voltage = logfile.data(r,63);
    Fs = 20000;         %sampling rate
    T = 1/Fs;
    L = length(struct_data(r).data(:,2));    
    t = (0:L-1)*T;
    
    % SUBPLOT 1:  Current
    subplot_tight(3,1,1,[0.05 0.1])
    set(0, 'DefaultAxesColorOrder', winter(wavetrain))
    %set(gca, 'ColorOrder', 'default');
    for i = (3*wavetrain+2):(4*wavetrain+1)
        plot(t,struct_data(r).data(:,i))
        hold all
    end
    %plot(t,struct_data(r).data(:,(wavetrain+2):(2*wavetrain+1)));
    set(gca,'XTick',[])
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    ylabel('Current (nA)')
    
    %SUBPLOT 2: Mech Steps
    subplot_tight(3,1,2, [0.01 0.1])
            
    set(0, 'DefaultAxesColorOrder', autumn(wavetrain));

    for i= (wavetrain+2) : (2*wavetrain+1)
        dc = mean(struct_data(r).data(1:100,i));
        plot(t,struct_data(r).data(:,i)-dc)
        hold all
    end
    
    set(gca,'XTick',[])
        if laser_voltage ~= 0
        line([laser_delay; (laser_delay + laser_duration)],[-30; -30],'color','r','linewidth',1.8)
        line([laser_delay; laser_delay],[-30;30],'color','k')
        textXpos = laser_delay + 0.3*laser_duration;
        text(textXpos,-20,num2str(laser_voltage),'color','r','fontsize',12)
        end
        ylabel('Zeroed Displacement (nm)')
    
    %SUBPLOT 3: Displacement, Laser Pulse, PD calibration pulse
    subplot_tight(3,1,3, [ 0.04 0.1])
    plot(t,struct_data(r).data(:,(2):(1*wavetrain+1)),'k');
    ylabel('Iontophoresis (nA)')
    xlabel('Time (sec)')
    
    % Plot Laser Duration:
    % If laser power is on, add a bar showing its duration, and text
    % showing its power:
        
        
    saveas(gcf,strcat('ZeroOffsetRecord',num2str(r),'.pdf'));
    saveas(gcf,strcat('ZeroOffsetRecord_m',num2str(r),'fig'));

end






