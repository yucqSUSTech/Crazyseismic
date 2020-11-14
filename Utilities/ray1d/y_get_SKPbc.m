function  [rayp, taup1, dtaup1]= y_get_SKPbc (evdp, np, em)

em.vs(find(em.vs==0))=1e-9;
sp_fine = (em.re - em.z)./em.vp; 
ss_fine = (em.re - em.z)./em.vs; 

% for P in the mantle
pPMmin = 0;
ztmp = em.z_cmb; 
[pPMmax,iflag] =  interp1db ( ztmp, em.z, sp_fine );
pPMmax = pPMmax - 10^-6;

% for K in outer core
ztmp = em.z_cmb + 10^-6;
[pPOmax,iflag] =  interp1db ( ztmp, em.z, sp_fine );
ztmp = em.z_iob - 10^-6;
[pPOmin,iflag] =  interp1db ( ztmp, em.z, sp_fine );

% find the maximum and minimum rayp for the phase
pmax = min(pPMmax,pPOmax);
pmin = max(pPMmin,pPOmin);

dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = (j-1)* dp + pmin;
    rayp(j) = pj;
    zt= wise_turn_v3 (pj, [em.z_cmb em.z_iob],  em.z, sp_fine);
    zt = zt - 0.5*10^-6;
    [rtmp1, dtmp1]= tau (evdp, em.z_cmb ,pj, em.z, ss_fine);
    [rtmp2, dtmp2]= tau (em.z_cmb, zt ,pj, em.z, sp_fine);
    [rtmp3, dtmp3]= tau (0.0,em.z_cmb,pj, em.z, sp_fine);
    taup1(j) = rtmp1 + 2*rtmp2 + rtmp3;
    dtaup1(j) = dtmp1 + 2*dtmp2 + dtmp3;
end

% extract -bc branches 
[dmin, imin] = min( dtaup1); 
rayp = rayp(imin:-1:1);
taup1 = taup1(imin:-1:1);
dtaup1 = dtaup1(imin:-1:1);

end
