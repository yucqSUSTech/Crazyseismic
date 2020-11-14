% test tau model 
clear;
close all;   
clc; 

r2d = 180/pi; 
d2r = pi/180; 

% use a velocity model 
em = set_vmodel ('iasp91'); 

% refine model 
thmax = 4; 
emf = refinemodel(em, thmax); 
z_fine = emf.z; 
sp_fine = (emf.re - z_fine)./ emf.vp; 

  figure; 
  plot( z_fine , sp_fine); 
  grid on;
  
% break; 
  
% test turning point 

rayp0 = 200; 
zmin = emf.z_cmb + 200; 
zt = wise_turn_v2 (rayp0, zmin, z_fine, sp_fine) ; 

% break; 
% test PKIKP 

np = 100; 
zdep = 300; 
 [rayp, taup, Xp]= get_PKIKP (zdep, np, em); 
t1 = taup + rayp.* Xp; 
figure; 
plot ( Xp*r2d, t1); 

% test PKP-bc, -ab 
[p2, taup2, dtaup2]= get_PKP (zdep, np, em); 
t2 = taup2 + p2.*dtaup2; 
hold on; 
plot( dtaup2*r2d, t2, 'r-'); 

% test PKP-cd 
[pcd, taupcd, dtaupcd]= get_PKP_cd (zdep, np, em); 
tcd = taupcd + pcd.*dtaupcd; 
plot( dtaupcd *r2d, tcd, 'k-'); 

% test directP 
[pdp, taupdp, dtaupdp]= get_directP(zdep, np, em); 
tdp = taupdp + pdp.* dtaupdp; 
figure; 
plot ( dtaupdp*r2d, tdp); 