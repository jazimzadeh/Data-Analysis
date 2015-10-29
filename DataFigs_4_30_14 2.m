% This imports all data files from a single day into one data structure
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-04-30.01/Ear 1/Cell 1')
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
N_records = size(fileList,1);
logfile_name = getfield(dir('*.log'),'name');
logfile = importdata(logfile_name);

for r = 1:N_records
    clf
wavetrains = logfile.data(r,8);

set(gcf,'DefaultAxesColorOrder',[1 0.8 0 ; 1 0.7 0 ; 1 0.5 0 ; 1 0.3 0 ; 1 0.1 0])
offset = 0;
    for n = wavetrains*3+2 : wavetrains*4+1
        Fs = 10000;         %sampling rate
        T = 1/Fs;
        L = eval(['length(struct_data.data' num2str(r) '.data(:,2))']);
        t = (0:L-1)*T;
        eval(['plot(t,struct_data.data' num2str(r) '.data(:,' num2str(n) ')+' num2str(offset) ')'])
        offset = offset + 300;
        hold all
    end
                                                
eval(['plot(t,struct_data.data' num2str(r) '.data(:,16)+1700,''k'')']);

title_string1 = strcat(num2str(logfile_name), ' Record  ', num2str(r));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} })

saveas(gcf,strcat('Record',num2str(r),'.pdf'));


end



