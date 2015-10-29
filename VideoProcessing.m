% Find movie file, import into a movie structure
clear;clc;clf;
cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/9_30_14/')
mov = aviread('Event1.avi');

%% View a frame
imagesc(mov(1,62).cdata)

%% Subsample the image to only one bundle
for i = 1:500
    eval(['a.frame' num2str(i) ' = mov(1,i).cdata([70:92],[25:50]);']);
end


%% Get mean brightness of each row
row_brightness = zeros(size(a.frame1,1),1);
for k = 1:size(a.frame1,1)
    row_brightness(k) = mean(a.frame1(k,:))
end
% Find the row with the highest average brightness
[y,row_index] = max(row_brightness)

%% Get mean brightness of each column
col_brightness = zeros(size(a.frame1,1),1);
for l = 1:size(a.frame1,2)
    col_brightness(l) = mean(a.frame1(:,l))
end
% Find the column with the highest average brightness
[x,col_index] = max(col_brightness)
    
