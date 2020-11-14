function [taup, dtaup, tt] = tauj_analytical (s1, s2, r1, r2, p)
% % 
% % Usage:
% %         [taup, dtaup, tt] = tauj_analytical (s1, s2, r1, r2, p)
% % Calculate Tau(p) and dtau(p)/dp by assuming slowness function  
% %          r/v(r) is linear in the interval [r1 < r2] 
% %  written by Yingcai Zheng 
% %  Date: 11/1/2010 
% % notes: see document 'taup.docx' for detailed formula 
% % 

% implicit none 
% real s1, s2, r1, r2, p, taup, dtaup,tt 
% real h,r0, p1,p2,x_alpha,x_beta ,p0,rk
% real t1,t2,sum1,sum2,sum3 ,prod,afac ,b 
% !// taup & dtaup/dp integral 
taup = 0.;
dtaup = 0.;
tt = 0.;% !// traveltime 

h = r2 - r1;
r0 = r1;
p0 = p ;
if ( abs(h) < 1e-3), return; end % !// layer too thin , < 1m thick

p1 = s1 ; p2 = s2; rk = (p2-p1)/h;

if (r0 < 1e-3) ,%  !// the ray goes through Earth's center
    if (rk < 0.) , disp( '394i39xkjdklafj' ); pause; end
    taup = rk*h;
    dtaup = 0.  ;
    % dtau2 
    dtau2 = 1/sqrt( rk*rk*h*h - p*p) - 1/p; 
    tt = rk*h ;
    return;
end

if (rk == 0.) ,%  !// const slowness layer
    if (p==p1) disp( '92-2x'), pause; end %  !// we can also return here
    taup = sqrt(p1*p1-p*p)*log( r2/r1) ;
    dtaup = p*log(r2/r1)/sqrt(p1*p1-p*p) ;
    tt = p1*p1*log(r2/r1)/sqrt(p1*p1-p*p) ;
    return
end

if (p== 0.) , % !// p==0, the ray is straight down 
%  			!// this is also the case for 2 identical roots (below)
   taup = rk*h+(p1-rk*r0)*log(r2/r1) ;
   dtaup = 0. ;
   tt = taup ;
   return 
end

% !/
% !//== find two roots --- now the two roots are distinct ---
% !// if the two roots are same, i.e. p0 =0, which has been already considered above. 
% !/
    x_alpha = (-p1+p)/rk;
     x_beta = (-p1-p)/rk ;
% !// distinct roots  rk>0
   t1 = sqrt ( x_alpha/x_beta) ;
   t2 = sqrt ( (h-x_alpha)/(h-x_beta)) ;

% % !// difft cases 
   if ( r0+x_alpha == 0) , % !// CASE 1
       taup = 2*t2/(t2*t2-1) - 2*t1/(t1*t1-1) + log ( (t2-1)/(t2+1)*(t1+1)/(t1-1)) ;
       taup = -0.5*rk*(x_alpha - x_beta)*taup ;
      dtaup = -2*p0/rk/(x_alpha - x_beta) *( 1/t2 - 1/t1) ;
         tt = taup + p0*dtaup ;
      return 
   end
   
   if ( r0+x_beta == 0) , % !// CASE 2
       taup = 2*t2/(t2*t2-1) - 2*t1/(t1*t1-1) - log ( (t2-1)/(t2+1)*(t1+1)/(t1-1)) ;
       taup = -0.5*rk*(x_alpha - x_beta) *taup;
      dtaup = +2*p0/rk/(x_alpha - x_beta) *( t2 - t1) ;
         tt = taup + p0*dtaup ;
      return 
   end
   
   if (r0+x_beta ~= 0 && r0+x_alpha ~=0 ) , % ! CASE 3
       taup = -rk*(x_alpha - x_beta) *( t2/ (t2*t2 -1) - t1/(t1*t1 -1)) + ...
              rk/2*(2*r0 + x_alpha + x_beta) * log (  (t2-1)/(t2+1)*(t1+1)/(t1-1)) ;
       afac = (r0 + x_alpha) /(r0 + x_beta) ;
       if ( afac > 0) ,  
          b = sqrt (afac) ;
          afac = ( 0.5/b) * log ( (t2-b)/(t2+b)*(t1+b)/(t1-b));
          taup = taup - 2*rk*(r0+x_alpha) * afac ;
          dtaup= -2*p0/( rk*(r0 + x_beta) ) *  afac ;
          tt = taup + p0*dtaup ;
       elseif ( afac < 0) , 
          b = sqrt( -afac) ;
          afac = (atan(t2/b)  - atan(t1/b) ) /b ;
          taup = taup - 2*rk*(r0+x_alpha) * afac ;
          dtaup = -2*p0/ (rk *(r0 +x_beta)) *afac ;
          tt = taup + p0*dtaup ;
       else 
         disp( ' impossible ..... 39439xf ' ); 
         pause
       end
      return 
   end
   return; 
% end subroutine tauj_analytical 
