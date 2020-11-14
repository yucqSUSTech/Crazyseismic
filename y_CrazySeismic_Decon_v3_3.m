function y_CrazySeismic_Decon_v3_3

% CrazySeismic
% -- A MATLAB-GUI based software for passive seismic data processing
% Subpackage: CrazySeismic_Decon
% Purposes: (1) Data selection, (2) Travel time picking, and (3)Deconvolution
% Features: (1) Easy to use, (2) Efficient, and (3) Quality control

% Written by Chunquan Yu & Yingcai Zheng @MIT-EAPS, 2015, All rights reserved.
% Reference: "Crazyseismic: A MATLAB-GUI based software for passive seismic
% data processing", to be submitted to Seismological Research Letters.

% modified by Chunquan Yu, 2019/11/09 to take into account ellipticity when
% calculating distance and azimuth

%% add path
path(path,genpath(pwd));

%% Import parameters
para = para_Decon;
% para = para_Decon_O;
% para = para_Decon_SF;
tr_denom = [];
tr_numer = [];


%% Main program
%% Figure setup
handle.f1               =	figure('Toolbar','figure','Units','normalized','keypressfcn', @Decon_short_cut,'Position',[.1 .1 .8 .8]);
                            set(handle.f1,'name','Crazyseismic Decon','NumberTitle','off');
handle.hax              =	axes('pos', [.2 .05 .6 .85]);
                            box(handle.hax,'on');

% uicontrol hot keys
handle.h_hot            =	uicontrol('String','<html><b>CrazySeismic Decon</b></html>','keypressfcn',@Decon_short_cut,'Position',[.01 .91 .15 .08]);

%% Plot panel
% plotting parameters
plot_panel              =	uipanel('parent', handle.f1,'title', 'Plot', 'Position', [0.01 .27 .15 .63]);
% initial plot (load in data)
                            uicontrol(plot_panel,'String','Ini(i)','callback',@Decon_callback_iniplot,'Position',[.1 .90 .8 .1]);
% find the default phase name
ind = find(strcmp(para.phaselist,para.phase));
if ~ind
    fprintf('No phase %s in the list\n',para.phase); return;
end
                            uicontrol(plot_panel,'Style','text','String','Phase','Position',[.0 .85 .4 .04]);
handle.h_phase_list     =   uicontrol(plot_panel,'Style','popupmenu','String',para.phaselist,'callback',@Decon_callback_choosephase,'Value',ind,'Position',[.4 .85 .4 .04]);
handle.h_mark_show      =   uicontrol(plot_panel,'Style','togglebutton','String','Mark','callback',@Decon_callback_markphase,'Position',[.80 .80 .2 .04]);
handle.h_mark_phase     =   uicontrol(plot_panel,'Style','listbox','String',para.phaselist,'Position',[.80 .45 .2 .35],'max',1000);
                            uicontrol(plot_panel,'Style','text','String','All','Position',[.80 .4 .1 .035]);
handle.h_mark_all       =   uicontrol(plot_panel,'Style','checkbox','callback',@Decon_callback_markphase,'Position',[.90 .40 .1 .04]);
% text distance and back azimuth
handle.h_textpara       =   uicontrol(plot_panel,'Style','togglebutton','String','Text','callback',@Decon_callback_textpara,'Position',[.80 .85 .2 .04]);
% find sort type
ind = find(strcmp(para.sortlist,para.sort_type));
if ~ind
    fprintf('No sort_type %s in the list\n',para.sort_type); return;
end
                            uicontrol(plot_panel,'Style','text','String','Sort','Position',[.0 .80 .4 .04]);
handle.h_sort_list      =   uicontrol(plot_panel,'Style','popup','String',para.sortlist,'callback',@Decon_callback_sort,'Value',ind,'Position',[.4 .80 .4 .04]);
% find plot type
ind = find(strcmp(para.plotype_list,para.plot_type));
if ~ind
    fprintf('No plot_type %s in the list\n',para.plot_type); return;
end
                            uicontrol(plot_panel,'Style','text','String','Ptype','Position',[.0 .75 .4 .04]);
handle.h_plotype_list   =   uicontrol(plot_panel,'Style','popup','String',para.plotype_list,'callback',@Decon_callback_plotype,'Value',ind,'Position',[.4 .75 .4 .04]);
% find norm type
ind = find(strcmp(para.normtype_list,para.norm_type));
if ~ind
    fprintf('No norm_type %s in the list\n',para.norm_type); return;
end
                            uicontrol(plot_panel,'Style','text','String','Norm','Position',[.0 .70 .4 .04]);
handle.h_normtype_list  =   uicontrol(plot_panel,'Style','popup','String',para.normtype_list,'callback',@Decon_callback_norm,'Value',ind,'Position',[.4 .70 .4 .04]);
% number of traces per frame
                            uicontrol(plot_panel,'Style','text','String','Ntrace','Position',[.0 .65 .4 .04]);
handle.h_ntrace_num     =   uicontrol(plot_panel,'Style','edit','String',num2str(para.n_per_frame),'callback',@Decon_callback_tracenumber,'Position',[.4 .65 .4 .04],'BackgroundColor',para.bcolor);
% data sampling interval
                            uicontrol(plot_panel,'Style','text','String','Delta','Position',[.0 .60 .4 .04]);
handle.h_delta          =   uicontrol(plot_panel,'Style','edit','String',num2str(para.delta),'callback',@Decon_callback_delta,'Position',[.4 .6 .4 .04],'BackgroundColor',para.bcolor);
% filtering
                            uicontrol(plot_panel,'Style','pushbutton','String','Filter','callback',@Decon_callback_filter,'Position',[.05 .55 .3 .04]);
% find filter type
ind = find(strcmp(para.filtertype_list,para.filter_type));
if ~ind
    fprintf('No filter_type %s in the list\n',para.filter_type); return;
end
handle.h_filter_type    =   uicontrol(plot_panel,'Style','popup','String',para.filtertype_list,'Value',ind,'Position',[.4 .55 .4 .04]);
                            uicontrol(plot_panel,'Style','text','String','Lowf','Position',[.0 .50 .4 .04]);
handle.h_filter_fl      =   uicontrol(plot_panel,'Style','edit','String',num2str(para.fl),'Position',[.4 .50 .4 .04],'BackgroundColor',para.bcolor);
                            uicontrol(plot_panel,'Style','text','String','Highf','Position',[.0 .45 .4 .04]);
handle.h_filter_fh      =   uicontrol(plot_panel,'Style','edit','String',num2str(para.fh),'Position',[.4 .45 .4 .04],'BackgroundColor',para.bcolor);
                            uicontrol(plot_panel,'Style','text','String','Order','Position',[.0 .40 .4 .04]);
handle.h_order          =   uicontrol(plot_panel,'Style','edit','String',num2str(para.order),'Position',[.4 .40 .4 .04],'BackgroundColor',para.bcolor);
% amp +/-
                            uicontrol(plot_panel,'Style','text','String','Amplitude','Position',[.2 .35 .6 .04]);
                            uicontrol(plot_panel,'String','+(=)','callback',@Decon_callback_ampup,'Position',[.05 .30 .45 .05]);
                            uicontrol(plot_panel,'String','-(-)', 'callback',@Decon_callback_ampdown,'Position',[.5 .30 .45 .05]);
% time axis +/-
                            uicontrol(plot_panel,'Style','text','String','Zoom','Position',[.2 .25 .6 .04]);
                            uicontrol(plot_panel,'String','In([)','callback',@Decon_callback_timeup,'Position',[.05 .20 .45 .05]);
                            uicontrol(plot_panel,'String','Out(])', 'callback',@Decon_callback_timedown,'Position',[.5 .20 .45 .05]);
% theoretical arrival time
handle.theoplot_button  =   uicontrol(plot_panel,'Style','togglebutton','String','Theo_T','callback',@Decon_callback_theoplot,'Position',[.05 .15 .9 .04]);
% polarity
handle.polarity         =	uicontrol(plot_panel,'Style','pushbutton','String','+/- (f)','callback',@Decon_callback_polarity,'Position',[.05 .10 .9 .04]);
% x-y switch
handle.xy_button        =   uicontrol(plot_panel,'Style','togglebutton','String','X<->Y','callback',@Decon_callback_xyswitch,'Position',[.05 .05 .9 .04]);
% evenly/Uniformly distribute
handle.even_button      =   uicontrol(plot_panel,'Style','togglebutton','String','Even (e)','callback',@Decon_callback_even,'Position',[.05 .0 .9 .04]);

%% Window panel
% time window
win_panel               =   uipanel('parent', handle.f1,'title', 'Win', 'pos', [0.01 .05 .15 .2]);
% window update
                            uicontrol(win_panel,'Style','pushbutton','callback',@Decon_callback_window,'String','Window update','Position',[.05 .83 .9 .15]);
% data window % for loading data
                            uicontrol(win_panel,'Style','text','String','Data','Position',[.0 .65 .3 .15]);
handle.h_timewin_L      =   uicontrol(win_panel,'Style','edit','String',num2str(para.timewin(1)),'Position',[.3 .65 .35 .15],'BackgroundColor',para.bcolor);
handle.h_timewin_R      =   uicontrol(win_panel,'Style','edit','String',num2str(para.timewin(2)),'Position',[.65 .65 .35 .15],'BackgroundColor',para.bcolor);
% xlim window
                            uicontrol(win_panel,'Style','text','String','Xlim','Position',[.0 .5 .3 .15]);
handle.h_xlim_L         =   uicontrol(win_panel,'Style','edit','String',num2str(para.x_lim(1)),'Position',[.3 .5 .35 .15],'BackgroundColor',para.bcolor);
handle.h_xlim_R         =   uicontrol(win_panel,'Style','edit','String',num2str(para.x_lim(2)),'Position',[.65 .5 .35 .15],'BackgroundColor',para.bcolor);
% signal window
                            uicontrol(win_panel,'Style','text','String','Signal','Position',[.0 .35 .3 .15]);
handle.h_signalwin_L    =   uicontrol(win_panel,'Style','edit','String',num2str(para.signalwin(1)),'Position',[.3 .35 .35 .15],'BackgroundColor',para.bcolor);
handle.h_signalwin_R    =   uicontrol(win_panel,'Style','edit','String',num2str(para.signalwin(2)),'Position',[.65 .35 .35 .15],'BackgroundColor',para.bcolor);
% noise window
                            uicontrol(win_panel,'Style','text','String','Noise','Position',[.0 .2 .3 .15]);
handle.h_noisewin_L     =   uicontrol(win_panel,'Style','edit','String',num2str(para.noisewin(1)),'Position',[.3 .2 .35 .15],'BackgroundColor',para.bcolor);
handle.h_noisewin_R     =   uicontrol(win_panel,'Style','edit','String',num2str(para.noisewin(2)),'Position',[.65 .2 .35 .15],'BackgroundColor',para.bcolor);
% norm window
                            uicontrol(win_panel,'Style','text','String','Norm','Position',[.0 .05 .3 .15]);
handle.h_normwin_L      =   uicontrol(win_panel,'Style','edit','String',num2str(para.normwin(1)),'Position',[.3 .05 .35 .15],'BackgroundColor',para.bcolor);
handle.h_normwin_R      =   uicontrol(win_panel,'Style','edit','String',num2str(para.normwin(2)),'Position',[.65 .05 .35 .15],'BackgroundColor',para.bcolor);

%% Pick panel
% phase arrival time picking
Pick_panel             =   uipanel('parent', handle.f1,'title', 'Pick', 'pos', [0.85 .87 .14 .12]);
                            uicontrol(Pick_panel,'String','Pick(p/t)','callback',@Decon_callback_picktt,'Position',[.05 .55 .4 .4]);
                            uicontrol(Pick_panel,'String','Align(a)','callback',@Decon_callback_align,'Position',[.05 .05 .4 .4]);
                            uicontrol(Pick_panel,'String','Peak(w)','callback',@Decon_callback_autopeak,'Position',[.45 .3 .5 .3]);
handle.h_autopeak_L     =   uicontrol(Pick_panel,'Style','edit','String',num2str(para.autopeakwin(1)),'Position',[.45 .7 .25 .25],'BackgroundColor',para.bcolor);
handle.h_autopeak_R     =   uicontrol(Pick_panel,'Style','edit','String',num2str(para.autopeakwin(2)),'Position',[.7 .7 .25 .25],'BackgroundColor',para.bcolor);
handle.h_peakloop       =   uicontrol(Pick_panel,'Style','togglebutton','String','Loop','callback',@Decon_callback_autopeakloop,'Position',[.75 .05 .2 .2],'BackgroundColor',para.bcolor);
handle.h_gpick          =   uicontrol(Pick_panel,'String','Gpick','callback',@Decon_callback_gpick,'Position',[.45 .05 .3 .2]);
     
%% Multi channel
% multi-channel cross correlation & stacking
multi_panel             =   uipanel('parent', handle.f1,'title', 'Multi', 'pos', [0.85 .6 .14 .25]);
                            uicontrol(multi_panel,'Style','text','String','Mccc window','Position',[0.05 .92 .9 .08 ]);
handle.h_xcorr_winL     =   uicontrol(multi_panel,'Style','edit','String',num2str(para.xcorr_win(1)),'Position',[0.05 .82 .45 .1],'BackgroundColor',para.bcolor);
handle.h_xcorr_winR     =   uicontrol(multi_panel,'Style','edit','String',num2str(para.xcorr_win(end)),'Position',[.5 .82 .45 .1],'BackgroundColor',para.bcolor);
                            uicontrol(multi_panel,'Style','text','String','Max lagT','Position',[0.05 .67 .45 .15 ]);
handle.h_xcorr_tlag     =   uicontrol(multi_panel,'Style','edit','String',num2str(para.xcorr_tlag),'Position',[.5 .72 .45 .1],'BackgroundColor',para.bcolor);
% cross correlation
                            uicontrol(multi_panel,'String','Xcorr(x)','callback',@Decon_callback_xcorr,'Position',[.2 .56 .6 .14]);
% pca stacking
                            uicontrol(multi_panel,'Style','text','String','Pca/Stack window','Position',[0.05 .48 .9 .08 ]);
handle.h_pca_winL       =   uicontrol(multi_panel,'Style','edit','String',num2str(para.pca_win(1)),'Position',[0.05 .38 .45 .1],'BackgroundColor',para.bcolor);
handle.h_pca_winR       =   uicontrol(multi_panel,'Style','edit','String',num2str(para.pca_win(end)),'Position',[.5 .38 .45 .1],'BackgroundColor',para.bcolor);
                            uicontrol(multi_panel,'Style','text','String','Nc','Position',[0.05 .28 .45 .1 ]);
handle.h_pca_num        =   uicontrol(multi_panel,'Style','edit','String',num2str(para.pca_ncomp),'Position',[.5 .28 .45 .1],'BackgroundColor',para.bcolor);
% find pca type1             
ind = find(strcmp(para.pcatype1_list,para.pca_type1));
if ~ind
    fprintf('No Pca_type1 %s in the list\n',para.pca_type1); return;
end
handle.h_pca_type1      =	uicontrol(multi_panel,'Style','popup','String',para.pcatype1_list,'Value',ind,'Position',[.05 .15 .3 .12]);
% find pca type2
ind = find(strcmp(para.pcatype2_list ,para.pca_type2));
if ~ind
    fprintf('No Pca_type2 %s in the list\n',para.pca_type2); return;
end
handle.h_pca_type2      =	uicontrol(multi_panel,'Style','popup','String',para.pcatype2_list,'Value',ind,'Position',[.4 .15 .3 .12]);
% show stacked figure or not
handle.h_pca_show       =	uicontrol(multi_panel,'Style','checkbox','String','Fig','Position',[.73 .15 .25 .12]);
% pca or stacking
                            uicontrol(multi_panel,'String','Pca(c)','callback',@Decon_callback_pca,'Position',[.05 .0 .45 .14]);
                            uicontrol(multi_panel,'String','Stack(k)','callback',@Decon_callback_stacking,'Position',[.5 .0 .45 .14]);                   
                   
%% Decon panel
% Deconvolution panel board
decon_panel             =   uipanel('parent', handle.f1,'title', 'Decon', 'pos', [0.85 .33 .14 .25]);
handle.h_decon          =   uicontrol(decon_panel,'Style','togglebutton','String','Decon(d)','callback',@Decon_callback_decon,'Position',[.05 .85 .45 .15]);
ind = find(strcmpi(para.decontype_list,para.decontype));
handle.h_decontype      =   uicontrol(decon_panel,'Style','popup','String',para.decontype_list,'Value',ind,'Position',[0.5, 0.85, 0.45, 0.15]);
                            uicontrol(decon_panel,'Style','text','String','Dwin','Position',[0.05 0.75 0.25 0.1]);
handle.h_decon_winL     =   uicontrol(decon_panel,'Style','edit','String',num2str(para.deconwin(1)),'Position',[0.35 0.75 0.3 0.1],'BackgroundColor',para.bcolor);
handle.h_decon_winR     =   uicontrol(decon_panel,'Style','edit','String',num2str(para.deconwin(2)),'Position',[0.65 0.75 0.3 0.1],'BackgroundColor',para.bcolor);    
                            uicontrol(decon_panel,'Style','text','String','Rwin','Position',[0.05 0.65 0.25 0.1]);
handle.h_decon_showinL  =   uicontrol(decon_panel,'Style','edit','String',num2str(para.deconshowin(1)),'Position',[0.35 0.65 0.3 0.10],'BackgroundColor',para.bcolor);
handle.h_decon_showinR  =   uicontrol(decon_panel,'Style','edit','String',num2str(para.deconshowin(2)),'Position',[0.65 0.65 0.3 0.10],'BackgroundColor',para.bcolor);    
                            uicontrol(decon_panel,'Style','text','String','Waterlevel','Position',[0.05 0.55 0.45 0.10]);
