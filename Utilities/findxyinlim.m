function [ x,y ] = findxyinlim( x,y,xlim,ylim )

% exclude x,y data outside xlim,ylim
nx = length(x);
ny = length(y);

if nx~=ny
    x = [];
    y = [];
    fprintf('X and Y do not have same length\n');
    return;
end

ind = find(x<xlim(1) | x>xlim(2) | y<ylim(1) | y>ylim(2));
ind0 = setdiff(1:nx,ind);

x = x(ind0);
y = y(ind0);


end

