clear;clf;clc;
cd('/Users/Julien/Desktop')
[video] = mmread('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/3_6_15/Event2.avi');

%% Look at a subtraction of two frames
clf
imagesc(video.frames(1,1).cdata(:,:,3) - video.frames(1,30).cdata(:,:,3));

%% Create a matrix "images" that just contains the 512 images
images = zeros(420,480,length(video.frames));
for i = 1:length(video.frames)      % Pull out the images, so I can then use mean(x,3)
    images(:,:,i) = video.frames(1,i).cdata(:,:,3);
end

%% Plot mean baseline minus mean peak frames

baseline = (mean(images(:,:,20:24),3) + mean(images(:,:,70:74),3) + mean(images(:,:,120:124),3)  + mean(images(:,:,170:174),3) + mean(images(:,:,220:224),3) + mean(images(:,:,270:274),3) + mean(images(:,:,320:324),3) + mean(images(:,:,370:374),3) + mean(images(:,:,420:424),3) + mean(images(:,:,470:474),3))/10;
peak =     (mean(images(:,:,30:34),3) + mean(images(:,:,80:84),3) + mean(images(:,:,130:134),3)  + mean(images(:,:,180:184),3) + mean(images(:,:,230:234),3) + mean(images(:,:,280:284),3) + mean(images(:,:,330:334),3) + mean(images(:,:,380:384),3) + mean(images(:,:,430:434),3) + mean(images(:,:,480:484),3))/10;
subtraction = baseline - peak;
subtraction_cropped = subtraction(50:end,:);    % cropped because upper left squares took all the dynamic range
imagesc(subtraction_cropped);
colorbar
title('3/6/15 - 250 Hz Video of laser-evoked mvt','fontsize',16)
set(gca,'Xtick',[],'YTick',[])






%%
clf
for i = 1:100
    subplot_tight(10,10,i,[0.0005 0.0005])
    imagesc(video.frames(1,2).cdata(:,:,3)-video.frames(1,i).cdata(:,:,3))
    set(gca,'XTickLabel',[],'YTickLabel',[]);
end