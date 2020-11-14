function [ para ] = para_Decon_O(  )

% set default parameters for y_crazyseismic_Pick

%% Figure and text setting
% default fontsize and fontname
set(0,'defaultaxesfontsize',12);
set(0,'defaultaxesfontname','Helvetica');
set(0,'DefaultaxesFontweight','Bold');
set(0,'defaulttextfontsize',12);
set(0,'defaulttextfontname','Helvetica');
set(0,'DefaulttextFontweight','Bold');
set(0,'DefaultUicontrolFontsize',12);
set(0,'DefaultUicontrolFontname','Helvetica');
set(0,'DefaultUicontrolFontweight','Bold');
set(0,'DefaultUipanelFontsize',12);
set(0,'DefaultUipanelFontname','Helvetica');
set(0,'DefaultUipanelFontweight','Bold');
set(0,'DefaultUicontrolUnits','normalized');
set(0,'Defaultlinelinewidth',1);

% define line width, color, marker, markersize
para.bcolor = 0.9*[1 1 1]; % edit box background color
para.color_denom = [0 0 0]; % color for denominator
para.color_numer = [0 0 1]; % color for numerator
para.color_denom_selected = [1 0 0]; % color for selected denominator
para.color_numer_selected = [0 1 0];  % color for selected numerator
para.color_wig_up_denom = [0 0 0]; % wiggle fill color for denominator - positive
para.color_wig_dn_denom = 0.7*[1 1 1]; % wiggle fill color for denominator - negative
para.color_wig_up_numer = [0 0 1]; % wiggle fill color for numerator - positive
para.color_wig_dn_numer = 0.8*[1 1 1]; % wiggle fill color for numerator - negative
para.marker_theo = 'v'; % theoretical arrival time marker
para.linewidth_show = 1.5; % line width of regular traces
para.linewidth_selected = 2; % line width of selected traces
para.color_theo = 'm'; % color of theoretical arrival time marker
para.msize_theo = 5; % theoretical arrival time marker size


%% Seismic phases, velocity models and travel times
% Reference 1D Earth model for trave time calculating. you can choose
% 'ak135', 'prem', 'iasp91', or others defined in set_vmodel_v2.m. 
para.mod = 'ak135';
% Maximum layer thickness in the earth model ( interpolate if layer
% thickness is larger than this value)
para.thmax = 15;
% Refine 1-D reference Earth model
para.em = set_vmodel_v2(para.mod);
para.em = refinemodel(para.em, para.thmax);
% Number of ray parameters used in calculating phase arrival time. We use
% ray shooting and then interpolate them to get the arrival time at certain
% epicentral distance.
para.np = 100;
% Seismic phase to pick
para.phase = 'O';
% 'x' discontinuity depth ( for some phases, such as Pxs, SxS,...)
para.xdep = 660;
% If you have a taup table, then use it for interpolation instead of
% calculating the travel time each time.
para.taupmat = 'taup.mat';


%% Input and output files
% Input
% List of events - full path
para.evlist = 'evlist_test.txt';
[para.evpathname, name1, name2] = fileparts(para.evlist);
para.evlistname = [name1,name2];
% List of numer/denom sacfiles (stored in each event directory)                
para.list_numer = 'list_r';
para.list_denom = 'list_z';   
% Output
% Phase filename for storing picked phase arrival time. If exist, load in
% phasefile instead of listname. 
para.phasefileapp = '.txt';
para.phasefile_denom = [para.list_denom,'_',para.phase,para.phasefileapp];
para.phasefile_numer = [para.list_numer,'_',para.phase,para.phasefileapp];
% copy list appendix
para.copylistapp = '_good';
% parameter output file for each event
para.paraoutfile = 'outpara.txt';


