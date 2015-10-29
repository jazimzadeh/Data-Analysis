cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2014-11-07.01/Ear 1/Cell 1')
fileList = dir('*.txt'); 
for r = 1:length(fileList)
    FileName = getfield(fileList(r), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', r ) ) = importdata(FileName);
end

%%
for r = 1:10
   
    
Fs = 20000;         %sampling rate
T = 1/Fs;
L = eval(['length(struct_data.data' num2str(r) '.data(:,2))']);
t = (0:L-1)*T;

subplot(3,1,1)
eval(['plot(t,struct_data.data' num2str(r) '.data(:,2))'])
title_string1 = strcat(num2str(logfile_name_clean), ' Record  ', num2str(r+1));
title_string2 = logfile.textdata(r,3);
title({ title_string1, title_string2{1} },'fontsize',13)
ylabel('Iontophoresis (nA)')

subplot(3,1,2)
eval(['plot(t,struct_data.data' num2str(r) '.data(:,3))'])
ylabel('Displacement')

subplot(3,1,3)
eval(['plot(t,struct_data.data' num2str(r) '.data(:,4))'])
ylabel('Probe Command (nm)')
xlabel('Time (Sec)')

saveas(gcf,strcat('DataFig',num2str(r),'.pdf'));
saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_e',num2str(r),'epsc'));
end