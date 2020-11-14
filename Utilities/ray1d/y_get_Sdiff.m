function  [rayp, taup1, dtaup1]= y_get_Sdiff (evdp, np, em)

mdist = 180*pi/180; % maximum distance for diffraction wave

em.vs(find(em.vs==0))=1e-9;
sp_fine = (em.re - em.z)./em.vp; 
ss_fine = (em.re - em.z)./em.vs; 

ztmp = em.z_cmb; 
[pmin,iflag] =  interp1db ( ztmp, em.z, ss_fine );

zt= wise_turn_v2 (pmin, em.z_660,  em.z, ss_fine);
zt = zt - 10^-6;
[rtmp1, dtmp1]= tau (evdp, zt ,pmin, em.z, ss_fine);
[rtmp2, dtmp2]= tau (0.0,evdp,pmin, em.z, ss_fine);

% diffraction
ddist = linspace(2*dtmp1+dtmp2,mdist,np) - (2*dtmp1+dtmp2);
for j = 1:np    
    zt= wise_turn_v3 (pmin, [em.z_660 em.z_cmb],  em.z, ss_fine);
    zt = zt - 0.5*10^-6;
    [rtmp1, dtmp1]= tau (evdp, zt ,pmin, em.z, ss_fine);
    [rtmp2, dtmp2]= tau (0.0,evdp,pmin, em.z, ss_fine);

    dtaup1(j) = 2* dtmp1 + dtmp2 + ddist(j);
    taup1(j) = 2* rtmp1 + rtmp2 + 0;
    rayp(j) = pmin;
end

end