handle.h_waterlevel     =   uicontrol(decon_panel,'Style','edit','String',num2str(para.waterlevel),'Position',[0.5 0.55 0.45 0.1],'BackgroundColor',para.bcolor);  
                            uicontrol(decon_panel,'Style','text','String','F0','Position',[0.25 0.45 0.25 0.1]);
handle.h_F0             =   uicontrol(decon_panel,'Style','edit','String',num2str(para.F0),'Position',[0.5 0.45 0.45 0.1],'BackgroundColor',para.bcolor); 
handle.h_decon_filter   =   uicontrol(decon_panel,'Style','checkbox','Value',0,'Position', [0.1 0.45 0.1 0.1]);
                            uicontrol(decon_panel,'Style','text','String','Time delay','Position',[0.05 0.35 0.45 0.1]);
handle.h_TDEL           =   uicontrol(decon_panel,'Style','edit','String',num2str(para.TDEL),'Position',[0.5 0.35 0.45 0.1],'BackgroundColor',para.bcolor); 
                            uicontrol(decon_panel,'Style','text','String','Max. iter.','Position',[0.05 0.25 0.45 0.1]);
handle.h_itmax          =   uicontrol(decon_panel,'Style','edit','String',num2str(para.itmax),'Position',[0.5 0.25 0.45 0.1],'BackgroundColor',para.bcolor);    
                            uicontrol(decon_panel,'Style','text','String','Min. err.','Position',[0.05 0.15 0.45 0.1]);
handle.h_minerr         =   uicontrol(decon_panel,'Style','edit','String',num2str(para.minerr),'Position',[0.5 0.15 0.45 0.1],'BackgroundColor',para.bcolor);  
                            uicontrol(decon_panel,'Style','pushbutton','String','Save Decon','callback',@Decon_callback_savedecon,'Position',[0.1 0. 0.8 0.15]);


%% I/O panel
% input and output
io_panel                =   uipanel('parent', handle.f1,'title', 'I/O', 'pos', [0.85 .05 .14 .26]);
% load in evlist
handle.h_evlist         =   uicontrol(io_panel,'Style','edit','String',para.evlistname,'callback',@Decon_callback_load_evlist_2,'Position',[.05 .9 .9 .1],'BackgroundColor',para.bcolor);
                            uicontrol(io_panel,'callback',@Decon_callback_load_evlist,'String','Load evlist','Position',[0.05 .8 .9 .1]);
% read in denominator and numerator
handle.h_numer          =   uicontrol(io_panel,'Style','edit','String',para.list_numer,'callback',@Decon_callback_load_numer_2,'Position',[.35 .7 .4 .1],'BackgroundColor',para.bcolor);
                            uicontrol(io_panel,'Style','pushbutton','String','Numer','callback',@Decon_callback_load_numer,'Position',[.05 .7 .3 .1]);
handle.h_denom          =   uicontrol(io_panel,'Style','edit','String',para.list_denom,'callback',@Decon_callback_load_denom_2,'Position',[.35 .6 .4 .1],'BackgroundColor',para.bcolor);
                            uicontrol(io_panel,'Style','pushbutton','String','Denom','callback',@Decon_callback_load_denom,'Position',[.05 .6 .3 .1]);
handle.h_numer_show     =   uicontrol(io_panel,'Style','checkbox','Value',para.numer_show,'callback',@Decon_callback_denom_numer_show,'Position',[.75 .7 .1 .1],'BackgroundColor',para.color_numer);  
handle.h_denom_show     =   uicontrol(io_panel,'Style','checkbox','Value',para.denom_show,'callback',@Decon_callback_denom_numer_show,'Position',[.75 .6 .1 .1],'BackgroundColor',para.color_denom);
handle.h_ref_numer      =   uicontrol(io_panel,'Style','radiobutton','Value',para.ref_numer,'callback',@Decon_callback_ref_numer,'Position',[0.85 .7 .1 .1]);
handle.h_ref_denom      =   uicontrol(io_panel,'Style','radiobutton','Value',para.ref_denom,'callback',@Decon_callback_ref_denom,'Position',[0.85 .6 .1 .1]);
 
% generate a new listname
                            uicontrol(io_panel,'Style','pushbutton','String','Copy list','callback',@Decon_callback_copyphasefile,'Position',[0.05 .48 .45 .1]);
handle.h_copyphasefile  =   uicontrol(io_panel,'Style','edit','String',para.copylistapp,'Position',[.5 .48 .45 .1],'BackgroundColor',para.bcolor);
% reset event
                            uicontrol(io_panel,'Style','pushbutton','String','Reset(r)','callback',@Decon_callback_reset_event,'Position',[0.05 .35 .9 .1]);
% delete event
                            uicontrol(io_panel,'Style','pushbutton','String','Delete(Ctrl+d)','callback',@Decon_callback_del_event,'Position',[0.05 .25 .9 .1]);
% save traces
                            uicontrol(io_panel,'Style','pushbutton','String','Save(s)','callback',@Decon_callback_save,'Position',[0.05 .025 .45 .2]);
% save figure
                            uicontrol(io_panel,'Style','pushbutton','String','Save Fig','callback',@Decon_callback_savefig,'Position',[.5 .025 .45 .2]);

%% Events and frames
% events
                            uicontrol(handle.f1,'Style','pushbutton','String','pre_ev(b)', 'callback',@Decon_callback_preevent,'Position', [.25 .95 .1 .04]);
                            uicontrol(handle.f1,'Style','pushbutton','String','next_ev(n)', 'callback',@Decon_callback_nextevent,'Position', [.65 .95 .1 .04]);
                            uicontrol(handle.f1,'Style','pushbutton','String','1st','callback',@Decon_callback_firstevent,'Position', [.20 .95 .05 .04]);
                            uicontrol(handle.f1,'Style','pushbutton','String','last','callback',@Decon_callback_lastevent,'Position', [.75 .95 .05 .04]);
% pages
                            uicontrol(handle.f1,'Style','pushbutton','String','pre_ls(,)','callback',@Decon_callback_prepage,'Position', [.25 .90 .1 .04]);
                            uicontrol(handle.f1,'Style','pushbutton','String','next_ls(.)','callback',@Decon_callback_nextpage,'Position', [.65 .90 .1 .04]);
                            uicontrol(handle.f1,'Style','pushbutton','String','1st','callback',@Decon_callback_firstpage,'Position', [.20 .90 .05 .04]);
                            uicontrol(handle.f1,'Style','pushbutton','String','last','callback',@Decon_callback_lastpage,'Position', [.75 .90 .05 .04]);
% ievent
                            uicontrol(handle.f1,'Style','text','String','ievent','Position',[.8 .97 .05 .025]);
handle.h_ievent         =   uicontrol(handle.f1,'Style','edit','String','0','callback',@Decon_callback_ievent,'Position',[.80 .95 .05 .02],'BackgroundColor',para.bcolor);
% iframe
                            uicontrol(handle.f1,'Style','text','String','iframe','Position',[.8 .92 .05 .025]);
handle.h_iframe         =   uicontrol(handle.f1,'Style','edit','String','0','callback',@Decon_callback_iframe,'Position',[.8 .90 .05 .02],'BackgroundColor',para.bcolor);

%% list box and delete trace
% listbox
handle.h_listbox_list   =   uicontrol(handle.f1,'Style','popupmenu','String',para.listbox_list,'callback',@Decon_callback_replot,'Value',1,'Position',[.8 .86 .05 .03]);
handle.h_listbox        =   uicontrol(handle.f1,'Style','listbox','callback',@Decon_callback_listbox,'Value',1,'keypressfcn', @Decon_short_cut_listbox,'Position',[.8 .17 .05 .69],'max',1000);
                            uicontrol(handle.f1,'Style','pushbutton','String','Del','callback',@Decon_callback_deltrace,'Position',[.80 .13 .05 .04]);
% show trace
                            uicontrol(handle.f1,'Style','pushbutton','String','Show','callback',@Decon_callback_showtrace,'Position',[.8 .09 .05 .04]);
% flip polarity for selected traces
                            uicontrol(handle.f1,'Style','pushbutton','String','Flip(f)','callback',@Decon_callback_flip,'Position',[.8 .05 .05 .04]);


                                            
%% Callback functions:

%% plot panel functions:
    function Decon_callback_iniplot(h, dummy)
        
        % load in data, preprocess and initial plot
        uicontrol(handle.h_hot)
        
        % clear axes
        cla(handle.hax,'reset');
        
        % check event list
        if ~exist(para.evlist,'file')
            fprintf('Evlist not exist!\n');
            para.evlist = [];
            para.ievent = 1;
            cla(handle.hax,'reset');
            set(handle.h_listbox, 'String', []);
            return;
        end
        
        if ~isfield(para,'ievent') || isempty(para.events)
            fid = fopen(para.evlist,'r');
            C = textscan(fid,'%s %*[^\n]','CommentStyle','#');
            para.events = C{1};
            fclose(fid);
            para.nevent = length(para.events);
            para.ievent = 1;
        end
        
        % find the event
        [ind, flag_file_denom, flag_file_numer] = find_event_2lists_phase(para.ievent, para.events, para.list_denom, para.list_numer, para.phasefile_denom, para.phasefile_numer,'forward');
        if isempty(ind)
            %             fprintf('No next event found! Go to the last event\n');
            para.ievent = para.nevent;
            Decon_callback_lastevent (h, dummy)
        else
            para.ievent = ind;
        end
        
        if flag_file_denom == 1
            fid = fopen(fullfile(para.events{para.ievent},para.list_denom),'r');
            C = textscan(fid,'%s %*[^\n]','CommentStyle','#');
            lists_denom = C{1};
            fclose(fid);
        elseif flag_file_denom == 2
            fid = fopen(fullfile(para.events{para.ievent},para.phasefile_denom),'r');
            C = textscan(fid,'%s %f %f %f %f %s %s %f %*[^\n]','CommentStyle','#');
            lists_denom = C{1}; phtt_denom = C{2}; phtshift_denom = C{3}; polarity_denom = C{5}; phrayp_denom = C{8};
%             phT_denom = C{4}; stnm_denom = C{6}; netwk_denom = C{7};
            fclose(fid);  
        else
            fprintf('No event found!\n');
            para.ievent = 1;
            return;
        end
        
        if flag_file_numer == 1
            fid = fopen(fullfile(para.events{para.ievent},para.list_numer),'r');
            C = textscan(fid,'%s %*[^\n]','CommentStyle','#');
            lists_numer = C{1};
            fclose(fid);
        elseif flag_file_numer == 2
            fid = fopen(fullfile(para.events{para.ievent},para.phasefile_numer),'r');
            C = textscan(fid,'%s %f %f %f %f %s %s %f %*[^\n]','CommentStyle','#');
            lists_numer = C{1}; phtt_numer = C{2}; phtshift_numer = C{3}; polarity_numer = C{5}; phrayp_numer = C{8};
%             phT_numer = C{4}; stnm_numer = C{6}; netwk_numer = C{7};           
            fclose(fid); 
        end
        
        % reset global variables for each event
        tr_denom = [];
        tr_numer = [];
        handle.seishandles_denom = {[]};
        handle.seishandles_numer = {[]};
        para.iframe = 1; % set to first frame
        
        fprintf('Load in data ...\n');
        hmsg = msgbox('Loading ...','Message','non-modal'); 
        t1 = [];
        for i = 1:2 % loop for denom and numer
            if i== 1
                lists = lists_denom;
                flag_file = flag_file_denom;
            else
                lists = lists_numer;
                flag_file = flag_file_numer;
            end
            
            tr = [];
            num = 0; % reset number of traces
            
            for j = 1:length(lists)
                
                filename = char(lists(j));
                if exist(fullfile(para.events{para.ievent},filename),'file')
                    [sachd,sacdat] = irdsac(fullfile(para.events{para.ievent},filename));
                else
                    fprintf('No file %s found!\n',fullfile(para.events{para.ievent},filename));
                    continue;
                end
                
                % in case nan value exist
                if max(isnan(sacdat)) == 1 || sachd.npts <= 1
                    continue;
                end
                
                % calculate epicenteral distance and back azimuth
                % modified by Chunquan Yu (2019/11/09) to take into account
                % ellipticity
%                 [dist,baz] = distance(sachd.stla,sachd.stlo,sachd.evla,sachd.evlo);
%                 az = azimuth(sachd.evla,sachd.evlo,sachd.stla,sachd.stlo);
                [dist,baz] = distance(sachd.stla,sachd.stlo,sachd.evla,sachd.evlo,[6378.137*180/pi/6371 0.0818191908426215]); %WGS84 reference ellipsoid
                az = azimuth(sachd.evla,sachd.evlo,sachd.stla,sachd.stlo,[6378.137*180/pi/6371 0.0818191908426215]); %WGS84 reference ellipsoid
                if flag_file == 1
                    % % use ray shooting to calculate travel time
                    if  isempty(t1) || sachd.evdp ~= para.evdp
                        para.evdp = sachd.evdp;
                        if para.evdp >= 999
                            fprintf('Evdp >= 999! Please check event depth. Depth units should be km!\n');
                            fprintf('Divide event depth by 1000!\n');
                            para.evdp = para.evdp/1000; % if evdp>999, convert m to km
                        end
                        
                        [rayp,taup,Xp] = phase_taup(para.phase,para.evdp,para.np,para.em,para.xdep);
                        t1 = taup + rayp.* Xp;
                        d1 = Xp*para.r2d;
                        
                        % in case d1 larger than 180
                        d1 = rem(d1,360);
