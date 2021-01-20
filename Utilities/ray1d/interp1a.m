
function vt =  interp1a (t0,t1,v0,v1,t)
%
% !// vt =  interp1 (t0,t1,v0,v1,t)
%
% !// this subroutine does 1D linear interpolation between
% !// points [t0, v0] and [t1, v1]
% !//
% !// INPUTS:
% !// 't' interpolation point
% !//
% !// OUTPUT:
% !// 'vt' interpolated value at 't'
% !//
% !// AUTHOR: Yingcai Zheng
% !//
% !// Date:
% !// 3/16/2010 Tuesday
% !// south bay to grafton , on train
% !//
%
% real t0, t1, v0, v1, t, vt
% real s

vt = nan ;

if ( (t-t0)*(t-t1) <= 0.) , % then !// within the interval
    if ( t0 == t1) ,
        vt = (v0 + v1) *.5;
    else
        s = ( t - t0) / ( t1 - t0);
        vt = s* v1 + (1. -s ) *v0;
    end
end

% end  subroutine interp1
