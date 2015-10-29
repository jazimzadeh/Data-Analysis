clf
cd /Users/Julien/Google' Drive'/Hudspeth/Data/Photos/Hamamatsu_OrcaR2

% Cropping dimensions:
x_start = 320;
x_end   = 1150;
y_start = 280;
y_end   = 830;
x_width = (x_end - x_start)+1;
y_line  = 523;
x = linspace(x_start*0.3205, x_width * 0.3205, x_width);
y_width = (y_end - y_start)+1;
x_line  = 750;
y = linspace(0, y_width * 0.3205, y_width);
aggregate_x = zeros(size(x,2),70);

for r = 1:70;
eval(['A = imread(''Image' num2str(r) '.tif'');']);
subplot('Position',[0 0.3 0.7 0.7])
%imagesc(A)

imagesc(A(y_start:y_end,x_start:x_end))        % Show only part of the image
% Calibration factor: 936 pixels for 300 um -> 3.12 pixels/um; 31.2 um/10pi
text(80,520,'10 um','color',[1 1 1],'fontsize',12);
text(30,20,sprintf('Record %d',r),'color',[1 1 1],'fontsize',14);
h = line([100 131],[500 500]);
set(h,'linewidth',4,'color',[1 1 1]);
%text(725,630,'12 um','color',[1 1 1],'fontsize',12)
set(gca,'XTick',[])
set(gca,'YTick',[])

% *** BOTTOM INTENSITY PLOT
%plot([678:836],A(523,678:836))
subplot('Position',[0 0.1 0.7 0.2])
plot(x,A(y_line,x_start:x_end),'linewidth',2,'color',[0 0 0])
xlim([min(x) max(x)])
set(gca,'YAxisLocation','right')
xlabel('um')
ylabel('Intensity')
set(gca,'color','none')
aggregate_x(:,r) = A(y_line,x_start:x_end);     % Store the x intensity profile in a variable

ylimit = get(gca,'Ylim');
m = line([183 183],[0 ylimit(2)]);
f = line([195 195],[0 ylimit(2)]);
set(m,'color',[1 0 0]);
set(f,'color',[1 0 0]);

% *** VERTICAL (RIGHT) INTENSITY PLOT
subplot('Position',[0.7 0.3 0.2 0.7])

plot(A(y_start:y_end,x_line),y,'linewidth',2,'color',[0 0 0])
ylim([min(y) max(y)])
set(gca,'YAxisLocation','right')
set(gca,'color','none')
set(gca,'Ydir','reverse')
ylabel('um')

saveas(gcf,strcat('DataFig_m',num2str(r),'fig'));
saveas(gcf,strcat('DataFig_e',num2str(r),'eps'),'epsc');

end

% Save these variables in the 7/9/15 high-speed video folder so that I can
% access them form that script to make overlaid plots
cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/7_9_15/')
save('Hamamatsu_variables')


%% Intensities near 3000
cd /Users/Julien/Google' Drive'/Hudspeth/Data/Photos/Hamamatsu_OrcaR2
clf
subplot(2,1,1)
r=12;
h1 = plot(x,aggregate_x(:,r)/max(aggregate_x(:,r)),'k','Linewidth',2);
[x1,y1] = intersections(x,aggregate_x(:,r),x,repmat((1/exp(2))*max(aggregate_x(:,r)),size(x)) );
eval(['fwhm' num2str(r) '= x1(2)-x1(1);']);
hold on
r=47;
h2 = plot(x,aggregate_x(:,r)/max(aggregate_x(:,r)),'b','Linewidth',2);
[x2,y2] = intersections(x,aggregate_x(:,r),x,repmat((1/exp(2))*max(aggregate_x(:,r)),size(x)) );
eval(['fwhm' num2str(r) '= x2(2)-x2(1);']);
r=38;
h3 = plot(x,aggregate_x(:,r)/max(aggregate_x(:,r)),'g','Linewidth',2);
[x3,y3] = intersections(x,aggregate_x(:,r),x,repmat((1/exp(2))*max(aggregate_x(:,r)),size(x)) );
eval(['fwhm' num2str(r) '= x3(end)-x3(1);']);
legend([h1 h2 h3],sprintf('Fluorescein, 1/e^2 %g um', fwhm12),sprintf('NADH, 1/e^2 %g um', fwhm47),sprintf('DiA, 1/e^2 %g um', fwhm38))

