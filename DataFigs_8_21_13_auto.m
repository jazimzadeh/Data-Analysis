%% 
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2013-08-21.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a nested structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

%%
logfile_name = getfield(dir('*.log'),'name');
logfile = importdata(logfile_name);

for r = 1:25
Fs = 10000;         %sampling rate
T = 1/Fs;
L = eval(['length(struct_data.data' num2str(r) '.data(:,2))']);
t = (0:L-1)*T;

clf
eval(['plot(t,struct_data.data' num2str(r) '.data(:,2),''r'')'])
hold on
eval(['plot(t,struct_data.data' num2str(r) '.data(:,4),''k'')'])

title_string1 = strcat(num2str(logfile_name), ' Record  ', num2str(r));
%title_string2 = logfile.textdata(r,3);
title({ title_string1})
    
 saveas(gcf,strcat('Record',num2str(r),'.pdf'));
 saveas(gcf,strcat('epsRecord',num2str(r),'.eps'));
end
