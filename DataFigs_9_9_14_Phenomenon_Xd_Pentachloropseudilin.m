% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-09-12.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%%%%  Plot oscillation records (Recs 1-5)
logfile_name = getfield(dir('*.log'),'name');
logfile_name_clean = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile = importdata(logfile_name);

%%
clf
    r=8;
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
        plot(t,(struct_data(r).data(:,i)-dc))
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
        %textXpos = laser_delay + 0.3*laser_duration;
        %textstring = strcat(num2str(laser_voltage), ' Volts')
        %text(textXpos,ypos, textstring,'color','r','fontsize',12)
    end
    
    %record 9
    r=9;
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
    offset = 80;
    for i= (wavetrain+2) : (2*wavetrain+1)
        dc = mean(struct_data(r).data(1:100,i));
        plot(t,(struct_data(r).data(:,i)-dc)+offset)
        hold all
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
        %textXpos = laser_delay + 0.3*laser_duration;
        %textstring = strcat(num2str(laser_voltage), ' Volts')
        %text(textXpos,ypos, textstring,'color','r','fontsize',12)
    end
    
    % record 10
    r=10;
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
    offset = 160;
    for i= (wavetrain+2) : (2*wavetrain+1)
        dc = mean(struct_data(r).data(1:100,i));
        plot(t,(struct_data(r).data(:,i)-dc)+offset)
        hold all
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
        %textXpos = laser_delay + 0.3*laser_duration;
        %textstring = strcat(num2str(laser_voltage), ' Volts')
        %text(textXpos,ypos, textstring,'color','r','fontsize',12)
    end
        
    %record 11
    r=11;
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
    offset = 240;
    for i= (wavetrain+2) : (2*wavetrain+1)
        dc = mean(struct_data(r).data(1:100,i));
        plot(t,(struct_data(r).data(:,i)-dc)+offset)
        hold all
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
        %textXpos = laser_delay + 0.3*laser_duration;
        %textstring = strcat(num2str(laser_voltage), ' Volts')
        %text(textXpos,ypos, textstring,'color','r','fontsize',12)
    end
    
    %record 12
    r=12;
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
    offset = 320;
    for i= (wavetrain+2) : (2*wavetrain+1)
        dc = mean(struct_data(r).data(1:100,i));
        plot(t,(struct_data(r).data(:,i)-dc)+offset)
        hold all
    end
      
    if laser_voltage ~= 0
        ylim = get(gca, 'YLim');
        ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
        x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
        y = [ylim(1) ylim(2)-1 ylim(2)-1 ylim(1)+0.2 ylim(1)+0.2]; 
        patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
        %set(gca,'XTick',[])
        %line([laser_delay; (laser_delay + laser_duration)],[-30; -30],'color','r','linewidth',1.8)
        %line([laser_delay; laser_delay],[-30;30],'color','k')
        %textXpos = laser_delay + 0.3*laser_duration;
        %textstring = strcat(num2str(laser_voltage), ' Volts')
        %text(textXpos,ypos, textstring,'color','r','fontsize',12)
    end
    
    
    text(0.04,60,'8 sec')
    text(0.04,140,'3.5 min')
    text(0.04,220, '1:10 min')
    text(0.04,300,'26 sec')
    text(-0.02,25,'Frog Normal Saline')
    text(-0.02,100,'Frog Normal Saline')
    text(-0.02,180,'Pentachloropseudilin')
    text(-0.02,260,'Pentachloropseudilin')
    text(-0.02,340,'Pentachloropseudilin')
    
    ylabel('Displacement (nm)')
    xlabel('Time (Sec)')
    title('9/12/14 Series with PENTACHLOROPSEUDILIN treatment - starts at bottom')
        
     %%   
    saveas(gcf,strcat('PentachloropseudilinFig',num2str(r),'.pdf'));
    saveas(gcf,strcat('PentachloropseudilinFig_m',num2str(r),'fig'));


