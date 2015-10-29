% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2015-09-16.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names={fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt

struct_data = cellfun(@importdata,{fileList2.name});% Import the data from the file list

%% 
for r = 1:20;
    clf
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
    % Displacement
    plot(t,-struct_data(r).data(:,2:wavetrain+1));
    xlabel('Time (sec)')
    ylabel('Displacement (nm)')
   
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)

    saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

%% Plot of HB's A-E in sacculus 1
clf
set(0, 'DefaultAxesColorOrder', copper(wavetrain+1));
    subplot_tight(4,5,1,[0.05 0.05])
    dc_offset = mean(mean(struct_data(1).data(:,2:4)));
    plot(t,-(struct_data(1).data(:,2:4)-dc_offset))
    set(gca,'XTickLabel',[]); 
    axis([0 1 -40 60])
    title('HB A (Small)')
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(4,5,2,[0.05 0.05])
    dc_offset = mean(mean(struct_data(2).data(:,2:4)));
    plot(t,-(struct_data(2).data(:,2:4)-dc_offset))
    set(gca,'XTickLabel',[]); 
    axis([0 1 -40 75])
    title('HB B')
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(4,5,3,[0.05 0.05])
    dc_offset = mean(mean(struct_data(3).data(:,2:4)));
    plot(t,-(struct_data(3).data(:,2:4)-dc_offset))
    set(gca,'XTickLabel',[]); 
    axis([0 1 -40 152])
    title('HB C')
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(4,5,4,[0.05 0.05])
    dc_offset = mean(mean(struct_data(4).data(:,2:4)));
    plot(t,-(struct_data(4).data(:,2:4)-dc_offset))
    set(gca,'XTickLabel',[]); 
    axis([0 1 -40 60])
    title('HB D')
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(4,5,5,[0.05 0.05])
    dc_offset = mean(mean(struct_data(5).data(:,2:4)));
    plot(t,-(struct_data(5).data(:,2:4)-dc_offset))
    set(gca,'XTickLabel',[]); 
    axis([0 1 -45 85])
    title('HB E')
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(4,5,6,[0.05 0.05])
    dc_offset = mean(mean(struct_data(6).data(:,2:4)));
    plot(t,-(struct_data(6).data(:,2:4)-dc_offset))
    set(gca,'XTickLabel',[]); 
    axis([0 1 -40 60])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(4,5,7,[0.05 0.05])
    dc_offset = mean(mean(struct_data(7).data(:,2:4)));
    plot(t,-(struct_data(7).data(:,2:4)-dc_offset))
    set(gca,'XTickLabel',[]); 
    axis([0 1 -40 75])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(4,5,8,[0.05 0.05])
    dc_offset = mean(mean(struct_data(8).data(:,2:4)));
    plot(t,-(struct_data(8).data(:,2:4)-dc_offset))  
    set(gca,'XTickLabel',[]); 
    axis([0 1 -40 152])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(4,5,9,[0.05 0.05])
    dc_offset = mean(mean(struct_data(9).data(:,2:4)));
    plot(t,-(struct_data(9).data(:,2:4)-dc_offset))
    set(gca,'XTickLabel',[]); 
    axis([0 1 -40 60])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(4,5,10,[0.05 0.05])
    dc_offset = mean(mean(struct_data(10).data(:,2:4)));
    plot(t,-(struct_data(10).data(:,2:4)-dc_offset))
    set(gca,'XTickLabel',[]); 
    axis([0 1 -45 85])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(4,5,11,[0.05 0.05])
    dc_offset = mean(mean(struct_data(11).data(:,2:4)));
    plot(t,-(struct_data(11).data(:,2:4)-dc_offset))
    set(gca,'XTickLabel',[]); 
    axis([0 1 -40 60])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(4,5,12,[0.05 0.05])
    dc_offset = mean(mean(struct_data(12).data(:,2:4)));
    plot(t,-(struct_data(12).data(:,2:4)-dc_offset))
    set(gca,'XTickLabel',[]); 
    axis([0 1 -40 75])
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(4,5,13,[0.05 0.05])
    dc_offset = mean(mean(struct_data(13).data(:,2:4)));
    plot(t,-(struct_data(13).data(:,2:4)-dc_offset))
    axis([0 1 -40 152])
    set(gca,'XTickLabel',[]); 
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(4,5,14,[0.05 0.05])
    dc_offset = mean(mean(struct_data(14).data(:,2:4)));
    plot(t,-(struct_data(14).data(:,2:4)-dc_offset))
    axis([0 1 -40 60])
    set(gca,'XTickLabel',[]); 
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(4,5,15,[0.05 0.05])
    dc_offset = mean(mean(struct_data(15).data(:,2:4)));
    plot(t,-(struct_data(15).data(:,2:4)-dc_offset))
    axis([0 1 -45 85])
    set(gca,'XTickLabel',[]); 
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(4,5,16,[0.05 0.05])
    dc_offset = mean(mean(struct_data(16).data(:,2:4)));
    plot(t,-(struct_data(16).data(:,2:4)-dc_offset))
    axis([0 1 -40 60])
    xlabel('Time (sec)')
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(4,5,17,[0.05 0.05])
    dc_offset = mean(mean(struct_data(17).data(:,2:4)));
    plot(t,-(struct_data(17).data(:,2:4)-dc_offset))
    axis([0 1 -40 75])
    xlabel('Time (sec)')
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(4,5,18,[0.05 0.05])
    dc_offset = mean(mean(struct_data(18).data(:,2:4)));
    plot(t,-(struct_data(18).data(:,2:4)-dc_offset))
    axis([0 1 -40 152])
    xlabel('Time (sec)')
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(4,5,19,[0.05 0.05])
    dc_offset = mean(mean(struct_data(19).data(:,2:4)));
    plot(t,-(struct_data(19).data(:,2:4)-dc_offset))
    axis([0 1 -40 60])
    xlabel('Time (sec)')
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    subplot_tight(4,5,20,[0.05 0.05])
    dc_offset = mean(mean(struct_data(20).data(:,2:4)));
    plot(t,-(struct_data(20).data(:,2:4)-dc_offset))
    axis([0 1 -45 85])
    xlabel('Time (sec)')
    ylim = get(gca, 'YLim');
    ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
    x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
    y = [ylim(1) ylim(2)-0.9 ylim(2)-0.9 ylim(1)+0.2 ylim(1)+0.2]; 
    patch(x, y, -1 * ones(size(x)), [0.9 0.9 0.9], 'LineStyle', 'none')
    
    annotation('textbox',[0.001 0.8 0.02 0.02],'string','FNS')
    annotation('textbox',[0.001 0.6 0.02 0.04],'string','1% DMSO')
    annotation('textbox',[0.001 0.4 0.02 0.04],'string','10uM PClP')
    annotation('textbox',[0.001 0.2 0.02 0.04],'string','10uM PClP')
    
    saveas(gcf,strcat('PClP_AllHBs_9_16_15'));
    saveas(gcf,strcat('PClP_AllHBs_9_16_15'),'epsc');
    


