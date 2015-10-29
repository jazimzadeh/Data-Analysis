clear;clf;clc
cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/8_04_15/')
%%
r = 5;
   
eval(['mov = aviread(''Event' num2str(r) '.avi'');']);
counter = 1;
for frame = [4:7]
    subplot_tight(2,2,counter,[0.005 0.005])
    imagesc(mov(frame).cdata(40:420,:));
    counter = counter+1;
    set(gca,'Xticklabel',[])
    set(gca,'Yticklabel',[])
    set(gca,'Xtick',[])
    set(gca,'Ytick',[])
end

%%
clf
r = 5;
eval(['mov = aviread(''Event' num2str(r) '.avi'');']);

summed = mov(4).cdata;
for frame = [5:7]
   summed =  summed + mov(frame).cdata;
end
averaged = summed/4;
figure
imagesc(averaged(40:420,:))
set(gca,'Xticklabel',[])
set(gca,'Yticklabel',[])
set(gca,'Xtick',[])
set(gca,'Ytick',[])
    
    colorbar