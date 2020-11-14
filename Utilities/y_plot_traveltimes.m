function y_plot_traveltimes

% plot travel times of selectedseismic phases
% Chunquan Yu, 2020-08-01
% yucq@sustech.edu.cn


evdp = 600; % event depth
imodel = 'ak135'; % velocity model, 'prem','ak135','iasp91'
em = set_vmodel_v2(imodel);
% em = refinemodel(em,10); % refine model to layer thickness of maximum=10 km
np = 1000;

r2d = 180/pi;
    
phasenames = {
    'P','S',...
    'pP','sP','sS','pS',...
    'Pdiff','Sdiff',...
    'PP','SS','PS','SP',...
    'PcP','ScS','PcS','ScP','ScSScS'...
    'PKPab','PKPbc',...
    'PKKP','SKS','SKKS',...
    'PKiKP','PKIKP'
    };

for i = 1:length(phasenames)
    
    [ rayp, taup, Xp ] = phase_taup( phasenames{i}, evdp, np, em );

    % get travel time and epicentral distance
    phases(i).t0 = taup + rayp.* Xp;
    phases(i).d0 = Xp*r2d;
    
    % if distance larger than 180 degrees, use the minor arc
    ind = find(phases(i).d0>180);
    phases(i).d0(ind) = 360-phases(i).d0(ind);
    
    
    phases(i).name = phasenames{i};
    phases(i).color = [rand rand rand];
end

%% plotting
figure;
subplot('position',[0.25 0.125 0.5 0.8]);
hold on;

for i = 1:length(phases)
    if isempty(phases(i).t0)
        continue;
    end
    h(i) = plot(phases(i).d0,phases(i).t0/60,'color',phases(i).color,'markersize',2,'linewidth',1);
    ind = round((1+length(phases(i).d0))/2);
    text(phases(i).d0(ind),phases(i).t0(ind)/60,phases(i).name,'color',phases(i).color,'Fontsize',10);
end
   
% legend(h,phasenames,'location','eastoutside');

set(gca,'Xtick',0:30:180);
grid on;
box on;
xlabel('Distance (^o)');
ylabel('Time (minutes)');
axis([0 180 0 60]);


end

