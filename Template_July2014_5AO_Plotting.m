% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-07-30.01/Ear 1/Cell 1')
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
    
    % SUBPLOT 1: Vsteps + current
    subplot_tight(5,1,1:2,[0.05 0.1])
    [haxes,hline1,hline2] = eval(['plotyy(t,struct_data(' num2str(r) ').data(:,(3*wavetrain+2):(4*wavetrain+1)),t,struct_data(' num2str(r) ').data(:,(4*wavetrain+2):(5*wavetrain+1)),''plot'',''plot'',''b'',''r'')']);    
    set(hline1,'color','b')
    set(hline2,'color','r')
    set(haxes(1),'ycolor','b')
    set(haxes(2),'ycolor','r')
    axis(haxes(2),[0 0.2 -400 100])
    axis(haxes(1),[0 0.2 -1000 5000])
    axes(haxes(1)); ylabel('Current (pA)')
    axes(haxes(2)); ylabel('V-Step (mV)')
    set(haxes(1),'Box','off')           % Turn 'box' off so i don't get double ticks (blue and red)
    set(haxes(2),'Box','off')
    set(haxes(2),'YMinorTick','on');    % Add in ticks
    set(haxes(1),'YMinorTick','on');
    set(haxes,'XTick',[])
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    
    %SUBPLOT 2: Mech Steps
    subplot_tight(5,1,3, [0.01 0.1])
    plot(t,struct_data(r).data(:,(2*wavetrain+2):(3*wavetrain+1)),'m');
    set(gca, 'YColor', 'm')
    set(gca,'XTick',[])
    ylabel('Mech Stim (nm)')
    
    %SUBPLOT 3: Displacement, Laser Pulse, PD calibration pulse
    subplot_tight(5,1,4:5, [ 0.03 0.1])
    plot(t,struct_data(r).data(:,(wavetrain+2):(2*wavetrain+1)),'k')
    ylabel('Displacement (nm)')
    xlabel('Time (sec)')
    
    % Plot Laser Duration:
    % If laser power is on, add a bar showing its duration, and text
    % showing its power:
        if laser_voltage ~= 0
        line([laser_delay; (laser_delay + laser_duration)],[0; 0],'color','r','linewidth',1.8)
        text(laser_delay,10,'5 V','color','r','fontsize',12)
        end
        
    saveas(gcf,strcat('Record',num2str(r),'.pdf'));
    saveas(gcf,strcat('Record_eps',num2str(r),'.eps'));
end






