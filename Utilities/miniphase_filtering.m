function [ dat ] = miniphase_filtering(varargin)
%MINIPHASE_FILTERING Summary of this function goes here
%   Detailed explanation goes here

% minimum phase filter
% usage:
% dat = miniphase_filtering(data, delta, lowf, highf, order) - bandpass filter
% dat = miniphase_filtering(data, delta, lowf, 'low', order) - lowpass filter
% dat = miniphase_filtering(data, delta, lowf, 'low') - lowpass filter
% change 'low' to 'high' for highpass filter
% else no filtering

% default butterworth order
order = 2;

if nargin <=3
    fprintf('Number of input parameters less than 4!\n');
    return;
else
    data = varargin{1};
    delta = varargin{2};
    f1 = varargin{3};
    if ~isnumeric(delta) || ~isnumeric(f1)
        fprintf('Delta or f1 not numeric!\n No filtering\n');
        return;
    end
    fs = 1/delta;
    nyq = fs/2;

    if nargin == 4
        if strcmpi(varargin{4},'high') || strcmpi(varargin{4},'hp')
            [B,A] = butter(order,f1/nyq,'high');
        elseif strcmpi(varargin{4},'low') || strcmpi(varargin{4},'lp')
            [B,A] = butter(order,f1/nyq,'low');
        elseif isnumeric(varargin{4})
            f2 = varargin{4};
            [B,A] = butter(order,[f1/nyq f2/nyq]);
        else
            fprintf('Check input para!\n');
            return;
        end
    elseif nargin >=5
        if (strcmpi(varargin{4},'high') || strcmpi(varargin{4},'hp')) && isnumeric(varargin{5})
            order = varargin{5};
            [B,A] = butter(order,f1/nyq,'high');
        elseif (strcmpi(varargin{4},'low') || strcmpi(varargin{4},'lp')) && isnumeric(varargin{5})
            order = varargin{5};
            [B,A] = butter(order,f1/nyq,'low');
        elseif isnumeric(varargin{4}) && isnumeric(varargin{5})
            f2 = varargin{4};
            order = varargin{5};
            [B,A] = butter(order,[f1/nyq f2/nyq]);
        else
            fprintf('Check input para!\n');
            return;
        end
    end

    L = length(data);
    NFFT = 2^nextpow2(L);
    [h,w] = freqz(B,A,NFFT/2);
%     dw = w(2)-w(1);
%     wa = linspace(0,2*pi-dw,NFFT);
    ha = [h;0;flipud(conj(h(2:end)))];
    sm = mps(ha); % find minimum phase spectrum response
    sa = sm(1:NFFT/2);
     
    % inverse to get iB and iA
    [iB,iA] = invfreqz(sa,w,length(B)-1,length(A)-1);
    
%     [ih,iw] = freqz(iB,iA,NFFT/2);
    
    data = detrend(data);
%     taper = tukeywin(length(data),0.1);
%     data = data.*reshape(taper,size(data,1),size(data,2));
    dat = filter(iB,iA,data);

end