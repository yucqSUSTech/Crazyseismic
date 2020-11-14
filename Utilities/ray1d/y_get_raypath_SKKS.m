function [ zdt  ] = y_get_raypath_SKKS( evdp, rayp, em )

z_fine = em.z;
re = em.re;
em.vs(find(em.vs==0)) = 1e-9;
sp_fine = (re-z_fine)./em.vp;
ss_fine = (re-z_fine)./em.vs;

for i = 1:length(rayp)
    pj = rayp(i);
    zt= wise_turn_v3 (pj, [em.z_cmb em.z_iob],  z_fine, sp_fine);
    [rtmp1,dtmp1,dd1,zz1,etab1,edtab1] = tau_raypath_v2(evdp,em.z_cmb,pj,z_fine,ss_fine);
    [rtmp2,dtmp2,dd2,zz2,etab2,edtab2] = tau_raypath_v2(em.z_cmb,zt,pj,z_fine,sp_fine);
    [rtmp6,dtmp6,dd6,zz6,etab6,edtab6] = tau_raypath_v2(0,em.z_cmb,pj,z_fine,ss_fine);
    
    cetab1 = cumsum(etab1);
    cedtab1 = cumsum(edtab1);
    cetab2 = cumsum(etab2);
    cedtab2 = cumsum(edtab2);
    cetab6 = cumsum(etab6);
    cedtab6 = cumsum(edtab6);
    
    tt1 = cetab1 + pj.*cedtab1;
    tt2 = cetab2 + pj.*cedtab2;
    tt3 = tt2(end)-flipud(tt2);
    tt4 = tt2;
    tt5 = tt3;
    tt6 = cetab6 + pj.*cedtab6;
    tt6 = tt6(end)-flipud(tt6);
    dd3 = dd2(end)-flipud(dd2);
    dd4 = dd2;
    dd5 = dd3;
    dd6 = dd6(end)-flipud(dd6);
    zz3 = flipud(zz2);
    zz4 = zz2;
    zz5 = zz3;
    zz6 = flipud(zz6);

    zdt(i).part(1).tt = real(tt1);
    zdt(i).part(2).tt = real([tt1(end)+tt2;tt1(end)+tt2(end)+tt3(2:end);tt1(end)+tt2(end)+tt3(end)+tt4(2:end);tt1(end)+tt2(end)+tt3(end)+tt4(end)+tt5(2:end)]);
    zdt(i).part(3).tt = real(tt1(end)+tt2(end)+tt3(end)+tt4(end)+tt5(end)+tt6);
    zdt(i).part(1).dd = 180/pi*real(dd1);
    zdt(i).part(2).dd = 180/pi*real([dd1(end)+dd2;dd1(end)+dd2(end)+dd3(2:end);dd1(end)+dd2(end)+dd3(end)+dd4(2:end);dd1(end)+dd2(end)+dd3(end)+dd4(end)+dd5(2:end)]);
    zdt(i).part(3).dd = 180/pi*real(dd1(end)+dd2(end)+dd3(end)+dd4(end)+dd5(end)+dd6);
    zdt(i).part(1).zz = real(zz1);
    zdt(i).part(2).zz = real([zz2;zz3(2:end);zz4(2:end);zz5(2:end)]);
    zdt(i).part(3).zz = zz6;
    
    zdt(i).part(1).theta = pi/180*zdt(i).part(1).dd;
    zdt(i).part(2).theta = pi/180*zdt(i).part(2).dd;
    zdt(i).part(3).theta = pi/180*zdt(i).part(3).dd;
    zdt(i).part(1).rr = em.re-zdt(i).part(1).zz; 
    zdt(i).part(2).rr = em.re-zdt(i).part(2).zz; 
    zdt(i).part(3).rr = em.re-zdt(i).part(3).zz; 
    
    zdt(i).part(1).ps = 'S';
    zdt(i).part(2).ps = 'P';
    zdt(i).part(3).ps = 'S';
end

end

