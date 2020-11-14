function h = single_wig7(time,data,offset,upcolor,dncolor,isupfill,isdnfill )
%SINGLE_WIG2 Summary of this function goes here
%   Detailed explanation goes here

dark = [0 0 0];
gray = [0.7 0.7 0.7];
if nargin <= 3
    upcolor = dark;
    dncolor = gray;
    isupfill = 'yes';
    isdnfill = 'yes';
elseif nargin == 4
    dncolor = gray;
    isupfill = 'yes';
    isdnfill = 'yes';
end

data = reshape(data,[],1);
time = reshape(time,[],1);

[t0,d0] = curveintersect(time, data, time, zeros(size(time)));

datatmp = [zeros(size(d0));data];
[timetmp,indx] = sort([t0;time],'ascend');
datatmp = datatmp(indx);

timetmp = [timetmp(1);timetmp;timetmp(end)];
datatmp = [0;datatmp;0];

dataup = datatmp;
dataup(find(dataup<0)) = 0;
dataup(1) = -max(abs(dataup))*1e-4;
dataup(end) = -max(abs(dataup))*1e-4;

datadn = datatmp;
datadn(find(datadn>0)) = 0;
datadn(1) = max(abs(datadn))*1e-4;
datadn(end) = max(abs(datadn))*1e-4;

if strcmpi(isupfill,'yes') || strcmpi(isupfill,'y')
    h(1) = patch(timetmp,dataup + offset,upcolor,'Facecolor',upcolor,'Edgecolor','none','LineWidth',0.1);
else
    h(1) = plot(timetmp,dataup+offset,'color',upcolor,'Linewidth',0.1);
end
if strcmpi(isdnfill,'yes') || strcmpi(isdnfill,'y')
    h(2) = patch(timetmp,datadn + offset,dncolor,'Facecolor',dncolor,'Edgecolor','none','LineWidth',0.1);
else
    h(2) = plot(timetmp,datadn+offset,'color',dncolor,'Linewidth',0.1);
end

end
