function [ zdt  ] = y_get_raypath_PKJKP( evdp, rayp, em )

z_fine = em.z;
re = em.re;
em.vs(find(em.vs==0)) = 1e-9;
sp_fine = (re-z_fine)./em.vp;
ss_fine = (re-z_fine)./em.vs;

for i = 1:length(rayp)
    pj = rayp(i);
    zt_s= wise_turn_v3 (pj, [em.z_iob em.re],  em.z, ss_fine);
    zt_s = zt_s - 0.5*10^-6;
    
    [rtmp1,dtmp1,dd1,zz1,etab1,edtab1] = tau_raypath_v2(evdp,em.z_iob,pj,z_fine,sp_fine);
    [rtmp2,dtmp2,dd2,zz2,etab2,edtab2] = tau_raypath_v2(em.z_iob,zt_s,pj,z_fine,ss_fine);
    [rtmp3,dtmp3,dd3,zz3,etab3,edtab3] = tau_raypath_v2(0,em.z_iob,pj,z_fine,sp_fine);
    
    cetab1 = cumsum(etab1);
    cedtab1 = cumsum(edtab1);
    cetab2 = cumsum(etab2);
    cedtab2 = cumsum(edtab2);    
    cetab3 = cumsum(etab3);
    cedtab3 = cumsum(edtab3);
    
    tt1 = cetab1 + pj.*cedtab1;
    tt2 = cetab2 + pj.*cedtab2;
    tt3 = tt2(end)-flipud(tt2);
    tt4 = cetab3 + pj.*cedtab3;
    tt4 = tt4(end)-flipud(tt4);  
    dd4 = dd3(end)-flipud(dd3);
    dd3 = dd2(end)-flipud(dd2);
    zz4 = flipud(zz3);
    zz3 = flipud(zz2);

    zdt(i).part(1).tt = real(tt1);   
    zdt(i).part(2).tt = real([tt1(end)+tt2;tt1(end)+tt2(end)+tt3(2:end)]);
    zdt(i).part(3).tt = real(tt1(end)+tt2(end)+tt3(end)+tt4(2:end));
    zdt(i).part(1).dd = 180/pi*real(dd1);
    zdt(i).part(2).dd = 180/pi*real([dd1(end)+dd2;dd1(end)+dd2(end)+dd3(2:end)]);
    zdt(i).part(3).dd = 180/pi*real(dd1(end)+dd2(end)+dd3(end)+dd4(2:end));
    zdt(i).part(1).zz = real(zz1);
    zdt(i).part(2).zz = real([zz2;zz3(2:end)]);
    zdt(i).part(3).zz = real(zz4(2:end));
    
    zdt(i).part(1).theta = pi/180*zdt(i).part(1).dd;
    zdt(i).part(2).theta = pi/180*zdt(i).part(2).dd;
    zdt(i).part(3).theta = pi/180*zdt(i).part(3).dd;
    zdt(i).part(1).rr = em.re-zdt(i).part(1).zz;  
    zdt(i).part(2).rr = em.re-zdt(i).part(2).zz; 
    zdt(i).part(3).rr = em.re-zdt(i).part(3).zz; 
    
    zdt(i).part(1).ps = 'P';
    zdt(i).part(2).ps = 'S';
    zdt(i).part(3).ps = 'P';
end

end

