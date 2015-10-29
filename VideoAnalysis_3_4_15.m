clear;clf;clc;
cd('/Users/Julien/Desktop')
[video] = mmread('/Users/Julien/Desktop/v_1628.mp4');
%%
clf
colormap hsv
imagesc(video.frames(1,1).cdata(:,:,3))

%%
colormap jet
for i = 201:300
    subplot_tight(10,10,i-200,[0.0005 0.0005])
    mean1 = (video.frames(1,i-1).cdata(:,:,3) + video.frames(1,i).cdata(:,:,3))/2;
    mean2 = (video.frames(1,i+1).cdata(:,:,3) + video.frames(1,i+2).cdata(:,:,3))/2;
    imagesc(mean1-mean2)
    set(gca,'XTickLabel',[],'YTickLabel',[]);
end

%%
clf
colormap hsv
for i = 201:300
    subplot_tight(10,10,i-200,[0.000 0.000])
    imagesc(video.frames(1,i-1).cdata(:,:,3))
    set(gca,'XTickLabel',[],'YTickLabel',[], 'XTick',[], 'YTick',[],'visible','off');
end
