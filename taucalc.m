function [R2,CI,fitresult,gof,iterations,residuals,tel] = taucalc(t, y, maxiter)

% Initialize
rt1=0; rt2=0; rt3=0; rt4=0; rt5=0; clear outliers; warning off;

tic;
ft = fittype( 'a - b*exp(c*x) - d*exp(e*x)', 'independent', 'x', 'dependent', 'y' );

opts = fitoptions('Algorithm','Levenberg-Marquardt','Method','NonlinearLeastSquares',...
        'Upper', [Inf Inf 0 Inf 0], 'Lower',[0 -Inf -Inf -Inf -Inf],'TolX',1e-10,'TolFun',1e-10,...
        'MaxFunEvals',4000, 'MaxIter',4000,'Robust','Off');

[fitresult, gof] = fit( t, y, ft, opts);

Aconfint = confint(fitresult);                      % Store confidence intervals
rt1 = sign(Aconfint(1,1)) + sign(Aconfint(2,1));    % do CI95 cross zero?
rt2 = sign(Aconfint(1,2)) + sign(Aconfint(2,2));    % do CI95 cross zero?
rt3 = sign(Aconfint(1,3)) + sign(Aconfint(2,3));    % do CI95 cross zero?
rt4 = sign(Aconfint(1,4)) + sign(Aconfint(2,4));    % do CI95 cross zero?
rt5 = sign(Aconfint(1,5)) + sign(Aconfint(2,5));    % do CI95 cross zero?
m = 0;
Acoeffs = coeffvalues(fitresult);                   % Save model parameters

fdata = feval(fitresult,t);                     % Evaluate fit
resd = fdata - y;                              % Calculate residuals

while rt1 == 0 || rt2 == 0 || rt3 == 0 || rt4 == 0 || rt5 == 0 || std(resd) >= 3 || isnan(rt1) ||isnan(rt2) || isnan(rt3) || isnan(rt4) || isnan(rt5)
    if m >= maxiter
        break;
    end
    
    m = m+1;
    fdata = feval(fitresult,t);                     % Evaluate fit
    resd = fdata - y;                              % Calculate residuals
    I = abs(resd) > 3*std(resd);                    % I = 1 for any residuals greater than 3 x SD
    outliers = excludedata(t,y,'indices',I);       % Find outliers
    opts = fitoptions('Algorithm','Levenberg-Marquardt','Method','NonlinearLeastSquares',...
        'Upper', [Inf Inf 0 Inf 0], 'Lower',[0 -Inf -Inf -Inf -Inf],'TolX',1e-10,'TolFun',1e-10,...
        'MaxFunEvals',4000, 'MaxIter',4000,'Robust','Off','Exclude',outliers);
    [fitresult, gof] = fit( t, y, ft, opts);       % Fit w/outliers removed
    Aconfint = confint(fitresult);                  % Check 95% CI
    rt1 = sign(Aconfint(1,1)) + sign(Aconfint(2,1));% do CI95 cross zero?
    rt2 = sign(Aconfint(1,2)) + sign(Aconfint(2,2));
    rt3 = sign(Aconfint(1,3)) + sign(Aconfint(2,3));
    rt4 = sign(Aconfint(1,4)) + sign(Aconfint(2,4));
    rt5 = sign(Aconfint(1,5)) + sign(Aconfint(2,5));
end

iter = m;                                           % Save number of iterations

% Outputs
R2 = [gof.rsquare];                                 % R-squared values
CI = [confint(fitresult)];                          % 95% confidence intervals
iterations = [iter];                                % Iterations
tel = toc;                                          % Time elapsed
residuals = [resd];                                 % Residuals


