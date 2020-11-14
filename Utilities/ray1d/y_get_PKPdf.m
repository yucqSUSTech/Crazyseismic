function  [rayp, taup1, dtaup1]= y_get_PKPdf (evdp, np, em)

em.vs(find(em.vs==0))=1e-9;
sp_fine = (em.re - em.z)./em.vp; 
ss_fine = (em.re - em.z)./em.vs; 

ztmp = em.z_iob + 10^-6;
[pmax,iflag] =  interp1db ( ztmp, em.z, sp_fine );

% ztmp = em.re - 10^-6; 
% [pmin,iflag] =  interp1db ( ztmp, em.z, sp_fine );
pmin = 0;

dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = (j-1)* dp + pmin;
    rayp(j) = pj;
    zt= wise_turn_v3 (pj, [em.z_iob em.re],  em.z, sp_fine);
    zt = zt - 0.5*10^-6;
    [rtmp1, dtmp1]=  tau (evdp, zt ,pj, em.z, sp_fine);
    [rtmp2, dtmp2]= tau ( 0.0,evdp,pj, em.z, sp_fine);
    taup1(j) = 2* rtmp1 + rtmp2;
    dtaup1(j) = 2* dtmp1 + dtmp2;
    if pj == 0
        dtaup1(j) = pi;
    end
end

end
