function [ rayp ] = y_get_rayp_PKPcd( evdp, em, dist, np )

% same as PKiKP

rayp = nan(size(dist));
z_fine = em.z; 
re = em.re; 
em.vs(find(em.vs==0)) = 1e-9;
sp_fine = (re - z_fine)./em.vp; 
ss_fine = (re - z_fine)./em.vs;

pmin = 0;
ztmp = em.z_iob; 
[pmax,iflag] =  interp1db ( ztmp, z_fine, sp_fine );
pmax = pmax - 10^-6;

% calculat the maximum and minimum distance range
[rtmp1, dtmp1]=  tau (evdp, em.z_iob ,pmin, z_fine, sp_fine);
[rtmp2, dtmp2]= tau ( 0.0, em.z_iob,pmin, z_fine, sp_fine);
dtaup = dtmp1 + dtmp2;
range1 = dtaup*180/pi;
[rtmp1, dtmp1]=  tau (evdp, em.z_iob ,pmax, z_fine, sp_fine);
[rtmp2, dtmp2]= tau ( 0.0, em.z_iob,pmax, z_fine, sp_fine);
dtaup = dtmp1 + dtmp2;
range2 = dtaup*180/pi;

if isempty(dist)
    rayp = linspace(pmin,pmax, np);
    return;
%     dist = linspace(min([range1 range2]), max([range1 range2]), 11);
end

if min(dist) < min([range1 range2]) || max(dist) > max([range1 range2])
    fprintf('Distances out of range!\n');
    fprintf('Should be within %.2f and %.2f degrees\n', min([range1 range2]), max([range1 range2]));
    return;
end

pmaxi = pmax;
pmini = pmin;
for i = 1:length(dist)
    pmax = pmaxi;
    pmin = pmini;
    ddist = 1;
    num = 0;
    while ddist > 0.001 && num < 30 % ~0.1 km offset
        num = num + 1;
        pj = (pmax + pmin)/2;
        [rtmp1, dtmp1]=  tau (evdp, em.z_iob ,pj, z_fine, sp_fine);
        [rtmp2, dtmp2]= tau ( 0.0, em.z_iob,pj, z_fine, sp_fine);
        taup = rtmp1 + rtmp2;
        dtaup = dtmp1 + dtmp2;
        
        range = dtaup*180/pi;
        drange = range - dist(i);
        
        if drange < 0
            pmin = pj;
        else
            pmax = pj;
        end
        
        ddist = abs(drange);
        
    end
    rayp(i) = pj;
    % num
end


end

