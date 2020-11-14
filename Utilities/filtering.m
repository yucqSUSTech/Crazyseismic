% function [ dat ] = filtering (data, delta, lowf, highf)
% %FILTERING Summary of this function goes here
% %   Detailed explanation goes here
% 
% % this program is aimed to filter data using a 2-pass butterworth
% % filter. You can also use other filters by changing butter to others 
% 
% 
% fs = 1/delta;
% nyq = fs/2;
% [B,A] = butter(order,[lowf/nyq highf/nyq]);
% dat = filtfilt(B,A,data);


% usage:
% dat = filtering(data, delta, lowf, highf, order) - bandpass filter
% dat = filtering(data, delta, lowf, highf) - bandpass filter
% dat = filtering(data, delta, lowf, 'low', order) - lowpass filter
% dat = filtering(data, delta, lowf, 'low') - lowpass filter
% change 'low' to 'high' for highpass filter
% else no filtering

function [ dat ] = filtering (varargin)
% default butterworth order
order = 2;

if nargin <=3
%     fprintf('Number of input parameters less than 4!\n');
    return;
else
    data = varargin{1};
    dat = data;
    delta = varargin{2};
    f1 = varargin{3};
    if ~isnumeric(delta) || ~isnumeric(f1)
%         fprintf('Delta or f1 not numeric!\n No filtering\n');
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
%             fprintf('Check input para!\n');
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
%             fprintf('Check input para!\n');
            return;
        end
    end

    data = detrend(data);
%     taper = tukeywin(length(data),0.1);
%     data = data.*reshape(taper,size(data,1),size(data,2));
    dat = filtfilt(B,A,double(data));

end