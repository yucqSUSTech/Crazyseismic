function [ para ] = para_Pick_SF(  )

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
set(0,'Defaultlinelinewidth',2);

% define line width, color, marker, markersize
para.bcolor = 0.9*[1 1 1]; % edit box background color
para.color_show = [0 0 0]; % color for regular traces
para.color_selected = [1 0 0]; % color for selected trace s
para.color_wig_up = [0 0 0]; % positive wiggle color
para.color_wig_dn = 0.7*[1 1 1]; % negative wiggle color
para.linewidth_show = 1.5; % line width of regular traces
para.linewidth_selected = 2; % line width of selected traces
para.marker_theo = 'v'; % theoretical arrival time marker
para.color_theo = 'm'; % color of theoretical arrival time marker
para.msize_theo = 5; % theoretical arrival time marker size


%% Seismic phases, velocity model and travel times
% Reference 1D Earth model for trave time calculating. you can choose
% 'ak135', 'prem', 'iasp91', or others defined in set_vmodel_v2.m. 
para.mod = 'ak135';%
% Maximum layer thickness in the earth model ( interpolate if layer
% thickness is larger than this value)
para.thmax = 15;
% Refine 1-D reference Earth model
para.em = set_vmodel_v2(para.mod);
para.em = refinemodel(para.em, para.thmax);
% avoid same depth
ind = find(diff(para.em.z)<1e-6);
para.em.z(ind+1) = para.em.z(ind) + 1e-6;
% Number of ray parameters used in calculating phase arrival time. We use
% ray shooting and then interpolate them to get the arrival time at certain
% epicentral distance.
para.np = 100;
% Seismic phase to pick
para.phase = 'SF';
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
% List of sacfiles (stored in each event directory)
para.listname = 'list_z';
% Output
% Phase filename for storing picked phase arrival time. If exist, load in
% phasefile instead of listname. 
para.phasefileapp = '.txt';
para.phasefile = [para.listname,'_',para.phase,para.phasefileapp];
% copy list appendix
para.copylistapp = '_good';
% parameter output file for each event
para.paraoutfile = 'outpara.txt';

%% Traces and time windows
% Number of traces per frame
para.n_per_frame = 100;
% Sampling rate (in seconds)
para.delta = 0.1;
% Trace time window (to read, in seconds, relative to the phase arrival time)
para.timewin = [-60 120];
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
para.pca_win = para.x_lim;
% PCA order: 1: for first principle component
para.pca_ncomp = 1;
% Trace sort type
para.sort_type = 'dist'; % dist, baz, snr, stla, stlo
% Trace plot type
para.plot_type = 'trace'; % trace or wiggles
% Trace normalization type. 'each' - each trace normalized by itself; 'all'
% - all traces normalized by the same scale.
para.norm_type = 'each';
% filter type and bandwidth, set fl=0 for low pass filter, and fh=0 for
% high pass filter. 'Two-Pass' for two pass butterworth filter; 'Min-Phase'
% for minimum phase filter
para.filter_type = 'Two-Pass';
para.fl = 0.02; % low frequency (Hz)
para.fh = 1; % high frequency (Hz)
para.order = 2; % order of the filter
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


%% lists
% phase list
para.phaselist  = {
    'P';
    'S';
    'pPF';
    'sSF';
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
    'SKSP';
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
    'R-10';
    'R-8';
    'R-6';
    };

% sort list
para.sortlist = {
    'dist';
    'az';
    'snr';
    'ccmean';
    'snr0'; % predefined snr
    'xcoeff0'; % predefined cross correlation coefficient
    'baz';
    'rayp';
    'stla';
    'stlo';
    'nstnm';
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
    'snr0';
    'ccmean';
    'xcoeff0';
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

para.r2d = 180/pi; % radius to degree convertion parameter

%%
para.intederi_type = 'no';
para.intederi_list = {
    'no';
    'int'; % integration
    'der'; % derivation
    'sqrt'; % square root with sign
    '4th'; % 4th root
    };

para.vmodel_list = {
    'AK135';
    'PREM';
    'IASP91';
    };
    
para.colorpool = {
    [255 0 0]/255;
    [0 255 0]/255;
    [0 0 255]/255;
    [255 255 0]/255;
    [0 255 255]/255;
    [255 0 255]/255;
    [255 128 0]/255;
    [128 0 255]/255;
    [128 128 128]/255;
    };
    
end

