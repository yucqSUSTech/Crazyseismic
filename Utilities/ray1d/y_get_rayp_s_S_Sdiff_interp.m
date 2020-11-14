function [ rayp, du ] = y_get_rayp_s_S_Sdiff_interp( evdp, em, dist, np )

% get P wave ray parameter using interpolation

[rayp1, taup1, dtaup1] = y_get_s_S_Sdiff (evdp, np, em);

d0 = dtaup1*180/pi;

rayp = zeros(size(dist));
du = zeros(size(dist));
for i = 1:length(dist)
    if dist(i) < min(d0) || dist(i) > max(d0)
        rayp(i) = nan;
        du(i) = 0;
        continue;
    end
    rayp(i) = interp1db(dist(i), d0,rayp1);
    if dist(i)<=d0(np)
        du(i) = -1; %upgoing wave
    else
        du(i) = 1;
    end
end


end

