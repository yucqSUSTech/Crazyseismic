function [ rayp ] = y_get_rayp_Sxp( evdp, em, dist, np, xdep )

% 
rayp = nan(size(dist));
z_fine = em.z; 
re = em.re; 
em.vs(find(em.vs==0)) = 1e-9;
sp_fine = (re - z_fine)./em.vp; 
ss_fine = (re - z_fine)./em.vs;

ztmp = em.z_cmb - 1; 
[pmin,iflag] =  interp1db ( ztmp, z_fine, ss_fine );
ztmp = max( em.z_660 , evdp) + 1 ; 
[pmax1,iflag] =  interp1db ( ztmp, z_fine, ss_fine );
ztmp = xdep + 1;
[pmax2,iflag] =  interp1db ( ztmp, z_fine, sp_fine );
pmax = min([pmax1 pmax2]);

% calculat the maximum and minimum distance range
zt= wise_turn_v3 (pmin, [em.z_660 em.z_cmb],  z_fine, ss_fine);
[rtmp1, dtmp1]=  tau (evdp, zt ,pmin, z_fine, ss_fine);
[rtmp2, dtmp2]= tau ( xdep, zt,pmin, z_fine, ss_fine);
[rtmp3, dtmp3]= tau ( 0.0, xdep,pmin, z_fine, sp_fine);
dtaup = dtmp1 + dtmp2 + dtmp3;
range1 = dtaup*180/pi;
zt= wise_turn_v3 (pmax, [em.z_660 em.z_cmb],  z_fine, ss_fine);
[rtmp1, dtmp1]=  tau (evdp, zt ,pmax, z_fine, ss_fine);
[rtmp2, dtmp2]= tau ( xdep, zt,pmax, z_fine, ss_fine);
[rtmp3, dtmp3]= tau ( 0.0, xdep,pmax, z_fine, sp_fine);
dtaup = dtmp1 + dtmp2 + dtmp3;
range2 = dtaup*180/pi;

if isempty(dist)
    rayp = linspace(pmin,pmax, np);
    return;
%     dist = linspace(min([range1 range2]), max([range1 range2]), 11);
end

if min(dist) < min([range1 range2]) || max(dist) > max([range1 range2])
    fprintf('Distance out of range!\n');
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
        zt= wise_turn_v3 (pj, [em.z_660 em.z_cmb],  z_fine, ss_fine);
        [rtmp1, dtmp1]=  tau (evdp, zt ,pj, z_fine, ss_fine);
        [rtmp2, dtmp2]= tau ( xdep, zt,pj, z_fine, ss_fine);
        [rtmp3, dtmp3]= tau ( 0.0, xdep,pj, z_fine, sp_fine);
        taup = rtmp1 + rtmp2 + rtmp3;
        dtaup = dtmp1 + dtmp2 + dtmp3;
        
        range = dtaup*180/pi;
        drange = range - dist(i);
        
        if drange > 0
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

