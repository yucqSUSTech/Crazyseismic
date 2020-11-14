function [ stack ] = stacking( data )

% stack data
% normalize each trace before stacking
data_new = data;
range = ones(size(data,2),1);
for i = 1:size(data,2)
    data_new(:,i) = detrend(data_new(:,i));
    range(i) = max(data_new(:,i))-min(data_new(:,i));
    if range(i) == 0
        range(i) = 1;
    end
    data_new(:,i) = data_new(:,i)/range(i);
end

stack = mean(data_new,2)*range';

end

