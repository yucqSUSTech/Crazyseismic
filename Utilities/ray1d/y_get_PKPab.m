function  [rayp, taup1, dtaup1]= y_get_PKPab (evdp, np, em)

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
    [rtmp1, dtmp1]= tau (evdp, zt ,pj, em.z, sp_fine);
    [rtmp2, dtmp2]= tau (0.0,evdp,pj, em.z, sp_fine);
    taup1(j) = 2* rtmp1 + rtmp2;
    dtaup1(j) = 2* dtmp1 + dtmp2;
end

% extract -ab branches 
[dmin, imin] = min( dtaup1); 
rayp = rayp(end:-1:imin);
taup1 = taup1(end:-1:imin);
dtaup1 = dtaup1(end:-1:imin);

end
