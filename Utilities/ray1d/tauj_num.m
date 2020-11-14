function [taup, dtaup,tt,dtau2] = tauj_num (s1, s2, r1, r2, p)
% numerical evaluation of linear slowness gradient for various tau
% functions
%  [taup, dtaup, dtau2,tt] = tauj_num (s1, s2, r1, r2, p)
h = r2 - r1; 
p1 = s1;
rk = (s2 - s1)/h;
r0 = r1;
taup = quad(@ftau, 0, h);
dtaup = quad(@fdtau, 0,h);
tt = taup + p*dtaup;
dtau2 = quad(@fdtau2, 0, h);

    function f1 = ftau (x)
        if r0 ==0
            f1 = rk* h;
            return;
        end
        f1 = sqrt( (p1+rk*x).^2 - p^2) ./(r0 + x);
        return;
    end

    function f2 = fdtau (x)
        if r0==0,
            f2 =0;
        end
        f2 = p./ sqrt( (p1+rk*x).^2 - p^2) ./(r0 +x);
        return;
    end
    function f3 = fdtau2 (x)
        if r0==0,
            f3=1/h;
        end
        f3 = 1./ sqrt( (p1+rk*x).^2 - p^2) ./(r0 +x) + p*p./(r0+x)./( (p1+rk*x).^2 - p^2).^(3/2);
        return;
    end
end