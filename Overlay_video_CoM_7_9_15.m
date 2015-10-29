clf
cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/7_9_15/')

r = 15;
eval(['video = aviread(''Event' num2str(r) '.avi'');']);

%% 
clf
writerObj = VideoWriter('Event15_avgd.avi');
open(writerObj);
for i = 1:10:200
    i
    close
    v = uint32(zeros());
    for j = i : 200 : (19*200)+i
        v = v + uint32(video(1,j).cdata);
    end
    image(v/50);
    colormap gray
    hold on
    plot(record(15).CoM_pixels(i)+6, record(15).CoM_vert_pixels(i)+3.5,'or','markersize',50);
    fig = gcf;
    set(fig,'Units','pixels');
    set(fig,'Position',[0 0 240*7 92*7]);
    frame = getframe;
    writeVideo(writerObj,frame);
    
end
close(writerObj);
