function  [rayp, taup1, dtaup1]= y_get_PKIKP (zdep, np, em)
% !//     'pmin' is ~ 0, i.e., straight through the center of the Earth
% !// 	'pmax' is slightly > p_iob
% real zdep
% real rayp(*), taup1(*), dtaup1(*)
% integer np ,iflag
% real pj , ztmp, ztmp2 ,pmin, pmax , zt

z_iob = em.z_iob;
z_fine = em.z; 
re = em.re; 
sp_fine = (re - z_fine)./em.vp; 

ztmp = z_iob + .1;
[pmax,iflag] =  interp1db ( ztmp, z_fine, sp_fine );
if (iflag ~=1) ,
    disp( 'kxkj3x22 e2sdfafvadf ');
    pause;
end

% pmin = 3.;
ztmp2 = re - 100; 
[pmin,iflag] =  interp1db ( ztmp2, z_fine, sp_fine );
% pmin = pmin 

dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = (j-1)* dp + pmin;
    rayp(j) = pj;
    zmin = z_iob;
    zt= wise_turn_v2 (pj, zmin,  z_fine, sp_fine);
    if ( zt < zdep ) ,
        disp( 'here is a problem in get_PKIKP ') ;
        pause;
    end
     zt = zt - .1;
    [rtmp1, dtmp1]=  tau (zdep, zt ,pj, z_fine, sp_fine);
    [rtmp2, dtmp2]= tau ( 0.0,zdep,pj, z_fine, sp_fine);
    taup1(j) = 2* rtmp1 + rtmp2;
    dtaup1(j) = 2* dtmp1 + dtmp2;
end

end
% end subroutine get_PKIKP
