% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-11-17.01/Ear 1/Cell 1')
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

%%  Plot ionto, displacement, & displacements as a function of ionto

for r = 1:length(fileList2)                    % Select the record numbers to plot
    clf
    logfile_name        = getfield(dir('*.log'),'name');
    logfile_name_clean  = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
    logfile             = importdata(logfile_name);
    wavetrain           = logfile.data(r,8);              % get number of wavetrains [actually waveforms] for that run
    laser_delay         = logfile.data(r,43)*.001;      % in milliseconds
    laser_duration      = logfile.data(r,44)*.001;   % in milliseconds
    laser_voltage       = logfile.data(r,63);
    probe_pzt_delay     = logfile.data(r,22)*0.001; % in seconds
    probe_pzt_duration  = logfile.data(r,23)*0.001;  % in seconds
    beta                = logfile.data(4,106);
    Fs                  = logfile.data(r,12);                                 % sampling rate
    T                   = 1/Fs;
    L                   = length(struct_data(r).data(:,2));    
    t                   = (0:L-1)*T;
    
    % Plot fluid jet voltage
h1 = subplot(6,1,1);
    set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
    plot(t,struct_data(r).data(:,(1*wavetrain+2):(2*wavetrain+1))/(beta*(1e9)));    
    ylabel('Piezo Voltage (V)')
    xlabel('Time (sec)')
    
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    
    % Plot Displacement         
    set(0, 'DefaultAxesColorOrder', ametrine(wavetrain));
    offset = 0;
h2 = subplot(6,1,2:4);
    for i= 2 : (1*wavetrain+1)
        dc = mean(struct_data(r).data(1:100,i));
        plot(t,struct_data(r).data(:,i)-dc+offset)
        hold all
        %offset = offset+120;
    end
    
    linkaxes([h1 h2],'x');
      
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
        textstring = strcat(num2str(laser_voltage), ' Volts');
        text(textXpos,ypos, textstring,'color','r','fontsize',12);
    end
    
    ylabel('Displacement (nm)')
 
    % Calculate delta displacements around laser
    baseline = zeros((2*wavetrain+1)-(wavetrain+2),1);  % Initialize baseline vector.
    peak = zeros((2*wavetrain+1)-(wavetrain+2),1);      % Initialize peak vector.
    steady = zeros((2*wavetrain+1)-(wavetrain+2),1);    % Initialize steady-state vector.
    
    for i= (wavetrain+2) : (2*wavetrain+1)
        baseline(i-wavetrain-1,1) = mean(struct_data(r).data(laser_delay*20000-300:laser_delay*20000-100,i));   % mean position before laser pulse                  % mean right before pulse (85-95 ms);
        peak(i-wavetrain-1,1) = mean(struct_data(r).data(laser_delay*20000+40:laser_delay*20000+240,i));        % mean position during laser, early
        steady(i-wavetrain-1,1) = mean(struct_data(r).data(laser_delay*20000+560:laser_delay*20000+760,i));     % mean position during laser, late
    end
        displacements = abs(baseline-peak);
        
    % Calculate Xd for each wavetrain in middle of fluid jet
    for i= 2 : (wavetrain+1)
        dc = mean(struct_data(r).data(1:100,i));
        Xd_mid(i-1,1) = mean(struct_data(r).data(round((probe_pzt_delay + 0.4*probe_pzt_duration)*Fs) : round((probe_pzt_delay + 0.6*probe_pzt_duration)*Fs),i) )-dc;
    end 
    
    % Calculate V command to fluid piezo
    for i= 2+wavetrain : (2*wavetrain+1)
        Xc_mid(i-wavetrain-1,1) = mean(struct_data(r).data(round((probe_pzt_delay + 0.4*probe_pzt_duration)*Fs) : round((probe_pzt_delay + 0.6*probe_pzt_duration)*Fs),i) )/(beta*1e9);
    end
        
    % Calculate delta PD displacements
    pd_delay = (Fs/1000)*logfile.data(r,15);            % delay prior to PD PZT calibration pulse (in samples)
    pd_duration = (Fs/1000)*logfile.data(r,16);         % duration of PD PZT calibration pulse; logfile gives values in ms
    pd_command_amplitude = logfile.data(r,55);          % amplitude of PD PZT calibration pulse
    
    pd_start = pd_delay + 20*(Fs/1000);                 % Since the mvt of PD piezo is delayed, add 20 msec delay to starting sample
    pd_end = pd_start + 0.5*pd_duration;
    pd_length = pd_end - pd_start;
    
    pre_pd_start = pd_start - pd_length;
    pre_pd_end = pre_pd_start + pd_length;
    
    pd_mean_pre = zeros(wavetrain,1);                   % Initialize vector
    pd_mean_during = zeros(wavetrain,1);                % Initialize vector
    correction_factor = zeros(wavetrain,1);             % Initialize vector
    
    for i = (wavetrain+2) : (2*wavetrain+1)
        pd_mean_pre(i-wavetrain-1,1) = mean(struct_data(r).data(pre_pd_start:pre_pd_end,i));
        pd_mean_during(i-wavetrain-1,1) = mean(struct_data(r).data(pd_start:pd_end,i));
        correction_factor(i-wavetrain-1,1) = abs(pd_mean_pre(i-wavetrain-1) - pd_mean_during(i-wavetrain-1))/pd_command_amplitude;
    end
    
        
    % Plot delta displacement as a function of ionto current
    ionto_half_time = length(struct_data(r).data(:,2:(1*wavetrain+1)))/2;   % CHANGE THIS, it relies on the ionto pulse being in middle of the recording
    ionto = struct_data(r).data(ionto_half_time,2:(1*wavetrain+1));         % Get ionto current, for ionto vs displ. plot
    
h3 = subplot(3,2,5);
plot(Xc_mid,Xd_mid,'.k','markersize',20)
xlabel('Piezo Voltage (V)')
ylabel('Displacement (nm)')
title('Displacement vs. Piezo voltage')
%     for i = 1:wavetrain
%     plot(ionto(i), displacements(i),'k.', 'markersize',20)
%     hold all
%     xlabel('Current (nA)')
%     ylabel('Displacement (nm)')
%     end
%     title('Displacement vs. Iontophoresis current')
    
% h4 = subplot(3,2,6);
%     for i = 1:wavetrain
%     plot(ionto(i), correction_factor(i)*displacements(i),'.', 'markersize',20)
%     hold all
%     xlabel('Current (nA)')
%     ylabel('Corrected Displ. (nm)')
%     end
%     title('Corrected Displ. vs. Iontophoresis current')        
        
    saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
    saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
    saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');
end

