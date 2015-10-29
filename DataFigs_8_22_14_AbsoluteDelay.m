% Each cell in this file plots one record. The purpose was to zoom in to
% hte traces and make figure 8_22_14_AbsoluteDelay


% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-08-22.01/Ear 1/Cell 1')
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

%%  Plot displacement records
logfile_name = getfield(dir('*.log'),'name');
logfile_name_clean = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile = importdata(logfile_name);

r = 3;    % Select the record numbers to plot
    clf
    wavetrain = logfile.data(r,8); % get number of wavetrains for that run
    laser_delay = logfile.data(r,43)*.001;      % in milliseconds
    laser_duration = logfile.data(r,44)*.001;   % in milliseconds
    laser_voltage = logfile.data(r,63);
    
    Fs = 20000;         %sampling rate
    T = 1/Fs;
    L = length(struct_data(r).data(:,2));    
    t = (0:L-1)*T;
    
    % Plot Displacement 
            
    set(0, 'DefaultAxesColorOrder', autumn(wavetrain));
    offset = 0;
    for i= (wavetrain+2) : (2*wavetrain+1)
        dc = mean(struct_data(r).data(1:100,i));
        plot(t,struct_data(r).data(:,i)-dc)
        hold all
        offset = offset+100;
    end
      
        if laser_voltage ~= 0
        ylim = get(gca, 'YLim');
        ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
        x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
        y = [ylim(1) ylim(2)-0.3 ylim(2)-0.3 ylim(1)+0.2 ylim(1)+0.2]; 
        patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
        %set(gca,'XTick',[])
        %line([laser_delay; (laser_delay + laser_duration)],[-30; -30],'color','r','linewidth',1.8)
        %line([laser_delay; laser_delay],[-30;30],'color','k')
        textXpos = laser_delay + 0.3*laser_duration;
        textstring = strcat(num2str(laser_voltage), ' Volts')
        text(textXpos,ypos, textstring,'color','r','fontsize',12)
        end
        ylabel('Zeroed Displacement (nm)')
        
        title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    ylabel('Displacement (nm)')
    xlabel('Time (Sec)')
        
     %%
     hold on
     r = 6;    % Select the record numbers to plot
    
    wavetrain = logfile.data(r,8); % get number of wavetrains for that run
    laser_delay = logfile.data(r,43)*.001;      % in milliseconds
    laser_duration = logfile.data(r,44)*.001;   % in milliseconds
    laser_voltage = logfile.data(r,63);
    
    Fs = 20000;         %sampling rate
    T = 1/Fs;
    L = length(struct_data(r).data(:,2));    
    t = (0:L-1)*T;
    
    % Plot Displacement 
            
    set(0, 'DefaultAxesColorOrder', autumn(wavetrain));
    offset = 0;
    for i= (wavetrain+2) : (2*wavetrain+1)
        dc = mean(struct_data(r).data(1:100,i));
        plot(t,struct_data(r).data(:,i)-dc-200)
        hold all
        offset = offset+100;
    end
      
        if laser_voltage ~= 0
        ylim = get(gca, 'YLim');
        ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
        x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
        y = [ylim(1) ylim(2)-0.3 ylim(2)-0.3 ylim(1)+0.2 ylim(1)+0.2]; 
        patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
        %set(gca,'XTick',[])
        %line([laser_delay; (laser_delay + laser_duration)],[-30; -30],'color','r','linewidth',1.8)
        %line([laser_delay; laser_delay],[-30;30],'color','k')
        textXpos = laser_delay + 0.3*laser_duration;
        textstring = strcat(num2str(laser_voltage), ' Volts')
        text(textXpos,ypos, textstring,'color','r','fontsize',12)
        end
        ylabel('Zeroed Displacement (nm)')
        
        title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    ylabel('Displacement (nm)')
    xlabel('Time (Sec)')
    
    %%
    r = 11;    % Select the record numbers to plot
    
    wavetrain = logfile.data(r,8); % get number of wavetrains for that run
    laser_delay = logfile.data(r,43)*.001;      % in milliseconds
    laser_duration = logfile.data(r,44)*.001;   % in milliseconds
    laser_voltage = logfile.data(r,63);
    
    Fs = 20000;         %sampling rate
    T = 1/Fs;
    L = length(struct_data(r).data(:,2));    
    t = (0:L-1)*T;
    
    % Plot Displacement 
            
    set(0, 'DefaultAxesColorOrder', autumn(wavetrain));
    offset = 0;
    for i= (wavetrain+2) : (2*wavetrain+1)
        dc = mean(struct_data(r).data(1:100,i));
        plot(t,struct_data(r).data(:,i)-dc-600)
        hold all
        offset = offset+100;
    end
      
        if laser_voltage ~= 0
        ylim = get(gca, 'YLim');
        ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
        x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
        y = [ylim(1) ylim(2)-0.3 ylim(2)-0.3 ylim(1)+0.2 ylim(1)+0.2]; 
        patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
        %set(gca,'XTick',[])
        %line([laser_delay; (laser_delay + laser_duration)],[-30; -30],'color','r','linewidth',1.8)
        %line([laser_delay; laser_delay],[-30;30],'color','k')
        textXpos = laser_delay + 0.3*laser_duration;
        textstring = strcat(num2str(laser_voltage), ' Volts')
        text(textXpos,ypos, textstring,'color','r','fontsize',12)
        end
        ylabel('Zeroed Displacement (nm)')
        
        title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    ylabel('Displacement (nm)')
    xlabel('Time (Sec)')
    
    
    % Do these in a separate figure:
    
    %%
    r = 18;    % Select the record numbers to plot
    
    wavetrain = logfile.data(r,8); % get number of wavetrains for that run
    laser_delay = logfile.data(r,43)*.001;      % in milliseconds
    laser_duration = logfile.data(r,44)*.001;   % in milliseconds
    laser_voltage = logfile.data(r,63);
    
    Fs = 20000;         %sampling rate
    T = 1/Fs;
    L = length(struct_data(r).data(:,2));    
    t = (0:L-1)*T;
    
    % Plot Displacement 
            
    set(0, 'DefaultAxesColorOrder', autumn(wavetrain));
    offset = 0;
    for i= (wavetrain+2) : (2*wavetrain+1)
        dc = mean(struct_data(r).data(1:100,i));
        plot(t,struct_data(r).data(:,i)-dc)
        hold all
        offset = offset+100;
    end
      
        if laser_voltage ~= 0
        ylim = get(gca, 'YLim');
        ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
        x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
        y = [ylim(1) ylim(2)-0.3 ylim(2)-0.3 ylim(1)+0.2 ylim(1)+0.2]; 
        patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
        %set(gca,'XTick',[])
        %line([laser_delay; (laser_delay + laser_duration)],[-30; -30],'color','r','linewidth',1.8)
        %line([laser_delay; laser_delay],[-30;30],'color','k')
        textXpos = laser_delay + 0.3*laser_duration;
        textstring = strcat(num2str(laser_voltage), ' Volts')
        text(textXpos,ypos, textstring,'color','r','fontsize',12)
        end
        ylabel('Zeroed Displacement (nm)')
        
        title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    ylabel('Displacement (nm)')
    xlabel('Time (Sec)')
    
    %%
    hold on
    r = 25;    % Select the record numbers to plot
    
    wavetrain = logfile.data(r,8); % get number of wavetrains for that run
    laser_delay = logfile.data(r,43)*.001;      % in milliseconds
    laser_duration = logfile.data(r,44)*.001;   % in milliseconds
    laser_voltage = logfile.data(r,63);
    
    Fs = 20000;         %sampling rate
    T = 1/Fs;
    L = length(struct_data(r).data(:,2));    
    t = (0:L-1)*T;
    
    % Plot Displacement 
            
    set(0, 'DefaultAxesColorOrder', autumn(wavetrain));
    offset = 0;
    for i= (wavetrain+2) : (2*wavetrain+1)
        dc = mean(struct_data(r).data(1:100,i));
        plot(t,struct_data(r).data(:,i)-dc-200)
        hold all
        offset = offset+100;
    end
      
        if laser_voltage ~= 0
        ylim = get(gca, 'YLim');
        ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
        x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
        y = [ylim(1) ylim(2)-0.3 ylim(2)-0.3 ylim(1)+0.2 ylim(1)+0.2]; 
        patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
        %set(gca,'XTick',[])
        %line([laser_delay; (laser_delay + laser_duration)],[-30; -30],'color','r','linewidth',1.8)
        %line([laser_delay; laser_delay],[-30;30],'color','k')
        textXpos = laser_delay + 0.3*laser_duration;
        textstring = strcat(num2str(laser_voltage), ' Volts')
        text(textXpos,ypos, textstring,'color','r','fontsize',12)
        end
        ylabel('Zeroed Displacement (nm)')
        
        title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    ylabel('Displacement (nm)')
    xlabel('Time (Sec)')
    
    