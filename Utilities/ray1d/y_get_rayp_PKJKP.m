function [ rayp ] = y_get_rayp_PKJKP( evdp, em, dist, np )

% SP phase has local minimum
% use y_get_rayp_directS instead
rayp = nan(size(dist));
z_fine = em.z; 
re = em.re; 
em.vs(find(em.vs==0)) = 1e-9;
sp_fine = (re - z_fine)./em.vp; 
ss_fine = (re - z_fine)./em.vs;


pmin = 0;

ztmp = em.z_cmb;
[pmax1,iflag] =  interp1db ( ztmp, em.z, sp_fine );
ztmp = em.z_iob;
[pmax2,iflag] = interp1db ( ztmp, em.z, sp_fine );
ztmp = em.z_iob + 10^-6;
[pmax3,iflag] = interp1db ( ztmp, em.z, ss_fine );

pmax = min([pmax1,pmax2,pmax3]);

% calculat the maximum and minimum distance range
zt_s= wise_turn_v3 (pmin, [em.z_iob em.re],  em.z, ss_fine);
zt_s = zt_s - 0.5*10^-6;
[rtmp1, dtmp1]= tau (evdp, em.z_iob-10^-6 ,pmin, em.z, sp_fine);
[rtmp2, dtmp2]= tau (em.z_iob+10^-6, zt_s ,pmin, em.z, ss_fine);
[rtmp3, dtmp3]= tau (0.0, em.z_iob-10^-6 ,pmin, em.z, sp_fine);
dtaup = dtmp1 + 2*dtmp2 + dtmp3;
range1 = dtaup*180/pi;

zt_s= wise_turn_v3 (pmax, [em.z_iob em.re],  em.z, ss_fine);
zt_s = zt_s - 0.5*10^-6;
[rtmp1, dtmp1]= tau (evdp, em.z_iob-10^-6 ,pmax, em.z, sp_fine);
[rtmp2, dtmp2]= tau (em.z_iob+10^-6, zt_s ,pmax, em.z, ss_fine);
[rtmp3, dtmp3]= tau (0.0, em.z_iob-10^-6 ,pmax, em.z, sp_fine);
dtaup = dtmp1 + 2*dtmp2 + dtmp3;
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
        zt_s= wise_turn_v3 (pj, [em.z_iob em.re],  em.z, ss_fine);
        zt_s = zt_s - 0.5*10^-6;
        [rtmp1, dtmp1]= tau (evdp, em.z_iob-10^-6 ,pj, em.z, sp_fine);
        [rtmp2, dtmp2]= tau (em.z_iob+10^-6, zt_s ,pj, em.z, ss_fine);
        [rtmp3, dtmp3]= tau (0.0, em.z_iob-10^-6 ,pj, em.z, sp_fine);
        dtaup = dtmp1 + 2*dtmp2 + dtmp3;
        
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

