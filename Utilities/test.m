function [  ] = test(  )
%TEST Summary of this function goes here
%   Detailed explanation goes here

eventdir = '/scratch1/yucq-MIT/Data/Hiclimb_north_SsPmp_H0/sac/20050215144225.85';
% eventdir = '/scratch1/yucq-MIT/Data/Hiclimb_north_SsPmp_H0/sac/20050205122318.94';
% eventdir = '/scratch1/yucq-MIT/Data/Hiclimb_north_SsPmp_H0/sac/20050613070233.09';
% eventdir = '/scratch1/yucq-MIT/Data/Hiclimb_north_SsPmp_H0/sac/20050410111419.62';
listname = 'list_z_S.txt';

timewin = [-30, 60];
delta = 0.025;
time = timewin(1):delta:timewin(2);

[lists, phtt, phtshift, phT, polarity, stnm, netwk, phrayp] = textread(fullfile(eventdir,listname),'%s %f %f %f %d %s %s %f','commentstyle','shell');    

dt = delta;
NFFT = 2^nextpow2(length(time));
Fs = 1/dt;
f = Fs/2*linspace(0,1,NFFT/2);
df = f(2) - f(1);

for i = 1:length(lists)
    
    listz = lists{i};
    listr = regexprep(listz,'BHZ','BHR');
    
    [hdz,dataz] = irdsac(fullfile(eventdir,listz));
    [hdr,datar] = irdsac(fullfile(eventdir,listr));
    
    % normalize
    
    timez = linspace(hdz.b, hdz.e, hdz.npts) -hdz.o-phT(i) ;
    timer = linspace(hdr.b, hdr.e, hdr.npts) -hdr.o-phT(i) ;
    
    % cut data
    dataz = interp1(timez,dataz,time,'linear',0);
    datar = interp1(timer,datar,time,'linear',0);
    
    dataz = reshape(dataz,[],1).*tukeywin(length(dataz),0.1);
    datar = reshape(datar,[],1).*tukeywin(length(datar),0.1);
    
    fdataz = fft(dataz,NFFT)/length(time);
    fdatar = fft(datar,NFFT)/length(time);

    DATZ(:,i) = dataz;
    DATR(:,i) = datar;
    FDATZ(:,i) = 2*abs(fdataz(1:NFFT/2));
    FDATR(:,i) = 2*abs(fdatar(1:NFFT/2));
        
    ampz(:,i) = max(dataz)-min(dataz);
    offset(i) = hdz.stla;
end

scal = 0.2;
aamp = mean(ampz);
figure
subplot(1,2,1)
for i = 1:size(DATZ,2)
    plot(time,scal*DATZ(:,i)/aamp + offset(i),'k');
    hold on;
    plot(time,scal*DATR(:,i)/aamp + offset(i),'r');
end
xlim(timewin);

subplot(1,2,2)
span = 21;
% smoothing
for i = 1:size(FDATZ,2)
    FDATZ(:,i) = smooth(FDATZ(:,i),span);
    FDATR(:,i) = smooth(FDATR(:,i),span);
end

% for i = 1:size(FDATZ,2)
%     loglog(f,FDATZ(:,i),'k');
%     hold on;
%     loglog(f,FDATR(:,i),'r');
% end

% stack
FDATZS = mean(FDATZ,2);
FDATRS = mean(FDATR,2);

loglog(f,FDATZS,'k');
% semilogy(f,FDATZS,'k');
hold on
loglog(f,FDATRS,'r');
% semilogy(f,FDATRS,'r');

xlim([min(f) max(f)])
grid minor


% find the filter that fit the data best
% plot the amplitude response of a gaussian filter
% figure


fn = log(0.01):0.01:0;
fr = exp(fn);
% fr = 0.01:df:1;
w = 2*pi*fr;
zr = interp1(f,FDATZS,fr);
% zr = interp1(f,FDATRS,fr);


c0 = 0.1:0.02:1;
n = 1:1:3;
ar = -1:0.1:0;
amp = 10.^ar;

% c0 = c0*2*pi;
% % num = 0;
% tic
% for i = 1:length(c0)
%     for j = 1:length(n);
%         
%         for k = 1:length(ar)
% %             num = num+1;
%             G = 10^ar(k)*max(zr)*sqrt(1./(1+(w/c0(i)).^(2*n(j))));
%             
%             misfit(i,j,k) = sum(abs(log(G)-log(zr)));
%         end
%     end
% end
% toc
% [a,indx] = min(misfit(:));
% [p q t] = ind2sub(size(misfit),indx);

[ c0_best, n_best, amp_best ] = fit_corner_order( fr, zr, c0, n, amp );
c0_best
n_best

G = sqrt(1./(1+(w/c0_best/2/pi).^(2*n_best)));
loglog(fr,G*max(zr)*amp_best);
% semilogy(fr,G*max(zr)*10^ar(t));

end