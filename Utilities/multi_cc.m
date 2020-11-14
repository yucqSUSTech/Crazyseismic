function [ dat, shift, varargout ] = multi_cc( data, time, ccwin, maxlagT )

% Multi-channel cross correlation with output of mean cross correlation
% coefficient of each trace
% Chunquan Yu, @Caltech, 12/03/2017
% Chunquan Yu, @MIT-EAPS, 02/01/11

% this program is aimed to conduct multi-channel cross correlation for the
% input data with a time window
% Be sure that each trace is stored in each column.
% data: n*m   n is the number of data point in each trace (npts)
%             m is the number of traces (ntrace)
% time: n*1   time of data traces
% ccwin: 1*2  begin and end time of cross correlatin window, should be
%               within [min(time), max(time)]
% maxlagT: maximum lag time
% OUTPUT:
% dat: aligned data after cross correlation
% shift: shifted points of each traces after cross correlation
% ccmean: mean cross correlation coefficient of each trace

if nargin == 0
    fprintf('ERR multi_cc: Input arg should be more than 1!\n'); return;
elseif nargin == 1
    time = 1:size(data,1);
    ccwin = [min(time),max(time)];
    maxlagT = 	max(time) - min(time);
elseif nargin == 2
    ccwin = [min(time),max(time)];
    maxlagT = 	max(time) - min(time);
elseif nargin == 3
    maxlagT = 	max(time) - min(time);
end

max_lags = floor(maxlagT/(time(2)-time(1)));

%  multi-channel cross correlation
% % A*x = b
% % x = lsqr(A,b)

% calculate A and b
npts = size(data,1);
delta = time(2)-time(1);
before = round((ccwin(1)-time(1))/delta) + 1;
after  = round((ccwin(2)-time(1))/delta) + 1;
datawin = data(before:after,:);
ntrace = size(datawin,2);
A = zeros(ntrace*(ntrace-1)/2+1,ntrace);
b = zeros(ntrace*(ntrace-1)/2+1,1);
num = 1;
ccmat = ones(ntrace,ntrace);
for i = 1:ntrace-1
    for j = i+1:ntrace
        A(num,i) = 1;
        A(num,j) = -1;
        
        [c,lags] = xcorr(datawin(:,i),datawin(:,j),max_lags,'coeff');
        [cmax,ind] = max(c);
        b(num) = lags(ind);
        ccmat(i,j) = cmax;
        ccmat(j,i) = cmax;
        num = num + 1;
    end
end
ccmean = mean(ccmat,2);
varargout{1} = ccmean;

% constraints, total shift is zero
A(num,:) = 1;
b(num) = 0;

% % lsqr solution, x is the shift
x = lsqr(A,b,1e-6,50);
% if x has nan values
x(find(isnan(x))) = 0;
% 
shift = - round(x);

% % shift data into aligned dat
dat = zeros(size(data));
for i = 1 : ntrace
    if shift(i) >= 0
        b_new = shift(i) + 1;
        e_new = npts;
        dat(b_new:e_new,i) = data(1:(e_new-b_new)+1,i);
        dat(1:b_new-1,i) = data(1,i);
    else
        b_new = 1;
        e_new = npts + shift(i);
        dat(b_new:e_new,i) = data(npts-e_new+b_new:npts,i);
        dat(e_new+1:npts,i) = data(npts,i);
    end
end


end

