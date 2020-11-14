function  [rayp, taup1, dtaup1]= y_get_Sn (evdp, np, em)

mdist = 20*pi/180; % maximum distance for Pn wave

em.vs(find(em.vs==0))=1e-9;
sp_fine = (em.re - em.z)./em.vp; 
ss_fine = (em.re - em.z)./em.vs; 

if evdp > em.z_moho
    fprintf('Event below Moho, No Sn phase');
    rayp = zeros(1,np);
    taup1 = nan(1,np);
    dtaup1 = linspace(0,1,np)*2*pi;
    return;
end

ztmp = em.z_moho + 10^-6; 
[pmin,iflag] =  interp1db ( ztmp, em.z, ss_fine );

% zt= wise_turn_v3 (pmin, [0 em.z_moho],  em.z, ss_fine);
% zt = zt - 0.5*10^-6;
zt = em.z_moho;
[rtmp1, dtmp1]= tau (evdp, zt ,pmin, em.z, ss_fine);
[rtmp2, dtmp2]= tau (0.0,evdp,pmin, em.z, ss_fine);

% diffraction
ddist = linspace(2*dtmp1+dtmp2,mdist,np) - (2*dtmp1+dtmp2);
for j = 1:np    

    dtaup1(j) = 2* dtmp1 + dtmp2 + ddist(j);
    taup1(j) = 2* rtmp1 + rtmp2 + 0;
    rayp(j) = pmin;
end

end
