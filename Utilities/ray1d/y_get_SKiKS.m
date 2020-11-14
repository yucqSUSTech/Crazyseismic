function  [rayp, taup1, dtaup1]= y_get_SKiKS (evdp, np, em)

em.vs(find(em.vs==0))=1e-9;
sp_fine = (em.re - em.z)./em.vp; 
ss_fine = (em.re - em.z)./em.vs; 

ztmp = em.z_iob;
[pmax,iflag] =  interp1db ( ztmp, em.z, sp_fine );
pmax = pmax - 10^-6;

pmin = 0;

dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = (j-1)* dp + pmin;
    rayp(j) = pj;
    [rtmp1, dtmp1]= tau (evdp, em.z_cmb ,pj, em.z, ss_fine);
    [rtmp2, dtmp2]= tau (em.z_cmb,em.z_iob,pj, em.z, sp_fine);
    [rtmp3, dtmp3]= tau (0,evdp,pj, em.z, ss_fine);
    taup1(j) = 2* rtmp1 + 2*rtmp2 + rtmp3;
    dtaup1(j) = 2* dtmp1 + 2*dtmp2 + dtmp3;
end


end


