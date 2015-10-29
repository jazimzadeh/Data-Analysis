% This imports all data files from a single day into one data structure
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-04-17.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a nested structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

% To call one experiment, use the following as the name of the data file:
% struct_data.dataN.data, where N is the run number
% for example: plot(struct_data.data1.data(:,2))

%%
n=6; % Write the # of the recording to plot here. $
wavetrains = 5;
waveforms = 5;
start = wavetrains*waveforms + 2;
%runs = 9;

%for n = 3:runs
    %data = eval(['struct_data.data' num2str(n) '.data(:,' num2str(start) ':end)']); % removes the first channel, which has no data
    data = eval(['struct_data.data' num2str(n) '.data(:,' num2str(start) ':end)']);
    
    % B should contain (waveform * 3) columns, with each column being the average
    % of the wavetrains in it.
    for nn = 1:(waveforms*3)   
        i = nn-1;
        data_mean(:,i+1) = mean(data(:,i*5+1:(i+1)*5),2); 
    end

    Fs = 10000;         %sampling rate
    T = 1/Fs;
    L = length(data_mean(:,4));
    t = (0:L-1)*T;
    
   
    for i = 1:(waveforms*2)
        eval(['subplot_tight(3,5,' num2str(i) ',[0.025 0.025])'])
        plot(t,eval(['-data_mean(:,' num2str(i) ')']))
    end

    for i = waveforms*2+1 : waveforms*3
        eval(['subplot_tight(3,5,' num2str(i) ',[0.025 0.025])'])
        plot(t,eval(['data_mean(:,' num2str(i) ')']))
    end

    % Setting the axes
    % Bundle Displacement
    for i = 1:waveforms
       eval(['subplot_tight(3,5,' num2str(i) ',[0.025 0.025])'])
       axis([0 0.3 -50 200])
    end
    % Probe stimulus
    for i = waveforms+1:waveforms*2
       eval(['subplot_tight(3,5,' num2str(i) ',[0.025 0.025])'])
       axis([0 0.3 -20 220])
    end
    % Iontophoresis current
    for i = waveforms*2+1:waveforms*3
        eval(['subplot_tight(3,5,' num2str(i) ',[0.025 0.025])'])
       axis([0 0.3 -5 20])
    end
    saveas(gcf,strcat('figure',num2str(n),'.pdf'));
    %clf
%end






