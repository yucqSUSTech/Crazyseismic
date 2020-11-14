function [ rayp ] = y_get_rayp_SKS( evdp, em, dist, np )

% 
rayp = nan(size(dist));
z_fine = em.z; 
re = em.re; 
em.vs(find(em.vs==0)) = 1e-9;
sp_fine = (re - z_fine)./em.vp; 
ss_fine = (re - z_fine)./em.vs;

pPMmin = 0;
ztmp = em.z_cmb ; 
[pPMmax,iflag] =  interp1db ( ztmp, z_fine, ss_fine );
pPMmax = pPMmax - 1;
ztmp = em.z_cmb + .1;
[pPOmax,iflag] =  interp1db ( ztmp, z_fine, sp_fine );
ztmp = em.z_iob - .1;
[pPOmin,iflag] =  interp1db ( ztmp, z_fine, sp_fine );
% find the maximum and minimum rayp for the phase
pmax = min(pPMmax,pPOmax);
pmin = max(pPMmin,pPOmin);

% calculat the maximum and minimum distance range
zt= wise_turn_v3 (pmin, [em.z_cmb em.z_iob],  z_fine, sp_fine);
[rtmp1, dtmp1]=  tau (evdp, em.z_cmb ,pmin, z_fine, ss_fine);
[rtmp2, dtmp2]=  tau (em.z_cmb, zt, pmin, z_fine, sp_fine);
[rtmp3, dtmp3]=  tau (0, em.z_cmb ,pmin, z_fine, ss_fine);
dtaup = dtmp1 + 2*dtmp2 + dtmp3;
range1 = dtaup*180/pi;
zt= wise_turn_v3 (pmax, [em.z_cmb em.z_iob],  z_fine, sp_fine);
[rtmp1, dtmp1]=  tau (evdp, em.z_cmb ,pmax, z_fine, ss_fine);
[rtmp2, dtmp2]=  tau (em.z_cmb, zt, pmax, z_fine, sp_fine);
[rtmp3, dtmp3]=  tau (0, em.z_cmb ,pmax, z_fine, ss_fine);
dtaup = dtmp1 + 2*dtmp2 + dtmp3;
range2 = dtaup*180/pi;

if isempty(dist)
    rayp = linspace(pmin,pmax, np);
    return;
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
        zt= wise_turn_v3 (pj, [em.z_cmb em.z_iob],  z_fine, sp_fine);
        [rtmp1, dtmp1]=  tau (evdp, em.z_cmb, pj, z_fine, ss_fine);
        [rtmp2, dtmp2]=  tau (em.z_cmb, zt, pj, z_fine, sp_fine);
        [rtmp3, dtmp3]=  tau (0, em.z_cmb, pj, z_fine, ss_fine);
%         taup = rtmp1 + rtmp2;
        dtaup = dtmp1 + 2*dtmp2 + dtmp3;
        
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

