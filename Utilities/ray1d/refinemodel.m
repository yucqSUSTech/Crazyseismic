function emf =  refinemodel (em, thmax)

% changes 02/06/2016
% original version: fine slowness interpolated from coarse slowness 
% new version: fine slowness calculated from fine velocity model

%  emf =  refinemodel (em, thmax)
emf = em ; 
zi = em.z; 
[z_fine, vp_fine, nl2] = refine_v ( thmax, zi, em.vp);
[zr, vs_fine, nl2] = refine_v ( thmax, zi, em.vs);
[zr, rho_fine, nl2] = refine_v ( thmax, zi, em.rho);
[zr, qp_fine, nl2] = refine_v ( thmax, zi, em.qp);
[zr, qs_fine, nl2] = refine_v ( thmax, zi, em.qs);
% [zr, sp_fine, nl2] = refine_v ( thmax, zi, em.sp_fine);
% [zr, ss_fine, nl2] = refine_v ( thmax, zi, em.ss_fine);
sp_fine = (emf.re - z_fine) ./ vp_fine;
ss_fine = (emf.re - z_fine) ./ vs_fine;
  % 
  emf.vp = vp_fine' ; 
  emf.vs = vs_fine'; 
  emf.rho = rho_fine'; 
  emf.z = z_fine'; 
  emf.qp = qp_fine';
  emf.qs = qs_fine';
  emf.sp_fine = sp_fine';
  emf.ss_fine = ss_fine';
end
