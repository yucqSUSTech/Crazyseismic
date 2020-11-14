function  [rayp, taup1, dtaup1]= y_get_SsPmp (zdep, np, em)
%  [rayp, taup1, dtaup1]= get_directP (zdep, np, em)
% zdep: source depth (km) 
% np: no of ray parameters 
% em: Earth Model 
% 
z_fine = em.z; 
re = em.re; 
em.vs(find(em.vs==0))=1e-9;
sp_fine = (re - z_fine)./em.vp; 
sp_fine_s = (re - z_fine)./em.vs; 

ztmp = em.z_cmb -1; 
[pmin,iflag] =  interp1db ( ztmp, z_fine, sp_fine_s );
if (iflag ~=1) ,
    disp( 'get_SsPmp: Error\n');
    pause;
end

ztmp = max( em.z_660 , zdep) + 1 ; 
[pmax,iflag] =  interp1db ( ztmp, z_fine, sp_fine_s );
if (iflag ~=1) ,
    disp( 'get_SsPmp: Error\n');
    pause;
end

dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = (j-1)* dp + pmin;
    rayp(j) = pj;
    zt_s= wise_turn_v2 (pj, em.z_660,  z_fine, sp_fine_s);
    zt_s = zt_s - .001;
    zt_p= wise_turn_v2 (pj, 0,  z_fine, sp_fine);
    zt_p = zt_p - .001;
    [rtmp1, dtmp1]=  tau (zdep, zt_s ,pj, z_fine, sp_fine_s);
    [rtmp2, dtmp2]= tau ( 0.0, zt_s ,pj, z_fine, sp_fine_s);
    [rtmp3, dtmp3]= tau ( 0.0, zt_p ,pj, z_fine, sp_fine);
    taup1(j) = rtmp1 + rtmp2 + 2*rtmp3;
    dtaup1(j) = dtmp1 + dtmp2 + 2*dtmp3;
end

end