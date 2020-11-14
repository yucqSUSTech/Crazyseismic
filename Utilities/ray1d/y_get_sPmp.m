function  [rayp, taup1, dtaup1]= y_get_sPmp (evdp, np, em)

em.vs(find(em.vs==0))=1e-9;
sp_fine = (em.re - em.z)./em.vp; 
ss_fine = (em.re - em.z)./em.vs; 

% if evdp > em.z_moho
%     fprintf('Event below Moho, No sPmp phase');    
%     rayp = zeros(1,np);
%     taup1 = nan(1,np);
%     dtaup1 = linspace(0,1,np)*2*pi;
%     return;
% end

ztmp = em.z_moho - 10^-6; 
[pmax1,iflag] =  interp1db ( ztmp, em.z, sp_fine );
[pmax2,iflag] =  interp1db ( evdp, em.z, ss_fine );
pmax = min([pmax1,pmax2]) - 10^-6;

pmin = 0;

dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = (j-1)* dp + pmin;
    rayp(j) = pj;
    zt = em.z_moho - 0.5*10^-6;
    [rtmp1, dtmp1]= tau (0.0, evdp ,pj, em.z, ss_fine);
    [rtmp2, dtmp2]= tau (0.0,zt,pj, em.z, sp_fine);
    taup1(j) = rtmp1 +  2*rtmp2;
    dtaup1(j) = dtmp1 + 2*dtmp2;
end

end