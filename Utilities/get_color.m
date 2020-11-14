function [ colorb ] = get_color( cmap, vrange, val )

%
vrange = reshape(vrange,[],1);
if vrange(1) > vrange(end)
    vrange = flipud(vrange);
    cmap = flipud(cmap);
end

if val < vrange(1)
    colorb = cmap(1,:);
    return;
elseif val > vrange(end)
    colorb = cmap(end,:);
    return;
else
    vr = linspace(vrange(1),vrange(end),size(cmap,1));
    colorb = interp1(vr,cmap,val);
end


end

