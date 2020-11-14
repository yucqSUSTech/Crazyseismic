function  [rayp, taup1, dtaup1]= y_get_p_P_Pdiff (evdp, np, em)

mdist = 180*pi/180; % maximum distance for diffraction wave

em.vs(find(em.vs==0))=1e-9;
sp_fine = (em.re - em.z)./em.vp; 
ss_fine = (em.re - em.z)./em.vs;  

ztmp = em.z_cmb - 10^-6; 
[pmin,iflag] =  interp1db ( ztmp, em.z, sp_fine );

ztmp = evdp + 10^-6 ; 
[pmax,iflag] =  interp1db ( ztmp, em.z, sp_fine );

% for upgoing p wave
dp0 = ( pmax - 0) /(np -1);
for j =1: np
%     pj = pmax - (j-1)*dp0;
    pj = (j-1)* dp0 ;
    rayp(j) = pj;
    [rtmp2, dtmp2]= tau (0.0,evdp,pj, em.z, sp_fine);
    taup1(j) = rtmp2;
    dtaup1(j) = dtmp2;
end

dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = pmax - (j-1)*dp;
    rayp(np+j) = pj;
    zt= wise_turn_v3 (pj, [evdp em.z_cmb],  em.z, sp_fine);
    zt = zt - 0.5*10^-6;
    [rtmp1, dtmp1]= tau (evdp, zt ,pj, em.z, sp_fine);
    [rtmp2, dtmp2]= tau (0.0,evdp,pj, em.z, sp_fine);
    taup1(np+j) = 2* rtmp1 + rtmp2;
    dtaup1(np+j) = 2* dtmp1 + dtmp2;
end

% add diffrantion part
ddist = linspace(dtaup1(2*np),mdist,np+1) - dtaup1(2*np);
zt= wise_turn_v3 (pmin, [em.z_660 em.z_cmb],  em.z, sp_fine);
zt = zt - 0.5*10^-6;
[rtmp1, dtmp1]= tau (evdp, zt ,pmin, em.z, sp_fine);
[rtmp2, dtmp2]= tau (0.0,evdp,pmin, em.z, sp_fine);
for j = 1:np    

    dtaup1(2*np+j) = 2* dtmp1 + dtmp2 + ddist(j+1);
    taup1(2*np+j) = 2* rtmp1 + rtmp2 + 0;
    rayp(2*np+j) = pmin;
end

end
