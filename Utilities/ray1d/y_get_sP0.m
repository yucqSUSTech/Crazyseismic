function  [rayp, taup1, dtaup1]= y_get_sP0 (evdp, np, em)

% upgoing s; P0 is a head wave along the surface

mdist = 2*pi/180; % maximum distance for sP0 wave

em.vs(find(em.vs==0))=1e-9;
sp_fine = (em.re - em.z)./em.vp; 
ss_fine = (em.re - em.z)./em.vs;  


ztmp = evdp; 
[pmax1,iflag] =  interp1db ( ztmp, em.z, ss_fine );

ztmp = 0; 
[pmax,iflag] =  interp1db ( ztmp, em.z, sp_fine );

if pmax1 < pmax
    fprintf('No sP0 phase');
    rayp = zeros(1,np);
    taup1 = nan(1,np);
    dtaup1 = linspace(0,1,np)*2*pi;
    return;
end
    
[rtmp1, dtmp1]= tau (0.0, evdp, pmax, em.z, ss_fine);

% diffraction
ddist = linspace(dtmp1,mdist,np) - dtmp1;
for j = 1:np    

    dtaup1(j) = dtmp1 + ddist(j);
    taup1(j) = rtmp1 + 0;
    rayp(j) = pmax;
end


end
