function  [rayp, taup1, dtaup1]= y_get_SKSP (evdp, np, em)

em.vs(find(em.vs==0))=1e-9;
sp_fine = (em.re - em.z)./em.vp; 
ss_fine = (em.re - em.z)./em.vs; 

%for S waves
ztmp = em.z_cmb; 
pSmin = 0;
[pSmax,iflag] =  interp1db ( ztmp, em.z, ss_fine );
pSmax = pSmax - 10^-6; 

% for K waves
ztmp = em.z_cmb + 10^-6;
[pPmax,iflag] =  interp1db ( ztmp, em.z, sp_fine );
ztmp = em.z_iob - 10^-6;
[pPmin,iflag] =  interp1db ( ztmp, em.z, sp_fine );

% for P wave
ztmp = em.z_cmb - 10^-6;
[pPMmin,iflag] =  interp1db ( ztmp, em.z, sp_fine );

% find the maximum and minimum rayp for the phase
pmax = min(pPmax,pSmax);
pmin = max([pPmin,pSmin,pPMmin]);

dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = (j-1)* dp + pmin;
    rayp(j) = pj;
    zt= wise_turn_v3 (pj, [em.z_cmb em.z_iob],  em.z, sp_fine);
    zt = zt - 0.5*10^-6;
    [rtmp1, dtmp1]= tau (evdp, em.z_cmb ,pj, em.z, ss_fine);
    [rtmp2, dtmp2]= tau (em.z_cmb,zt,pj, em.z, sp_fine);
    [rtmp3, dtmp3]= tau (0,evdp,pj, em.z, ss_fine);
    zt_P = wise_turn_v3 (pj, [0 em.z_cmb],  em.z, sp_fine);
    zt_P = zt_P - 0.5*10^-6;
    [rtmp4, dtmp4] = tau (0, zt_P,pj, em.z, sp_fine);
    taup1(j) = 2* rtmp1 + 2*rtmp2 + rtmp3 + 2*rtmp4;
    dtaup1(j) = 2* dtmp1 + 2*dtmp2 + dtmp3 + 2*dtmp4;
end

end