%ylimit = get(gca,'Ylim');
%m = line([183 183],[0 ylimit(2)]);
%f = line([195 195],[0 ylimit(2)]);
%set(m,'color',[1 0 0],'linewidth',2);
%set(f,'color',[1 0 0],'linewidth',2);
title('Overlaid normalized intensity profiles, Max values ~ 3000')
xlabel('um')
ylabel('Intensity (normalized)')

% Intensities near 1700
%clf
subplot(2,1,2)
r=64;
h1 = plot(x,aggregate_x(:,r)/max(aggregate_x(:,r)),'k','Linewidth',2);
[x1,y1] = intersections(x,aggregate_x(:,r),x,repmat((1/exp(2))*max(aggregate_x(:,r)),size(x)) );
eval(['fwhm' num2str(r) '= x1(2)-x1(1);']);
hold on
r=49;
h2 = plot(x,aggregate_x(:,r)/max(aggregate_x(:,r)),'b','Linewidth',2);
[x2,y2] = intersections(x,aggregate_x(:,r),x,repmat((1/exp(2))*max(aggregate_x(:,r)),size(x)) );
eval(['fwhm' num2str(r) '= x2(2)-x2(1);']);
r=44;
h3 = plot(x,aggregate_x(:,r)/max(aggregate_x(:,r)),'g','Linewidth',2);
[x3,y3] = intersections(x,aggregate_x(:,r),x,repmat((1/exp(2))*max(aggregate_x(:,r)),size(x)) );
eval(['fwhm' num2str(r) '= x3(end)-x3(1);']);
legend([h1 h2 h3],sprintf('Fluorescein, 1/e^2 %g um', fwhm64),sprintf('NADH, 1/e^2 %g um', fwhm49),sprintf('DiA, 1/e^2 %g um', fwhm44))

%ylimit = get(gca,'Ylim');
%m = line([183 183],[0 ylimit(2)]);
%f = line([195 195],[0 ylimit(2)]);
%set(m,'color',[1 0 0],'linewidth',2);
%set(f,'color',[1 0 0],'linewidth',2);
title('Overlaid normalized intensity profiles, Max values ~ 1700')
xlabel('um')
ylabel('Intensity (normalized)')

cd /Users/Julien/Google' Drive'/Hudspeth/Data/Photos/Hamamatsu_OrcaR2
saveas(gcf,strcat('LaserSpread_Fluorescein_NADH_DiA_8_7_15','fig'));
saveas(gcf,strcat('LaserSpread_Fluorescein_NADH_DiA_8_7_15','eps'),'epsc');


%% - Half of the intensity curve
cd /Users/Julien/Google' Drive'/Hudspeth/Data/Photos/Hamamatsu_OrcaR2
clf
% start plot at 189 um, which is 189*3.12 = 590 pixels
h1 = plot(x(435:end)-188.2,aggregate_x((435:end),12)/max(aggregate_x(:,12)),'Linewidth',2,'color',[0 0 0]);
hold on
h2 = plot(x(435:end)-188.2,aggregate_x(435:end,38)/max(aggregate_x(:,38)),'Linewidth',2,'color',[0.4 0.4 0.4]);
legend([h1 h2],'Fluorescein','DiA')

ylimit = get(gca,'Ylim');
f = line([6 6],[0 ylimit(2)],'Linestyle',':');
set(f,'color',[1 0 0],'linewidth',2);
title('Overlaid normalized intensity profiles, Max values ~ 3000')
xlabel('um')
ylabel('Intensity (normalized)')

