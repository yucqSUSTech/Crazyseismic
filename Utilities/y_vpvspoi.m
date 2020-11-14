function [ varargout ] = y_vpvspoi( varargin )
%Y_VPVSPOI Summary of this function goes here
%   Detailed explanation goes here

% example:
% [vp,vs,poi] = y_vpvspoi(6.3, 6.3/1.8,'vpvs');


varargout = {[]};
if nargin < 2
    fprintf('Input arguments must be >= 2!\n');
    return;
elseif nargin == 2 || strcmpi(varargin{3},'vpvs')
    vp = varargin{1};
    vs = varargin{2};   
    poi = (1-1./((vp./vs).^2 -1))/2;
elseif strcmpi(varargin{3},'vppoi')
    vp = varargin{1};
    poi = varargin{2};
    k = sqrt((2-2*poi)./(1-2*poi));
    vs = vp./k;
elseif strcmpi(varargin{3},'vspoi')
    vs = varargin{1};
    poi = varargin{2};
    k = sqrt((2-2*poi)./(1-2*poi));
    vp = vs.*k;
else
    fprintf('Wrong input arguments!\n');
    return;
end

varargout{1} = vp;
varargout{2} = vs;
varargout{3} = poi;

end
