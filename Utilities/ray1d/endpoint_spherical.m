function [rlat2, rlon2] = endpoint_spherical (rlat1, rlon1,  raz, rdeg)
% [rlat2, rlon2] = endpoint_spherical (rlat1, rlon1,  raz, rdeg)
% given starting point [rlat1, rlon1] and azimuth 'raz' and travel distance 'rdeg'
%// find the end point on the spherical Earth 
%
% Author: Yingcai Zheng , mit, 2010
% 
 pi = acos(-1.); 
 r2d = 180./pi; 
 d2r = pi /180.; 
 re = 6371.; 
 lat1 = rlat1 * d2r;
 long1 = rlon1 *d2r;
 rlat2 = asin( sin(lat1)*cos(rdeg*d2r) + ...
               cos(lat1)*sin(rdeg*d2r)*cos(raz*d2r) ) *r2d;
 rlon2 = (long1 + atan2( sin(raz*d2r)*sin(rdeg*d2r)*cos(lat1), ...
                        cos(rdeg*d2r)-sin(lat1)*sin(rlat2*d2r))) *r2d;
 rlon2 = mod( rlon2 +360., 360.) ;
return
