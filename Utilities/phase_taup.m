function [ rayp, taup, Xp ] = phase_taup( varargin )
% function [ rayp, taup, Xp ] = phase_taup( phase_name, evdp, np, em )

% calculate travel time based on 1-D reference earth model
%
% Written by Chunquan Yu and Yingcai Zheng, MIT-EAPS, 04/2012
% email: yucq@mit.edu


if nargin == 4
    phase_name = varargin{1};
    evdp = varargin{2};
    np = varargin{3};
    em = varargin{4};
    xdep = 410; % default conversion depth;
elseif nargin == 5
    phase_name = varargin{1};
    evdp = varargin{2};
    np = varargin{3};
    em = varargin{4};
    xdep = varargin{5};
else
    fprintf('Wrong input number of parameters!\n');
    return;
end

if strcmp(phase_name,'P')
    [rayp, taup, Xp]= y_get_directP (evdp, np, em);
elseif strcmp(phase_name,'S')
    [rayp, taup, Xp]= y_get_directS (evdp, np, em);
elseif strcmp(phase_name,'Pn')
    [rayp, taup, Xp]= y_get_Pn (evdp, np, em);
elseif strcmp(phase_name,'PmP')
    [rayp, taup, Xp]= y_get_PmP (evdp, np, em);
elseif strcmp(phase_name,'PmPx')
    if xdep == 410, xdep = 1; end
    [rayp, taup, Xp]= y_get_PmPn (evdp, np, em, xdep);
elseif strcmp(phase_name,'Sn')
    [rayp, taup, Xp]= y_get_Sn (evdp, np, em);
elseif strcmp(phase_name,'SmS')
    [rayp, taup, Xp]= y_get_SmS (evdp, np, em);
elseif strcmp(phase_name,'SmSx')
    if xdep == 410, xdep = 1; end
    [rayp, taup, Xp]= y_get_SmSn (evdp, np, em, xdep);
elseif strcmp(phase_name,'PP')
    [rayp, taup, Xp]= y_get_PP (evdp, np, em);
elseif strcmp(phase_name,'PPP')
    [rayp, taup, Xp]= y_get_PPP (evdp, np, em);
elseif strcmp(phase_name,'SS')
    [rayp, taup, Xp]= y_get_SS (evdp, np, em); 
elseif strcmp(phase_name,'SSS')
    [rayp, taup, Xp]= y_get_SSS (evdp, np, em); 
elseif strcmp(phase_name,'pP')
    [rayp, taup, Xp]= y_get_p0P (evdp, np, em);
elseif strcmp(phase_name,'pPP')
    [rayp, taup, Xp]= y_get_p0PP (evdp, np, em);
elseif strcmp(phase_name,'sS')
    [rayp, taup, Xp]= y_get_s0S (evdp, np, em);   
elseif strcmp(phase_name,'sxS')
    [rayp, taup, Xp]= y_get_sx0S (evdp, np, em, xdep);   
elseif strcmp(phase_name,'PKPab')    
    [rayp, taup, Xp]= y_get_PKPab (evdp, np, em);
elseif strcmp(phase_name,'PKPbc')    
    [rayp, taup, Xp]= y_get_PKPbc (evdp, np, em);
elseif strcmp(phase_name,'PKiKP') || strcmp(phase_name,'PKPcd')
    [rayp, taup, Xp]= y_get_PKPcd (evdp, np, em);
elseif strcmp(phase_name,'PKIKP') || strcmp(phase_name,'PKPdf') 
    [rayp, taup, Xp]= y_get_PKPdf (evdp, np, em);
elseif strcmp(phase_name,'PKKP')    
    [rayp, taup, Xp]= y_get_PKKP (evdp, np, em);
elseif strcmp(phase_name,'SKPab')    
    [rayp, taup, Xp]= y_get_SKPab (evdp, np, em);
elseif strcmp(phase_name,'SKPbc')    
    [rayp, taup, Xp]= y_get_SKPbc (evdp, np, em);
elseif strcmp(phase_name,'SKiKP') || strcmp(phase_name,'SKPcd')
    [rayp, taup, Xp]= y_get_SKPcd (evdp, np, em);
elseif strcmp(phase_name,'SKIKP') || strcmp(phase_name,'SKPdf') 
    [rayp, taup, Xp]= y_get_SKPdf (evdp, np, em);
elseif strcmp(phase_name,'SKS')
    [rayp, taup, Xp]= y_get_SKS (evdp, np, em);
elseif strcmp(phase_name,'SKSP')
    [rayp, taup, Xp]= y_get_SKSP (evdp, np, em);
elseif strcmp(phase_name,'SKiKS')
    [rayp, taup, Xp]= y_get_SKiKS (evdp, np, em);
