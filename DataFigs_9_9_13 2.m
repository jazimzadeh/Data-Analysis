cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2013-09-09.01/Ear 1/Cell 1')
fileList = dir('*.txt'); 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

%%
for i = 1:26
    
Fs = 10000;         %sampling rate
T = 1/Fs;
L = eval(['length(struct_data.data' num2str(i) '.data(:,2))']);
t = (0:L-1)*T;

subplot(2,1,1)
eval(['plot(t,struct_data.data' num2str(i) '.data(:,2))'])
subplot(2,1,2)
eval(['plot(t,struct_data.data' num2str(i) '.data(:,3))'])


saveas(gcf,strcat('DataFig',num2str(i),'.pdf'));
saveas(gcf,strcat('DataFig_m',num2str(i),'fig'));
end