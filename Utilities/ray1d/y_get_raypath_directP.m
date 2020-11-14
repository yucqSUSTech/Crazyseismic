function [ zdt  ] = y_get_raypath_directP( evdp, rayp, em )

z_fine = em.z;
re = em.re;
em.vs(find(em.vs==0)) = 1e-9;
sp_fine = (re-z_fine)./em.vp;
ss_fine = (re-z_fine)./em.vs;

for i = 1:length(rayp)
    pj = rayp(i);
    zt = wise_turn_v3(pj,[em.z_660 em.z_cmb],z_fine,sp_fine);
    
    [rtmp1,dtmp1,dd1,zz1,etab1,edtab1] = tau_raypath_v2(evdp,zt,pj,z_fine,sp_fine);
    [rtmp2,dtmp2,dd2,zz2,etab2,edtab2] = tau_raypath_v2(0,zt,pj,z_fine,sp_fine);
    
    cetab1 = cumsum(etab1);
    cedtab1 = cumsum(edtab1);
    cetab2 = cumsum(etab2);
    cedtab2 = cumsum(edtab2);
    
    tt1 = cetab1 + pj.*cedtab1;
    tt2 = cetab2 + pj.*cedtab2;
    
    tt2 = tt2(end)-flipud(tt2);
    zz2 = flipud(zz2);
    dd2 = dd2(end)-flipud(dd2);

    zdt(i).part.tt = real([tt1;tt1(end)+tt2(2:end)]);
    zdt(i).part.dd = 180/pi*real([dd1;dd1(end)+dd2(2:end)]);
    zdt(i).part.zz = real([zz1;zz2(2:end)]);
    
    zdt(i).part.theta = pi/180*zdt(i).part.dd;
    zdt(i).part.rr = em.re-zdt(i).part.zz;  
    
    zdt(i).part.ps = 'P';
end

end

