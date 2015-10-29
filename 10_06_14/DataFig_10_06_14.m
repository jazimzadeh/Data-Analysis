% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-10-06.01/Ear 1/Cell 1')
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

%%  Plot displacements in response to laser
logfile_name = getfield(dir('*.log'),'name');
logfile_name_clean = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile = importdata(logfile_name);

for r = 1:length(fileList2)      % Select the record numbers to plot
    clf
    Fs = logfile.data(r,12);
    run_period = logfile.data(r,3);             % in ms already
    wavetrain = logfile.data(r,9); 
    waveform = logfile.data(r,8);               % get number  waveforms for that run
    laser_delay = logfile.data(r,43);      
    laser_duration = logfile.data(r,44);   
    laser_voltage = logfile.data(r,63);
    
    % Average the 4 wavetrains
    average = zeros(run_period/1000 * Fs, waveform);
    for i = 2: waveform + 1
    average(:, i-1) = mean(struct_data(r).data(:,i:waveform:21),2);
    end
    
    T = 1/Fs;
    L = waveform * length(struct_data(r).data(:,2));    
    t = linspace(0,run_period*waveform,L)';
    
    % Concatenate the waveforms into one long recording, to match the order
    % of the video traces
    collated = [average(:,1);average(:,2);average(:,3);average(:,4);average(:,5)];
    
    plot(t,collated)
    
    %Draw laser pulse patches
    ylim = get(gca, 'YLim');
    x  = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    x2 = [(laser_delay + run_period) (laser_delay + run_period) (laser_delay + laser_duration + run_period) (laser_delay + laser_duration + run_period) (laser_delay + run_period)];
    x3 = [(laser_delay + 2*run_period) (laser_delay + 2*run_period) (laser_delay + laser_duration + 2*run_period) (laser_delay + laser_duration + 2*run_period) (laser_delay + 2*run_period)];
    x4 = [(laser_delay + 3*run_period) (laser_delay + 3*run_period) (laser_delay + laser_duration + 3*run_period) (laser_delay + laser_duration + 3*run_period) (laser_delay + 3*run_period)];
    x5 = [(laser_delay + 4*run_period) (laser_delay + 4*run_period) (laser_delay + laser_duration + 4*run_period) (laser_delay + laser_duration + 4*run_period) (laser_delay + 4*run_period)];
    y  = [ylim(1) ylim(2)-0.3 ylim(2)-0.3 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x , y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    patch(x2, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    patch(x3, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    patch(x4, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    patch(x5, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    xlabel('Time (ms)')
    ylabel('Displacement (nm)')
    
    title_string1 = strcat(num2str(logfile_name), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} })
        
    saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_e',num2str(r),'.eps'));
    saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
end

