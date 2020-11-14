function h = single_wig4(time,data )
%SINGLE_WIG2 Summary of this function goes here
%   Detailed explanation goes here

mdata = mean(data);
data = data - mdata;
if size(data,1) == 1
    data = data';
end

if size(time,1) == 1
    time = time';
end

dark = [0 0 0];
gray = [0.7 0.7 0.7];

% plot wiggle for a single trace
% path('../CurveIntersect', path);

[t0,d0] = curveintersect(time, data, time, zeros(size(time)));

data = [d0;data];
[time,indx] = sort([t0;time],'ascend');
data = data(indx);

time = [time(1);time;time(end)];
data = [0;data;0];

dataup = data;
dataup(find(dataup<0)) = 0;

datadn = data;
datadn(find(datadn>0)) = 0;

h(1) = patch(time,dataup + mdata,dark,'Facecolor',dark,'Edgecolor',dark);
h(2) = patch(time,datadn + mdata,gray,'Facecolor',gray,'Edgecolor',gray);


end
