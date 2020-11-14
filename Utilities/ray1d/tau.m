function [tab, dtab]= tau (za, zb, p0, zi, si) 
% % 
% % 
% %  [tab, dtab]= tau (za, zb, p0, zi, si) 
% % !//
% % !// za, zb: integration limits 
% % !// p0    : slowness 
% % !// tab   : tau(p)
% % !// dtab  : -dtau(p)/dp 
% % !//   zi  : depth array (model) 
% % !//  si   : slowness array (model) 
% % !//  nl   : No of layers (model) 
% % !// 


nl = length(zi); 

% % !// copy models // 
znew = zi; 
snew = si; 

re = max(zi); 

% !-- 
tab = 0. ;
dtab = .0;

if ( za < 0 ||za > re ) , 
 disp( 'za out of the Earth' ); 
 pause ; 
end

if ( zb < 0 ||zb > re ) , 
 disp('zb out of the Earth' ) ; 
 pause ; 
end

if ( za > zb ) , 
    strtmp = strcat( 'tau: za > zb', 'za=',za,' zb=',zb); 
  disp( strtmp ); 
  pause ; 
end


for j =1:  nl ,
    if ( zi(j) <= za),  ja =j ; end
    if ( zi(j) <= zb),  jb =j ; end
end

if (ja >= 1 && ja < nl && jb >= 1 &&  jb < nl) ,  
else
 disp( 'see tau '); 
 pause; 
end

% !// get va & vb 
 zj1 = zi(ja) ;
 zj2 = zi(ja+1) ;
 sj1 = si(ja) ;
 sj2 = si(ja+1) ;
sa= interp1a ( zj1, zj2, sj1, sj2, za);  

 zj1 = zi(jb);
 zj2 = zi(jb+1);
 sj1 = si(jb);
 sj2 = si(jb+1);
sb= interp1a ( zj1, zj2, sj1, sj2, zb); 

% !// insert new points 
znew(ja) = za ; 
snew(ja) = sa ; 
znew(jb+1) = zb;  
snew(jb+1) = sb ; 

tab = 0. ;
dtab = 0. ;
for j = ja: jb 
  zj1 = znew(j) ;
  zj2 = znew(j+1) ;
  sj1 = snew(j) ;
  sj2 = snew(j+1) ;
% !  call tauj ( sj1, sj2, zj1, zj2, p0 ,tj, dj) 
   [tjx, djx,ttjx]= tauj_analytical ( sj2, sj1, re-zj2, re-zj1, p0 ); 
%     [tjx, djx,ttjx,dtau2]= tauj_n ( sj2, sj1, re-zj2, re-zj1, p0 ); 
  tab = tab + tjx ;
  dtab = dtab + djx  ;
end
return 
% end subroutine tau 