%                         ind_major = find(d1>180);
%                         d1(ind_major) = 360-d1(ind_major);
                    end
                    
                    % interpolate to get the phase arrival time
                    tt = interp1db(dist,d1,t1);
                    if isnan(tt)
                        continue;
                    end
                    
                    num = num + 1;
                    tr(num).tt = tt;
                    tr(num).tshift = 0;
                    tr(num).polarity = 1;
                    tr(num).rayp = interp1db(dist,d1,rayp/111.195/para.r2d);
                else
                    num = num + 1;
                    if i == 1                        
                        tr(num).tt = phtt_denom(j);
                        tr(num).tshift = phtshift_denom(j);
                        if polarity_denom(j) == 1 || polarity_denom(j) == -1
                            tr(num).polarity = polarity_denom(j);
                        else
                            tr(num).polarity = 1;
                        end
                        tr(num).rayp = phrayp_denom(j);
                    else
                        tr(num).tt = phtt_numer(j);
                        tr(num).tshift = phtshift_numer(j);
                        if polarity_numer(j) == 1 || polarity_numer(j) == -1
                            tr(num).polarity = polarity_numer(j);
                        else
                            tr(num).polarity = 1;
                        end
                        tr(num).rayp = phrayp_numer(j);
                    end
                end
                
                % assign values to tr structure
                tr(num).headers = sachd;
                tr(num).data_raw = sacdat;
                tr(num).visible = 1; % trace to show
                tr(num).A0 = 1; % amplitude amplify factor , used to plot
                tr(num).range = 1; % amplitude range within the normalization window
                stnm_tmp = deblank(reshape(sachd.kstnm,1,[]));
                netwk_tmp = deblank(reshape(sachd.knetwk,1,[]));
                ind1 = find(double(stnm_tmp)==0);
                ind2 = find(double(netwk_tmp)==0);
                if ~isempty(ind1)
                    stnm_tmp = stnm_tmp(1:ind1(1)-1);
                end
                if ~isempty(ind2)
                    netwk_tmp = netwk_tmp(1:ind2(1)-1);
                end
                tr(num).stnm = stnm_tmp;
                tr(num).netwk = netwk_tmp;
                tr(num).nstnm = [netwk_tmp,'.',stnm_tmp];
                tr(num).filename = filename;
                tr(num).dist = dist;
                tr(num).baz = baz;
                tr(num).az = az;
                
                tr(num).dtshift = 0; % to store the time shift of each step;
                % time relative to the theoretical phase arrival time
                tr(num).time_raw = [0:tr(num).headers.npts-1]'*tr(num).headers.delta + tr(num).headers.b - tr(num).headers.o;
                tr(num).delta_raw = tr(num).headers.delta;
            end
            
            if num == 0
                fprintf('No trace found!\n');
                return;
            end
            
            if i == 1
                tr_denom = tr;
            else
                tr_numer = tr;
            end
        end
        
        % find stations that have both denom and numer recordings
        num = 0;
        ind_denom=[];
        ind_numer = [];
        for j = 1:length(tr_denom)
            for k = 1:length(tr_numer)
                tmp_denomname = tr_denom(j).filename;
                tmp_numername = tr_numer(k).filename;
                tmp_length = min(length(tmp_denomname),length(tmp_numername));
                tmp_denomname = tmp_denomname(1:tmp_length);
                tmp_numername = tmp_numername(1:tmp_length);
                tmp = length(find(tmp_denomname - tmp_numername)); % number of different characters between them
                if strcmp(para.list_numer,para.list_denom)
                    maxtmp = 0;
                else
                    maxtmp = 1;
                end
                if tmp <= maxtmp % only one character is different, such as 'BHZ' and 'BHR'
                    num = num + 1;
                    ind_denom(num) = j;
                    ind_numer(num) = k;
                    break;
                end
            end
        end        
        
        % total number of traces
        para.nl = num;
        tr_denom = tr_denom(ind_denom);
        tr_numer = tr_numer(ind_numer);
        
        % set reference component; the other component will align according
        % to the reference component
        for j = 1:length(tr_denom)
            if para.ref_denom == 1
                tr_numer(j).tt = tr_denom(j).tt;
                tr_numer(j).tshift = tr_denom(j).tshift;
                tr_numer(j).polarity = tr_denom(j).polarity;
            else
                tr_denom(j).tt = tr_numer(j).tt;
                tr_denom(j).tshift = tr_numer(j).tshift;
                tr_denom(j).polarity = tr_numer(j).polarity;
            end
        end

        % total frames
        para.nframes = ceil(para.nl/para.n_per_frame);
        
        % show first trace's information
        para.evla = tr(1).headers.evla;
        para.evlo = tr(1).headers.evlo;
        para.evdp = tr(1).headers.evdp;
        para.mag = tr(1).headers.mag;
        if para.evdp >= 999
            fprintf('Event deep larger than 999, divided by 1000 to convert unit from m to km!\n');
            para.evdp = para.evdp/1000;
        end
        fprintf('\nEvent: %s\n',para.events{para.ievent});
        fprintf('First trace info:\n');
        fprintf('gcarc=%5.2f; az= %5.2f; baz= %5.2f; \nevla=%5.2f; evlo=%6.2f; evdp=%.0f; mag=%3.1f\n',tr(1).dist,tr(1).az,tr(1).baz,para.evla,para.evlo,para.evdp,para.mag);
        fprintf('Number of traces: %d\n', para.nl);                
        
        % set deconvolutio button to off
        set(handle.h_decon,'Value',0);
        
        % define flags, 1: run; others: pass
        para.flag.cut = 1;
        para.flag.sort = 1;
        para.flag.filter = 1;
        para.flag.snr = 1;
        
        set(handle.h_listbox,'Value',[]);
        Decon_callback_preprocess (h, dummy);
        Decon_callback_markphase (h, dummy);   
        
        delete(hmsg);
    end

    function Decon_callback_preprocess (h, dummy)
        
        % cut data and store
        if para.flag.cut == 1
            for i = 1:2 % loop for denom and numer
                if i == 1
                    tr = tr_denom;
                else
                    tr = tr_numer;
                end
                
                for j = 1:para.nl
                    % assign the sampling interval
                    tr(j).delta = para.delta;
                    % time axis
                    tr(j).time_cut = reshape(para.timewin(1):tr(j).delta:para.timewin(end),[],1);
                    % % cut data ( relative to shifted phase arrival time)
                    if length(tr(j).data_raw) > 1
                        tr(j).data_cut = interp1(tr(j).time_raw-tr(j).tt-tr(j).tshift,tr(j).data_raw,tr(j).time_cut,'linear',nan);
                    else
                        tr(j).data_cut = zeros(size(tr(j).time_cut));
                    end
                    tr(j).dtshift = 0; % reset dtshift
                    % in case time axis exceeds tr(nl).time, assign the first
                    % or last value to the data out of time window
                    nonnan = find(~isnan(tr(j).data_cut));
                    if ~isempty(nonnan)
                        tr(j).data_cut(1:nonnan(1)-1) = tr(j).data_cut(nonnan(1));
                        tr(j).data_cut(nonnan(end)+1:end) = tr(j).data_cut(nonnan(end));
                    else
                        tr(j).data_cut = zeros(size(tr(j).data_cut));
                    end
                    tr(j).data_cut = reshape(tr(j).data_cut,[],1);
                    
                    % copy for further analysis, such as filtering
                    tr(j).data = tr(j).data_cut;
                    tr(j).time = tr(j).time_cut;
                end
                if i == 1
                    tr_denom = tr;
                else
                    tr_numer = tr;
                end
            end
        end
        
        if para.flag.filter == 1
            index_filtertype = get(handle.h_filter_type,'Value');
            para.filter_type = para.filtertype_list{index_filtertype};
            for i = 1:2 % loop for denom and numer
                if i == 1
                    tr = tr_denom;
                else
                    tr = tr_numer;
                end
                for j = 1:para.nl % loop for filtering
                    % copy raw cut data, tr(j).data might be already filtered
                    decon_tmp = get(handle.h_decon,'Value');
                    if decon_tmp ~= 1
                        tr(j).data = tr(j).data_cut; % raw data
                    else % read in decon result
                        tr(j).data = tr(j).data_decon;
                        tr(j).time = tr(j).time_decon;
                    end
                    
                    % if exceed Nyquist freq. - No filtering
                    if para.fh >= 1/tr(j).delta/2
                        continue;
                    end
                    
                    if max(tr(j).data) - min(tr(j).data) ~= 0
                        tr(j).data = detrend(tr(j).data);
                        taper = tukeywin(length(tr(j).data), 0.1);
                        tr(j).data = tr(j).data .* reshape(taper,size(tr(j).data,1),size(tr(j).data,2));
                        
                        if strcmpi(para.filter_type,'Two-Pass') % Two-pass filtering
                            if para.fl > 0 && para.fh > para.fl
                                tr(j).data = filtering(tr(j).data,tr(j).delta,para.fl,para.fh,para.order); % band pass filtering
                            elseif para.fh > 0 && para.fl == 0
                                tr(j).data = filtering(tr(j).data,tr(j).delta,para.fh,'low',para.order); % low pass filtering
                            elseif para.fl > 0 && para.fh == 0
                                tr(j).data = filtering(tr(j).data,tr(j).delta,para.fl,'high',para.order); % high pass filtering
                            else
                                % no filtering
                            end
                        elseif strcmpi(para.filter_type,'One-Pass') % Two-pass filtering
                            if para.fl > 0 && para.fh > para.fl % bandpass filtering
                                tr(j).data = filtering_1pass(tr(j).data,tr(j).delta,para.fl,para.fh,para.order); % band pass filtering
                            elseif para.fh > 0 && para.fl == 0
                                tr(j).data = filtering_1pass(tr(j).data,tr(j).delta,para.fh,'low',para.order); % low pass filtering
                            elseif para.fl > 0 && para.fh == 0
                                tr(j).data = filtering_1pass(tr(j).data,tr(j).delta,para.fl,'high',para.order); % high pass filtering
                            else
                                % no filtering
                            end
                        elseif strcmpi(para.filter_type,'Min-Phase') % Two-pass filtering
                            if para.fl > 0 && para.fh > para.fl % bandpass filtering
                                tr(j).data = miniphase_filtering(tr(j).data,tr(j).delta,para.fl,para.fh,para.order); % two-pass filtering
                            elseif para.fh > 0 && para.fl == 0
                                tr(j).data = miniphase_filtering(tr(j).data,tr(j).delta,para.fh,'low',para.order); % low pass filtering
                            elseif para.fl > 0 && para.fh == 0
                                tr(j).data = miniphase_filtering(tr(j).data,tr(j).delta,para.fl,'high',para.order); % high pass filtering
                            else
                                % no filtering
                            end
                        else
                            fprintf('No filter type: %s available!\n',para.filter_type);
                            return;
                        end
                    end
                end
                if i == 1
                    tr_denom = tr;
                else
                    tr_numer = tr;
                end
            end
        end
        
        if para.flag.snr == 1
            % calculate signal to noise ratio
            for i = 1:2 % loop for denom and numer
                if i == 1
                    tr = tr_denom;
                else
                    tr = tr_numer;
                end
                for j = 1:para.nl
                    tr(j).snr = 0;
                    data_signal = interp1(tr(j).time,tr(j).data,para.signalwin(1):tr(j).delta:para.signalwin(2),'linear',0);
                    data_noise = interp1(tr(j).time,tr(j).data,para.noisewin(1):tr(j).delta:para.noisewin(2),'linear',0);
                    if std(data_noise) > 0
                        tr(j).snr = std(data_signal)/std(data_noise);
                    end
                end
                if i == 1
                    tr_denom = tr;
                else
                    tr_numer = tr;
                end
            end
        end
        
        % sort traces
        if para.flag.sort == 1
            para.offset = [];
            if strcmpi(para.sort_type,'dist')
                for j = 1:para.nl,   tr_denom(j).offset = tr_denom(j).dist; para.offset(j) = tr_denom(j).offset; end
                para.ylabel_name = 'Distance (^o)';
            elseif strcmpi(para.sort_type,'az')
                for j = 1:para.nl,   tr_denom(j).offset = tr_denom(j).az; para.offset(j) = tr_denom(j).offset; end
                para.ylabel_name = 'Azimuth (^o)';
            elseif strcmpi(para.sort_type,'baz')
                for j = 1:para.nl,   tr_denom(j).offset = tr_denom(j).baz; para.offset(j) = tr_denom(j).offset; end
                para.ylabel_name = 'Back azimuth (^o)';
            elseif strcmpi(para.sort_type,'rayp')
                for j = 1:para.nl,   tr_denom(j).offset = tr_denom(j).rayp; para.offset(j) = tr_denom(j).offset; end
                para.ylabel_name = 'Ray para. (s/km)';
            elseif strcmpi(para.sort_type,'stla')
                for j = 1:para.nl,   tr_denom(j).offset = tr_denom(j).headers.stla; para.offset(j) = tr_denom(j).offset; end
                para.ylabel_name = 'Station lat. (^o)';
            elseif strcmpi(para.sort_type,'stlo')
                for j = 1:para.nl,   tr_denom(j).offset = tr_denom(j).headers.stlo; para.offset(j) = tr_denom(j).offset; end
                para.ylabel_name = 'Station lon. (^o)';
            elseif strcmpi(para.sort_type,'nstnm')
                [c,indtmp] = sort({tr_denom.nstnm});
                for j = 1:para.nl,   tr_denom(indtmp(j)).offset = j; para.offset(indtmp(j)) = tr_denom(indtmp(j)).offset; end
                para.ylabel_name = 'Station name';  
            elseif strcmpi(para.sort_type,'snr')
                for j = 1:para.nl,   tr_denom(j).offset = tr_denom(j).snr; para.offset(j) = tr_denom(j).offset; end
                para.ylabel_name = 'Snr';
            elseif strcmpi(para.sort_type,'tshift')
                for j = 1:para.nl,   tr_denom(j).offset = tr_denom(j).tshift; para.offset(j) = tr_denom(j).offset; end
                para.ylabel_name = 'Time shift (s)';
            elseif strcmpi(para.sort_type,'evla')
                for j = 1:para.nl,   tr_denom(j).offset = tr_denom(j).headers.evla; para.offset(j) = tr_denom(j).offset; end
                para.ylabel_name = 'Event lat. (^o)';
            elseif strcmpi(para.sort_type,'evlo')
                for j = 1:para.nl,   tr_denom(j).offset = tr_denom(j).headers.evlo; para.offset(j) = tr_denom(j).offset; end
                para.ylabel_name = 'Event lon. (^o)';
            elseif strcmpi(para.sort_type,'evdp')
                for j = 1:para.nl,   tr_denom(j).offset = tr_denom(j).headers.evdp; para.offset(j) = tr_denom(j).offset; end
                para.ylabel_name = 'Event depth (^o)';
            elseif strcmpi(para.sort_type,'mag')
                for j = 1:para.nl,   tr_denom(j).offset = tr_denom(j).headers.mag; para.offset(j) = tr_denom(j).offset; end
                para.ylabel_name = 'Magnitude';
            else
                fprintf('No sort type: %s ; Change to dist sort!\n', para.sort_type);
                for j = 1:para.nl,   tr_denom(j).offset = tr_denom(j).dist;  end
                para.ylabel_name = 'Distance (^o)';
            end
            [para.offset,indx] = sort(para.offset,'ascend');
            tr_denom = tr_denom(indx);
            tr_numer = tr_numer(indx);
            para.ylabel_name_backup = para.ylabel_name; % set ylabelname to 'Num' if evenly distributed
        end
        
    end

    function Decon_callback_replot (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        
        handle.seishandles_denom = {[]};
        handle.seishandles_numer = {[]};
        % whether even plot or not
        if para.even_switch ~= 0
            para.offset = 1:para.nl;
            para.ylabel_name = 'Num';
        else
            for j = 1:para.nl, para.offset(j) = tr_denom(j).offset; end
            para.ylabel_name = para.ylabel_name_backup;
        end
        
        % find start and end traces
        j1 = (para.iframe -1) * para.n_per_frame +1;
        j2 = j1 + para.n_per_frame -1;
        j2 = min( j2, para.nl);
        indj = j1:j2;
        
        if isempty(indj)
            return;
        end
        
        % list station names to listbox
        stnm_tmp = {[]};
        indtmp = get(handle.h_listbox_list,'Value');
        for j = indj
            if strcmpi(para.listbox_list{indtmp},'nstnm')
                stnm_tmp{max(indj)-j+1} = [tr_denom(j).netwk,'.',tr_denom(j).stnm];
            elseif strcmpi(para.listbox_list{indtmp},'stnm')
                stnm_tmp{max(indj)-j+1} = tr_denom(j).stnm;
            elseif strcmpi(para.listbox_list{indtmp},'fname')
                stnm_tmp{max(indj)-j+1} = tr_denom(j).filename;
            end
        end
        set(handle.h_listbox, 'String', stnm_tmp);
        list_entries = get(handle.h_listbox,'String');
        
        cla(handle.hax,'reset');
        axes(handle.hax);
        box on;
        hold (handle.hax, 'on');
        
        % updata time
        for j = indj
            tr_denom(j).time = tr_denom(j).time - tr_denom(j).dtshift;
            tr_denom(j).dtshift = 0; % reset dtshift
            tr_numer(j).time = tr_numer(j).time - tr_numer(j).dtshift;
            tr_numer(j).dtshift = 0; % reset dtshift
        end
        
        % calculate the normalization factor
        doff = ( max(para.offset(indj)) - min(para.offset(indj)) ) / length(indj) ;
        if doff == 0
            doff = 1;
        end
        
        amp_range_denom = [];
        amp_range_numer = [];
        for j = indj
            tmp_denom = interp1(tr_denom(j).time, tr_denom(j).data, para.normwin(1):tr_denom(j).delta:para.normwin(end),'linear',0);
            tmp_numer = interp1(tr_numer(j).time, tr_numer(j).data, para.normwin(1):tr_numer(j).delta:para.normwin(end),'linear',0);
            amp_range_denom(j-j1+1) = max(tmp_denom) - min(tmp_denom);
            amp_range_numer(j-j1+1) = max(tmp_numer) - min(tmp_numer);
            if amp_range_denom(j-j1+1) == 0 || amp_range_numer(j-j1+1) == 0
                tr_denom(j).visible = 0;
                tr_denom(j).A0 = 0;
                tr_numer(j).visible = 0;
                tr_numer(j).A0 = 0;
            else
                tr_denom(j).A0 = doff/amp_range_denom(j-j1+1);
                tr_numer(j).A0 = doff/amp_range_numer(j-j1+1);
            end
            tr_denom(j).range = amp_range_denom(j-j1+1);
            tr_numer(j).range = amp_range_numer(j-j1+1);
        end
        
        if strcmpi(para.norm_type,'all')
            for j = indj
                tr_denom(j).A0 = doff/median(amp_range_denom(find(amp_range_denom))) ; % median normalization
                tr_numer(j).A0 = doff/median(amp_range_numer(find(amp_range_numer))) ; % median normalization
            end
        elseif strcmpi(para.norm_type,'each')
        end
        
        % mark phases
        for kk = 1:length(para.phase_mark) % reset phase mark flag
            para.phase_mark(kk).imark=1;
        end
        
        fprintf('Plotting ...\n');
        xlim_tmpL = para.x_lim(1);
        xlim_tmpR = para.x_lim(2);
        ht = [];
        hp = [];
        ntmp = 0;
        
        if para.denom_show == 1 % plot denom
            for j = indj
                time_tmp_denom = reshape(min(para.x_lim):tr_denom(j).delta:max(para.x_lim),[],1);
                if get(handle.h_decon,'Value')
                    data_tmp_denom = interp1(tr_denom(j).time, tr_denom(j).data*tr_denom(j).A0*para.scale, time_tmp_denom ,'linear',0);
                else
                    data_tmp_denom = interp1(tr_denom(j).time, tr_denom(j).data*tr_denom(j).polarity*tr_denom(j).A0*para.scale, time_tmp_denom ,'linear',0);
                end
                
                if strcmpi(para.plot_type,'trace')
                    handle.seishandles_denom{j} = plot( handle.hax, time_tmp_denom, para.offset(j) + data_tmp_denom, 'color',para.color_denom,'linewidth', para.linewidth_show);
                else
%                     handle.seishandles_denom{j} = single_wig4( time_tmp_denom, para.offset(j) + data_tmp_denom);
                    handle.seishandles_denom{j} = single_wig7( time_tmp_denom, data_tmp_denom, para.offset(j));
                    set(handle.seishandles_denom{j}(1),'Facecolor',para.color_wig_up_denom,'Edgecolor',para.color_wig_up_denom,'Linewidth',para.linewidth_show);
                    set(handle.seishandles_denom{j}(2),'Facecolor',para.color_wig_dn_denom,'Edgecolor',para.color_wig_dn_denom,'Linewidth',para.linewidth_show);
                end
                if tr_denom(j).visible == 0
                    set(handle.seishandles_denom{j},'visible','off');
                    list_entries{j2-j+1}=[];
                end
            end
        end
        
        if para.numer_show == 1 % plot denom
            for j = indj
                time_tmp_numer = reshape(min(para.x_lim):tr_numer(j).delta:max(para.x_lim),[],1);
                if get(handle.h_decon,'Value')
                    data_tmp_numer = interp1(tr_numer(j).time, tr_numer(j).data*tr_numer(j).A0*para.scale, time_tmp_numer ,'linear',0);
                else
                    data_tmp_numer = interp1(tr_numer(j).time, tr_numer(j).data*tr_numer(j).polarity*tr_numer(j).A0*para.scale, time_tmp_numer ,'linear',0);
                end
                
                if strcmpi(para.plot_type,'trace')
                    handle.seishandles_numer{j} = plot( handle.hax, time_tmp_numer, para.offset(j) + data_tmp_numer,  'color', para.color_numer,'linewidth', para.linewidth_show);
                else
%                     handle.seishandles_numer{j} = single_wig4( time_tmp_numer, para.offset(j) + data_tmp_numer);
                    handle.seishandles_numer{j} = single_wig7( time_tmp_numer, data_tmp_numer, para.offset(j));
                    set(handle.seishandles_numer{j}(1),'Facecolor',para.color_wig_up_numer,'Edgecolor',para.color_wig_up_numer,'Linewidth',para.linewidth_show);
                    set(handle.seishandles_numer{j}(2),'Facecolor',para.color_wig_dn_numer,'Edgecolor',para.color_wig_dn_numer,'Linewidth',para.linewidth_show);
                end
                if tr_denom(j).visible == 0
                    set(handle.seishandles_numer{j},'visible','off');
                    list_entries{j2-j+1}=[];
                end
            end
        end
        
        for j = indj
            if para.denom_show == 1
                tr = tr_denom;
            elseif para.denom_show ~=1 && para.numer_show == 1
                tr = tr_numer;
            else
                return;
            end
            
            % plot theoretical phase arrival time
            if para.theo_switch == 1 && tr(j).visible == 1 % plot theoretical arrival time
                hold on;
                plot(handle.hax, -tr(j).tshift, para.offset(j), 'color',para.color_theo,'Marker',para.marker_theo,'Markersize',para.msize_theo);
            end
            
            % mark phases
            if para.phase_show == 1 && ~isempty(para.phase_mark) && tr(j).visible == 1
                tt_ref = tr(j).tt;
                for kk = 1:length(para.phase_mark)
                    tt_tmp = interp1db(tr(j).dist,para.phase_mark(kk).d1,para.phase_mark(kk).t1);
%                     tt_tmp = interp1(para.phase_mark(kk).d1,para.phase_mark(kk).t1,tr(j).dist,'linear',nan);
                    if ~isnan(tt_tmp) % no such phase for this epi-center distance
                        if (tt_tmp-tt_ref > xlim_tmpL) && (tt_tmp-tt_ref < xlim_tmpR) % within the xlim window
                            hold on;
                            plot(handle.hax,[tt_tmp-tt_ref tt_tmp-tt_ref], [para.offset(j)-doff/2 para.offset(j)+doff/2],'color',para.phase_mark(kk).color);
                            if para.phase_mark(kk).imark == 1
                                ntmp = ntmp + 1;
                                hp(ntmp) = text(tt_tmp-tt_ref, para.offset(j)-doff, regexprep(para.phase_mark(kk).name,'x',num2str(para.xdep,'%d')),'color',para.phase_mark(kk).color,'FontWeight','bold');
                                para.phase_mark(kk).imark = 0;
                            end
                        end
                    end
                end
            end
            
            % text parameters
            if tr(j).visible == 1 && get(handle.h_textpara,'Value')
                str = '';
                for kk = 1:length(para.text_para)
                    if strcmpi(para.text_para(kk),'dist')
                        str = [str,'  \Delta=',num2str(tr(j).dist,'%03.1f'),'^o'];
                    elseif strcmpi(para.text_para(kk),'az')
                        str = [str,'  Az=',num2str(tr(j).az,'%03.1f'),'^o']; 
                    elseif strcmpi(para.text_para(kk),'baz')
                        str = [str,'  Baz=',num2str(tr(j).baz,'%03.1f'),'^o']; 
                    elseif strcmpi(para.text_para(kk),'rayp')
                        str = [str,'  Rayp=',num2str(tr(j).rayp,'%.4f'),'s/km']; 
                    elseif strcmpi(para.text_para(kk),'stla')
                        str = [str,'  Stla=',num2str(tr(j).headers.stla,'%03.3f'),'^o']; 
                    elseif strcmpi(para.text_para(kk),'stlo')
                        str = [str,'  Stlo=',num2str(tr(j).headers.stlo,'%03.3f'),'^o']; 
                    elseif strcmpi(para.text_para(kk),'snr')
                        str = [str,'  Snr=',num2str(tr(j).snr,'%.1f')]; 
                    elseif strcmpi(para.text_para(kk),'evla')
                        str = [str,'  Evla=',num2str(tr(j).headers.evla,'%03.3f'),'^o']; 
                    elseif strcmpi(para.text_para(kk),'evlo')
                        str = [str,'  Evlo=',num2str(tr(j).headers.evlo,'%03.3f'),'^o']; 
                    elseif strcmpi(para.text_para(kk),'evdp')
                        str = [str,'  Evdp=',num2str(tr(j).headers.evdp,'%03.1f'),'km']; 
                    elseif strcmpi(para.text_para(kk),'mag')
                        str = [str,'  Mag=',num2str(tr(j).headers.mag,'%03.1f'),'']; 
                    end
                end
                ht(j) = text(para.x_lim(1),para.offset(j),str);
            end
        end        
            
        set(handle.h_listbox, 'String', list_entries);
        
        % change X-Y label and x-y lim
        dy = 2*doff;
        xlim(para.x_lim);
        ylim( [min(para.offset(indj))-dy max(para.offset(indj))+dy]);
        xlabel(para.xlabel_name);
        ylabel(para.ylabel_name);
        
        hold on
        plot( [0 0], [min(para.offset(indj))-dy max(para.offset(indj))+dy],'k-.');
        if para.xy_switch == 0
            view(handle.hax,0,90);
        else
            view(handle.hax,90,90);
            set(ht,'rotation',-90);
            set(hp,'rotation',-90);
        end
        
        [natmp1,natmp2,natmp3] = fileparts(para.events{para.ievent});
        if isempty(natmp2)
            [natmp1,natmp2,natmp3] = fileparts(natmp1);
        end
        ename = regexprep([natmp2,natmp3],'_','\\_');
        title ( [ename,'\newlineevla=',num2str(para.evla,'%.2f'),'^o, evlo=',num2str(para.evlo,'%.2f'),'^o\newlineevdp=',num2str(para.evdp,'%.1f'),' km, mag=',num2str(para.mag,'%.1f')]);
        
        set(handle.h_ievent,'String',num2str(para.ievent));
        set(handle.h_iframe,'String',num2str(para.iframe));
        
        fprintf('ievent= %d\n',para.ievent);
        fprintf('iframe= %d\n\n',para.iframe);
        uicontrol(handle.h_hot);
        figure(handle.f1);
    end

    function Decon_callback_choosephase  (h, dummy)
        
        uicontrol(handle.h_hot);
        list_phase = get(handle.h_phase_list,'String');
        index_phase = get(handle.h_phase_list,'Value');
        para.phase = list_phase{index_phase};
        fprintf('Phase %s selected!\n',para.phase);
        if strfind(lower(para.phase),'x')
            flag_xdep = 0;
            while flag_xdep == 0
                xdep_temp = input('Please input x depth!\n','s');
                xdep_temp = str2num(xdep_temp);
                if ~isempty(xdep_temp)
                    if xdep_temp >= 0 && xdep_temp < em.z_cmb
                        para.xdep = xdep_temp;
                        flag_xdep = 1;
                    else
                        fprintf('Xdep should be smaller than CMB depth!\n');
                    end
                else
                    fprintf('Xdep should be a positive number!\n');
                end
            end
        end
        
        % change phase file name
        para.phasefile_denom = [para.list_denom,'_',para.phase,para.phasefileapp];
        para.phasefile_numer = [para.list_numer,'_',para.phase,para.phasefileapp];
                
        if ~isfield(para,'nevent')
            return;
        end
        Decon_callback_iniplot (h, dummy);
    end

    function Decon_callback_markphase (h,dummy)
              
        uicontrol(handle.h_hot);  
        if ~isfield(para,'iframe')
            return;
        end
        phase_all = get(handle.h_mark_all,'Value');
        para.phase_show = get(handle.h_mark_show,'Value');
        ind_phase = get(handle.h_mark_phase,'Value');
        para.phase_mark = [];
        if para.phase_show == 1 && ~isempty(para.nl)
            Mxdep = []; Mphase_mark = []; Mphaselist = []; Mevdp = [];
            if exist(para.taupmat,'file') % if exist already calculated taup, just read in
                fprintf('\nMark all phases\n Load in phases ...\n');
                C = load(para.taupmat); % load in Mphase_mark Mphaselist Mxdep Mevdp
                Mxdep = C.Mxdep; Mphase_mark = C.Mphase_mark; Mphaselist = C.Mphaselist; Mevdp = C.Mevdp;
            else % if not exist, re-calculating
                fprintf('\nMark all phases\n Calculating ...\n');
            end
            
            if phase_all == 1 % mark all phases
                phaselist_tmp = para.phaselist;
            else % mark selected phases
                phaselist_tmp = para.phaselist(ind_phase);
            end
            
            for kk = 1:length(phaselist_tmp)
                indph_tmp = 0;
                if ~isempty(Mxdep) % find taup data
                    for kkk = 1:length(Mphaselist)
                        if ~strfind(phaselist_tmp{kk},'x') % phase without x
                            if strcmp(phaselist_tmp{kk},Mphaselist{kkk})
                                indph_tmp = kkk; break;
                            end
                        else % phase with x, xdep should also match
                            if strcmp(phaselist_tmp{kk},Mphaselist{kkk}) && para.xdep == Mxdep
                                indph_tmp = kkk; break;
                            end
                        end
                    end
                end
                
                if indph_tmp ~= 0 % phase found in the taup data
                    ind_depth = find(Mevdp-para.evdp<=0, 1, 'last'); % find the nearest depth <= evdp
                    t1_tmp1 = Mphase_mark(indph_tmp,ind_depth).t1;
                    t1_tmp2 = Mphase_mark(indph_tmp,ind_depth+1).t1;
                    d1_tmp1 = Mphase_mark(indph_tmp,ind_depth).d1;
                    d1_tmp2 = Mphase_mark(indph_tmp,ind_depth+1).d1;
                    
                    if length(t1_tmp1) ~= length(t1_tmp2)  % if length is different
                        t1_tmp1 = linspace(t1_tmp1(1),t1_tmp1(end),np);
                        t1_tmp2 = linspace(t1_tmp2(1),t1_tmp2(end),np);
                        d1_tmp1 = linspace(d1_tmp1(1),d1_tmp1(end),np);
                        d1_tmp2 = linspace(d1_tmp2(1),d1_tmp2(end),np);
                    end
                    rr = abs(Mevdp(ind_depth+1)-Mevdp(ind_depth));
                    r1 = abs(para.evdp - Mevdp(ind_depth))/rr;
                    r2 = abs(Mevdp(ind_depth+1) - para.evdp)/rr;
                    
                    para.phase_mark(kk).t1 = r2*t1_tmp1 + r1*t1_tmp2;
                    para.phase_mark(kk).d1 = r2*d1_tmp1 + r1*d1_tmp2;
                else
                    [rayp,taup,Xp] = phase_taup(phaselist_tmp{kk}, para.evdp, para.np, para.em, para.xdep);
                    t1 = taup + rayp.* Xp;
                    d1 = Xp*para.r2d;
                    
                    % in case d1 larger than 180
                    d1 = rem(d1,360);
                    ind_major = find(d1>180);
                    d1(ind_major) = 360-d1(ind_major);
                    
                    para.phase_mark(kk).t1 = t1;
                    para.phase_mark(kk).d1 = d1;
                end
                para.phase_mark(kk).name = phaselist_tmp{kk};
                para.phase_mark(kk).evdp = para.evdp;
                para.phase_mark(kk).color = [rand rand rand];
                para.phase_mark(kk).imark = 1; % to text phase name
            end
        end
        Decon_callback_replot (h,dummy)
    end

    function Decon_callback_sort (h, dummy)
        % sort type
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        index_sort = get(handle.h_sort_list,'Value');
        if length(index_sort) == 1
            para.sort_type = para.sortlist{index_sort};
            para.iframe = 1;
            fprintf('Sort traces according to %s\n',para.sort_type);
            para.flag.cut = 0;
            para.flag.sort = 1;
            para.flag.filter = 0;
            para.flag.snr = 0;
            Decon_callback_preprocess (h, dummy);
            Decon_callback_replot (h, dummy);
            set(handle.h_listbox,'Value',[]);
        end
    end

    function Decon_callback_plotype (h, dummy)
        % plot type: wiggle or trace
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        index_plotype = get(handle.h_plotype_list,'Value');
        if length(index_plotype) == 1
            para.plot_type = para.plotype_list{index_plotype};
        end
        fprintf('Plot type: %s\n',para.plot_type);
        Decon_callback_replot (h,dummy)
    end

    function Decon_callback_norm (h, dummy)
        % normalization type: each or all
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        list_normtype = get(handle.h_normtype_list,'String');
        index_normtype = get(handle.h_normtype_list,'Value');
        if length(index_normtype) == 1
            para.norm_type = list_normtype{index_normtype};
        end
        tmpL = str2num(get(handle.h_normwin_L,'String'));
        tmpR = str2num(get(handle.h_normwin_R,'String'));
        if ~isempty(tmpL) && ~isempty(tmpR)
            para.normwin(1) = tmpL;
            para.normwin(2) = tmpR;
            fprintf('normalization type: %s\n',para.norm_type);
            Decon_callback_replot (h, dummy);
        end
    end

    function Decon_callback_tracenumber (h, dummy)
        % number of traces in each frame
        uicontrol(handle.h_hot);
        para.n_per_frame = floor(str2num(get(handle.h_ntrace_num,'String')));        
        if ~isfield(para,'iframe')
            return;
        end
        para.nframes = ceil (para.nl/para.n_per_frame);
        para.iframe = 1;
        set(handle.h_listbox, 'Value', 1);
        fprintf('Number of trace per frame set to %d\n',para.n_per_frame);
        Decon_callback_replot (h, dummy);
    end

    function Decon_callback_filter (h, dummy)
                
        uicontrol(handle.h_hot);
        fl_temp = str2num(get(handle.h_filter_fl,'String'));
        fh_temp = str2num(get(handle.h_filter_fh,'String'));
        order_temp = str2num(get(handle.h_order,'String'));
        if ~isempty(fl_temp) && ~isempty(fh_temp) && isnumeric(order_temp)
            para.fl = fl_temp;
            para.fh = fh_temp;
            para.order = order_temp;
        else
            para.fl = 0;
            para.fh = 0;
            para.order = 0;
            fprintf('No filtering!\n');
        end
        
        if ~isfield(para,'iframe')
            return;
        end
        para.flag.cut = 0;
        para.flag.sort = 0;
        para.flag.filter = 1;
        para.flag.snr = 1;
        Decon_callback_preprocess (h, dummy);
        Decon_callback_replot (h, dummy);
    end

    function Decon_callback_ampup (h, dummy)
        uicontrol(handle.h_hot);
        para.scale = para.scale * 1.25;
        Decon_callback_replot (h, dummy);
    end

    function Decon_callback_ampdown (h, dummy)
        uicontrol(handle.h_hot);
        para.scale = para.scale * 0.8;
        Decon_callback_replot (h, dummy);
    end

    function Decon_callback_timeup (h, dummy)
        
        uicontrol(handle.h_hot);
        para.x_lim = para.x_lim*0.8;
        Decon_callback_replot (h,dummy);
    end

    function Decon_callback_timedown (h, dummy)
        
        uicontrol(handle.h_hot);
        para.x_lim = para.x_lim*1.25;
        Decon_callback_replot (h,dummy);
    end

    function Decon_callback_theoplot (h, dummy)
        
        uicontrol(handle.h_hot);
        para.theo_switch = get(handle.theoplot_button,'Value');
        Decon_callback_replot (h,dummy)
        fprintf('Plot theoretical phase arrival time\n');
    end

    function Decon_callback_xyswitch (h,dummy)
        
        uicontrol(handle.h_hot);
        para.xy_switch = get(handle.xy_button,'Value');
        Decon_callback_replot (h,dummy);
        fprintf('X<->Y axis reverse!\n');
    end

    function Decon_callback_even (h,dummy)
        
        uicontrol(handle.h_hot);
        para.even_switch = get(handle.even_button,'Value');        
        fprintf('Evenly/Unevenly distributed!\n')
        Decon_callback_replot (h, dummy);
    end

    function Decon_callback_polarity (h,dummy)
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        fprintf('Polarity change!\n')
        for j = 1:para.nl
            tr_denom(j).polarity = -1*tr_denom(j).polarity;
            tr_numer(j).polarity = -1*tr_numer(j).polarity;
        end
        Decon_callback_replot (h,dummy);
    end

    function Decon_callback_delta (h,dummy)
        % data sampling rate
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        delta_tmp = str2num(get(handle.h_delta,'String'));
        if ~isempty(delta_tmp)
            fl_temp = str2num(get(handle.h_filter_fl,'String'));
            fh_temp = str2num(get(handle.h_filter_fh,'String'));
            if ~isempty(fl_temp) && ~isempty(fh_temp)
                if isinf(1/2/delta_tmp)
                    fprintf('Please check delta!\n');
                elseif 1/2/delta_tmp > max(fl_temp,fh_temp)
                    fprintf('Resampling rate %f\n',delta_tmp);
                    para.delta = delta_tmp;
                    para.flag.cut = 1;
                    para.flag.sort = 0;
                    para.flag.filter = 1;
                    Decon_callback_preprocess (h,dummy)
                    Decon_callback_replot (h,dummy)
                else
                    fprintf('Please check Nyquist frequency! It should be large enough!\n');
                end
            else
                fprintf('Please check filter width!\n');
            end
        end
        
    end

    function Decon_callback_textpara(h,dummy)
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end                
        if get(handle.h_textpara,'Value') == 1            
                        
            dlg_title = 'Text parameters';
            basestr = para.text_list{1};
            for i = 2:length(para.text_list)
                basestr = [basestr,',',para.text_list{i}];
            end
            prompt = {['1st (',basestr,')'],['2nd (',basestr,')'],['3rd (',basestr,')'],['4th (',basestr,')'],['5th (',basestr,')']};
            def = para.text_para;
            if length(def) < length(prompt)
                def(length(def)+1:length(prompt)) = {''};
            else
                def = def(1:length(prompt));
            end
            options.Resize='on';
            options.WindowStyle='normal';
            options.Interpreter='tex';
            answer = inputdlg(prompt,dlg_title,length(prompt),def,options);
            
            if isempty(answer)
                set(handle.h_textpara,'Value',0);
            else
                para.text_para = {};
                num = 0;
                for i = 1:length(answer)
                    ind = find(strcmpi(para.text_list,deblank(answer{i})));
                    if ind
                        num = num + 1;
                        para.text_para(num) = para.text_list(ind(1));
                    end
                end
            end
        end
        Decon_callback_replot (h,dummy);        
    end


%% window panel functions
    function Decon_callback_window (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        timewin_tmpL = str2num(get(handle.h_timewin_L,'String'));
        timewin_tmpR = str2num(get(handle.h_timewin_R,'String'));
        xlim_tmpL = str2num(get(handle.h_xlim_L,'String'));
        xlim_tmpR = str2num(get(handle.h_xlim_R,'String'));
        signalwin_tmpL = str2num(get(handle.h_signalwin_L,'String'));
        signalwin_tmpR = str2num(get(handle.h_signalwin_R,'String'));
        noisewin_tmpL = str2num(get(handle.h_noisewin_L,'String'));
        noisewin_tmpR = str2num(get(handle.h_noisewin_R,'String'));
        normwin_tmpL = str2num(get(handle.h_normwin_L,'String'));
        normwin_tmpR = str2num(get(handle.h_normwin_R,'String'));
        
        if ~isempty(timewin_tmpL) && ~isempty(timewin_tmpR) && ~isempty(xlim_tmpL) && ~isempty(xlim_tmpR) && ~isempty(signalwin_tmpL) && ~isempty(signalwin_tmpR) && ~isempty(noisewin_tmpL) && ~isempty(noisewin_tmpR) && ~isempty(normwin_tmpL) && ~isempty(normwin_tmpR)
            para.timewin(1) = timewin_tmpL;
            para.timewin(2) = timewin_tmpR;
            para.x_lim(1) = xlim_tmpL;
            para.x_lim(2) = xlim_tmpR;
            para.signalwin(1) = signalwin_tmpL;
            para.signalwin(2) = signalwin_tmpR;
            para.noisewin(1) = noisewin_tmpL;
            para.noisewin(2) = noisewin_tmpR;
            para.normwin(1) = normwin_tmpL;
            para.normwin(2) = normwin_tmpR;
            
            para.flag.cut = 1;
            para.flag.sort = 0;
            para.flag.filter = 1;
            para.flag.snr = 1;
            Decon_callback_preprocess (h, dummy);
            Decon_callback_replot (h, dummy);
        else
            fprintf('Please check time window!\n')
        end
    end


%% pick panel functions
    function Decon_callback_picktt (h, dummy) 
        
        uicontrol(handle.h_hot);    
        if ~isfield(para,'iframe')
            return;
        end        
        disp('Left mouse button picks points.');
        disp('Right mouse button picks last point.');
        % Initially, the list of points is empty.
        para.ypick = [];
        para.xpick = [];
        xy = [];
        n = 0;
        but = 1;
        while but == 1
            [xi,yi,but] = myginput(1,'crosshair');
            plot(xi,yi,'ro','markersize',5,'markerfacecolor','red')
            n = n+1;
            xy(:,n) = [xi;yi];
        end
        
        % Plot the interpolated curve.
        plot(handle.hax, xy(1,:),xy(2,:),'b-');
        para.xpick = xy(1,:);
        para.ypick = xy(2,:);
            
    end

    function Decon_callback_align (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        if para.denom_show == 1
            tr = tr_denom;
        elseif para.denom_show ~=1 && para.numer_show == 1
            tr = tr_numer;
        else
            return;
        end
        
        if length(para.xpick) < 2
            uicontrol(handle.h_hot);
            return;
        end
        j1 = (para.iframe -1) * para.n_per_frame +1;
        j2 = j1 + para.n_per_frame -1;
        j2 = min( j2, para.nl);
        for j =j1: j2
            [x0,y0] = curveintersect(tr(j).time, para.offset(j) + tr(j).data*tr(j).polarity*tr(j).A0, para.xpick, para.ypick);
            if size(x0) > 0
                tr_denom(j).dtshift = x0(1);
                tr_denom(j).tshift = tr_denom(j).tshift + tr_denom(j).dtshift;
                tr_numer(j).dtshift = x0(1);
                tr_numer(j).tshift = tr_numer(j).tshift + tr_numer(j).dtshift;
            end
            plot(handle.hax, x0, y0, 'ro');
        end
        pause (.3);
        Decon_callback_replot (h, dummy);
        
        para.xpick = [];
        para.ypick = [];
    end

    function Decon_callback_autopeak( h, dummy )
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        
        if para.ref_denom == 1
            tr = tr_denom;
        else
            tr = tr_numer;
        end
        % automatic pick peak            
        autopeak_winL_tmp = str2num(get(handle.h_autopeak_L,'String'));
        autopeak_winR_tmp = str2num(get(handle.h_autopeak_R,'String'));
        if ~isempty(autopeak_winL_tmp)
            para.autopeakwin(1) = autopeak_winL_tmp;
        end
        if ~isempty(autopeak_winR_tmp)
            para.autopeakwin(end) = autopeak_winR_tmp;
        end
        
        j1 = (para.iframe -1) * para.n_per_frame +1;
        j2 = j1 + para.n_per_frame -1;
        j2 = min( j2, para.nl);
        
        autopeak_wintime = para.autopeakwin(1):para.delta:para.autopeakwin(end);
        
        index_selected = get(handle.h_listbox,'Value');
        %         j = j1 -1 + index_selected;
        j = j2 - index_selected + 1;
        if length(index_selected) <= 1 % default: autopeak for all traces
            for kk = j1:j2
                if tr(kk).visible == 1
                    datawin = interp1(tr(kk).time,tr(kk).data*tr(kk).A0*tr(kk).polarity,autopeak_wintime,'linear',0);
                    [c,indt] = max(datawin);
                    tr_denom(kk).dtshift = autopeak_wintime(indt);
                    tr_denom(kk).tshift = tr_denom(kk).tshift + tr_denom(kk).dtshift;
                    tr_numer(kk).dtshift = autopeak_wintime(indt);
                    tr_numer(kk).tshift = tr_numer(kk).tshift + tr_numer(kk).dtshift;
                end
            end
        else % autopeak for selected traces
            for kk = 1:length(j)
                if tr(j(kk)).visible == 1
                    datawin = interp1(tr(j(kk)).time,tr(j(kk)).data*tr(j(kk)).A0*tr(j(kk)).polarity,autopeak_wintime,'linear',0);
                    [c,indt] = max(datawin);
                    tr_denom(kk).dtshift = autopeak_wintime(indt);
                    tr_denom(kk).tshift = tr_denom(kk).tshift + tr_denom(kk).dtshift;
                    tr_numer(kk).dtshift = autopeak_wintime(indt);
                    tr_numer(kk).tshift = tr_numer(kk).tshift + tr_numer(kk).dtshift;
                end
            end
        end
                        
        fprintf('Auto peak finished!\n');
        Decon_callback_replot (h,dummy);              
    end

    function Decon_callback_autopeakloop( h,dummy )
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            set(handle.h_peakloop,'Value',0);
            return;
        end
        % loop for automatic pick peaks        
        para.n_per_frame = 1000;
        set(handle.h_ntrace_num,'String',num2str(para.n_per_frame));
        
        while 1
            peaklooptmp = get(handle.h_peakloop,'Value');
            if ~peaklooptmp
                break;
            end
            event_tmp = para.ievent;
            Decon_callback_autopeak(h,dummy);
            Decon_callback_save(h,dummy);
            Decon_callback_nextevent (h, dummy);
            if para.ievent == event_tmp
                break;
            end
        end
        
        set(handle.h_peakloop,'Value',0);
    end

    function Decon_callback_gpick ( h,dummy)
        
        if ~isfield(para,'iframe')
            return;
        end
        [x1,y1,but1] = myginput(1,'crosshair');
        
        j1 = (para.iframe -1) * para.n_per_frame +1;
        j2 = j1 + para.n_per_frame -1;
        j2 = min( j2, para.nl);
        
        [c,index_selected] = min(abs(para.offset(j1:j2)-y1));
        index_selected = j2-j1-index_selected+2;
        
        j = j2 - index_selected + 1; % reverse the list
            
        if para.denom_show == 1
            for k = j1:j2
                if length(handle.seishandles_denom{k}) == 1
                    set( handle.seishandles_denom{k} , 'color',para.color_denom,'linewidth',para.linewidth_show);
                else
                    set(handle.seishandles_denom{k}(1),'Facecolor',para.color_wig_up_denom,'Edgecolor',para.color_wig_up_denom,'Linewidth',para.linewidth_show);
                    set(handle.seishandles_denom{k}(2),'Facecolor',para.color_wig_dn_denom,'Edgecolor',para.color_wig_dn_denom,'Linewidth',para.linewidth_show);
                end
            end
            for k = 1:length(j)
                if length(handle.seishandles_denom{j(k)}) == 1
                    set( handle.seishandles_denom{j(k)} , 'color',para.color_denom_selected,'linewidth',para.linewidth_selected);
                else
                    set( handle.seishandles_denom{j(k)}(1) ,'edgecolor',para.color_denom_selected,'linewidth',para.linewidth_selected);
                    set( handle.seishandles_denom{j(k)}(2) ,'edgecolor',para.color_denom_selected,'linewidth',para.linewidth_selected);
                end
            end
        end
        
        if para.numer_show == 1
            for k = j1:j2
                if length(handle.seishandles_numer{k}) == 1
                    set( handle.seishandles_numer{k} , 'color',para.color_numer,'linewidth',para.linewidth_show);
                else
                    set( handle.seishandles_numer{k}(1) ,'Facecolor',para.color_wig_up_numer, 'edgecolor',para.color_wig_up_numer,'linewidth',para.linewidth_show);
                    set( handle.seishandles_numer{k}(2) ,'Facecolor',para.color_wig_dn_numer, 'edgecolor',para.color_wig_dn_numer,'linewidth',para.linewidth_show);
                end
            end
            for k = 1:length(j)
                if length(handle.seishandles_numer{j(k)}) == 1
                    set( handle.seishandles_numer{j(k)} , 'color',para.color_numer_selected,'linewidth',para.linewidth_selected);
                else
                    set( handle.seishandles_numer{j(k)}(1) ,'edgecolor',para.color_numer_selected, 'linewidth',para.linewidth_selected);
                    set( handle.seishandles_numer{j(k)}(2) ,'edgecolor',para.color_numer_selected, 'linewidth',para.linewidth_selected);
                end
            end
        end
        
        set(handle.h_listbox,'Value',index_selected);        
        uicontrol(handle.h_listbox)
    end


%% Multi panel functions
    function Decon_callback_xcorr( h, dummy )
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end     
        if para.denom_show == 1
            tr = tr_denom;
        elseif para.denom_show ~=1 && para.numer_show == 1
            tr = tr_numer;
        else
            return;
        end
        
        % cross correlation for seismic traces        
        fprintf('Multi-channel cross-correlation...\n');        
%         hmsg = msgbox('Multi-channel cross correlation ...','Message','modal'); 
        xcorr_winL_temp = str2num(get(handle.h_xcorr_winL,'String'));
        xcorr_winR_temp = str2num(get(handle.h_xcorr_winR,'String'));
        xcorr_tlag_temp = str2num(get(handle.h_xcorr_tlag,'String'));
        if ~isempty(xcorr_winL_temp)
            para.xcorr_win(1) = xcorr_winL_temp;
        end
        if ~isempty(xcorr_winR_temp)
            para.xcorr_win(end) = xcorr_winR_temp;
        end
        if ~isempty(xcorr_tlag_temp)
            para.xcorr_tlag = xcorr_tlag_temp;
        end
        
        j1 = (para.iframe -1) * para.n_per_frame +1;
        j2 = j1 + para.n_per_frame -1;
        j2 = min( j2, para.nl);
        
        xcorr_wintime = para.xcorr_win(1):para.delta:para.xcorr_win(end);
        datawin = [];
        tmpind = [];
        k = 0;
        
        index_selected = get(handle.h_listbox,'Value');
        %         j = j1 -1 + index_selected;
        j = j2 - index_selected + 1;
        if length(index_selected) <= 1 % default: xcorr for all traces
            for kk = j1:j2
                if tr(kk).visible == 1
                    k = k + 1;
                    tmpind(k) = kk;
                    datawin(:,k) = interp1(tr(kk).time,tr(kk).data*tr(kk).A0*tr(kk).polarity,xcorr_wintime,'linear',0);
                end
            end
        else % xcorr for selected traces
            for kk = 1:length(j)
                if tr(j(kk)).visible == 1
                    k = k + 1;
                    tmpind(k) = j(kk);
                    datawin(:,k) = interp1(tr(j(kk)).time,tr(j(kk)).data*tr(j(kk)).A0*tr(j(kk)).polarity,xcorr_wintime,'linear',0);
                end
            end
        end
        
        [datawin,lags] = multi_cc(datawin,xcorr_wintime',[para.xcorr_win(1),para.xcorr_win(end)],para.xcorr_tlag);
%         [datawin,lags] = multi_cc_v2(datawin,xcorr_wintime',[para.xcorr_win(1),para.xcorr_win(end)],para.xcorr_tlag);
        for kk = 1:k
            tr_denom(tmpind(kk)).dtshift = - lags(kk)*para.delta;
            tr_denom(tmpind(kk)).tshift = tr_denom(tmpind(kk)).tshift + tr_denom(tmpind(kk)).dtshift;
            tr_numer(tmpind(kk)).dtshift = - lags(kk)*para.delta;
            tr_numer(tmpind(kk)).tshift = tr_numer(tmpind(kk)).tshift + tr_numer(tmpind(kk)).dtshift;
        end
        fprintf('Multi-channel cross correlation finished!\n');
        Decon_callback_replot (h,dummy);
        Decon_callback_listbox (h, dummy);
%         delete(hmsg);
    end

    function Decon_callback_pca (h,dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        pca_winL_temp = str2num(get(handle.h_pca_winL,'String'));
        pca_winR_temp = str2num(get(handle.h_pca_winR,'String'));
        ind_pca_type1 = get(handle.h_pca_type1,'Value');
        para.pca_type1 = para.pcatype1_list{ind_pca_type1};
        ind_pca_type2 = get(handle.h_pca_type2,'Value');
        para.pca_type2 = para.pcatype2_list{ind_pca_type2};
        pca_show_tmp =   get(handle.h_pca_show,'Value');
        
        if ~isempty(pca_winL_temp)
            para.pca_win(1) = pca_winL_temp;
        end
        if ~isempty(pca_winR_temp)
            para.pca_win(end) = pca_winR_temp;
        end
        
        if strcmpi(para.pca_type1,'all')
            j1 = 1;
            j2 = para.nl;
            j = j1:j2;
        elseif strcmpi(para.pca_type1,'frame')
            j1 = (para.iframe -1) * para.n_per_frame +1;
            j2 = j1 + para.n_per_frame -1;
            j2 = min( j2, para.nl);
            j = j1:j2;
        elseif strcmpi(para.pca_type1,'select')
            j1 = (para.iframe -1) * para.n_per_frame +1;
            j2 = j1 + para.n_per_frame -1;
            j2 = min( j2, para.nl);
            index_selected = get(handle.h_listbox,'Value');
            j = j2 - index_selected + 1;
        else
            fprintf('No Pca type1: %s exist!\n',para.pca_type1);
            return;
        end
        
        pca_wintime = para.pca_win(1):para.delta:para.pca_win(end);
        
        for i = 1:2
            if i == 1
                if para.denom_show ~= 1
                    continue;
                end
                tr = tr_denom; list_temp = para.list_denom; legend_name = 'Denom';
            else
                if para.numer_show ~= 1
                    continue;
                end
                tr = tr_numer; list_temp = para.list_numer; legend_name = 'Numer';
            end
            
            datawin = [];
            tmpind = [];
            k = 0;
            
            for kk = 1:length(j)
                if tr(j(kk)).visible == 1
                    k = k + 1;
                    tmpind(k) = j(kk);
                    if strcmpi(para.pca_type2,'raw')
                        % PCA for raw data % time should be the updated time
                        datawin(:,k) = interp1(tr(j(kk)).time,tr(j(kk)).data_cut*tr(j(kk)).polarity,pca_wintime,'linear',0);
                    elseif strcmpi(para.pca_type2,'filter')
                        % PCA for filtered data
                        datawin(:,k) = interp1(tr(j(kk)).time,tr(j(kk)).data*tr(j(kk)).polarity,pca_wintime,'linear',0);
                    else
                        fprintf('No Pca type2: %s exist!\n',para.pca_type2);
                        return;
                    end
                end
            end
            % end
            
            if length(tmpind) < 1
                return;
            end
            
            % apply pca
            nc_temp = str2num(get(handle.h_pca_num,'String'));
            if ~isempty(nc_temp) || round(nc_temp) < 1 || round(nc_temp) > size(datawin,2)
                pca_ncomp = 1;
            else
                pca_ncomp = round(nc_temp);
            end
            datawin_pc = principle_comp(datawin,pca_ncomp);
            
            pcalist = [list_temp,'_PCA'];
            pcalist_phase = [list_temp,'_PCA_',para.phase,para.phasefileapp];
            
            fid_pcalist = fopen(fullfile(para.events{para.ievent},pcalist),'w');
            fid_pcalist_phase = fopen(fullfile(para.events{para.ievent},pcalist_phase),'w');
            fprintf(fid_pcalist_phase,'#filename  theo_tt  tshift  obs_tt  polarity  stnm  netwk  rayp\n');
            for kk = 1:length(tmpind)
                outfilename = [tr(tmpind(kk)).filename,'.',para.phase,'.PCA'];
                tmphd = tr(tmpind(kk)).headers;
                tmphd.delta = para.delta;
                tmphd.b = tmphd.o + tr(tmpind(kk)).tt + para.pca_win(1) + tr(tmpind(kk)).tshift;
                tmphd.e = tmphd.o + tr(tmpind(kk)).tt + para.pca_win(end) + tr(tmpind(kk)).tshift;
                tmphd.npts = length(pca_wintime);
                imksac( tmphd, datawin_pc(:,kk)*tr(tmpind(kk)).polarity, fullfile(para.events{para.ievent},outfilename))
                fprintf(fid_pcalist,'%s\n',outfilename);
                fprintf(fid_pcalist_phase,'%s %f %f %f %d %s %s %f\n',outfilename, tr(tmpind(kk)).tt, tr(tmpind(kk)).tshift, tr(tmpind(kk)).tt+tr(tmpind(kk)).tshift, tr(tmpind(kk)).polarity, deblank(tr(tmpind(kk)).headers.kstnm'), deblank(tr(tmpind(kk)).headers.knetwk'), tr(tmpind(kk)).rayp);
            end
            fclose(fid_pcalist);
            fclose(fid_pcalist_phase);
            
            outmeanfile = ['SAC_',list_temp,'_',para.phase,'_PCA'];
            newhd = inewsachd;
            newhd.delta = para.delta;
            newhd.b = para.pca_win(1);
            newhd.e = para.pca_win(end);
            newhd.npts = length(pca_wintime);
            newhd.iftype = 1;
            newhd.nvhdr = 6;
            imksac( newhd, mean(datawin_pc,2), fullfile(para.events{para.ievent},outmeanfile))
            
            if pca_show_tmp == 1
                if i == 1
                    figure('name','PCA','NumberTitle','off');
                end
                subplot(2,1,i);
                data_mean_tmp = mean(datawin_pc,2);
                % normalize
                data_mean_tmp = data_mean_tmp/(max(data_mean_tmp)-min(data_mean_tmp));
                plot(pca_wintime,data_mean_tmp,'k');
                legend(legend_name);
                xlabel('Time (s)');
                ylabel('Mean Amp.');
            end
        end        
        fprintf('PCA done. Type: %s, %s\n',para.pca_type1,para.pca_type2);        
    end

    function Decon_callback_stacking (h,dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        pca_winL_temp = str2num(get(handle.h_pca_winL,'String'));
        pca_winR_temp = str2num(get(handle.h_pca_winR,'String'));
        ind_pca_type1 = get(handle.h_pca_type1,'Value');
        para.pca_type1 = para.pcatype1_list{ind_pca_type1};
        ind_pca_type2 = get(handle.h_pca_type2,'Value');
        para.pca_type2 = para.pcatype2_list{ind_pca_type2};
        pca_show_tmp =   get(handle.h_pca_show,'Value');
        
        if ~isempty(pca_winL_temp)
            para.pca_win(1) = pca_winL_temp;
        end
        if ~isempty(pca_winR_temp)
            para.pca_win(end) = pca_winR_temp;
        end
        
        if strcmpi(para.pca_type1,'all')
            j1 = 1;
            j2 = para.nl;
            j = j1:j2;
        elseif strcmpi(para.pca_type1,'frame')
            j1 = (para.iframe -1) * para.n_per_frame +1;
            j2 = j1 + para.n_per_frame -1;
            j2 = min( j2, para.nl);
            j = j1:j2;
        elseif strcmpi(para.pca_type1,'select')
            j1 = (para.iframe -1) * para.n_per_frame +1;
            j2 = j1 + para.n_per_frame -1;
            j2 = min( j2, para.nl);
            index_selected = get(handle.h_listbox,'Value');
            j = j2 - index_selected + 1;
        else
            fprintf('No Stacking type1: %s exist!\n',para.pca_type1);
            return;
        end
        
        pca_wintime = para.pca_win(1):para.delta:para.pca_win(end);
        
        for i = 1:2
            if i == 1
                if para.denom_show ~= 1
                    continue;
                end
                tr = tr_denom; list_temp = para.list_denom; legend_name = 'Denom';
            else
                if para.numer_show ~= 1
                    continue;
                end
                tr = tr_numer; list_temp = para.list_numer; legend_name = 'Numer';
            end
            
            datawin = [];
            tmpind = [];
            k = 0;
            
            for kk = 1:length(j)
                if tr(j(kk)).visible == 1
                    k = k + 1;
                    tmpind(k) = j(kk);
                    if strcmpi(para.pca_type2,'raw')
                        % PCA for raw data % time should be the updated time
                        datawin(:,k) = interp1(tr(j(kk)).time,tr(j(kk)).data_cut*tr(j(kk)).polarity,pca_wintime,'linear',0);
                    elseif strcmpi(para.pca_type2,'filter')
                        % PCA for filtered data
                        datawin(:,k) = interp1(tr(j(kk)).time,tr(j(kk)).data*tr(j(kk)).polarity,pca_wintime,'linear',0);
                    else
                        fprintf('No Pca type2: %s exist!\n',para.pca_type2);
                        return;
                    end
                end
            end
            
            if length(tmpind) < 1
                return;
            end
            
            % stacking
            datawin_pc = stacking(datawin);
            
            pcalist = [list_temp,'_STACK'];
            pcalist_phase = [list_temp,'_STACK_',para.phase,para.phasefileapp];
            
            fid_pcalist = fopen(fullfile(para.events{para.ievent},pcalist),'w');
            fid_pcalist_phase = fopen(fullfile(para.events{para.ievent},pcalist_phase),'w');
            fprintf(fid_pcalist_phase,'#filename  theo_tt  tshift  obs_tt  polarity  stnm  netwk  rayp\n');
            for kk = 1:length(tmpind)
                outfilename = [tr(tmpind(kk)).filename,'.',para.phase,'.STACK'];
                tmphd = tr(tmpind(kk)).headers;
                tmphd.delta = para.delta;
                tmphd.b = tmphd.o + tr(tmpind(kk)).tt + para.pca_win(1) + tr(tmpind(kk)).tshift;
                tmphd.e = tmphd.o + tr(tmpind(kk)).tt + para.pca_win(end) + tr(tmpind(kk)).tshift;
                tmphd.npts = length(pca_wintime);
                imksac( tmphd, datawin_pc(:,kk)*tr(tmpind(kk)).polarity, fullfile(para.events{para.ievent},outfilename))
                fprintf(fid_pcalist,'%s\n',outfilename);
                fprintf(fid_pcalist_phase,'%s %f %f %f %d %s %s %f\n',outfilename, tr(tmpind(kk)).tt, tr(tmpind(kk)).tshift, tr(tmpind(kk)).tt+tr(tmpind(kk)).tshift, tr(tmpind(kk)).polarity, deblank(tr(tmpind(kk)).headers.kstnm'), deblank(tr(tmpind(kk)).headers.knetwk'), tr(tmpind(kk)).rayp);
            end
            fclose(fid_pcalist);
            fclose(fid_pcalist_phase);
            
            outmeanfile = ['SAC_',list_temp,'_',para.phase,'_STACK'];
            newhd = inewsachd;
            newhd.delta = para.delta;
            newhd.b = para.pca_win(1);
            newhd.e = para.pca_win(end);
            newhd.npts = length(pca_wintime);
            newhd.iftype = 1;
            newhd.nvhdr = 6;
            imksac( newhd, mean(datawin_pc,2), fullfile(para.events{para.ievent},outmeanfile))
            
            if pca_show_tmp == 1
                if i == 1
                    figure('name','Stacking','NumberTitle','off');
                end
                subplot(2,1,i);
                data_mean_tmp = mean(datawin_pc,2);
                % normalize
                data_mean_tmp = data_mean_tmp/(max(data_mean_tmp)-min(data_mean_tmp));
                plot(pca_wintime,data_mean_tmp,'k');
                xlim([min(pca_wintime) max(pca_wintime)]);
                legend(legend_name);
                xlabel('Time (s)');
                ylabel('Mean Amp.');
            end
            
        end
        fprintf('Stacking done. Type: %s, %s\n',para.pca_type1,para.pca_type2);
    end


%% Decon panel functions
    function Decon_callback_decon (h,dummy)
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            set(handle.h_decon,'Value',0);
            return;
        end
        decon_tmp = get(handle.h_decon,'Value');
        if decon_tmp ~= 1
            x_lim_L = str2num(get(handle.h_xlim_L,'String'));
            x_lim_R = str2num(get(handle.h_xlim_R,'String'));
            if ~isnumeric(x_lim_L) || ~isnumeric(x_lim_R)
                fprintf('X_lim has no numeric input!\n');
                return;
            end
            para.x_lim = [x_lim_L x_lim_R];
            para.flag.cut = 1;
            para.flag.sort = 0;
            para.flag.filter = 1;
            para.flag.snr = 1;
            Decon_callback_preprocess (h,dummy);
            Decon_callback_replot (h,dummy);
        else
            deconwin_L = str2num(get(handle.h_decon_winL,'String'));
            deconwin_R = str2num(get(handle.h_decon_winR,'String'));
            deconshowin_L = str2num(get(handle.h_decon_showinL,'String'));
            deconshowin_R = str2num(get(handle.h_decon_showinR,'String'));
            para.waterlevel  = str2num(get(handle.h_waterlevel,'String'));
            para.F0 = str2num(get(handle.h_F0,'String'));
            para.TDEL = str2num(get(handle.h_TDEL,'String'));
            para.itmax = str2num(get(handle.h_itmax,'String'));
            para.minerr = str2num(get(handle.h_minerr,'String'));
            if ~isnumeric(deconwin_L) || ~isnumeric(deconwin_R) || ~isnumeric(deconshowin_L) || ~isnumeric(deconshowin_R) ||  ~isnumeric(para.waterlevel) || ~isnumeric(para.F0) || ~isnumeric(para.TDEL) || ~isnumeric(para.itmax) || ~isnumeric(para.minerr)
                fprintf('Deconvolution parameters have non numeric inputs!\n');
                return;
            end
            para.deconwin(1) = deconwin_L;
            para.deconwin(2) = deconwin_R;
            para.deconshowin(1) = deconshowin_L;
            para.deconshowin(2) = deconshowin_R;
            
            para.decontype = para.decontype_list{get(handle.h_decontype,'Value')};
            if strcmpi(para.decontype,'water')
                fprintf('Waterlevel Deconvolution ...\n');
            elseif strcmpi(para.decontype,'iter')
                fprintf('Iterative Deconvolution ...\n');
            end
            para.x_lim = para.deconshowin;
            
            time_decon = min(para.deconwin):para.delta:max(para.deconwin);
            for j = 1:para.nl
                data_decon_denom = interp1(tr_denom(j).time, tr_denom(j).data_cut*tr_denom(j).polarity, time_decon ,'linear',0); % for raw data
                data_decon_numer = interp1(tr_numer(j).time, tr_numer(j).data_cut*tr_numer(j).polarity, time_decon ,'linear',0);
                data_decon_denom = detrend(data_decon_denom) .* tukeywin(length(time_decon),0.1)';
                data_decon_numer = detrend(data_decon_numer) .* tukeywin(length(time_decon),0.1)';
                if strcmpi(para.decontype,'water')
                    [eqr, rms, nwl] = y_decon_waterlevel_matlab_v3_trueamp( data_decon_numer, data_decon_denom, para.TDEL, para.delta, para.waterlevel, para.F0);
                    [aftn, rms, nwl] = y_decon_waterlevel_matlab_v3_trueamp( data_decon_denom, data_decon_denom, para.TDEL, para.delta, para.waterlevel, para.F0);
                    %             [eqr, rms, nwl] = y_decon_waterlevel_matlab_v2( data_decon_numer, data_decon_denom, para.TDEL, para.delta, length(time_decon), para.waterlevel, para.F0, 0);
                    %             [aftn, rms, nwl] = y_decon_waterlevel_matlab_v2( data_decon_denom, data_decon_denom, para.TDEL, para.delta, length(time_decon), para.waterlevel, para.F0, 0);
                elseif strcmpi(para.decontype,'iter')
                    [eqr, rms] = y_decon_iterdecon_matlab( data_decon_numer, data_decon_denom, para.delta, length(time_decon), para.TDEL, para.F0, para.itmax, para.minerr);
                    [aftn, rms] = y_decon_iterdecon_matlab( data_decon_denom, data_decon_denom, para.delta, length(time_decon), para.TDEL, para.F0, para.itmax, para.minerr);
                end
                tr_numer(j).data = eqr;
                tr_denom(j).data = aftn;
                tr_numer(j).time = time_decon-time_decon(1) - para.TDEL;
                tr_denom(j).time = time_decon-time_decon(1) - para.TDEL;
                
                % copy for backup
                tr_numer(j).data_decon = tr_numer(j).data;
                tr_denom(j).data_decon = tr_denom(j).data;
                tr_numer(j).time_decon = tr_numer(j).time;
                tr_denom(j).time_decon = tr_denom(j).time;
            end
            
            % decon results filtering
            decon_filter_switch = get(handle.h_decon_filter,'Value');
            if decon_filter_switch == 1
                para.flag.cut = 0;
                para.flag.sort = 0;
                para.flag.snr = 0;
                para.flag.filter = 1;
                Decon_callback_preprocess (h, dummy);
            end
            
            Decon_callback_replot (h,dummy);
        end
    end

    function Decon_callback_savedecon (h,dummy)
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        decon_tmp = get(handle.h_decon,'Value');
        if decon_tmp ~= 1
            fprintf('No decon result to save!\nPlease push Decon button!\n');
            return;
        else
            deconlist_denom = [para.list_denom,'_Decon'];
            deconlist_denom_phase = [para.list_denom,'_Decon_',para.phase,para.phasefileapp];
            deconlist_numer = [para.list_numer,'_Decon'];
            deconlist_numer_phase = [para.list_numer,'_Decon_',para.phase,para.phasefileapp];
            fid1 = fopen(fullfile(para.events{para.ievent},deconlist_denom),'w');
            fid2 = fopen(fullfile(para.events{para.ievent},deconlist_denom_phase),'w');
            fid3 = fopen(fullfile(para.events{para.ievent},deconlist_numer),'w');
            fid4 = fopen(fullfile(para.events{para.ievent},deconlist_numer_phase),'w');
            fprintf(fid2,'#filename  theo_tt  tshift  obs_tt  polarity  stnm  netwk  rayp\n');
            fprintf(fid4,'#filename  theo_tt  tshift  obs_tt  polarity  stnm  netwk  rayp\n');
            for j = 1:para.nl
                if tr_denom(j).visible == 1
                    outfilename = [tr_denom(j).filename,'.',para.phase,'.Decon'];
                    tmphd = tr_denom(j).headers;
                    tmphd.delta = para.delta;
                    tmphd.b = tmphd.o + tr_denom(j).tt + tr_denom(j).tshift + tr_denom(j).time(1);
                    tmphd.e = tmphd.o + tr_denom(j).tt + tr_denom(j).tshift + tr_denom(j).time(end);
                    tmphd.a = tmphd.b - tr_denom(j).time(1);
                    tmphd.npts = length(tr_denom(j).time);
                    imksac( tmphd, tr_denom(j).data, fullfile(para.events{para.ievent},outfilename))
                    fprintf(fid1,'%s\n',outfilename);
                    fprintf(fid2,'%s %f %f %f %d %s %s %f\n',outfilename, tr_denom(j).tt, tr_denom(j).tshift, tr_denom(j).tt+tr_denom(j).tshift, tr_denom(j).polarity, tr_denom(j).stnm, tr_denom(j).netwk, tr_denom(j).rayp);
                end
                
                if tr_numer(j).visible == 1
                    outfilename = [tr_numer(j).filename,'.',para.phase,'.Decon'];
                    tmphd = tr_numer(j).headers;
                    tmphd.delta = para.delta;
                    tmphd.b = tmphd.o + tr_numer(j).tt + tr_numer(j).tshift + tr_numer(j).time(1);
                    tmphd.e = tmphd.o + tr_numer(j).tt + tr_numer(j).tshift + tr_numer(j).time(end);
                    tmphd.a = tmphd.b - tr_numer(j).time(1);
                    tmphd.npts = length(tr_numer(j).time);
                    imksac( tmphd, tr_numer(j).data, fullfile(para.events{para.ievent},outfilename))
                    fprintf(fid3,'%s\n',outfilename);
                    fprintf(fid4,'%s %f %f %f %d %s %s %f\n',outfilename, tr_numer(j).tt, tr_numer(j).tshift, tr_numer(j).tt+tr_numer(j).tshift, tr_numer(j).polarity, tr_numer(j).stnm, tr_numer(j).netwk, tr_numer(j).rayp);
                end
            end
            fclose(fid1);
            fclose(fid2);
            fclose(fid3);
            fclose(fid4);
            fprintf('\nSave Decon: %s\nDecon denominator list saved to file %s\n',para.events{para.ievent},deconlist_denom);
            fprintf('Decon denominator phase time shift saved to file %s\n',deconlist_denom_phase);
            fprintf('Decon numerator list saved to file %s\n',deconlist_numer);
            fprintf('Decon numerator phase time shift saved to file %s\n',deconlist_numer_phase);
            
            % output a decon parameter file
            [aa,bb,cc] = fileparts(para.paraoutfile);            
            fid = fopen(fullfile(para.events{para.ievent},[bb,'_Decon',cc]),'w');
            fprintf(fid,'#Parameters used for Deconvolution\n');
            fprintf(fid,'decontype = %s\n',para.decontype);
            fprintf(fid,'deconwin = %f %f\n',para.deconwin(1),para.deconwin(2));
            fprintf(fid,'TDEL = %f\n',para.TDEL);
            if strcmpi(para.decontype,'water')
                fprintf(fid,'waterlevel = %f\n',para.waterlevel);
                fprintf(fid,'F0 = %f\n',para.F0);
            else
                fprintf(fid,'itmax = %.0f\n',para.itmax);
                fprintf(fid,'minerr = %f\n',para.minerr);                
            end
            fclose(fid);
            fprintf('Decon parameters saved to file %s\n',[bb,'_Decon',cc]);
        end
    end


%% I/O panel functions
    function Decon_callback_load_evlist(h,dummy)
        
        uicontrol(handle.h_hot);
        [templist, temppath] = uigetfile({'*.txt','Txt Files (*.txt)';'*.m;*.fig;*.mat;*.mdl','Matlab Files (*.m,*.fig,*.mat,*.mdl)';'*.*', 'All Files (*.*)'}, 'Load event list',para.evpathname);
        if templist == 0
            uicontrol(handle.h_hot)
        else
            para.evpathname = temppath;
            para.evlistname = templist;
            set(handle.h_evlist,'String', para.evlistname);
            para.evlist = fullfile(para.evpathname,para.evlistname);
            para.events = [];
            Decon_callback_iniplot(h,dummy)
        end
    end

    function Decon_callback_load_evlist_2(h,dummy)
        
        uicontrol(handle.h_hot);
        para.evlistname = get(handle.h_evlist,'String');
        set(handle.h_evlist,'String', para.evlistname);
        para.evlist = fullfile(para.evpathname,para.evlistname);
        para.events = [];
        
        Decon_callback_iniplot(h,dummy)
    end

    function Decon_callback_load_denom (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'ievent')
            return;
        end
        [templist, temppath] = uigetfile({'*list*', 'List Files (*list*)';'*.txt','Txt Files (*.txt)';'*.m;*.fig;*.mat;*.mdl','Matlab Files (*.m,*.fig,*.mat,*.mdl)';'*.*', 'All Files (*.*)'}, 'Load event list',para.events{para.ievent});
        
        if templist ~= 0
            if strcmp(temppath(end),'/') || strcmp(temppath(end),'\')
                temppath = temppath(1:end-1);
            end
            [temp1,temp2,temp3] = fileparts(temppath);
            evname = [temp2,temp3];
            
            ind = strfind(para.events,evname);
            tempev = find(~cellfun(@isempty,ind));
            if ~isempty(tempev)
                para.list_denom = templist;
                for k = 1:length(para.phaselist) % whether it is a phasefile
                    phasefiletail = ['_',para.phaselist{k},para.phasefileapp];
                    ltail = length(phasefiletail);
                    if length(templist)>=ltail && strcmp(templist(end-ltail+1:end),phasefiletail) % in case read in phase file
                        para.list_denom = templist(1:end-ltail);
                        para.phase = para.phaselist{k};
                        set(handle.h_phase_list,'Value',k);
                        break;
                    end
                end
                
                para.phasefile_denom = [para.list_denom,'_',para.phase,para.phasefileapp];
                set(handle.h_denom,'String', para.list_denom);
                para.ievent = tempev(1);            % change event number
                Decon_callback_iniplot(h,dummy)
            end
        end
        uicontrol(handle.h_hot)
    end

    function Decon_callback_load_denom_2 (h, dummy)
        
        uicontrol(handle.h_hot);
        para.list_denom = get(handle.h_denom,'String');
        for k = 1:length(para.phaselist) % whether it is a phasefile
            phasefiletail = ['_',para.phaselist{k},para.phasefileapp];
            ltail = length(phasefiletail);
            if length(para.list_denom)>=ltail && strcmp(para.list_denom(end-ltail+1:end),phasefiletail) % in case read in phase file
                para.list_denom = para.list_denom(1:end-ltail);
                para.phase = para.phaselist{k};
                set(handle.h_phase_list,'Value',k);
                break;
            end
        end
        
        para.phasefile_denom = [para.list_denom,'_',para.phase,para.phasefileapp];
        if ~isfield(para,'ievent')
            return;
        end
        Decon_callback_iniplot(h,dummy)
    end

    function Decon_callback_load_numer (h, dummy)
                
        uicontrol(handle.h_hot);
        if ~isfield(para,'ievent')
            return;
        end
        [templist, temppath] = uigetfile({'*list*', 'List Files (*list*)';'*.txt','Txt Files (*.txt)';'*.m;*.fig;*.mat;*.mdl','Matlab Files (*.m,*.fig,*.mat,*.mdl)';'*.*', 'All Files (*.*)'}, 'Load event list',para.events{para.ievent});
        
        if templist ~= 0
            if strcmp(temppath(end),'/') || strcmp(temppath(end),'\')
                temppath = temppath(1:end-1);
            end
            [temp1,temp2,temp3] = fileparts(temppath);
            evname = [temp2,temp3];
            
            ind = strfind(para.events,evname);
            tempev = find(~cellfun(@isempty,ind));
            if ~isempty(tempev)
                para.list_numer = templist;
                for k = 1:length(para.phaselist) % whether it is a phasefile
                    phasefiletail = ['_',para.phaselist{k},para.phasefileapp];
                    ltail = length(phasefiletail);
                    if length(templist)>=ltail && strcmp(templist(end-ltail+1:end),phasefiletail) % in case read in phase file
                        para.list_numer = templist(1:end-ltail);
                        para.phase = para.phaselist{k};
                        set(handle.h_phase_list,'Value',k);
                        break;
                    end
                end
                
                para.phasefile_numer = [para.list_numer,'_',para.phase,para.phasefileapp];
                set(handle.h_numer,'String', para.list_numer);
                para.ievent = tempev(1);            % change event number
                Decon_callback_iniplot(h,dummy)
            end
        end
        uicontrol(handle.h_hot)
    end

    function Decon_callback_load_numer_2 (h, dummy)
                
        uicontrol(handle.h_hot);
        para.list_numer = get(handle.h_numer,'String');
        for k = 1:length(para.phaselist) % whether it is a phasefile
            phasefiletail = ['_',para.phaselist{k},para.phasefileapp];
            ltail = length(phasefiletail);
            if length(para.list_numer)>=ltail && strcmp(para.list_numer(end-ltail+1:end),phasefiletail) % in case read in phase file
                para.list_numer = para.list_numer(1:end-ltail);
                para.phase = para.phaselist{k};
                set(handle.h_phase_list,'Value',k);
                break;
            end
        end
        
        para.phasefile_numer = [para.list_numer,'_',para.phase,para.phasefileapp];
        if ~isfield(para,'ievent')
            return;
        end
        Decon_callback_iniplot(h,dummy)
    end

    function Decon_callback_denom_numer_show( h,dummy )
                
        uicontrol(handle.h_hot);
        para.numer_show = get(handle.h_numer_show,'Value');
        para.denom_show = get(handle.h_denom_show,'Value');
        Decon_callback_replot(h, dummy);        
    end

    function Decon_callback_ref_numer( h,dummy )
        
        uicontrol(handle.h_hot);
        para.ref_numer = get(handle.h_ref_numer,'Value');
        if para.ref_numer == 1
            set(handle.h_ref_denom,'Value',0);
            para.ref_denom = 0;
            for j = 1:length(tr_denom)
                tr_denom(j).tt = tr_numer(j).tt;
                tr_denom(j).tshift = tr_numer(j).tshift;
                tr_denom(j).polarity = tr_numer(j).polarity;
            end            
        else
            set(handle.h_ref_denom,'Value',1);
            para.ref_denom = 1;
            for j = 1:length(tr_denom)
                tr_numer(j).tt = tr_denom(j).tt;
                tr_numer(j).tshift = tr_denom(j).tshift;
                tr_numer(j).polarity = tr_denom(j).polarity;
            end
        end
        Decon_callback_iniplot(h,dummy)
%         Decon_callback_replot(h,dummy)
    end

    function Decon_callback_ref_denom( h,dummy )
        
        uicontrol(handle.h_hot);
        para.ref_denom = get(handle.h_ref_denom,'Value');
        if para.ref_denom == 1
            set(handle.h_ref_numer,'Value',0);
            para.ref_numer = 0;
            for j = 1:length(tr_denom)
                tr_numer(j).tt = tr_denom(j).tt;
                tr_numer(j).tshift = tr_denom(j).tshift;
                tr_numer(j).polarity = tr_denom(j).polarity;
            end
        else
            set(handle.h_ref_numer,'Value',1);
            para.ref_numer = 1;
            for j = 1:length(tr_denom)
                tr_denom(j).tt = tr_numer(j).tt;
                tr_denom(j).tshift = tr_numer(j).tshift;
                tr_denom(j).polarity = tr_numer(j).polarity;
            end  
        end
        
        Decon_callback_iniplot(h,dummy)
%         Decon_callback_replot(h,dummy)
    end

    function Decon_callback_del_event (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'ievent')
            return;
        end
        fprintf('Delete Event: %s \n',para.events{para.ievent});
        fid2 = fopen(fullfile(para.events{para.ievent},para.phasefile_denom),'w');
        fclose(fid2);
        fid3 = fopen(fullfile(para.events{para.ievent},para.phasefile_numer),'w');
        fclose(fid3);
        Decon_callback_nextevent (h,dummy)
    end

    function Decon_callback_reset_event (h, dummy)
        uicontrol(handle.h_hot);
        if ~isfield(para,'ievent')
            return;
        end
        if exist(fullfile(para.events{para.ievent},para.phasefile_denom),'file')
            delete(fullfile(para.events{para.ievent},para.phasefile_denom));
        end
        if exist(fullfile(para.events{para.ievent},para.phasefile_numer),'file')
            delete(fullfile(para.events{para.ievent},para.phasefile_numer));
        end
        fprintf('Reset Event: %s\n',para.events{para.ievent});
        Decon_callback_iniplot (h, dummy);
    end

    function Decon_callback_save (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'ievent')
            return;
        end
        fid2 = fopen(fullfile(para.events{para.ievent},para.phasefile_denom),'w');
        fprintf(fid2,'#filename theo_tt tshift obs_tt polarity stnm netwk rayp stla stlo stel evla evlo evdp dist az baz\n');
        for j=1 : para.nl
            if tr_denom(j).visible == 1
                fprintf(fid2,'%s %f %f %f %d %s %s %f %f %f %f %f %f %f %f %f %f\n',tr_denom(j).filename, tr_denom(j).tt, tr_denom(j).tshift, tr_denom(j).tt+tr_denom(j).tshift, tr_denom(j).polarity,tr_denom(j).stnm,tr_denom(j).netwk, tr_denom(j).rayp, tr_denom(j).headers.stla, tr_denom(j).headers.stlo, tr_denom(j).headers.stel, tr_denom(j).headers.evla, tr_denom(j).headers.evlo, tr_denom(j).headers.evdp, tr_denom(j).dist, tr_denom(j).az, tr_denom(j).baz);
            end
        end
        fclose(fid2);
        fprintf('Save Event: %s\nDenominator phasefile: %s\n',para.events{para.ievent},para.phasefile_denom);
        
        fid3 = fopen(fullfile(para.events{para.ievent},para.phasefile_numer),'w');
        fprintf(fid3,'#filename theo_tt tshift obs_tt polarity stnm netwk rayp stla stlo stel evla evlo evdp dist az baz\n');
        for j=1 : para.nl
            if tr_numer(j).visible == 1
                fprintf(fid3,'%s %f %f %f %d %s %s %f %f %f %f %f %f %f %f %f %f\n',tr_numer(j).filename, tr_numer(j).tt, tr_numer(j).tshift, tr_numer(j).tt+tr_numer(j).tshift, tr_numer(j).polarity,tr_numer(j).stnm,tr_numer(j).netwk, tr_numer(j).rayp, tr_numer(j).headers.stla, tr_numer(j).headers.stlo, tr_numer(j).headers.stel, tr_numer(j).headers.evla, tr_numer(j).headers.evlo, tr_numer(j).headers.evdp, tr_numer(j).dist, tr_numer(j).az, tr_numer(j).baz);
            end
        end
        fclose(fid3);
        fprintf('Numerator phasefile: %s\n',para.phasefile_numer);
        
        % output a parameter file
        fid = fopen(fullfile(para.events{para.ievent},para.paraoutfile),'w');
        fprintf(fid,'#Parameters used for processing\n');
        fprintf(fid,'#filter\n');
        fprintf(fid,'filter_type = %s\n',para.filter_type);
        fprintf(fid,'fl = %f\n',para.fl);
        fprintf(fid,'fh = %f\n',para.fh);
        fprintf(fid,'order = %d\n',para.order);
        fclose(fid);
    end

    function Decon_callback_savefig (h, dummy)
        
        uicontrol(handle.h_hot);  
        if ~isfield(para,'ievent')
            return;
        end
        set(handle.f1,'PaperPositionMode','auto');
        ptmp = get(handle.f1,'PaperPosition');
        set(handle.f1,'Papersize',[ ptmp(3) ptmp(4)]);
        
        [a,b,c] = fileparts(para.events{para.ievent});
        if isempty(b)
            [a,b,c] = fileparts(a);
        end
        eventname_tmp = [b,c];
        
        figname_base = ['Fig_',eventname_tmp,'_',para.phase,'_'];
        tmp = dir(fullfile(para.events{para.ievent},[figname_base,'*.pdf']));
        if isempty(tmp)
            nnum = 1;
        else
            fignames = sort({tmp.name});
            figend = fignames{end};
            nnum = str2num(figend(length(figname_base)+1:end-4)) + 1;
            if isempty(nnum)
                nnum = 1;
            end
        end
        
        print(handle.f1,'-r300','-dpdf',fullfile(para.events{para.ievent},[figname_base,num2str(nnum,'%02d'),'.pdf']));
        fprintf('Save figure to %s\n',fullfile(para.events{para.ievent},[figname_base,num2str(nnum,'%02d'),'.pdf']));
        
    end

    function Decon_callback_copyphasefile (h,dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        apptext = get(handle.h_copyphasefile,'String');
        index_selected = get(handle.h_listbox,'Value');
        j1 = (para.iframe -1) * para.n_per_frame +1;
        j2 = j1 + para.n_per_frame -1;
        j2 = min( j2, para.nl);
        
        j = j2 - index_selected + 1;
        if length(j) < 1
            return;
        end
        
        for i = 1:2
            if i==1
                listname_new = [para.list_denom,apptext];
                phasefile_new = [para.list_denom,apptext,'_',para.phase,'.txt'];
                tr = tr_denom;
            else
                listname_new = [para.list_numer,apptext];
                phasefile_new = [para.list_numer,apptext,'_',para.phase,'.txt'];
                tr = tr_numer;
            end
            fid1 = fopen(fullfile(para.events{para.ievent},listname_new),'w');
            fid2 = fopen(fullfile(para.events{para.ievent},phasefile_new),'w');
            fprintf(fid2,'#filename theo_tt tshift obs_tt polarity stnm netwk rayp stla stlo stel evla evlo evdp dist az baz\n');
            for kk = 1:length(j)
                if tr(j(kk)).visible == 1
                    fprintf(fid1,'%s\n',tr(j(kk)).filename);
                    fprintf(fid2,'%s %f %f %f %d %s %s %f %f %f %f %f %f %f %f %f %f\n',tr(j(kk)).filename, tr(j(kk)).tt, tr(j(kk)).tshift, tr(j(kk)).tt+tr(j(kk)).tshift, tr(j(kk)).polarity,tr(j(kk)).stnm,tr(j(kk)).netwk, tr(j(kk)).rayp, tr(j(kk)).headers.stla, tr(j(kk)).headers.stlo, tr(j(kk)).headers.stel, tr(j(kk)).headers.evla, tr(j(kk)).headers.evlo, tr(j(kk)).headers.evdp, tr(j(kk)).dist, tr(j(kk)).az, tr(j(kk)).baz);
                end
            end
            fclose(fid1);
            fclose(fid2);
            fprintf('Generate %s & %s\n',listname_new,phasefile_new);
        end
    end


%% Events & frames functions
    function Decon_callback_nextpage (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        para.iframe = para.iframe + 1;
        if para.iframe < 1 ,
            para.iframe = 1;
        end
        if para.iframe > para.nframes,
            para.iframe = para.nframes;
        end
        set(handle.h_listbox,'Value',[]);
        Decon_callback_replot (h, dummy);
    end

    function Decon_callback_lastpage (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        para.iframe = para.nframes;
        set(handle.h_listbox,'Value',[]);
        Decon_callback_replot (h, dummy);
    end

    function Decon_callback_firstpage (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        para.iframe = 1;
        set(handle.h_listbox,'Value',[]);
        Decon_callback_replot (h, dummy);
    end

    function Decon_callback_prepage (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        para.iframe = para.iframe - 1;
        if para.iframe < 1 ,
            para.iframe = 1;
        end
        if para.iframe > para.nframes,
            para.iframe = para.nframes;
        end
        set(handle.h_listbox,'Value',[]);
        Decon_callback_replot (h, dummy);
    end

    function Decon_callback_preevent (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'nevent')
            return;
        end
        if para.ievent ~= 1
            [ind, flag_file_denom, flag_file_numer] = find_event_2lists_phase(para.ievent-1, para.events, para.list_denom, para.list_numer, para.phasefile_denom, para.phasefile_numer,'backward');
        else
            [ind, flag_file_denom, flag_file_numer] = find_event_2lists_phase(para.ievent, para.events, para.list_denom, para.list_numer, para.phasefile_denom, para.phasefile_numer,'exact');
        end
        
        if isempty(ind)
            %             fprintf('No previous event found! Go to the first event\n');
            para.ievent = 1;
            Decon_callback_firstevent (h, dummy)
        else
            para.ievent = ind;
            Decon_callback_iniplot (h, dummy)
        end
    end

    function Decon_callback_nextevent (h, dummy)
               
        uicontrol(handle.h_hot); 
        if ~isfield(para,'nevent')
            return;
        end
        if para.ievent ~= para.nevent
            [ind, flag_file_denom, flag_file_numer] = find_event_2lists_phase(para.ievent+1, para.events,para.list_denom, para.list_numer, para.phasefile_denom, para.phasefile_numer,'forward');
        else
            [ind, flag_file_denom, flag_file_numer] = find_event_2lists_phase(para.ievent, para.events, para.list_denom, para.list_numer, para.phasefile_denom, para.phasefile_numer,'exact');
        end
        
        if isempty(ind)
            %             fprintf('No next event found! Go to the last event\n');
            para.ievent = para.nevent;
            Decon_callback_lastevent (h, dummy)
        else
            para.ievent = ind;
            Decon_callback_iniplot (h, dummy)
        end
    end

    function Decon_callback_lastevent (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'nevent')
            return;
        end        
        para.ievent = para.nevent;
        [ind, flag_file_denom, flag_file_numer] = find_event_2lists_phase(para.ievent, para.events, para.list_denom, para.list_numer, para.phasefile_denom, para.phasefile_numer,'backward');
        
        if isempty(ind)
            set(handle.hax,'Visible','off');
            return;
        else
            para.ievent = ind;
        end
        Decon_callback_iniplot (h, dummy)
    end

    function Decon_callback_firstevent (h, dummy)
        
        if ~isfield(para,'nevent')
            return;
        end
        para.ievent = 1;
        [ind, flag_file_denom, flag_file_numer] = find_event_2lists_phase(para.ievent, para.events, para.list_denom, para.list_numer, para.phasefile_denom, para.phasefile_numer,'forward');
        if isempty(ind)
            %             fprintf('\nNo event found!\n');
            set(handle.hax,'Visible','off');
            return;
        else
            para.ievent = ind;
        end
        Decon_callback_iniplot (h, dummy)
    end

    function Decon_callback_ievent (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'nevent')
            set(handle.h_ievent,'String','0');
            return;
        end
        para.ievent = floor(str2num(get(handle.h_ievent,'String')));
        Decon_callback_iniplot (h, dummy);
    end

    function Decon_callback_iframe (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            set(handle.h_iframe,'String','0');
            return;
        end
        para.iframe = floor(str2num(get(handle.h_iframe,'String')));
        Decon_callback_replot (h, dummy)
    end


%% Listbox and others functions
    function Decon_callback_listbox (h, dummy)
               
        if ~isfield(para,'iframe')
            return;
        end
        
        index_selected = get(handle.h_listbox,'Value');
        j1 = (para.iframe -1) * para.n_per_frame +1;
        j2 = j1 + para.n_per_frame -1;
        j2 = min( j2, para.nl);
        %         j = j1 -1 + index_selected;
        j = j2 - index_selected + 1; % reverse the list
        
        if para.denom_show == 1
            for k = j1:j2
                if length(handle.seishandles_denom{k}) == 1
                    set( handle.seishandles_denom{k} , 'color',para.color_denom,'linewidth',para.linewidth_show);
                else
                    set(handle.seishandles_denom{k}(1),'Facecolor',para.color_wig_up_denom,'Edgecolor',para.color_wig_up_denom,'Linewidth',para.linewidth_show);
                    set(handle.seishandles_denom{k}(2),'Facecolor',para.color_wig_dn_denom,'Edgecolor',para.color_wig_dn_denom,'Linewidth',para.linewidth_show);
                end
            end
            for k = 1:length(j)
                if length(handle.seishandles_denom{j(k)}) == 1
                    set( handle.seishandles_denom{j(k)} , 'color',para.color_denom_selected,'linewidth',para.linewidth_selected);
                else
                    set( handle.seishandles_denom{j(k)}(1) ,'edgecolor',para.color_denom_selected,'linewidth',para.linewidth_selected);
                    set( handle.seishandles_denom{j(k)}(2) ,'edgecolor',para.color_denom_selected,'linewidth',para.linewidth_selected);
                end
            end
        end
        
        if para.numer_show == 1
            for k = j1:j2
                if length(handle.seishandles_numer{k}) == 1
                    set( handle.seishandles_numer{k} , 'color',para.color_numer,'linewidth',para.linewidth_show);
                else
                    set( handle.seishandles_numer{k}(1) ,'Facecolor',para.color_wig_up_numer, 'edgecolor',para.color_wig_up_numer,'linewidth',para.linewidth_show);
                    set( handle.seishandles_numer{k}(2) ,'Facecolor',para.color_wig_dn_numer, 'edgecolor',para.color_wig_dn_numer,'linewidth',para.linewidth_show);
                end
            end
            for k = 1:length(j)
                if length(handle.seishandles_numer{j(k)}) == 1
                    set( handle.seishandles_numer{j(k)} , 'color',para.color_numer_selected,'linewidth',para.linewidth_selected);
                else
                    set( handle.seishandles_numer{j(k)}(1) ,'edgecolor',para.color_numer_selected, 'linewidth',para.linewidth_selected);
                    set( handle.seishandles_numer{j(k)}(2) ,'edgecolor',para.color_numer_selected, 'linewidth',para.linewidth_selected);
                end
            end
        end
    end

    function Decon_short_cut_listbox ( src, evnt)
                
        if ~isfield(para,'iframe') || ~isprop(evnt,'Key') %~isfield(evnt,'Key')
            return;
        end
        k = evnt.Key;
        list_entries = get(handle.h_listbox,'String');
        index_selected = get(handle.h_listbox,'Value');
        j1 = (para.iframe -1) * para.n_per_frame +1;
        j2 = j1 + para.n_per_frame -1;
        j2 = min( j2, para.nl);
        
        j = j2 - index_selected + 1;
        if strcmp (k, 'backspace') || strcmp(k,'delete')
            for kk = 1: length(j)
                if para.denom_show == 1
                    set( handle.seishandles_denom{j(kk)} , 'visible','off');
                end
                if para.numer_show == 1
                    set( handle.seishandles_numer{j(kk)} , 'visible','off');
                end
                tr_denom(j(kk)).visible = 0;
                tr_numer(j(kk)).visible = 0;
                fprintf('Delete station %s\n',[tr_denom(j(kk)).netwk,'.',tr_denom(j(kk)).stnm]);
                list_entries{index_selected(kk)}=[];
            end
            set(handle.h_listbox, 'String', list_entries);
            set(handle.h_listbox, 'Value',index_selected);
            %     return;
        elseif strcmp (k, 'f')
            Decon_callback_flip (src, evnt)
        elseif strcmp (k, 'escape')
            uicontrol(handle.h_hot);
            set(handle.h_listbox,'Value',[]);
        elseif strcmp (k, 'alt') %|| (~isempty(evnt.Modifier) && ( strcmpi(k,'0') && strcmpi(evnt.Modifier{:},'command')))
            uicontrol(handle.h_hot);
        else
            if ~isempty(evnt.Modifier) && (strcmp(evnt.Modifier{:},'control') || strcmp(evnt.Modifier{:},'command')) && strcmp (k, 'leftarrow')
                for kk = 1:length(j)
                    tr_denom(j(kk)).dtshift = tr_denom(j(kk)).dtshift + tr_denom(j(kk)).delta;
                    tr_denom(j(kk)).tshift = tr_denom(j(kk)).tshift + tr_denom(j(kk)).dtshift;
                    tr_numer(j(kk)).dtshift = tr_numer(j(kk)).dtshift + tr_numer(j(kk)).delta;
                    tr_numer(j(kk)).tshift = tr_numer(j(kk)).tshift + tr_numer(j(kk)).dtshift;
                end
            elseif ~isempty(evnt.Modifier) && (strcmp(evnt.Modifier{:},'control') || strcmp(evnt.Modifier{:},'command')) && strcmp (k, 'rightarrow')
                for kk = 1:length(j)
                    tr_denom(j(kk)).dtshift = tr_denom(j(kk)).dtshift - tr_denom(j(kk)).delta;
                    tr_denom(j(kk)).tshift = tr_denom(j(kk)).tshift + tr_denom(j(kk)).dtshift;
                    tr_numer(j(kk)).dtshift = tr_numer(j(kk)).dtshift - tr_numer(j(kk)).delta;
                    tr_numer(j(kk)).tshift = tr_numer(j(kk)).tshift + tr_numer(j(kk)).dtshift;
                end
            elseif ~isempty(evnt.Modifier) && strcmp(evnt.Modifier{:},'shift') && strcmp (k, 'leftarrow')
                for kk = 1:length(j)
                    tr_denom(j(kk)).dtshift = tr_denom(j(kk)).dtshift + 100*tr_denom(j(kk)).delta;
                    tr_denom(j(kk)).tshift = tr_denom(j(kk)).tshift + tr_denom(j(kk)).dtshift;
                    tr_numer(j(kk)).dtshift = tr_numer(j(kk)).dtshift + 100*tr_numer(j(kk)).delta;
                    tr_numer(j(kk)).tshift = tr_numer(j(kk)).tshift + tr_numer(j(kk)).dtshift;
                end
            elseif ~isempty(evnt.Modifier) && strcmp(evnt.Modifier{:},'shift') && strcmp (k, 'rightarrow')
                for kk = 1:length(j)
                    tr_denom(j(kk)).dtshift = tr_denom(j(kk)).dtshift - 100*tr_denom(j(kk)).delta;
                    tr_denom(j(kk)).tshift = tr_denom(j(kk)).tshift + tr_denom(j(kk)).dtshift;
                    tr_numer(j(kk)).dtshift = tr_numer(j(kk)).dtshift - 100*tr_numer(j(kk)).delta;
                    tr_numer(j(kk)).tshift = tr_numer(j(kk)).tshift + tr_numer(j(kk)).dtshift;
                end
                
            elseif isempty(evnt.Modifier) && strcmp (k, 'leftarrow')
                for kk = 1:length(j)
                    tr_denom(j(kk)).dtshift = tr_denom(j(kk)).dtshift + 10*tr_denom(j(kk)).delta;
                    tr_denom(j(kk)).tshift = tr_denom(j(kk)).tshift + tr_denom(j(kk)).dtshift;
                    tr_numer(j(kk)).dtshift = tr_numer(j(kk)).dtshift + 10*tr_numer(j(kk)).delta;
                    tr_numer(j(kk)).tshift = tr_numer(j(kk)).tshift + tr_numer(j(kk)).dtshift;
                end
            elseif isempty(evnt.Modifier) && strcmp (k, 'rightarrow')
                for kk = 1:length(j)
                    tr_denom(j(kk)).dtshift = tr_denom(j(kk)).dtshift - 10*tr_denom(j(kk)).delta;
                    tr_denom(j(kk)).tshift = tr_denom(j(kk)).tshift + tr_denom(j(kk)).dtshift;
                    tr_numer(j(kk)).dtshift = tr_numer(j(kk)).dtshift - 10*tr_numer(j(kk)).delta;
                    tr_numer(j(kk)).tshift = tr_numer(j(kk)).tshift + tr_numer(j(kk)).dtshift;
                end
            else
                return;
            end
            Decon_callback_replot
            uicontrol(handle.h_listbox)
        end
        Decon_callback_listbox (src, evnt)
    end

    function Decon_callback_deltrace (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        list_entries = get(handle.h_listbox,'String');
        index_selected = get(handle.h_listbox,'Value');
        j1 = (para.iframe -1) * para.n_per_frame +1;
        j2 = j1 + para.n_per_frame -1;
        j2 = min( j2, para.nl);
        
        j = j2 - index_selected + 1;
        for kk = 1: length(j)
            if para.denom_show == 1
                set( handle.seishandles_denom{j(kk)} , 'visible','off');
                tr_denom(j(kk)).visible = 0;
            end
            if para.numer_show == 1
                set( handle.seishandles_numer{j(kk)} , 'visible','off');
                tr_numer(j(kk)).visible = 0;
            end
            fprintf('Delete station %s\n',[tr_denom(j(kk)).netwk,'.',tr_denom(j(kk)).stnm]);
            list_entries{index_selected(kk)}=[];
        end        
        set(handle.h_listbox, 'String', list_entries);
    end

    function Decon_callback_showtrace (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        list_entries = get(handle.h_listbox,'String');
        index_selected = get(handle.h_listbox,'Value');
        j1 = (para.iframe -1) * para.n_per_frame +1;
        j2 = j1 + para.n_per_frame -1;
        j2 = min( j2, para.nl);
        
        j = j2 - index_selected + 1;
        indtmp = get(handle.h_listbox_list,'Value');
        for kk = 1: length(j)
            if para.denom_show == 1
                set( handle.seishandles_denom{j(kk)} , 'visible','on');
                tr_denom(j(kk)).visible = 1;
            end
            if para.numer_show == 1
                set( handle.seishandles_numer{j(kk)} , 'visible','on');
                tr_numer(j(kk)).visible = 1;
            end
            fprintf('Show station %s\n',[tr_denom(j(kk)).netwk,'.',tr_denom(j(kk)).stnm]);
            if strcmpi(para.listbox_list{indtmp},'nstnm')
                list_entries{index_selected(kk)} = [tr_denom(j(kk)).netwk,'.',tr_denom(j(kk)).stnm];
            elseif strcmpi(para.listbox_list{indtmp},'stnm')
                list_entries{index_selected(kk)} = tr_denom(j(kk)).stnm;
            elseif strcmpi(para.listbox_list{indtmp},'fname')
                list_entries{index_selected(kk)} = tr_denom(j(kk)).filename;
            end
        end
        
        set(handle.h_listbox, 'String', list_entries);
    end

    function Decon_callback_flip (h,dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        index_selected = get(handle.h_listbox,'Value');
        j1 = (para.iframe -1) * para.n_per_frame +1;
        j2 = j1 + para.n_per_frame -1;
        j2 = min( j2, para.nl);
        
        %         j = j1 -1 + index_selected;
        j = j2 - index_selected + 1;
        for kk = 1:length(j)
            tr_denom(j(kk)).polarity = -1*tr_denom(j(kk)).polarity;
            tr_numer(j(kk)).polarity = -1*tr_numer(j(kk)).polarity;
        end
        Decon_callback_replot(h,dummy)
        set(handle.h_listbox, 'Value',index_selected);
        uicontrol(handle.h_listbox)
    end


%% Hot keys
    function Decon_short_cut(src, evnt)
        
        uicontrol(handle.h_hot);        
        if strcmpi(evnt.Key,'i')
            Decon_callback_iniplot(src,evnt)
        elseif strcmpi(evnt.Key,'b') || strcmpi(evnt.Key,'backspace')
            Decon_callback_preevent(src,evnt)
        elseif strcmpi(evnt.Key,'n') || strcmpi(evnt.Key,'space')
            Decon_callback_nextevent(src,evnt)
        elseif strcmpi(evnt.Key,'comma')
            Decon_callback_prepage(src,evnt)
        elseif strcmpi(evnt.Key,'period')
            Decon_callback_nextpage(src,evnt)
        elseif strcmpi(evnt.Key,'s')
            Decon_callback_save(src,evnt)
        elseif ~isempty(evnt.Modifier) && strcmp(evnt.Modifier{:},'control') && strcmpi(evnt.Key,'d')
            Decon_callback_del_event(src,evnt)
        elseif strcmpi(evnt.Key,'r')
            Decon_callback_reset_event(src,evnt)
        elseif strcmpi(evnt.Key,'p') || strcmpi(evnt.Key,'t')
            Decon_callback_picktt(src,evnt)
        elseif strcmpi(evnt.Key,'a')
            Decon_callback_align(src,evnt)
        elseif strcmpi(evnt.Key,'x')
            Decon_callback_xcorr(src,evnt)
        elseif strcmpi(evnt.Key,'c')
            Decon_callback_pca(src,evnt)
        elseif strcmpi(evnt.Key,'k')
            Decon_callback_stacking(src,evnt)
        elseif strcmpi(evnt.Key,'equal')
            Decon_callback_ampup(src,evnt)
        elseif strcmpi(evnt.Key,'hyphen')
            Decon_callback_ampdown(src,evnt)
        elseif strcmpi(evnt.Key,'leftbracket')
            Decon_callback_timeup(src,evnt)
        elseif strcmpi(evnt.Key,'rightbracket')
            Decon_callback_timedown(src,evnt)
        elseif strcmpi(evnt.Key,'alt') || (~isempty(evnt.Modifier) && ( strcmpi(evnt.Key,'0') && strcmpi(evnt.Modifier{:},'command')))
            uicontrol(handle.h_listbox)
        elseif strcmpi(evnt.Key,'d')
            decon_tmp = get(handle.h_decon,'Value');
            set(handle.h_decon,'Value',~decon_tmp);
            Decon_callback_decon (src,evnt)
        elseif strcmpi(evnt.Key,'f')
            Decon_callback_polarity(src,evnt)
        elseif strcmpi(evnt.Key,'e')          
            if get(handle.even_button,'Value') == 1
                set(handle.even_button,'Value',0);
            else
                set(handle.even_button,'Value',1);
            end
            Decon_callback_even(src,evnt)
        elseif strcmpi(evnt.Key,'w')
            Decon_callback_autopeak(src,evnt)
        elseif strcmpi(evnt.Key,'g')
            Decon_callback_gpick(src,evnt)
        else
        end
        
    end

end