%% Looking at the effect of focal plane - DiA
clf
subplot(4,1,2:3)
r=29;
h1 = plot(x,aggregate_x(:,r)/max(aggregate_x(:,r)),'color',[0.1 0.1 1],'Linewidth',2);
[x1,y1] = intersections(x,aggregate_x(:,r),x,repmat((1/2)*max(aggregate_x(:,r)),size(x)) );
eval(['fwhm' num2str(r) '= x1(2)-x1(1);']);
hold on
r=31;
h2 = plot(x,aggregate_x(:,r)/max(aggregate_x(:,r)),'color',[0 0.9 0.1],'Linewidth',2);
[x2,y2] = intersections(x,aggregate_x(:,r),x,repmat((1/2)*max(aggregate_x(:,r)),size(x)) );
eval(['fwhm' num2str(r) '= x2(2)-x2(1);']);
r=32;
h3 = plot(x,aggregate_x(:,r)/max(aggregate_x(:,r)),'color',[0 0.7 0.3],'Linewidth',2);
[x3,y3] = intersections(x,aggregate_x(:,r),x,repmat((1/2)*max(aggregate_x(:,r)),size(x)) );
eval(['fwhm' num2str(r) '= x3(end)-x3(1);']);
r=33;
h4 = plot(x,aggregate_x(:,r)/max(aggregate_x(:,r)),'color',[0 0.5 0.8],'Linewidth',2);
[x4,y4] = intersections(x,aggregate_x(:,r),x,repmat((1/2)*max(aggregate_x(:,r)),size(x)) );
eval(['fwhm' num2str(r) '= x4(end)-x4(1);']);
legend([h1 h2 h3 h4],sprintf('HB plane, fwhm %g um', fwhm29),sprintf('Lower, fwhm %g um', fwhm31),sprintf('Lower still, fwhm %g um', fwhm32),sprintf('Back to HB plane, fwhm %g um', fwhm33))

title('Effect of focal plane on scattering - Recs 29, 31, 32, 33 - DiA')
xlabel('um')
ylabel('Intensity (normalized)')
cd /Users/Julien/Google' Drive'/Hudspeth/Data/Photos/Hamamatsu_OrcaR2
saveas(gcf,strcat('LaserSpread_wFocalPlane_DiA_8_7_15','fig'));
saveas(gcf,strcat('LaserSpread_wFocalPlane_DiA_8_7_15','eps'),'epsc');


%% Looking at the effect of focal plane - autofluorescence (NADH)
clf
subplot(4,1,2:3)
r=51;
h1 = plot(x,aggregate_x(:,r)/max(aggregate_x(:,r)),'color',[0.2 0.2 1],'Linewidth',2);
[x1,y1] = intersections(x,aggregate_x(:,r),x,repmat((1/2)*max(aggregate_x(:,r)),size(x)) );
eval(['fwhm' num2str(r) '= x1(2)-x1(1);']);
hold on
r=53;
h2 = plot(x,aggregate_x(:,r)/max(aggregate_x(:,r)),'color',[0 0.9 0.3],'Linewidth',2);
[x2,y2] = intersections(x,aggregate_x(:,r),x,repmat((1/2)*max(aggregate_x(:,r)),size(x)) );
eval(['fwhm' num2str(r) '= x2(2)-x2(1);']);
r=54;
h3 = plot(x,aggregate_x(:,r)/max(aggregate_x(:,r)),'color',[0.2 0.6 0.2],'Linewidth',2);
[x3,y3] = intersections(x,aggregate_x(:,r),x,repmat((1/2)*max(aggregate_x(:,r)),size(x)) );
eval(['fwhm' num2str(r) '= x3(end)-x3(1);']);
r=55;
h4 = plot(x,aggregate_x(:,r)/max(aggregate_x(:,r)),'color',[0.3 0.4 0.1],'Linewidth',2);
[x4,y4] = intersections(x,aggregate_x(:,r),x,repmat((1/2)*max(aggregate_x(:,r)),size(x)) );
eval(['fwhm' num2str(r) '= x4(end)-x4(1);']);
legend([h1 h2 h3 h4],sprintf('HB plane, fwhm %g um', fwhm51),sprintf('Lower, fwhm %g um', fwhm53),sprintf('Lower still, fwhm %g um', fwhm54),sprintf('Lowest (HB base),fwhm %g um', fwhm55))

title('Effect of focal plane on scattering - Recs 51,53,54,55 - NADH')
xlabel('um')
ylabel('Intensity (normalized)')
cd /Users/Julien/Google' Drive'/Hudspeth/Data/Photos/Hamamatsu_OrcaR2
saveas(gcf,strcat('LaserSpread_wFocalPlane_NADH_8_7_15','fig'));
saveas(gcf,strcat('LaserSpread_wFocalPlane_NADH_8_7_15','eps'),'epsc');




