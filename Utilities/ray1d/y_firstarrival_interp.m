function [ rayp1, d1, t1 ] = y_firstarrival_interp( rayp0, d0, t0 )

% interpolate travel time 
% d: distance; t: time; rayp: ray parameter

% find distance turning points
dd0 = diff(d0);
ind = find(dd0(1:end-1).*dd0(2:end) < 0);

ind = [1,ind,length(d0)];
ind = unique(ind);

% sort distance
d1 = unique(d0);

for i = 1:length(ind)-1
    dtmp = d0(ind(i):ind(i+1));
    ttmp = t0(ind(i):ind(i+1));
    rtmp = rayp0(ind(i):ind(i+1));
    [dtmp,idx] = unique(dtmp);
    ttmp = ttmp(idx);
    rtmp = rtmp(idx);
    
    if length(idx) <= 1
        tt(:,i) = nan(length(d1),1);
        rr(:,i) = nan(length(d1),1);
    else
        tt(:,i) = interp1(dtmp,ttmp,d1,'linear',nan);
        rr(:,i) = interp1(dtmp,rtmp,d1,'linear',nan);
    end
    
end
    
% get first arrival t1 and its ray parameter
[t1,idx] = min(tt,[],2);
for i = 1:length(idx)
    rayp1(i) = rr(i,idx(i));
end



end

