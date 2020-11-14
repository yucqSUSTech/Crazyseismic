function wiggle_v4(data,scal,offset,time,upcolor,dncolor,isupfill,isdnfill)

% wiggle plot for seismic traces
% Chunquan Yu @MIT-EAPS, 05/2013

if nargin < 4, fprintf('Input parameters must be more than 4!\n'); return; end   
if nargin < 5, upcolor = 'k'; end
if nargin < 6, dncolor = [0.7 0.7 0.7]; end
if nargin < 7, isupfill = 'yes'; end
if nargin < 8, isdnfill = 'yes'; end

% 
time = reshape(time,[],1);
offset = reshape(offset,[],1);
if size(data,1) == length(offset) && size(data,2) ~= length(offset)
    data = data';
end

% sort data
[offset,IX] = sort(offset,'ascend');
data = data(:,IX);

% calcuate mean doff
doff = mean( diff(offset) );

% in case time step is not uniform, add by yucq 09/15/11
dtime = diff(time);
if max(dtime) ~= min(dtime)
    time_new = linspace(min(time),max(time),length(time));
    data = interp1(time,data,time_new');
    time = time_new';
end

% normalize data
amp=mean(max(abs(data)));
yrange = max(offset) - min(offset);
data = yrange*scal*data/amp/100;

% plot wiggle for seismic traces
off1=min(offset)-2.0*doff; off2=max(offset)+2.0*doff;
set(gca,'NextPlot','add','Box','on', 'XLim', [min(time) max(time)],'YLim',[off1 off2]);
for i = 1:length(offset)
    datatmp = reshape(data(:,i),[],1);
    timetmp = time;
    [t0,d0] = curveintersect(time, datatmp, time, zeros(size(time)));

    datatmp = [zeros(size(d0));datatmp];
    [timetmp,indx] = sort([t0;timetmp],'ascend');
    datatmp = datatmp(indx);
    
    timetmp = [timetmp(1);timetmp;timetmp(end)];
    datatmp = [0;datatmp;0];
    
    dataup = datatmp;
    dataup(find(dataup<0)) = 0;

    datadn = datatmp;
    datadn(find(datadn>0)) = 0;
    
    hold on;
    % plot upper part
    j = 1;
    while j<length(timetmp)
        if dataup(j) ~= 0
            for k = j+1:length(timetmp)
                if dataup(k) == 0
                    break;
                end
            end
            if strcmpi(isupfill,'yes') || strcmpi(isupfill,'y')
                patch(timetmp(j-1:k),dataup(j-1:k)+offset(i),upcolor,'Facecolor',upcolor,'Edgecolor',upcolor,'LineWidth',0.1);
%                 patch(timetmp(j-1:k),dataup(j-1:k)+offset(i),upcolor,'Facecolor',upcolor,'Edgecolor','none','LineWidth',0.1);
            else
                plot(timetmp(j-1:k),dataup(j-1:k)+offset(i),'color',upcolor,'Linewidth',0.1);
            end
            j = k+1;
        else
            j = j+1;
        end
    end
    
    % plot down part
    j = 1;
    while j<length(timetmp)
        if datadn(j) ~= 0
            for k = j+1:length(timetmp)
                if datadn(k) == 0
                    break;
                end
            end
            if strcmpi(isdnfill,'yes') || strcmpi(isdnfill,'y')               
                patch(timetmp(j-1:k),datadn(j-1:k)+offset(i),dncolor,'Facecolor',dncolor,'Edgecolor',dncolor,'LineWidth',0.1);
%                 patch(timetmp(j-1:k),datadn(j-1:k)+offset(i),dncolor,'Facecolor',dncolor,'Edgecolor','none','LineWidth',0.1);
            else
                plot(timetmp(j-1:k),datadn(j-1:k)+offset(i),'color',dncolor,'Linewidth',0.1);
            end
            j = k+1;
        else
            j = j+1;
        end
    end

    % the zero line will show up in saved figures
%     % plot upper part
%     if strcmpi(isupfill,'yes') || strcmpi(isupfill,'y')
% %         patch(timetmp,dataup+offset(i),upcolor,'Facecolor',upcolor,'Edgecolor',upcolor,'LineWidth',0.1);
%         patch(timetmp,dataup+offset(i),upcolor,'Facecolor',upcolor,'Edgecolor','none','LineWidth',0.1);
%     else
%         plot(timetmp,dataup+offset(i),'color',upcolor,'Linewidth',0.1);
%     end
%     hold on;
%     % plot down part 
%     if strcmpi(isdnfill,'yes') || strcmpi(isdnfill,'y')
% %         patch(timetmp,datadn+offset(i),dncolor,'Facecolor',dncolor,'Edgecolor',dncolor,'LineWidth',0.1);
%         patch(timetmp,datadn+offset(i),dncolor,'Facecolor',dncolor,'Edgecolor','none','LineWidth',0.1);
%     else
%         plot(timetmp,datadn+offset(i),'color',dncolor,'Linewidth',0.1);
%     end
    
end


end
