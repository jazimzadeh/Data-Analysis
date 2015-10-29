cd('/Users/Julien/Google Drive/Hudspeth/Data/High-Speed Videos/7_9_15/')
load('7_9_15_workspace.mat')    % Load the workspace

% Do a fit for each record. 
for r = 3:27; 
    clf
    time = record(r).time(64:90);   % Set interval over which to fit
    displ = record(r).CoM_avg(64:90);
    warning off
    F = fitoptions('METHOD','NonlinearLeastSquares');
    [f2, gof] = fit(time',-displ','exp2',F);
    record(r).f = f2;
    
    % Check whether the CI of any of the 4 parameters includes zero
    if sum(sum(sign(confint(f2)),1) == 0) > 0
        record(r).ci = 0;           % If any confint includes 0, store a 0 in the ci field
    else
        record(r).ci = 1;           % Otherwise store a 1
    end
    record(r).Tau1 = abs(1/f2.b);   % Store the two time constants
    record(r).Tau2 = abs(1/f2.d);

end


%% Plot CoM_avg and include Tau in legend
for r = 15
    clf
    h1 = plot(record(r).time,record(r).CoM_avg,'k');
    hold on
    time = record(r).time(64:90);
    displ = record(r).CoM_avg(64:90);
    f2 = fit(time',displ','exp2');
    plot(f2,time,displ,'r');
    
    legend([h1],sprintf('Tau = %f ms',record(r).tau))
    title(strcat('Record ',num2str(r)));
    xlabel('Time (ms)')
    ylabel('Displacement (um)')
    
    %saveas(gcf,strcat('Tau_7_9_15_displ',num2str(r),'fig'));
    %saveas(gcf,strcat('Tau_7_9_15_displ_e',num2str(r),'eps'),'epsc');
    
end

%% Plot the confidence interval parameter to see which records have good fits (ci = 1)
clf
for r = 3:27
plot(r,record(r).ci,'.')
hold on
end
axis([0 30 -0.1 1.1])

%% Plot Tau vs. distance
clf
set(0, 'DefaultAxesColorOrder', ametrine(5));

r=3; h1 = plot(record(r).distance, record(r).tau,'.','markersize',24)
hold all
r=4; h2 = plot(record(r).distance, record(r).tau,'.','markersize',24)
r=5; h3 = plot(record(r).distance, record(r).tau,'.','markersize',24)
r=6; h4 = plot(record(r).distance, record(r).tau,'.','markersize',24)
r=7; h5 = plot(record(r).distance, record(r).tau,'.','markersize',24)
xlabel('Distance (um)')
ylabel('Tau (ms)')
title('7/9/15 HB1')

%% Plot Tau vs. distance
clf
set(0, 'DefaultAxesColorOrder', ametrine(7));

r=8; h1 = plot(record(r).distance, record(r).tau,'.','markersize',24)
hold all
r=9; h2 = plot(record(r).distance, record(r).tau,'.','markersize',24)
r=10; h3 = plot(record(r).distance, record(r).tau,'.','markersize',24)
r=11; h4 = plot(record(r).distance, record(r).tau,'.','markersize',24)
r=12; h5 = plot(record(r).distance, record(r).tau,'.','markersize',24)
r=13; h5 = plot(record(r).distance, record(r).tau,'.','markersize',24)
r=14; h5 = plot(record(r).distance, record(r).tau,'.','markersize',24)
xlabel('Distance (um)')
ylabel('Tau (ms)')
title('7/9/15 HB2')

%% Plot Tau vs. distance
clf
set(0, 'DefaultAxesColorOrder', ametrine(12));

r=15; h1 = plot(record(r).distance, record(r).tau,'.','markersize',24)
hold all
r=16; h2 = plot(record(r).distance, record(r).tau,'.','markersize',24)
r=17; h3 = plot(record(r).distance, record(r).tau,'.','markersize',24)
r=18; h4 = plot(record(r).distance, record(r).tau,'.','markersize',24)
r=19; h5 = plot(record(r).distance, record(r).tau,'.','markersize',24)
r=20; h5 = plot(record(r).distance, record(r).tau,'.','markersize',24)
r=21; h5 = plot(record(r).distance, record(r).tau,'.','markersize',24)
r=22; h5 = plot(record(r).distance, record(r).tau,'.','markersize',24)
r=23; h5 = plot(record(r).distance, record(r).tau,'.','markersize',24)
r=24; h5 = plot(record(r).distance, record(r).tau,'.','markersize',24)
r=25; h5 = plot(record(r).distance, record(r).tau,'.','markersize',24)
r=26; h5 = plot(record(r).distance, record(r).tau,'.','markersize',24)
r=27; h5 = plot(record(r).distance, record(r).tau,'.','markersize',24)
xlabel('Distance (um)')
ylabel('Tau (ms)')
title('7/9/15 HB3')


   




