
% !//-----------------------------------------------------
function raypath_PKIKP ( rayp0, azi, evla, evlo, evdp,  plat, plon, rayz, sdist, ns) 
% !/ given ray par 'rayp0' [s/deg] and azimuth 
% !// get : 
% !// ray path , plat() , plon(), rayz() 
real rayp0,  evla, evlo, evdp,azi 
real vf(NL2), zf(NL2), theta(NL2), sf(NL2) 
real plat(*), plon(*),rayz(*) ,sdist(*) !// returned path 
parameter (nlegmax = 10000) 
real z1(nlegmax), z2 (nlegmax), delta (nlegmax) 
integer nlayer, ns
nlayer = NL2
vf(1:NL2) = vp_fine (1:NL2)
sf(1:NL2) = sp_fine (1:NL2) 
zf(1:NL2) = z_fine (1:NL2)

pi = acos(-1.)
r2d = 180./pi

zmin = z_iob  - 100. 
p0 = rayp0 * r2d 
call wise_turn_v2 (p0, zmin, zt, zf, sf, nl2)
zt = zt - .01 

!/ downgoing path 
 k = 0 
nseg1 = 1000
dz = (zt - evdp ) / nseg1 
do iseg = 1, nseg1 
  za = evdp + (iseg -1)* dz 
  zb = za + dz 
  call tau (za, zb, p0, tab, dtab, zf, sf, nl2)
 k = k + 1 
 z1 (k) = za 
 z2(k) = zb 
 delta (k) = dtab  
!print*,' ---',k, za, zb 
enddo 

!/ upgoing path 
nseg2 = nseg1 
dz = (zt - 0.) / nseg2 
do iseg = nseg2, 1, -1 
  zb = iseg * dz 
  za = amax1 (.0, zb - dz) 
!print*,' ---', k, za, zb 
  call tau (za, zb, p0, tab, dtab, zf, sf, nl2)
  k = k + 1 
  z1(k)  = zb  !/ starting 
  z2(k) = za  !/ endign 
  delta (k) = dtab 
enddo 
nseg = k 

print*,'nseg', nseg 
!// convert to lat, lon 

gcarc = .0 
k = 1 
plat(k) = evla
plon(k) = evlo 
rayz(k) = evdp 
sdist(k) = 0. 
k = k + 1 
do j =1, nseg 
 gcarc = gcarc + delta (j) * r2d 
 call endpoint_spherical( evla, evlo,  rlatj, rlonj, azi, gcarc )  
 plat(k) = rlatj 
 plon(k) = rlonj 
 rayz(k) = z2(j) 
 sdist(k) = gcarc 
k = k + 1 
enddo 
ns =k  - 1 

if (ns > nlegmax ) stop 'kdjfk39xkjfkdfj k2923 ' 
end subroutine raypath_PKIKP 