% 8/29/13 - Trying to break tip links by iontophoresing 80 mM BAPTA on them
% Light-piping spontaneous oscillations

% --- Import Data --- %
cd('/Users/Julien/Google Drive/Hudspeth/Data/Orange Room/2013-08-29.01/Ear 1/Cell 1')
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name

% Make a nested structure with 
for i = 1:length(fileList)
    FileName = getfield(fileList(i), 'name');    % Pull out the name of the file
    struct_data.( sprintf( 'data%d', i ) ) = importdata(FileName);
end

Fig_cell1_8_29_13
figure
Fig_cell2_8_29_13
figure
Fig_cell3_8_29_13
figure
Fig_cell4_8_29_13
figure
Fig_cell5_8_29_13