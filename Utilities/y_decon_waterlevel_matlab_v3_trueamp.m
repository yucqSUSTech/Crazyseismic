function [ RFt, rms, nwl ] = y_decon_waterlevel_matlab_v3_trueamp( numer, denom, tshift, dt, waterlevel, gaussa )

% waterlevel deconvolution with true amplitude
% Chunquan Yu, @MIT-EAPS, 06/2013

% calculate frequency
NT = length(numer);
Fs = 1/dt;
% fny = Fs/2;      % nyquist
df = Fs/NT;
Q = ceil((NT+1)/2);
freq = df*(0:1:Q-1);
w = 2*pi*[freq,-fliplr(freq(2:NT-Q+1))];
w = reshape(w,[],1);

numer = reshape(numer,[],1);
denom = reshape(denom,[],1);
numerf = fft( numer );
denomf = fft( denom );

% denominator
Df = denomf.* conj(denomf);
dmax = max( real( Df ) );

% add water level correction
phi1 = waterlevel*dmax; % water level
nwl = length( find(Df<phi1) ); % number corrected
% Df( real(Df)<phi1 ) = phi1;
Df = Df + phi1;

% numerator
Nf = numerf .* conj(denomf);

% compute RF
RFf = Nf ./ Df;

% compute predicted numerator
pnumerf = RFf.*denomf;

% add gauss filter
gfilter = exp(-w.*w/(4*gaussa*gaussa))/dt*sqrt(pi)/gaussa;
RFf = RFf .* gfilter;

% add phase shift
RFf = RFf .* exp(-1i*w*tshift);
RFt = (1+waterlevel)*real(ifft(RFf));

% compute the fit
pnumer=real(ifft(pnumerf));
rms = sum( (pnumer - numer).^2 )/sum(numer.^2);


end
