clear;clc;clf
cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/7_29_15/')


r=3;
eval(['mov = aviread(''Event' num2str(r) '.avi'');']);
frame = 15;
map = [linspace(0,0,250)', linspace(0,1,250)', linspace(0,0,250)'];
colormap(map)
%subplot(2,2,4)
imagesc(mov(frame).cdata)
set(gca,'YTickLabel',[])
set(gca,'XTickLabel',[])
title(sprintf('%d mW',voltage_to_power(0.7)))

%%
%clf
clear intensity
time_length = 50;      % Time until which to plot, in ms
t = [0:2:time_length];   % Time vector in ms
for frame = 1:(time_length/2)+1
    hold on
    %intensity(frame) =  mov(frame).cdata(76,154);
   intensity(frame) =  mov(frame).cdata(60,163);
end

h1 = plot(t,intensity,'color',[0 0.8 0],'MarkerSize',20);
set(h1,'LineWidth',3)
axis([0 time_length -10 260])
ylabel('Intensity (au)')
xlabel('Time (ms)')