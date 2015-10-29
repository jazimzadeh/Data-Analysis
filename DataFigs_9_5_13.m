% 9/5/13 - Trying to break tip links by iontophoresing 500 mM BAPTA on them
% Light-piping spontaneous oscillations

% --- Import Data --- %
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2013-09-05.01/Ear 1/Cell 1')
fileList = dir('*.txt'); 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

Fig_cell5_9_5_13
figure
Fig_cell4_9_5_13
figure
Fig_cell3_9_5_13
figure
Fig_cell2_9_5_13
figure
Fig_cell1_9_5_13