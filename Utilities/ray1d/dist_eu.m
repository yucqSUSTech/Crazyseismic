% !/// Euclid distance (straight line) between any points within the spherical Earth /// 
function dist12 =  dist_eu ( r1, rlat1, rlon1, r2, rlat2, rlon2)
% !// r1, r2, dist12, [km]
% !// rlat1, rlat2, rlon1, rlon2 : [deg] 

pi = acos(-1.);
d2r = pi/180.;

colat1 = 90. - rlat1;
colat2 = 90. - rlat2;

z1 = r1 * cos ( colat1*d2r );
x1 = r1 * sin  ( colat1*d2r ) * cos ( rlon1 *d2r);
y1 = r1 * sin  ( colat1*d2r ) * sin ( rlon1 *d2r);

z2 = r2 * cos ( colat2*d2r );
x2 = r2 * sin  ( colat2*d2r ) * cos ( rlon2 *d2r);
y2 = r2 * sin  ( colat2*d2r ) * sin ( rlon2 *d2r);

dist12 = sqrt( (x1-x2)**2 + (y1-y2)**2 + (z1-z2) **2 );
return
% end subroutine dist_eu ;