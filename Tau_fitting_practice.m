%% Create two data sets: one with a single exponential and one with two
clear
clf
t = [1:0.01:100]';
N_o = 100;
Tau1 = 20;
Tau2 = 3;
A1 = 50;    % Magnitude of each component
A2 = 50;    % Magnitude of each component
y = N_o - (A1+A2)*exp(-t./Tau1) + randn(size(t));
yy = N_o ...
    - A1*exp(-t./Tau1) ...
    - A2*exp(-t./Tau2) ...
    + randn(size(t));
subplot(3,1,1:2)
plot(t,y,'m')
hold on
plot(t,yy,'k')
axis([-10 100 0 110])

%% Perform a standard 'exp2' fit on the above data
options = fitoptions('exp2');
options.Upper = [Inf 0 Inf 0];  
[f,s] = fit(t', yy','exp2',options);

plot(f,'k')

%% Another fit
% Set up fittype and options.
ft = fittype( 'a - b*exp(c*x) - d*exp(e*x)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( ft );                % Load default options
opts.Upper = [Inf Inf 0 Inf 0];         % Constrain parameters 'c' and 'e' to negative numbers
opts.Lower = [0 -Inf -Inf -Inf -Inf];   
opts.MaxIter = 4000;
opts.MaxFunEvals = 4000;
opts.robust = 'LAR';
opts.algorithm = 'Levenberg-Marquardt';
opts.TolX = 1e-10;
opts.TolFun = 1e-10;

% Fit model to data.
[fitresult, gof] = fit( t, yy, ft, opts);

hold on
subplot(3,1,1:2)
plot(fitresult,'g')
subplot(3,1,3)
plot(fitresult,t,yy,'residuals')
title('Residuals')
clc
disp(['Tau1: ',num2str(-1/fitresult.c),' ms'])
disp(['Tau2: ',num2str(-1/fitresult.e),' ms'])
