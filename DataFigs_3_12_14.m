% This imports all data files from a single day into one data structure
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-03-12.01/Ear 1/Cell 1')
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
for r = 1:12
    logfile_name = getfield(dir('*.log'),'name');
    logfile = importdata(logfile_name);
    clf
    Fs = 10000;         %sampling rate
    T = 1/Fs;
    L = eval(['length(struct_data.data' num2str(r) '.data(:,20))']);
    t = (0:L-1)*T;

    eval(['plot(t,struct_data.data' num2str(r) '.data(:,2:6)+2000,''k'')'])
    hold on
    eval(['plot(t,struct_data.data' num2str(r) '.data(:,12:16)+1500,''m'')'])
    hold on
    
    offset = 0;
    for n=17:21
        eval(['plot(t,struct_data.data' num2str(r) '.data(:,' num2str(n) ')+' num2str(offset) ')'])
        hold all
        offset = offset + 150;
    end
    
    title_string1 = strcat(num2str(logfile_name), ' Record  ', num2str(r));
    title_string2 = logfile.textdata(r,3);
    title_string3 = 'Black is vstep, purple is mech step';
    title({ title_string1, title_string2{1}, title_string3 })

    saveas(gcf,strcat('Record',num2str(r),'.pdf'));
    saveas(gcf,strcat('Record_eps',num2str(r),'.eps'));
end


