function [ zdt  ] = y_get_raypath_Sdiff( evdp, em, np )

mdist = 155*pi/180; % maximum distance for diffraction wave

% Sdiff only have one rayp, so the input rayp is useless
z_fine = em.z;
re = em.re;
em.vs(find(em.vs==0)) = 1e-9;
sp_fine = (re-z_fine)./em.vp;
ss_fine = (re-z_fine)./em.vs;

zt = em.z_cmb - 0.001; 
[rayp,iflag] =  interp1db ( zt, z_fine, ss_fine );

pj = rayp;        
[rtmp1,dtmp1,dd1,zz1,etab1,edtab1] = tau_raypath_v2(evdp,zt,pj,z_fine,ss_fine);
[rtmp2,dtmp2,dd2,zz2,etab2,edtab2] = tau_raypath_v2(0,zt,pj,z_fine,ss_fine);

cetab1 = cumsum(etab1);
cedtab1 = cumsum(edtab1);
cetab2 = cumsum(etab2);
cedtab2 = cumsum(edtab2);

tt1 = cetab1 + pj.*cedtab1;
tt2 = cetab2 + pj.*cedtab2;

tt2 = tt2(end)-flipud(tt2);
zz2 = flipud(zz2);
dd2 = dd2(end)-flipud(dd2);

% np = 11;
dist_diff = linspace(dd1(end)+dd2(end),mdist,np) - (dd1(end)+dd2(end));
time_diff = dist_diff*rayp;
ddist = dist_diff(2)-dist_diff(1);
for i = 1:np
    
    nd_diff = round(dist_diff(i)/ddist*10) + 1;
    dd_diff = linspace(0,dist_diff(i),nd_diff);
    tt_diff = linspace(0,time_diff(i),nd_diff);
    dd_diff = reshape(dd_diff,[],1);
    tt_diff = reshape(tt_diff,[],1);
    zz_diff = em.z_cmb*ones(size(dd_diff));
    
    zdt(i).part.tt = real([tt1;tt1(end)+tt_diff(2:end);tt1(end)+tt_diff(end)+tt2(2:end)]);
    zdt(i).part.dd = 180/pi*real([dd1;dd1(end)+dd_diff(2:end);dd1(end)+dd_diff(end)+dd2(2:end)]);
    zdt(i).part.zz = real([zz1;zz_diff(2:end);zz2(2:end)]);
    
    zdt(i).part.theta = pi/180*zdt(i).part.dd;
    zdt(i).part.rr = em.re-zdt(i).part.zz;  
    
    zdt(i).part.ps = 'S';
end

end

