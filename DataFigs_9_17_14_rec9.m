% Plot record 9 from 9/17/14

% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-09-17.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

logfile_name_clean = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile = importdata(logfile_name);

r=9;
clf
    wavetrain = logfile.data(r,8); % get number of wavetrains for that run
    laser_delay = logfile.data(r,43)*.001;      % in milliseconds
    laser_duration = logfile.data(r,44)*.001;   % in milliseconds
    laser_voltage = logfile.data(r,63);
    Fs = 20000;         %sampling rate
    T = 1/Fs;
    L = length(struct_data(r).data(:,2));    
    t = (0:L-1)*T;
    
    set(0, 'DefaultAxesColorOrder', winter(wavetrain))
    %set(gca, 'ColorOrder', 'default');
    offset = 0;
    sum = 0;
    for i = (3*wavetrain+2):(4*wavetrain+1)
        sum = sum + struct_data(r).data(:,i);
        hold all
        %offset = offset + 150;
    end
    average = sum/5;
    plot(t,average)
    
    %plot(t,struct_data(r).data(:,(wavetrain+2):(2*wavetrain+1)));
    %set(gca,'XTick',[])
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    ylabel('Current (nA)')
    xlabel('Time (Sec)')
    
    % Draw laser duration line and its label
    if laser_voltage ~= 0
        ylim = get(gca, 'YLim');
        ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
        x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
        y = [ylim(1) ylim(2)-0.3 ylim(2)-0.3 ylim(1)+0.2 ylim(1)+0.2]; 
        patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
        textXpos = laser_delay + 0.3*laser_duration;
        text(textXpos,350,num2str(laser_voltage),'color','r','fontsize',12)
    end
    
        
        
    saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');