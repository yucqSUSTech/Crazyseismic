function zt = wise_turn_v3 (rayp0, zrange, zi, si)
% % > 
% % !// find turning point by linear slowness profile
% %
% % zt = wise_turn_v2 (rayp0, zmin, zi, si)
% 
% %    succeed : zt >=0; not successful: zt < 0; 
% 
% % given ray parameter 'rayp0' and slowness profile zi[], si[]
% %
% % find the turning point 'zt' greater than 'zmin'
% %
% % !// using linear slowness
% %  !// find the turning point below 'zmin'
% % by Yingcai Zheng, mit & ucsc, 2011 
% modified by Chunquan Yu, MIT, 06/2013
% constrain the depth range of turning point

re = max(zi);

if length(zrange) == 1
    zrange = [zrange,re];
end
nl = length(zi);
zt = -1; 

% if rayp0 >= si(1) ,
%     zt = 0.;
%     return;
% end

if ( rayp0 < 0 ) ,
    disp('rayp0 < 0');
    zt = re;
    return;
end

for j =1: nl -1
    p1 = si(j);
    p2 = si(j+1);
    if ( rayp0 <= p1 && rayp0 >= p2) ,
        z1 = zi(j);
        z2 = zi(j+1);
        zt= interp1a (p1, p2, z1, z2, rayp0);
        if zt >= min(zrange) && zt <= max(zrange)
            return;
        else
            zt = -1;
        end
%         if (zt >= zmin) , return;   end
    end
end

end  %subroutine wise_turn_v3
