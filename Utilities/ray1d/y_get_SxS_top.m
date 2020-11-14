function  [rayp, taup1, dtaup1]= y_get_SxS_top (evdp, np, em, xdep)

if evdp > xdep
    rayp = [];
    taup1 = [];
    dtaup1 = [];
    return;
end

em.vs(find(em.vs==0))=1e-9;
sp_fine = (em.re - em.z)./em.vp; 
ss_fine = (em.re - em.z)./em.vs; 

ztmp = xdep; 
[pmax,iflag] =  interp1db ( ztmp, em.z, ss_fine );

pmin = 0;

dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = (j-1)* dp + pmin;
    rayp(j) = pj;
    zt = ztmp - 10^-6;
    [rtmp1, dtmp1]= tau (evdp, zt ,pj, em.z, ss_fine);
    [rtmp2, dtmp2]= tau (0.0,zt,pj, em.z, ss_fine);
    taup1(j) = rtmp1 +  rtmp2;
    dtaup1(j) = dtmp1 +  dtmp2;
end

end