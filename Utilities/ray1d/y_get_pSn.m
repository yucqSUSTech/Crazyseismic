function  [rayp, taup1, dtaup1]= y_get_pSn (evdp, np, em)

mdist = 20*pi/180; % maximum distance for Sn wave

em.vs(find(em.vs==0))=1e-9;
sp_fine = (em.re - em.z)./em.vp; 
ss_fine = (em.re - em.z)./em.vs; 

if evdp > em.z_moho
    fprintf('Event below Moho, No pSn phase\n');
    rayp = zeros(1,np);
    taup1 = nan(1,np);
    dtaup1 = linspace(0,1,np)*2*pi;
    return;
end

ztmp = em.z_moho + 10^-6; 
[pmin,iflag] =  interp1db ( ztmp, em.z, ss_fine );
[pmin1,iflag] = interp1db ( evdp, em.z,sp_fine);
if pmin > pmin1
    fprintf('No pSn phase\n');
    rayp = zeros(1,np);
    taup1 = nan(1,np);
    dtaup1 = linspace(0,1,np)*2*pi;
    return;
end
    
% zt= wise_turn_v3 (pmin, [0 em.z_moho],  em.z, sp_fine);
% zt = zt - 0.5*10^-6;
zt = em.z_moho;
[rtmp1, dtmp1]= tau (0.0, evdp, pmin, em.z, sp_fine);
[rtmp2, dtmp2]= tau (0.0, zt, pmin, em.z, ss_fine);

% diffraction
ddist = linspace(dtmp1+2*dtmp2,mdist,np) - (dtmp1+2*dtmp2);
for j = 1:np    

    dtaup1(j) = dtmp1 + 2*dtmp2 + ddist(j);
    taup1(j) = rtmp1 + 2*rtmp2 + 0;
    rayp(j) = pmin;
end

end