elseif strcmp(phase_name,'SKKS')
    [rayp, taup, Xp]= y_get_SKKS (evdp, np, em);
elseif strcmp(phase_name,'SKKS1')
    [rayp, taup, Xp]= y_get_SKKS1 (evdp, np, em);
elseif strcmp(phase_name,'SKKS2')
    [rayp, taup, Xp]= y_get_SKKS2 (evdp, np, em);
elseif strcmp(phase_name,'Ps') || strcmp(phase_name,'Pxs') % convert waves
    [rayp, taup, Xp]= y_get_Pxs (evdp, np, em, xdep);   
elseif strcmp(phase_name,'PxP')
    [rayp, taup, Xp]= y_get_PxP (evdp, np, em, xdep);    
elseif strcmp(phase_name,'SxS')
    [rayp, taup, Xp]= y_get_SxS (evdp, np, em, xdep);  
% elseif strcmp(phase_name,'SsPmp')
%     [rayp, taup, Xp]= y_get_SsPmp (evdp, np, em);
elseif strcmp(phase_name,'SsPxp')
    [rayp, taup, Xp]= y_get_SsPxp (evdp, np, em, xdep);
elseif strcmpi(phase_name,'O') % original time
    taup = zeros(1,np);    rayp = zeros(1,np);    Xp = linspace(0,pi,np);
elseif strcmp(phase_name,'pS')
    [rayp, taup, Xp]= y_get_p0S (evdp, np, em);
elseif strcmp(phase_name,'sP')
    [rayp, taup, Xp]= y_get_s0P (evdp, np, em);  
elseif strcmp(phase_name,'sPP')
    [rayp, taup, Xp]= y_get_s0PP (evdp, np, em);  
elseif strcmp(phase_name,'PcP')
    [rayp, taup, Xp]= y_get_PcP (evdp, np, em);
elseif strcmp(phase_name,'PcS')
    [rayp, taup, Xp]= y_get_PcS (evdp, np, em);
elseif strcmp(phase_name,'PcPPcP')
    [rayp, taup, Xp]= y_get_PcPPcP (evdp, np, em);
elseif strcmp(phase_name,'PcPPcPPcP')
    [rayp, taup, Xp]= y_get_PcPPcPPcP (evdp, np, em);
elseif strcmp(phase_name,'ScS')
    [rayp, taup, Xp]= y_get_ScS (evdp, np, em);
elseif strcmp(phase_name,'ScP')
    [rayp, taup, Xp]= y_get_ScP (evdp, np, em);
elseif strcmp(phase_name,'ScSScS')
    [rayp, taup, Xp]= y_get_ScSScS (evdp, np, em);
elseif strcmp(phase_name,'SP')
    [rayp, taup, Xp]= y_get_SP (evdp, np, em);
elseif strcmp(phase_name,'sSP')
    [rayp, taup, Xp]= y_get_sSP (evdp, np, em);
elseif strcmp(phase_name,'pSP')
    [rayp, taup, Xp]= y_get_pSP (evdp, np, em);
elseif strcmp(phase_name,'PS')
    [rayp, taup, Xp]= y_get_PS (evdp, np, em);
elseif strcmp(phase_name,'S_Sdiff') || strcmp(phase_name,'SSdiff')
    [rayp, taup, Xp]= y_get_S_Sdiff (evdp, np, em);
elseif strcmp(phase_name,'P_Pdiff') || strcmp(phase_name,'PPdiff')
    [rayp, taup, Xp]= y_get_P_Pdiff (evdp, np, em);
elseif strcmp(phase_name,'sSall') || strcmp(phase_name,'s0Sall') || strcmp(phase_name,'sSF')
    [rayp, taup, Xp]= y_get_s0Sall (evdp, np, em);
elseif strcmp(phase_name,'Sdiff')
    [rayp, taup, Xp]= y_get_Sdiff (evdp, np, em);
elseif strcmp(phase_name,'Pdiff')
    [rayp, taup, Xp]= y_get_Pdiff (evdp, np, em);
% elseif strcmp(phase_name,'Pall')
%     [rayp, taup, Xp]= y_get_Pall (evdp, np, em);
elseif strcmp(phase_name,'pPall') || strcmp(phase_name,'p0Pall') || strcmp(phase_name,'pPF')
    [rayp, taup, Xp]= y_get_p0Pall (evdp, np, em);
elseif strcmp(phase_name,'PPS')
    [rayp, taup, Xp]= y_get_PPS (evdp, np, em);
elseif strcmp(phase_name,'PSS')
    [rayp, taup, Xp]= y_get_PSS (evdp, np, em);
% elseif strcmp(phase_name,'Sall')
%     [rayp, taup, Xp]= y_get_Sall (evdp, np, em);
elseif strcmp(phase_name,'Ssxs')
    [rayp, taup, Xp]= y_get_Ssxs (evdp, np, em, xdep);
