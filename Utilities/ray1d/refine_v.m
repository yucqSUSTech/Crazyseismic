
function  [zr, vr, nl2] = refine_v ( thmax, zi, vi) 
% !// this program refines a 1D velocity model 
% !// the max layer thickness is less than 'thmax'
% !//
% !// INTPUTS: 
% !// zi(*), vi(*), nl 
% !//
% !// OUTPUTS: refined model 
% !// 
% !// zr(*), vr(*), nl2 (no of lines) 
% !//
% !// AUTHOR: 
% !// Yingcai Zheng
% !// 
% !// Date: 
% !// 3/16/2010 on rail from S. Bay to Grafton 
% !//
% real thmax
% real zi(*), vi(*), zr(*), vr(*)
% integer nl, nl2 

k = 0 ; 
nl = length(zi); 

for j =1: nl -1, 
  z1 = zi(j) ;
  z2 = zi(j+1) ;
  v1 = vi(j) ;
  v2 = vi(j+1) ;
  delta_z = z2 - z1 ;
  nz = ceil (  delta_z/ thmax) + 1 ;
%   if ( nz < 2 ), nz = 2; end  
  nz = max(2, nz); % !// at least 2 interpolation points 
  dz = delta_z / (nz -1) ;
  for iz = 0: nz -2 
    k = k + 1; 
    s = 1.0 *iz / (nz-1) ;
    zr (k) = z2 *s + (1-s)* z1 ;
    vr (k) = v2 *s + (1-s)* v1 ;
  end
end 
k = k + 1 ;
zr(k) = zi(nl) ;
vr(k) = vi(nl) ;

nl2 = k ; 
% return 
% end  subroutine refine_v
