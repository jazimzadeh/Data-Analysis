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

%%  Plot records 
logfile_name = getfield(dir('*.log'),'name');
logfile_name_clean = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile = importdata(logfile_name);

for r = 8:13      % Select the record numbers to plot
    clf
    wavetrain = logfile.data(r,8);              % get number of wavetrains for that run
    laser_delay = logfile.data(r,43)*.001;      % in milliseconds
    laser_duration = logfile.data(r,44)*.001;   % in milliseconds
    laser_voltage = logfile.data(r,63);
    
    Fs = 20000;        
    T = 1/Fs;
    L = length(struct_data(r).data(:,2));    
    t = (0:L-1)*T;
    
    % Plot Displacement 
    sum=0;        
    offset = 0;
    for i= (wavetrain+2) : (2*wavetrain+1)
        sum = sum + struct_data(r).data(:,i); 
    end
        
        average = sum/wavetrain;
        dc = mean(average(1:100));
        traces(:,r) = average - dc;

        
    %saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
    %saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
end

%%
clf
plot(t,traces(:,8),'k')
hold on
plot(t,traces(:,9)+70,'k')
plot(t,traces(:,10)+140,'k')
plot(t,traces(:,11)+210,'k')
plot(t,traces(:,12)+280,'k')
title('9/12/14 Recs 8, 9, 10, 11, 12 - 5 uM Pentachloropseudilin on 9-12')
ylim = get(gca, 'YLim');
ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
y = [ylim(1) ylim(2)-0.3 ylim(2)-0.3 ylim(1)+0.2 ylim(1)+0.2]; 
patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')

