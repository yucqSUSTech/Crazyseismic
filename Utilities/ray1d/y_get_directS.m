function  [rayp, taup1, dtaup1]= y_get_directS (evdp, np, em)

em.vs(find(em.vs==0))=1e-9;
sp_fine = (em.re - em.z)./em.vp; 
ss_fine = (em.re - em.z)./em.vs; 

ztmp = em.z_cmb - 10^-6; 
[pmin,iflag] =  interp1db ( ztmp, em.z, ss_fine );

ztmp = max( em.z_660 , evdp) + 10^-6 ; 
[pmax,iflag] =  interp1db ( ztmp, em.z, ss_fine );

dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = (j-1)* dp + pmin;
    rayp(j) = pj;
    zt= wise_turn_v3 (pj, [em.z_660 em.z_cmb],  em.z, ss_fine);
    zt = zt - 0.5*10^-6;
    [rtmp1, dtmp1]= tau (evdp, zt ,pj, em.z, ss_fine);
    [rtmp2, dtmp2]= tau (0.0,evdp,pj, em.z, ss_fine);
    taup1(j) = 2* rtmp1 + rtmp2;
    dtaup1(j) = 2* dtmp1 + dtmp2;
end

end
