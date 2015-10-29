% This makes a figure with all 12 microphonics recordings from 3/27/13

% This first for-loop removes the DC offset from all traces
for i=1:12
eval(['X=' 'struct_data.data' num2str(i) '.data(:,2);']) ;
%X = sprintf( 'struct_data.data%d.data(:,2)', i );      % original array
Xa = 0;             % adjusted array
Tr = 0;             % trend array
eval(['f = struct_data.data' num2str(i) '.data(1,2);']) ;
%f = sprintf( 'struct_data.data%d.data(1,2)', i );      % first point
eval(['l = struct_data.data' num2str(i) '.data(end,2);']) ;
%l = sprintf( 'struct_data.data%d.data(end,2)', i );    % last point
eval(['N = length(struct_data.data' num2str(i) '.data);']);   % number of points

    for n = 1:N;
    Tr = (n-1) * ( (l-f) / (N-1) ) + f;
    end;
Xa = X - Tr;

%sprintf('data%d',i) = Xa;
eval(['data' num2str(i) '(:,1) = struct_data.data' num2str(i) '.data(:,1);']);
eval(['data' num2str(i) '(:,2) = Xa;']);
end



subplot(4,3,1)
plot(data1(:,2))
axis([0 5000 -0.02 0.05])
text(500,0.045, 'Perilymph')
title('3/27/13 Microphonics')
subplot(4,3,4)
plot(data2(:,2))
axis([0 5000 -0.02 0.05])
text(500,0.045, '100nM DF')
subplot(4,3,7)
plot(data3(:,2))
axis([0 5000 -0.02 0.05])
text(500,0.045, 'Endolymph')
subplot(4,3,10)
plot(data4(:,2))
axis([0 5000 -0.02 0.05])
text(500,0.045, 'Perilymph')
subplot(4,3,2)
plot(data5(:,2))
axis([0 5000 -0.02 0.05])
text(500,0.045, 'Endolymph')
subplot(4,3,5)
plot(data6(:,2))
axis([0 5000 -0.02 0.05])
text(500,0.045, 'Endolymph')
subplot(4,3,8)
plot(data7(:,2))
axis([0 5000 -0.02 0.05])
text(500,0.045, '100nM Endolymph')
subplot(4,3,11)
plot(data8(:,2))
axis([0 5000 -0.02 0.05])
text(500,0.045, '100nM Endolymph')
subplot(4,3,3)
plot(data9(:,2))
axis([0 5000 -0.02 0.05])
text(500,0.045, '100nM Endolymph')
subplot(4,3,6)
plot(data10(:,2))
axis([0 5000 -0.02 0.05])
text(500,0.045, '100nM Endolymph')
subplot(4,3,9)
plot(data11(:,2))
axis([0 5000 -0.02 0.05])
text(500,0.045, 'Endolymph')
subplot(4,3,12)
plot(data12(:,2))
axis([0 5000 -0.02 0.05])
text(500,0.045, 'Endolymph')



