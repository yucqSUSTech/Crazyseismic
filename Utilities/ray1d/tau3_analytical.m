function [taup, dtaup, dtau2,tt] = tau3_analytical (s1, s2, r1, r2, p)

if s1 <p || s2 < p,
    disp ('s1 ,s2 must be >= p');
    pause
end
    
if p <= 0,
    disp( 'slowness p must be >0, no ray should go through the earth center');
    pause;
end

taup =0; 
dtaup =0;
dtau2 =0;
tt = 0;

p1 = s1; 
h = r2 - r1; 
r0 = r1; 

if h < 1e-6 ,    return; end
p0=p;
k = (s2-s1)/h; 

if k==0,
    tmp = 1/sqrt(p1*p1 -p0*p0); 
    tmp2 = p0*p0/tmp^3; 
    dtau2 = -(tmp+tmp2)*log( (h+r1)/r1); 
    dtaup =0; 
    taup = h*sqrt(p1*p1 -p0*p0);
    return;
end

disp('here ...')
a = (p0 -p1)/k;
b = -(p0 + p1)/k;

t1 = sqrt(a/b);
t2 = sqrt( (h-a)/(h-b));
rk =k; 


if r1 == -a && r1 ~= -b,
    taup = 2*t2/(t2*t2-1) - 2*t1/(t1*t1-1) + log ( (t2-1)/(t2+1)*(t1+1)/(t1-1)) ;
    taup = -0.5*rk*(a - b)*taup ;
    dtaup =  -2*p0/k/(a - b) *( 1/t2 - 1/t1) ;
    tt = taup + p0*dtaup ;
    tmp = (a-b)^3*k^3;
    
    dtau2 = -2*p0*p0/tmp*(t2-t1) + ...
        2*p0*p0/( 3*tmp)*(1/t2^3-1/t1^3) + ...
        2*(k^2*(a-b)^2-2*p0^2)/tmp*(1/t2-1/t1);
    disp('r1 == -a && r1 ~= -b'); 
elseif r1 ~= -a && r1 == -b,
    taup = 2*t2/(t2*t2-1) - 2*t1/(t1*t1-1) - log ( (t2-1)/(t2+1)*(t1+1)/(t1-1)) ;
    taup = -0.5*rk*(a - b)*taup ;
    dtaup = +2*p0/rk/(a - b) *( t2 - t1) ;
    tt = taup + p0*dtaup ;
    tmp = (a-b)^3*k^3;
    dtau2 = +2*p0*p0/tmp*(1/t2-1/t1) - ...
        2*p0*p0/( 3*tmp)*(t2^3-t1^3) + ...
        2*(k^2*(a-b)^2-2*p0^2)/tmp*(t2-t1);
    disp('r1 ~= -a && r1 == -b'); 
elseif r1 ~=-a && r1~=-b,
    fac = (r0+a)/(r0+b);
    taup = -rk*(a - b) *( t2/ (t2*t2 -1) - t1/(t1*t1 -1)) + ...
        rk/2*(2*r0 + a + b) * log (  (t2-1)/(t2+1)*(t1+1)/(t1-1)) ;
    
    if fac >0,
        R = sqrt(fac);
        
        tmp1 = (a-b)^2*k^2*R^2 + p0^2*(R^2-1)^2;
        tmp = (a-b)^2*k^3;
        dtau2 = 2*p0^2/tmp/(r0+b) *(t2-t1) +...
            2*p0^2/(tmp*R^2*(r0+b))*(1/t2 -1/t1) + ...
            tmp1/(tmp*(r0+b)*R^3)*log( (t2-R)/(t1-R) *(t1+R)/(t2+R));
        
        %
        afac = ( 0.5/R) * log ( (t2-R)/(t2+R)*(t1+R)/(t1-R));
        taup = taup - 2*k*(r0+a) * afac ;
        dtaup= -2*p0/( rk*(r0 + b) ) *  afac ;
        tt = taup + p0*dtaup ;
        disp('r1 ~=-a && r1~=-b,fac>0'); 
    elseif fac <0,
        R = sqrt(-fac);
        tmp1 = (a-b)^2*k^2*R^2 - p0^2*(R^2+1)^2;
        tmp = (a-b)^2*k^3*(r0+b);
        dtau2 = 2*p0^2/tmp *(t2-t1) +...
            2*p0^2/(tmp*R^2)*(1/t1 -1/t2) + ...
           2*tmp1/(tmp*R^4)* ( atan(t2/R) - atan(t1/R) );  
       %
%           R = sqrt( -afac) ;
          afac = (atan(t2/R)  - atan(t1/R) ) /R ;
          taup = taup - 2*rk*(r0+a) * afac ;
          dtaup = -2*p0/ (rk *(r0 +b)) *afac ;
          tt = taup + p0*dtaup ;
                  disp('r1 ~=-a && r1~=-b,fac < 0'); 
    else
        disp ('impossible, see tau3_analytical'); 
    end
else 
      disp ('impossible' );
end
    return;