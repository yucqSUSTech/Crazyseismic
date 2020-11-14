function [ datai ] = y_intederi( data, delta, inteorderi )

% integral or derivation of data
%
% for multi-channel
% data: ntime by ntrace
% delta: sampling interval in the time domain
% inteorderi: 'inte' or 'deri'

if ~strcmpi(inteorderi(1:3),'int') &&  ~strcmpi(inteorderi(1:3),'der')
    datai = data;
    return;
end

% apply phase shift to data
[n, m] = size(data);
if n == 1
    data = data';
    n = m;
end
NT = 2^nextpow2(n);
Fs = 1/delta;
% fny = Fs/2;      % nyquist
df = Fs/NT;

fd = fftshift(fft(data,NT),1);
if ~mod(NT,2);
    f = df*(-NT/2:NT/2-1); % NT is even
else
    f = df*(-(NT-1)/2:(NT-1)/2); % NT is odd
end

w = 2*pi*f;

m = size(data,2);
% fd = fft(data,NT);
if strcmpi(inteorderi(1:3),'int')
    fd = -1i * fd ./ (w'*ones(1,m));
else
    fd = -1i * fd .* (w'*ones(1,m));
end

ifd = ifft(ifftshift(fd),'symmetric');

datai = real(ifd(1:n,:));

end