%% Trace and time windows
% Number of traces per frame
para.n_per_frame = 100;
% Sampling rate (in seconds)
para.delta = 0.1;
% Trace time window (to read, in seconds, relative to the phase arrival time)
para.timewin = [-60,120];
% Trace time window (to show, in seconds, relative to the phase arrival time)
para.x_lim = para.timewin/2;
% Trace normalizaton window;
para.normwin = para.timewin;
% Trace signal and noise window
para.signalwin = [-5 20];
para.noisewin = [-30 -5];
% automatic pick peak window
para.autopeakwin = [-5 5];
% Cross correlation parameters
para.xcorr_win = [-5 5]; % right
para.xcorr_tlag = 5; % maximum lags (in seconds)
% PCA stacking time window
para.pca_win = para.x_lim; % stacking window
% PCA order: 1: for first principle component
para.pca_ncomp = 1;
% Trace sort type
para.sort_type = 'dist'; % dist, baz, snr, stla, stlo
% Trace plot type
para.plot_type = 'trace'; % trace or wiggle
% Trace normalization type. 'each' - each trace normalized by itself; 'all'
% - all traces normalized by the same scale.
para.norm_type = 'each'; % all or each
% filter type and bandwidth, set fl=0 for low pass filter, and fh=0 for
% high pass filter. 'Two-Pass' for two pass butterworth filter; 'Min-Phase'
% for minimum phase filter
para.filter_type = 'Two-Pass'; % Two-Pass or Min-Phase
para.fl = 0.02; % low frequency (Hz)
para.fh = 1; % high frequency (Hz)
para.order = 2;
% Trace amplitude scale
para.scale = 1;
% text parameters
para.text_para = {'dist','baz'};
% Pca type1: 'all': for all traces of current event; 'select': for selected
% traces only; 'frame': for traces in the current frame; 
para.pca_type1 = 'all'; 
% Pca type2: 'raw': for raw data; 'filter': for filtered data
para.pca_type2 = 'raw';


%% Plot switches and labels
para.theo_switch = 0; % whether plot theoretical arrvial time, 0 not plot
para.phase_show = 0; % whether mark phases
para.xy_switch = 0; % whether change X-Y axis
para.even_switch = 0; % whether evenly distribute
para.xlabel_name = 'Time (s)'; % xlabel
% para.ylabel_name = para.sort_type; % ylabel
% para.ylabel_name_backup = para.ylabel_name; % ylabel backup


%% Deconvolution para meters
para.decontype='water'; % 'water' or 'iter'
para.denom_show = 1;
para.numer_show = 1;
para.ref_numer = 0;
para.ref_denom = 1;
para.deconwin = para.x_lim;
para.deconshowin = para.x_lim;
para.waterlevel = 0.001;
para.F0 = 2.5;
para.TDEL = 20;
% time domain iterative deconvolution parameters
para.itmax = 100;
para.minerr = 0.01;


%% lists
% phase list
para.phaselist  = {
    'P';
    'S';
    'pP';
    'sS';
    'sP';
%     'pS';
    'PP';
%     'PPP';
    'SS';
%     'SSS';
    'PS';
    'SP';
    'PcP';
    'ScS';
    'PcS';
    'ScP';
%     'PcPPcP';
    'ScSScS';
    'Pdiff';
    'Sdiff';
%     'P_Pdiff';
%     'S_Sdiff';
    'PF'; %p, P, Pdiff
    'SF';
%     'PKPab';
%     'PKPbc';
    'PKiKP';
    'PKIKP';
    'PKKP'
    'SKS';
    'SKKS';
    'O';% origin time
    'Pn';
    'pPn';
    'sPn';
    'PmP';
    'pPmp';
    'sPmp';
    'Sn';
    'pSn';
    'sSn';
    'SmS';
    'pSms';
    'sSms';
    'Pg';
    'Sg';
    'sPg';
    'sP0';
    'R-8';
    'R-6';
    };

% sort list
para.sortlist = {
    'dist';
    'az'
    'baz';
    'rayp';
    'stla';
    'stlo';
    'nstnm';
    'snr';
    'tshift';
    'evla';
    'evlo';
    'evdp';
    'mag';
    };

% plot type list

para.plotype_list = {
    'trace';
    'wiggle'
    };

% normalization list
para.normtype_list = {
    'each';
    'all'
    };

% filter type
para.filtertype_list = {
    'Two-Pass';
    'One-Pass';
    'Min-Phase'
    };

% text parameters
para.text_list = {
    'dist';
    'az';
    'baz';
    'rayp';
    'stla';
    'stlo';
    'snr';
    'evla';
    'evlo';
    'evdp';
    'mag';
    };

% pca type1
para.pcatype1_list = {    
    'all';
    'frame';
    'select'
    };

% pca type2
para.pcatype2_list = {
    'raw';
    'filter';
    };

% listbox type
para.listbox_list = {
    'nstnm';
    'stnm';
    'fname';
    };

para.decontype_list = {
    'water';
    'iter';
    };

para.r2d = 180/pi;% radius to degree convertion parameter

end

