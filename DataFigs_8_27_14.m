% This imports all data files from a single day into one data structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-08-27.01/Ear 1/Cell 1')
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





%%  Plot oscillations
logfile_name = getfield(dir('*.log'),'name');
logfile_name_clean = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile = importdata(logfile_name, '\t');

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

    
    %SUBPLOT 1: Oscillating bundles
    set(0, 'DefaultAxesColorOrder', autumn(wavetrain));
    l=0;
    for i= (wavetrain+2) : (2*wavetrain+1)
        dc = mean(struct_data(r).data(1:100,i));
        plot(t,struct_data(r).data(:,i)-dc+l)
        l=l+100;
        hold all
    end
    
        
        % Plot line denoting laser duration
        if laser_voltage ~= 0
            ylim = get(gca, 'YLim');
            ypos = ylim(1) + 0.85*ylim(2)-ylim(1);
            x = [laser_delay laser_delay (laser_delay + laser_duration) (laser_delay + laser_duration) laser_delay]; 
            y = [ylim(1) ylim(2)-0.3 ylim(2)-0.3 ylim(1)+0.2 ylim(1)+0.2]; 
            patch(x, y, -1 * ones(size(x)), [0.92 0.92 0.92], 'LineStyle', 'none')
            textXpos = laser_delay + 0.3*laser_duration;
            text(textXpos,-15,num2str(laser_voltage),'color','r','fontsize',20)
        end
        ylabel('Displacement (nm)')
        xlabel('Time (sec)')
    
        
        
    saveas(gcf,strcat('ZeroOffsetRecord',num2str(r),'.pdf'));
    saveas(gcf,strcat('ZeroOffsetRecord_m',num2str(r),'fig'));
    saveas(gcf,strcat('ZeroOffsetRecord_e',num2str(r),'eps'),'epsc');
end

%% Displacement vs Power curves
    
r=27;
logfile_name = getfield(dir('*.log'),'name');
logfile_name_clean = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile = importdata(logfile_name, '\t');
logfile.data(22,:) = []; % delete row 22 (with spillover info) %THIS LINE ADDED TO DEAL WITH THE WAVETRAINS

clf
wavetrain = logfile.data(r,8); % get number of wavetrains for that run
laser_delay = logfile.data(r,43)*.001;      % in milliseconds
laser_duration = logfile.data(r,44)*.001;   % in milliseconds
laser_voltage = logfile.data(r,63);
Fs = 20000;         %sampling rate
T = 1/Fs;
L = length(struct_data(r).data(:,2));    
t = (0:L-1)*T;

subplot_tight(2,1,1, [0.07 0.1])        
    set(0, 'DefaultAxesColorOrder', autumn(wavetrain));
    baseline = zeros((2*wavetrain+1)-(wavetrain+2),1);  % Initialize baseline vector.
    peak = zeros((2*wavetrain+1)-(wavetrain+2),1);      % Initialize peak vector.
    steady = zeros((2*wavetrain+1)-(wavetrain+2),1);    % Initialize steady-state vector.
    
    step_size = laser_voltage/wavetrain;
    vector = [1:wavetrain];
    power_vector = (vector * step_size)';   % in Volts
    powers = Power(power_vector);           % converted to mW with my function "Power"
    
    for i= (wavetrain+2) : (2*wavetrain+1)
        baseline(i-wavetrain-1,1) = mean(struct_data(r).data(laser_delay*20000-300:laser_delay*20000-100,i));                     % mean right before pulse (85-95 ms);
        peak(i-wavetrain-1,1) = mean(struct_data(r).data(laser_delay*20000+40:laser_delay*20000+240,i));
        steady(i-wavetrain-1,1) = mean(struct_data(r).data(laser_delay*20000+560:laser_delay*20000+760,i));
        dc = mean(struct_data(r).data(1:100,i));
        plot(t,struct_data(r).data(:,i)-dc)
        hold all
    end
    
    if laser_voltage ~= 0
        line([laser_delay; (laser_delay + laser_duration)],[20; 20],'color','m','linewidth',1.8)        % laser duration
        line([laser_delay+(40/20000) ; laser_delay+(240/20000)],[17;17],'color','k','linewidth',1.8)    % peak area
        line([laser_delay+(560/20000) ; laser_delay+(760/20000)],[17;17],'color','r','linewidth',1.8)   % steady-state area
        line([laser_delay-(300/20000) ; laser_delay-(100/20000)],[17;17],'color','b','linewidth',1.8) 
        textXpos = laser_delay + 0.3*laser_duration;
        text(textXpos,25,num2str(laser_voltage),'color','m','fontsize',12)
    end
    ylabel('Zeroed Displacement (nm)')
    xlabel('Time (sec');
    title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title({ title_string1, title_string2{1} },'fontsize',13)
    
%subplot_tight(2,2,3, [0.07 0.1])
%     plot(powers, abs(baseline-peak),'k.')
%     xlabel('Power (mW)')
%     ylabel('Displacement (nm)')
%     title('Peak Displacement')
    
subplot_tight(2,1,2, [0.07 0.1])
plot(powers, abs(baseline-peak),'k.')
xlabel('Power (mW)')
ylabel('Displacement (nm)')
hold on
    
%subplot_tight(2,2,4, [0.07 0.1])
    plot(powers, abs(baseline-steady),'r+')
    xlabel('Power (mW)')
    legend('Peak','Steady-State','Location','NorthWest')    
    
saveas(gcf,strcat('ZeroOffset_DispVsP_',num2str(r),'.pdf'));
saveas(gcf,strcat('ZeroOffset_DispVsP_m_',num2str(r),'fig'));




        

