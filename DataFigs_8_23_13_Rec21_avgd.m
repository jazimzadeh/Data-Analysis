% Averaged version of 8/23/13 record 21

m = zeros(length(struct_data.data21.data(:,2)),5);

for i = 1:5;
    j = i + 1;
    m(:,i) = struct_data.data21.data(:,j);
end

p = size(m);
m(:,p(2)+1) = (m(:,1) + m(:,2) + m(:,3) + m(:,4) + m(:,5) )/5;



plot(m(:,6))
