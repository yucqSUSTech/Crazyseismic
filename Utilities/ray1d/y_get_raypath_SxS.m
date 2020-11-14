function [ zdt  ] = y_get_raypath_SxS( evdp, rayp, em, xdep )

z_fine = em.z;
re = em.re;
em.vs(find(em.vs==0)) = 1e-9;
sp_fine = (re-z_fine)./em.vp;
ss_fine = (re-z_fine)./em.vs;

for i = 1:length(rayp)
    pj = rayp(i);
    zt = wise_turn_v3(pj,[em.z_660 em.z_cmb],z_fine,ss_fine);
    
    [rtmp1,dtmp1,dd1,zz1,etab1,edtab1] = tau_raypath_v2(evdp,zt,pj,z_fine,ss_fine);
    [rtmp2,dtmp2,dd2,zz2,etab2,edtab2] = tau_raypath_v2(xdep,zt,pj,z_fine,ss_fine);
    [rtmp4,dtmp4,dd4,zz4,etab4,edtab4] = tau_raypath_v2(0,zt,pj,z_fine,ss_fine);
    
    cetab1 = cumsum(etab1);
    cedtab1 = cumsum(edtab1);
    cetab2 = cumsum(etab2);
    cedtab2 = cumsum(edtab2);   
    cetab4 = cumsum(etab4);
    cedtab4 = cumsum(edtab4);
    
    tt1 = cetab1 + pj.*cedtab1;
    tt2 = cetab2 + pj.*cedtab2;
    tt4 = cetab4 + pj.*cedtab4;
    tt3 = tt2;
    tt4 = tt4(end)-flipud(tt4);
    tt2 = tt2(end)-flipud(tt2);    
    dd3 = dd2;
    dd4 = dd4(end)-flipud(dd4);
    dd2 = dd2(end)-flipud(dd2);
    zz3 = zz2;
    zz4 = flipud(zz4);
    zz2 = flipud(zz2);

    zdt(i).part(1).tt = real([tt1;tt1(end)+tt2(2:end)]);   
    zdt(i).part(2).tt = real([tt1(end)+tt2(end)+tt3;tt1(end)+tt2(end)+tt3(end)+tt4(2:end)]);
    zdt(i).part(1).dd = 180/pi*real([dd1;dd1(end)+dd2(2:end)]);
    zdt(i).part(2).dd = 180/pi*real([dd1(end)+dd2(end)+dd3;dd1(end)+dd2(end)+dd3(end)+dd4(2:end)]);
    zdt(i).part(1).zz = real([zz1;zz2(2:end)]);
    zdt(i).part(2).zz = real([zz3;zz4(2:end)]);
    
    zdt(i).part(1).theta = pi/180*zdt(i).part(1).dd;
    zdt(i).part(2).theta = pi/180*zdt(i).part(2).dd;
    zdt(i).part(1).rr = em.re-zdt(i).part(1).zz;  
    zdt(i).part(2).rr = em.re-zdt(i).part(2).zz; 
    
    zdt(i).part(1).ps = 'S';
    zdt(i).part(2).ps = 'S';
end

end

