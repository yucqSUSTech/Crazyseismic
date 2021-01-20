function  [y0, iflag] = interp1db ( x0, xi, yi )
%  [y0, iflag] = interp1d ( x0, xi, yi )

iflag = 0 ; 
nl = length(xi); 
y0 =nan; 

for j =1: nl -1 
  x1 = xi(j);
  x2 = xi(j+1) ;
  y1 = yi(j) ;
  y2 = yi(j+1) ;
% !  if ( x0 >= x1 .and. x0 <= x2) then 
  if ( (x0 -x1) *(x0-x2) <= 0) , 
    y0= interp1a ( x1,x2,y1,y2, x0);
    iflag = 1 ; 
    return  ;
  end
end