elseif strcmp(phase_name,'ScSSxs')
    [rayp, taup, Xp]= y_get_ScSSxs (evdp, np, em, xdep);
elseif strcmp(phase_name,'S_Sdiff_sxs')
    [rayp, taup, Xp]= y_get_S_Sdiff_sxs (evdp, np, em, xdep);
elseif strcmp(phase_name,'ScSxScS')
    [rayp, taup, Xp]= y_get_ScSxScS (evdp, np, em, xdep);
elseif strcmp(phase_name,'SxSS')
    [rayp, taup, Xp]= y_get_SxSS (evdp, np, em, xdep); 
elseif strcmp(phase_name,'p_P_Pdiff') || strcmp(phase_name,'PF') ||  strcmp(phase_name,'Pall')
    [rayp, taup, Xp]= y_get_p_P_Pdiff (evdp, np, em);
elseif strcmp(phase_name,'s_S_Sdiff') || strcmp(phase_name,'SF') || strcmp(phase_name,'Sall')
    [rayp, taup, Xp]= y_get_s_S_Sdiff (evdp, np, em);
elseif strcmp(phase_name,'PKJKP') 
    [rayp, taup, Xp]= y_get_PKJKP (evdp, np, em);
elseif strcmp(phase_name,'Surf')    
    v = xdep; % reduced velocity or default surface wave velocity
    taup = zeros(1,2);
    Xp = [0 pi];
    rayp = em.re/v*ones(1,2);
elseif strcmp(phase_name,'R-6') % reduced 6 km/s
    v = 6;
    taup = zeros(1,2);
    Xp = [0 pi];
    rayp = em.re/v*ones(1,2);
elseif strcmp(phase_name,'R-8') % reduced 8 km/s
    v = 8;
    taup = zeros(1,2);
    Xp = [0 pi];
    rayp = em.re/v*ones(1,2);
elseif strcmp(phase_name,'R-10') % reduced 10 km/s
    v = 10;
    taup = zeros(1,2);
    Xp = [0 pi];
    rayp = em.re/v*ones(1,2);
elseif strcmp(phase_name,'SxS_top');
    [rayp, taup, Xp]= y_get_SxS_top (evdp, np, em, xdep);
elseif strcmp(phase_name,'pPn');
    [rayp, taup, Xp]= y_get_pPn (evdp, np, em);
elseif strcmp(phase_name,'sPn');
    [rayp, taup, Xp]= y_get_sPn (evdp, np, em);
elseif strcmp(phase_name,'sSn');
    [rayp, taup, Xp]= y_get_sSn (evdp, np, em);
elseif strcmp(phase_name,'pSn');
    [rayp, taup, Xp]= y_get_pSn (evdp, np, em);
elseif strcmp(phase_name,'PmpPn') || strcmp(phase_name,'PnPmp')
    [rayp, taup, Xp]= y_get_PmpPn (evdp, np, em);
elseif strcmp(phase_name,'PmsPn') || strcmp(phase_name,'PnPms')
    [rayp, taup, Xp]= y_get_PmsPn (evdp, np, em);
elseif strcmp(phase_name,'pPmp') || strcmp(phase_name,'pPmP')
    [rayp, taup, Xp]= y_get_pPmp (evdp, np, em);
elseif strcmp(phase_name,'sPmp') || strcmp(phase_name,'sPmP')
    [rayp, taup, Xp]= y_get_sPmp (evdp, np, em);
elseif strcmp(phase_name,'sSms') || strcmp(phase_name,'sSmS')
    [rayp, taup, Xp]= y_get_sSms (evdp, np, em);
elseif strcmp(phase_name,'pSms') || strcmp(phase_name,'pSmS')
    [rayp, taup, Xp]= y_get_pSms (evdp, np, em);
elseif strcmp(phase_name,'Pg');
    [rayp, taup, Xp]= y_get_Pg (evdp, np, em);
elseif strcmp(phase_name,'Sg');
    [rayp, taup, Xp]= y_get_Sg (evdp, np, em);
elseif strcmp(phase_name,'sPg');
    [rayp, taup, Xp]= y_get_sPg (evdp, np, em);
elseif strcmp(phase_name,'pPg');
    [rayp, taup, Xp]= y_get_pPg (evdp, np, em);
elseif strcmp(phase_name,'sP0');
    [rayp, taup, Xp]= y_get_sP0 (evdp, np, em);
elseif strcmp(phase_name,'Pgx');
    if xdep > 10, xdep = 1; end
    [rayp, taup, Xp]= y_get_Pgx (evdp, np, em, xdep);
else
    fprintf('No phase %s available!\n',phase_name);
end

end
