% [Sacculus; Muscle; Retina]
Opn = [5.97921E-05
0.003050265
0.066952735];

Arr = [3.40174E-24
1.18297E-22
0.140883935];

Myo = [0.000199412
1.18297E-22
0.000984041];

data = [Opn';Arr';Myo'];

subplot(3,1,1)
bar(Arr)
set(gca,'XTickLabel',[])
title('Arrestin','FontSize',16)
set(gca, 'FontSize',16)
ylabel('2^{-Cp}')

subplot(3,1,2)
bar(Opn)
set(gca,'XTickLabel',[])
title('Opsin 1sw','FontSize',16)
set(gca, 'FontSize',16)
ylabel('2^{-Cp}')
% Ef1 was not highly expressed in muscle, so when I normalize Opn to Ef1
% the amount of Opn in muscle is artificially boosted.

subplot(3,1,3)
bar(Myo)
set(gca,'XTickLabel',{'Sacculus', 'Muscle', 'Retina'})
title('Myo 7a','FontSize',16)
set(gca, 'FontSize',16)
ylabel('2^{-Cp}')

%% Plot ratio of Opsin to Myo 7a in both sacculus and retina
figure
bar([Opn(1)/Myo(1) Opn(3)/Myo(3)])
set(gca,'XTickLabel',{'Sacculus','Retina'})
set(gca,'FontSize',16)
title('Ratio of fold difference, Opsin1sw : Myo7a','FontSize',16)

% We know that Myo7a is expressed in the sacculus. 
% So if we compare Opn1sw to Myo7a in the sacculus, there is only 1/3 less
% Opn than Myo7A, so Opn1sw is probably expressed in hte sacculus


