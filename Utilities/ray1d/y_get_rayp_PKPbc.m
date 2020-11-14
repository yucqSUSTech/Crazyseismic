function [ rayp ] = y_get_rayp_PKPbc( evdp, em, dist, np )

% 
rayp = nan(size(dist));
z_fine = em.z; 
re = em.re; 
em.vs(find(em.vs==0)) = 1e-9;
sp_fine = (re - z_fine)./em.vp; 
ss_fine = (re - z_fine)./em.vs;

pPMmin = 0;
ztmp = em.z_cmb ; 
[pPMmax,iflag] =  interp1db ( ztmp, z_fine, sp_fine );
pPMmax = pPMmax - 1;
ztmp = em.z_cmb + .1;
[pPOmax,iflag] =  interp1db ( ztmp, z_fine, sp_fine );
ztmp = em.z_iob - .1;
[pPOmin,iflag] =  interp1db ( ztmp, z_fine, sp_fine );
% find the maximum and minimum rayp for the phase
pmax = min(pPMmax,pPOmax);
pmin = max(pPMmin,pPOmin);

% np = 100;
dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = (j-1)* dp + pmin;
    rayp1(j) = pj; 
    zt= wise_turn_v3 (pj, [em.z_cmb em.z_iob],  z_fine, sp_fine);
    [rtmp1, dtmp1]=  tau (evdp, zt ,pj, z_fine, sp_fine);
    [rtmp2, dtmp2]= tau ( 0.0,zt,pj, z_fine, sp_fine);
    taup1(j) = rtmp1 + rtmp2;
    dtaup1(j) = dtmp1 + dtmp2;
end

% extract -bc branches 
[dmin, imin] = min( dtaup1); 
rayp1 = rayp1(imin:-1:1);
% taup1 = taup1(imin:-1:1);
dtaup1 = dtaup1(imin:-1:1);

% % calculat the maximum and minimum distance range
% [rtmp1, dtmp1]=  tau (evdp, em.z_iob ,pmin, z_fine, sp_fine);
% [rtmp2, dtmp2]= tau ( 0.0, em.z_iob,pmin, z_fine, sp_fine);
% dtaup = dtmp1 + dtmp2;
% range1 = dtaup*180/pi;
% [rtmp1, dtmp1]=  tau (evdp, em.z_iob ,pmax, z_fine, sp_fine);
% [rtmp2, dtmp2]= tau ( 0.0, em.z_iob,pmax, z_fine, sp_fine);
% dtaup = dtmp1 + dtmp2;
% range2 = dtaup*180/pi;

if isempty(dist)    
    rayp = linspace(min(rayp1),max(rayp1), np);
    return;
end

if min(dist) < min(dtaup1*180/pi) || max(dist) > max(dtaup1*180/pi)
    fprintf('Distances out of range!\n');
    fprintf('Should be within %.2f and %.2f degrees\n', min(dtaup1*180/pi), max(dtaup1*180/pi));
    return;
end

pmaxi = max(rayp1);
pmini = min(rayp1);
for i = 1:length(dist)
    pmax = pmaxi;
    pmin = pmini;
    ddist = 1;
    num = 0;
    while ddist > 0.001 && num < 30 % ~0.1 km offset
        num = num + 1;
        pj = (pmax + pmin)/2;        
        zt= wise_turn_v3 (pj, [em.z_cmb em.z_iob],  z_fine, sp_fine);
        [rtmp1, dtmp1]=  tau (evdp, zt, pj, z_fine, sp_fine);
        [rtmp2, dtmp2]= tau ( 0.0, zt, pj, z_fine, sp_fine);
%         taup = rtmp1 + rtmp2;
        dtaup = dtmp1 + dtmp2;
        
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

