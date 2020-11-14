function [ rayp ] = y_get_rayp_SsSxs( evdp, em, dist, np, xdep )

% SsPxp phase has local minimum
% use y_get_rayp_directS instead
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
ztmp = xdep; 
[pmax2,iflag] =  interp1db ( ztmp, z_fine, ss_fine );
pmax = min([pmax1,pmax2]);


% % calculat the maximum and minimum distance range - not monotonous
% ztS= wise_turn_v3 (pmin, [em.z_660 em.z_cmb],  z_fine, ss_fine);
% ztP= xdep;
% [rtmp1, dtmp1]=  tau (evdp, ztS ,pmin, z_fine, ss_fine);
% [rtmp2, dtmp2]= tau ( 0.0, ztS,pmin, z_fine, ss_fine);
% [rtmp3, dtmp3]= tau ( 0.0, ztP,pmin, z_fine, sp_fine);
% dtaup = dtmp1 + dtmp2 + 2*dtmp3;
% range1 = dtaup*180/pi;
% ztS= wise_turn_v2 (pmax, em.z_660,  z_fine, ss_fine);
% ztP= xdep;
% [rtmp1, dtmp1]=  tau (evdp, ztS ,pmax, z_fine, ss_fine);
% [rtmp2, dtmp2]= tau ( 0.0, ztS,pmax, z_fine, ss_fine);
% [rtmp3, dtmp3]= tau ( 0.0, ztP,pmax, z_fine, sp_fine);
% dtaup = dtmp1 + dtmp2 + 2*dtmp3;
% range2 = dtaup*180/pi;

if isempty(dist)
    rayp = linspace(pmin,pmax, np);
    return;
%     dist = linspace(min([range1 range2]), max([range1 range2]), 11);
end

% calculate the distance range
np = 100;
dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = (j-1)* dp + pmin;
    rayp1(j) = pj; 
    ztS= wise_turn_v3 (pj, [em.z_660 em.z_cmb],  z_fine, ss_fine);
    ztS2= xdep;
    [rtmp1, dtmp1]= tau (evdp, ztS ,pj, z_fine, ss_fine);
    [rtmp2, dtmp2]= tau ( 0.0, ztS,pj, z_fine, ss_fine);
    [rtmp3, dtmp3]= tau ( 0.0, ztS2,pj, z_fine, ss_fine);
    taup1(j) = real(rtmp1 + rtmp2 + 2*rtmp3);
    dtaup1(j) = real(dtmp1 + dtmp2 + 2*dtmp3);
end

if min(dist) < min(dtaup1*180/pi) || max(dist) > max(dtaup1*180/pi)
    fprintf('Distance out of range!\n');
    fprintf('Should be within %.2f and %.2f degrees\n', min(dtaup1*180/pi), max(dtaup1*180/pi));
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
        ztS= wise_turn_v3 (pj, [em.z_660 em.z_cmb],  z_fine, ss_fine);
        ztS2= xdep;
        [rtmp1, dtmp1]=  tau (evdp, ztS ,pj, z_fine, ss_fine);
        [rtmp2, dtmp2]= tau ( 0.0, ztS,pj, z_fine, ss_fine);
        [rtmp3, dtmp3]= tau ( 0.0, ztS2,pj, z_fine, ss_fine);
%         taup = real(rtmp1 + rtmp2 + 2*rtmp3);
        dtaup = real(dtmp1 + dtmp2 + 2*dtmp3);
        
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

