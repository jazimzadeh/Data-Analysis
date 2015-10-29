% This imports all data files from a single day into one data structure
cd('/Users/Julien/Documents/Research/Hudspeth/Data/Orange Room/2013-04-15.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a nested structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

Fs = 5000;         %sampling rate
T = 1/Fs;
L = length(struct_data.data3.data(:,2));
t = (0:L-1)*T;

figure
hold on
plot(t,struct_data.data3.data(:,2),'k')
plot(t,struct_data.data4.data(:,2)-130,'r')
plot(t,struct_data.data6.data(:,2)+80,'k')
plot(t,struct_data.data9.data(:,2)+200,'g')
plot(t,struct_data.data11.data(:,2)+210,'k')

text(-0.6, 40, 'Endolymph')
text(-1, 65, 'Endolymph w/glutathione')
text(-0.6, 110, 'Endolymph')
text(-1, 135, '1uM Ca Endo w/glutathione')
text(-0.6, 160, 'Endolymph')