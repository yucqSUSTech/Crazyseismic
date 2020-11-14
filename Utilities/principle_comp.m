function [ pc ] = principle_comp( varargin )
%PRINCIPLE_COMP Summary of this function goes here
%   Detailed explanation goes here

% this program is aimed to find the principle component of several traces,
% such as the tele-seismic P wave recording of an array.
% These traces should be lined up before this code.
% Be sure that each trace is stored in each column.

% nc: number of first few components
% data: n*p 
%       n: number of data points
%       p: number of traces
if nargin == 1
    data = varargin{1};
    nc = 1;
elseif nargin == 2
    data = varargin{1};
    nc = varargin{2};
end

% normalize each trace before pca for stability consideration
data_new = data;
range = ones(size(data,2),1);
for i = 1:size(data,2)
    data_new(:,i) = detrend(data_new(:,i));
    range(i) = max(data_new(:,i))-min(data_new(:,i));
    if range(i) == 0
        range(i) = 1;
    end
    data_new(:,i) = data_new(:,i)/range(i);
end


data_new = data_new';
[U,S,V] = svd(data_new,'econ');
Ufo = zeros(size(U));
Ufo(:,1:nc) = U(:,1:nc); % first column
dat = Ufo*Ufo'*data_new;
pc = dat';

for i = 1:size(data,2)
    pc(:,i) = pc(:,i)*range(i);
end


end

