function  [rayp, taup1, dtaup1]= y_get_PKJKP (evdp, np, em)

em.vs(find(em.vs==0))=1e-9;
sp_fine = (em.re - em.z)./em.vp; 
ss_fine = (em.re - em.z)./em.vs; 

pmin = 0;

ztmp = em.z_cmb;
[pmax1,iflag] =  interp1db ( ztmp, em.z, sp_fine );
ztmp = em.z_iob;
[pmax2,iflag] = interp1db ( ztmp, em.z, sp_fine );
ztmp = em.z_iob + 10^-6;
[pmax3,iflag] = interp1db ( ztmp, em.z, ss_fine );

pmax = min([pmax1,pmax2,pmax3]);

dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = (j-1)* dp + pmin;
    rayp(j) = pj;
    zt_s= wise_turn_v3 (pj, [em.z_iob em.re],  em.z, ss_fine);
    zt_s = zt_s - 0.5*10^-6;
    [rtmp1, dtmp1]= tau (evdp, em.z_iob-10^-6 ,pj, em.z, sp_fine);
    [rtmp2, dtmp2]= tau (em.z_iob+10^-6, zt_s ,pj, em.z, ss_fine);
    [rtmp3, dtmp3]= tau (0.0, em.z_iob-10^-6 ,pj, em.z, sp_fine);
    taup1(j) = rtmp1 + 2*rtmp2 + rtmp3;
    dtaup1(j) = dtmp1 + 2*dtmp2 + dtmp3;
    
    if pj == 0
        dtaup1(j) = pi;
    end
end

end
