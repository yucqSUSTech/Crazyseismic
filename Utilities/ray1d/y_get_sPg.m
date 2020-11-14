function  [rayp, taup1, dtaup1]= y_get_sPg (evdp, np, em)

em.vs(find(em.vs==0))=1e-9;
sp_fine = (em.re - em.z)./em.vp; 
ss_fine = (em.re - em.z)./em.vs;  

% if evdp > em.z_moho
%     fprintf('Event below Moho, No sPg phase');
%     rayp = zeros(1,np);
%     taup1 = nan(1,np);
%     dtaup1 = linspace(0,1,np)*2*pi;
%     return;
% end
ztmp = em.z_moho - 10^-6; 
[pmin,iflag] =  interp1db ( ztmp, em.z, sp_fine );

ztmp = 0 + 10^-6; 
[pmax1,iflag] =  interp1db ( ztmp, em.z, sp_fine );
[pmax2,iflag] =  interp1db ( evdp+10^-6, em.z, ss_fine );
pmax = min([pmax1,pmax2]) - 10^-6;

% % for upgoing p wave
% dp0 = ( pmax - 0) /(np -1);
% for j =1: np
% %     pj = pmax - (j-1)*dp0;
%     pj = (j-1)* dp0 ;
%     rayp(j) = pj;
%     [rtmp2, dtmp2]= tau (0.0,evdp,pj, em.z, sp_fine);
%     taup1(j) = rtmp2;
%     dtaup1(j) = dtmp2;
% end

% for downgoing Pg wave in the crust
dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = pmax - (j-1)*dp;
    rayp(j) = pj;
    zt= wise_turn_v3 (pj, [0 em.z_moho],  em.z, sp_fine);
    zt = zt - 0.5*10^-6;
    [rtmp1, dtmp1]= tau (0.0,evdp,pj, em.z, ss_fine);
    [rtmp2, dtmp2]= tau (0.0,zt,pj, em.z, sp_fine);
    taup1(j) = rtmp1 + 2*rtmp2;
    dtaup1(j) = dtmp1 + 2*dtmp2;
end


end
