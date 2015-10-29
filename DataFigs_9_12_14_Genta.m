% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-09-12.01/Ear 1/Cell 1')
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





%% Get averages
for r = 8:13      % Select the record numbers to plot
    clf
    logfile_name = getfield(dir('*.log'),'name');
    logfile_name_clean = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
    logfile = importdata(logfile_name);

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
    sum=0;
    for i= (wavetrain+2) : (2*wavetrain+1)
        sum = sum + struct_data(r).data(:,i);      
    end
    average = sum/wavetrain;
    dc = mean(average(1:100));
    
    traces(:,r) = average + dc;
        
    %plot(t,-average+dc)
      
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
        ylabel('Displacement (nm)')
        
        title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    ylabel('Current (nA)')
    xlabel('Time (Sec)')
        
        
    saveas(gcf,strcat('DataFig_avg',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_avgm',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_avge',num2str(r),'eps'),'epsc');
end

%%
clf
plot(t,traces(:,1),'k')
hold on
plot(t,traces(:,2)+100,'k')
plot(t,traces(:,3)+200,'k')
plot(t,traces(:,5)+300,'k')
plot(t,traces(:,6)+400,'k')
title('9/12/14 Recs 1,2,3,5,6 from bottom. 2 and 3 have 60 uM gentamicin')
ylim = get(gca, 'YLim');
ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
y = [ylim(1) ylim(2)-0.3 ylim(2)-0.3 ylim(1)+0.2 ylim(1)+0.2]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')

%% Subtraction
plot(t,traces(:,1),'k')
hold on
plot(t,traces(:,2)+100,'k')
plot(t,traces(:,1) - traces(:,2) + 200,'r')

ylim = get(gca, 'YLim');
ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
y = [ylim(1) ylim(2)-0.3 ylim(2)-0.3 ylim(1)+0.2 ylim(1)+0.2]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')

%% Subtraction2
plot(t,traces(:,3),'k')
hold on
plot(t,traces(:,5)+100,'k')
plot(t,traces(:,5) - traces(:,3) + 200,'r')

ylim = get(gca, 'YLim');
ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
y = [ylim(1) ylim(2)-0.3 ylim(2)-0.3 ylim(1)+0.2 ylim(1)+0.2]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')







