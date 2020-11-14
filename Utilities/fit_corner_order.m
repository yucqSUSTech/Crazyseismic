function [ c0_best, order_best, amp_best ] = fit_corner_order( f, fdata, c0_try, order_try, amp_try )
%FIT_CORNER_ORDER Summary of this function goes here
%   Detailed explanation goes here

% find the best fit corner frequency and order for butterworth low pass filtering
% f: data frequency (Hz)
% fdata: frequency domain data
% co_try: corner frequency (in Hz) for grid search
% order_try: butterworth filter order for try
% amp_try: % amplitude relative to the maximum value of abs(fdata) for try

% ar = -1:0.1:0;
% amp_try = 10.^ar; 

w = 2*pi*f;
w0_try = 2*pi*c0_try;

for i = 1:length(c0_try)
    for j = 1:length(order_try);        
        for k = 1:length(amp_try)
            G = amp_try(k)*max(abs(fdata))*sqrt(1./(1+(w/w0_try(i)).^(2*order_try(j))));            
            misfit(i,j,k) = sum(abs(log(G)-log(abs(fdata))));
        end
    end
end

[a,indx] = min(misfit(:));
[p q t] = ind2sub(size(misfit),indx);

c0_best = c0_try(p);
order_best = order_try(q);
amp_best = amp_try(t);

end
