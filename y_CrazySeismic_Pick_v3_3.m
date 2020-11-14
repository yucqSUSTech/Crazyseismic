function y_CrazySeismic_Pick_v3_3

% CrazySeismic
% -- A MATLAB-GUI based software for passive seismic data processing
% Subpackage: CrazySeismic_Pick
% Purposes: (1) Data selection and (2) Travel time picking
% Features: (1) Easy to use, (2) Efficient, and (3) Quality control

% modified by Chunquan Yu, 2019/11/09 to take into account ellipticity when
% calculating distance and azimuth

% Contact:
% Chunquan Yu, yucq@sustech.edu.cn
% Reference:
% Yu, C., Zheng, Y., Shang, X., 2017. Crazyseismic: A MATLAB GUI-Based Software Package for Passive Seismic Data Preprocessing. Seismological Research Letters 88, 410?415. doi:10.1785/0220160207


%% add path
path(path,genpath(pwd));

%% Import parameters
para = para_Pick;
% para = para_Pick_PF;
% para = para_Pick_SF;
tr = [];


%% Main program
%% Figure setup
handle.f1               =	figure('Toolbar','figure','Units','normalized','keypressfcn', @Pick_short_cut,'Position',[.1 .1 .8 .8]);
                            set(handle.f1,'name','Crazyseismic Pick','NumberTitle','off');
handle.hax              =	axes('pos', [.2 .05 .6 .85]);
                            box(handle.hax,'on');

% uicontrol hot keys
handle.h_hot            =	uicontrol('String','<html><b>CrazySeismic Pick</b></html>','keypressfcn',@Pick_short_cut,'Position',[.01 .91 .15 .08]);

%% Plot panel
% plotting parameters
plot_panel              =	uipanel('parent', handle.f1,'title', 'Plot', 'Position', [0.01 .27 .15 .63]);
% initial plot (load in data)
                            uicontrol(plot_panel,'String','Ini(i)','callback',@Pick_callback_iniplot,'Position',[.1 .90 .5 .1]);

% velocity model
handle.h_vmodel_list    =   uicontrol(plot_panel,'Style','popupmenu','String',para.vmodel_list,'callback',@Pick_callback_vmodel,'Value',1,'Position',[.6 .95 .4 .04]);

% integration, derivation or not
ind = find(strcmp(para.intederi_list,para.intederi_type));
if ~ind
    fprintf('No intederi type %s in the list\n',para.intederi_type); return;
end
handle.h_intederi_list  =   uicontrol(plot_panel,'Style','popupmenu','String',para.intederi_list,'callback',@Pick_callback_intederi,'Value',ind,'Position',[.6 .9 .4 .04]);


                            
% find the default phase name
ind = find(strcmp(para.phaselist,para.phase));
if ~ind
    fprintf('No phase %s in the list\n',para.phase); return;
end
                            uicontrol(plot_panel,'Style','text','String','Phase','Position',[.0 .85 .4 .04]);
handle.h_phase_list     =   uicontrol(plot_panel,'Style','popupmenu','String',para.phaselist,'callback',@Pick_callback_choosephase,'Value',ind,'Position',[.4 .85 .4 .04]);
handle.h_mark_show      =   uicontrol(plot_panel,'Style','togglebutton','String','Mark','callback',@Pick_callback_markphase,'Position',[.80 .80 .2 .04]);
handle.h_mark_phase     =   uicontrol(plot_panel,'Style','listbox','String',para.phaselist,'Position',[.80 .45 .2 .35],'max',1000);
                            uicontrol(plot_panel,'Style','text','String','All','Position',[.80 .4 .1 .035]);
handle.h_mark_all       =   uicontrol(plot_panel,'Style','checkbox','callback',@Pick_callback_markphase,'Position',[.90 .40 .1 .04]);
% text distance and back azimuth
handle.h_textpara       =   uicontrol(plot_panel,'Style','togglebutton','String','Text','callback',@Pick_callback_textpara,'Position',[.80 .85 .2 .04]);
% find sort type
ind = find(strcmp(para.sortlist,para.sort_type));
if ~ind
    fprintf('No sort_type %s in the list\n',para.sort_type); return;
end
                            uicontrol(plot_panel,'Style','text','String','Sort','Position',[.0 .80 .4 .04]);
handle.h_sort_list      =   uicontrol(plot_panel,'Style','popup','String',para.sortlist,'callback',@Pick_callback_sort,'Value',ind,'Position',[.4 .80 .4 .04]);
% find plot type
ind = find(strcmp(para.plotype_list,para.plot_type));
if ~ind
    fprintf('No plot_type %s in the list\n',para.plot_type); return;
end
                            uicontrol(plot_panel,'Style','text','String','Ptype','Position',[.0 .75 .4 .04]);
handle.h_plotype_list   =   uicontrol(plot_panel,'Style','popup','String',para.plotype_list,'callback',@Pick_callback_plotype,'Value',ind,'Position',[.4 .75 .4 .04]);
% find norm type
ind = find(strcmp(para.normtype_list,para.norm_type));
if ~ind
    fprintf('No norm_type %s in the list\n',para.norm_type); return;
end
                            uicontrol(plot_panel,'Style','text','String','Norm','Position',[.0 .70 .4 .04]);
handle.h_normtype_list  =   uicontrol(plot_panel,'Style','popup','String',para.normtype_list,'callback',@Pick_callback_norm,'Value',ind,'Position',[.4 .70 .4 .04]);
% number of traces per frame
                            uicontrol(plot_panel,'Style','text','String','Ntrace','Position',[.0 .65 .4 .04]);
handle.h_ntrace_num     =   uicontrol(plot_panel,'Style','edit','String',num2str(para.n_per_frame),'callback',@Pick_callback_tracenumber,'Position',[.4 .65 .4 .04],'BackgroundColor',para.bcolor);
% data sampling interval
                            uicontrol(plot_panel,'Style','text','String','Delta','Position',[.0 .60 .4 .04]);
handle.h_delta          =   uicontrol(plot_panel,'Style','edit','String',num2str(para.delta),'callback',@Pick_callback_delta,'Position',[.4 .6 .4 .04],'BackgroundColor',para.bcolor);
% filtering
                            uicontrol(plot_panel,'Style','pushbutton','String','Filter','callback',@Pick_callback_filter,'Position',[.05 .55 .3 .04]);
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
                            uicontrol(plot_panel,'String','+(=)','callback',@Pick_callback_ampup,'Position',[.05 .30 .45 .05]);
                            uicontrol(plot_panel,'String','-(-)', 'callback',@Pick_callback_ampdown,'Position',[.5 .30 .45 .05]);
% time axis +/-
                            uicontrol(plot_panel,'Style','text','String','Zoom','Position',[.2 .25 .6 .04]);
                            uicontrol(plot_panel,'String','In([)','callback',@Pick_callback_timeup,'Position',[.05 .20 .45 .05]);
                            uicontrol(plot_panel,'String','Out(])', 'callback',@Pick_callback_timedown,'Position',[.5 .20 .45 .05]);
% theoretical arrival time
handle.theoplot_button  =   uicontrol(plot_panel,'Style','togglebutton','String','Theo_T','callback',@Pick_callback_theoplot,'Position',[.05 .15 .9 .04]);
% polarity
handle.polarity         =	uicontrol(plot_panel,'Style','pushbutton','String','+/- (f)','callback',@Pick_callback_polarity,'Position',[.05 .10 .9 .04]);
% x-y switch
handle.xy_button        =   uicontrol(plot_panel,'Style','togglebutton','String','X<->Y','callback',@Pick_callback_xyswitch,'Position',[.05 .05 .9 .04]);
% evenly/Uniformly distribute
handle.even_button      =   uicontrol(plot_panel,'Style','togglebutton','String','Even (e)','callback',@Pick_callback_even,'Position',[.05 .0 .9 .04]);

%% Window panel
% time window
win_panel               =   uipanel('parent', handle.f1,'title', 'Win', 'pos', [0.01 .05 .15 .2]);
% window update
                            uicontrol(win_panel,'Style','pushbutton','callback',@Pick_callback_window,'String','Window update','Position',[.05 .83 .9 .15]);
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
pick_panel              =   uipanel('parent', handle.f1,'title', 'Pick', 'pos', [0.85 .82 .14 .17]);
                            uicontrol(pick_panel,'String','Pick(p/t)','callback',@Pick_callback_picktt,'Position',[.05 .55 .4 .4]);
                            uicontrol(pick_panel,'String','Align(a)','callback',@Pick_callback_align,'Position',[.05 .05 .4 .4]);
                            uicontrol(pick_panel,'String','Peak(w)','callback',@Pick_callback_autopeak,'Position',[.45 .3 .5 .3]);
handle.h_autopeak_L     =   uicontrol(pick_panel,'Style','edit','String',num2str(para.autopeakwin(1)),'Position',[.45 .7 .25 .25],'BackgroundColor',para.bcolor);
handle.h_autopeak_R     =   uicontrol(pick_panel,'Style','edit','String',num2str(para.autopeakwin(2)),'Position',[.7 .7 .25 .25],'BackgroundColor',para.bcolor);
handle.h_peakloop       =   uicontrol(pick_panel,'Style','togglebutton','String','Loop','callback',@Pick_callback_autopeakloop,'Position',[.75 .05 .2 .2],'BackgroundColor',para.bcolor);
handle.h_gpick          =   uicontrol(pick_panel,'String','Gpick(g)','callback',@Pick_callback_gpick,'Position',[.45 .05 .3 .2]);

  
%% Multi channel
% multi-channel cross correlation & stacking
multi_panel             =   uipanel('parent', handle.f1,'title', 'Multi', 'pos', [0.85 .45 .14 .35]);
                            uicontrol(multi_panel,'Style','text','String','Mccc window','Position',[0.05 .92 .9 .08 ]);
handle.h_xcorr_winL     =   uicontrol(multi_panel,'Style','edit','String',num2str(para.xcorr_win(1)),'Position',[0.05 .82 .45 .1],'BackgroundColor',para.bcolor);
handle.h_xcorr_winR     =   uicontrol(multi_panel,'Style','edit','String',num2str(para.xcorr_win(end)),'Position',[.5 .82 .45 .1],'BackgroundColor',para.bcolor);
                            uicontrol(multi_panel,'Style','text','String','Max lagT','Position',[0.05 .67 .45 .15 ]);
handle.h_xcorr_tlag     =   uicontrol(multi_panel,'Style','edit','String',num2str(para.xcorr_tlag),'Position',[.5 .72 .45 .1],'BackgroundColor',para.bcolor);
% cross correlation
                            uicontrol(multi_panel,'String','Xcorr(x)','callback',@Pick_callback_xcorr,'Position',[.1 .56 .5 .14]);
% xcross correlation loop
handle.h_xcorrloop      =   uicontrol(multi_panel,'Style','togglebutton','String','XLoop','callback',@Pick_callback_xcorrloop,'Position',[.7 .56 .25 .14],'BackgroundColor',para.bcolor);
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
                            uicontrol(multi_panel,'String','Pca(c)','callback',@Pick_callback_pca,'Position',[.05 .0 .45 .14]);
                            uicontrol(multi_panel,'String','Stack(k)','callback',@Pick_callback_stacking,'Position',[.5 .0 .45 .14]);                   
                   
%% I/O panel
% input and output
io_panel                =   uipanel('parent', handle.f1,'title', 'I/O', 'pos', [0.85 .05 .14 .38]);
% load in evlist
handle.h_evlist         =   uicontrol(io_panel,'Style','edit','String',para.evlistname,'callback',@Pick_callback_load_evlist_2,'Position',[.05 .9 .9 .1],'BackgroundColor',para.bcolor);
                            uicontrol(io_panel,'callback',@Pick_callback_load_evlist,'String','Load evlist','Position',[0.05 .8 .9 .1]);
% load in listname
handle.h_listname       =   uicontrol(io_panel,'Style','edit','String',para.listname,'callback',@Pick_callback_load_listname_2,'Position',[0.05 .7 .9 .1],'BackgroundColor',para.bcolor);
                            uicontrol(io_panel,'Style','pushbutton','String','Load listname','callback',@Pick_callback_load_listname,'Position',[0.05 .6 .9 .1]);
% generate a new listname
                            uicontrol(io_panel,'Style','pushbutton','String','Copy list','callback',@Pick_callback_copyphasefile,'Position',[0.05 .45 .4 .1]);
handle.h_copyphasefile  =   uicontrol(io_panel,'Style','edit','String',para.copylistapp,'Position',[.5 .45 .4 .1],'BackgroundColor',para.bcolor);
% reset event
                            uicontrol(io_panel,'Style','pushbutton','String','Reset(r)','callback',@Pick_callback_reset_event,'Position',[0.05 .35 .9 .1]);
% delete event
                            uicontrol(io_panel,'Style','pushbutton','String','Delete(Ctrl+d)','callback',@Pick_callback_del_event,'Position',[0.05 .25 .9 .1]);
% save traces
                            uicontrol(io_panel,'Style','pushbutton','String','Save(s)','callback',@Pick_callback_save,'Position',[0.05 .025 .45 .2]);
% save figure
                            uicontrol(io_panel,'Style','pushbutton','String','Save Fig','callback',@Pick_callback_savefig,'Position',[.5 .025 .45 .2]);

%% Events and frames
% events
                            uicontrol(handle.f1,'Style','pushbutton','String','pre_ev(b)', 'callback',@Pick_callback_preevent,'Position', [.25 .95 .1 .04]);
                            uicontrol(handle.f1,'Style','pushbutton','String','next_ev(n)', 'callback',@Pick_callback_nextevent,'Position', [.65 .95 .1 .04]);
                            uicontrol(handle.f1,'Style','pushbutton','String','1st','callback',@Pick_callback_firstevent,'Position', [.20 .95 .05 .04]);
                            uicontrol(handle.f1,'Style','pushbutton','String','last','callback',@Pick_callback_lastevent,'Position', [.75 .95 .05 .04]);
% pages
                            uicontrol(handle.f1,'Style','pushbutton','String','pre_ls(,)','callback',@Pick_callback_prepage,'Position', [.25 .90 .1 .04]);
                            uicontrol(handle.f1,'Style','pushbutton','String','next_ls(.)','callback',@Pick_callback_nextpage,'Position', [.65 .90 .1 .04]);
                            uicontrol(handle.f1,'Style','pushbutton','String','1st','callback',@Pick_callback_firstpage,'Position', [.20 .90 .05 .04]);
                            uicontrol(handle.f1,'Style','pushbutton','String','last','callback',@Pick_callback_lastpage,'Position', [.75 .90 .05 .04]);
% ievent
                            uicontrol(handle.f1,'Style','text','String','ievent','Position',[.8 .97 .05 .025]);
handle.h_ievent         =   uicontrol(handle.f1,'Style','edit','String','0','callback',@Pick_callback_ievent,'Position',[.80 .95 .05 .02],'BackgroundColor',para.bcolor);
% iframe
                            uicontrol(handle.f1,'Style','text','String','iframe','Position',[.8 .92 .05 .025]);
handle.h_iframe         =   uicontrol(handle.f1,'Style','edit','String','0','callback',@Pick_callback_iframe,'Position',[.8 .90 .05 .02],'BackgroundColor',para.bcolor);
                            uicontrol(handle.f1,'Style','pushbutton','String','Del frame','callback',@Pick_callback_delframe,'Position',[.6 .90 .05 .04]);
                            
%% list box and delete trace
% listbox
handle.h_listbox_list   =   uicontrol(handle.f1,'Style','popupmenu','String',para.listbox_list,'callback',@Pick_callback_replot,'Value',1,'Position',[.8 .86 .05 .03]);
handle.h_listbox        =   uicontrol(handle.f1,'Style','listbox','callback',@Pick_callback_listbox,'Value',1,'keypressfcn', @Pick_short_cut_listbox,'Position',[.8 .17 .05 .69],'max',1000);
                            uicontrol(handle.f1,'Style','pushbutton','String','Del','callback',@Pick_callback_deltrace,'Position',[.80 .13 .05 .04]);
% show trace
                            uicontrol(handle.f1,'Style','pushbutton','String','Show','callback',@Pick_callback_showtrace,'Position',[.8 .09 .05 .04]);
% flip polarity for selected traces
                            uicontrol(handle.f1,'Style','pushbutton','String','Flip(f)','callback',@Pick_callback_flip,'Position',[.8 .05 .05 .04]);


                   
%% Callback functions:

%% plot panel functions:
    function Pick_callback_iniplot(h, dummy)
        
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
        [ind, flag_file] = find_event_list_phase(para.ievent, para.events, para.listname, para.phasefile,'forward');
        if isempty(ind)
            para.ievent = para.nevent;
            Pick_callback_lastevent (h, dummy)
        else
            para.ievent = ind;
        end
        
        if flag_file == 1 % no phasefile, read listname
            fid = fopen(fullfile(para.events{para.ievent},para.listname),'r');
            C = textscan(fid,'%s %*[^\n]','CommentStyle','#');
            lists = C{1};
            fclose(fid);
        elseif flag_file == 2 % find phasefile, read phasefile
            fid = fopen(fullfile(para.events{para.ievent},para.phasefile),'r');
%             C = textscan(fid,'%s %f %f %f %f %s %s %f %*[^\n]','CommentStyle','#','EmptyValue',0);
            C = textscan(fid,'%s %f %f %f %f %s %s %f %f %f %f %f %f %f %f %f %f %f %f %*[^\n]','CommentStyle','#','EmptyValue',0);
            lists = C{1}; phtt = C{2}; phtshift = C{3}; polarity = C{5}; phrayp = C{8};
            snr0 = C{18}; xcoeff0 = C{19};
%             phT = C{4}; stnm = C{6}; netwk = C{7};
            fclose(fid);   
        else
            fprintf('No event found!\n');
            para.ievent = 1;
            return;
        end
        
        % reset global variable for each event
        tr = [];
        handle.seis = {[]};
        para.iframe = 1; % set to first frame
        
        fprintf('Load in data ...\n');
%         hmsg = msgbox('Loading ...','Message','non-modal'); 
        num = 0; % reset number of traces
        t1 = [];
        para.nl = 0;
        % load in data
        for j = 1:length(lists)
            
            filename = char(lists(j));
            if exist(fullfile(para.events{para.ievent},filename),'file')
                [sachd,sacdat] = irdsac(fullfile(para.events{para.ievent},filename));
            else
                fprintf('No file %s found!\n',fullfile(para.events{para.ievent},filename));
                continue;
            end
            
            % in case nan value exist
            if isempty(sacdat) || max(isnan(sacdat)) == 1 || sachd.npts <= 1
                continue;
            end            
                        
            % calculate epicenteral distance and back azimuth 
            % modified by Chunquan Yu (2019/11/09) to take into account
            % ellipticity
%             [dist,baz] = distance(sachd.stla,sachd.stlo,sachd.evla,sachd.evlo);
%             az = azimuth(sachd.evla,sachd.evlo,sachd.stla,sachd.stlo);
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
                    
                    % calculate first arrival time if there are
                    % triplication
                    [ rayp, d1, t1 ] = y_firstarrival_interp( rayp, d1, t1 );
                    
                    % in case d1 larger than 180
                    d1 = rem(d1,360);
                    ind_major = find(d1>180);
                    d1(ind_major) = 360-d1(ind_major);
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
                
                tr(num).xcoeff0 = 1;
                tr(num).snr0 = 1;
            else
                num = num + 1;
                tr(num).tt = phtt(j);
                tr(num).tshift = phtshift(j);
                if polarity(j) == 1 || polarity(j) == -1
                    tr(num).polarity = polarity(j);
                else
                    tr(num).polarity = 1;
                end
                tr(num).rayp = phrayp(j);
                
                tr(num).xcoeff0 = xcoeff0(j);
                tr(num).snr0 = snr0(j);
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
%             tr(num).az = y_azconvert(az,1);%% change az to [-180 180]
            
            
            tr(num).dtshift = 0; % to store the time shift of each step;            
            % time relative to the theoretical phase arrival time
            tr(num).time_raw = [0:tr(num).headers.npts-1]'*tr(num).headers.delta + tr(num).headers.b - tr(num).headers.o - tr(num).tt;
            tr(num).delta_raw = tr(num).headers.delta;
            
            tr(num).ccmean = 1;
        end
                
        if num == 0
            fprintf('No trace found!\n');
            return;
        end
        
        % total number of traces
        para.nl = num; 
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
        
        % define flags, 1: run; others: pass
        para.flag.cut = 1;
        para.flag.sort = 1;
        para.flag.filter = 1;
        para.flag.snr = 1;
        
        set(handle.h_listbox,'Value',[]);
        Pick_callback_preprocess (h, dummy);
        Pick_callback_markphase (h, dummy);   
        
%         delete(hmsg);
    end

    function Pick_callback_preprocess (h, dummy)
        
        % cut data and store
        if para.flag.cut == 1
            for j = 1:para.nl
                % assign the sampling interval
                tr(j).delta = para.delta;
                % time axis
                tr(j).time_cut = reshape(para.timewin(1):tr(j).delta:para.timewin(end),[],1);
                % % cut data ( relative to shifted phase arrival time)
                if length(tr(j).data_raw) > 1
                    data_raw = detrend(tr(j).data_raw);
%                     data_raw = data_raw.*tukeywin(length(data_raw),0.1);
                    tr(j).data_cut = interp1(tr(j).time_raw-tr(j).tshift,data_raw,tr(j).time_cut,'linear',nan);
%                     tr(j).data_cut = interp1(tr(j).time_raw-tr(j).tshift,tr(j).data_raw,tr(j).time_cut,'linear',nan);
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
                
                % whether calculate integral, derivation or not
                if strcmpi(para.intederi_type,'int')
                    tr(j).data_cut = y_intederi(tr(j).data_cut,tr(j).delta,'int');
                elseif strcmpi(para.intederi_type,'der')
                    tr(j).data_cut = y_intederi(tr(j).data_cut,tr(j).delta,'der');
                end
                
                % copy for further analysis, such as filtering
                tr(j).data = tr(j).data_cut;
                tr(j).time = tr(j).time_cut;
            end
            
        end
        
        if para.flag.filter == 1
            index_filtertype = get(handle.h_filter_type,'Value');
            para.filter_type = para.filtertype_list{index_filtertype};
            for j = 1:para.nl % loop for filtering
                % copy raw cut data, tr(j).data might be already filtered
                tr(j).data = tr(j).data_cut;
                
                % if exceed Nyquist freq. - No filtering
                if para.fh >= 1/tr(j).delta/2
                    continue;
                end
                if max(tr(j).data) - min(tr(j).data) ~= 0
                    tr(j).data = detrend(tr(j).data);
                    tr(j).data = tr(j).data .* tukeywin(length(tr(j).data), 0.1);
                    
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
                    
                    % nth root
                    if strcmpi(para.intederi_type,'sqrt') % square root
                        tr(j).data = sign(tr(j).data).*abs(tr(j).data).^(1/2);
                    elseif strcmpi(para.intederi_type,'4th') % 4th root
                        tr(j).data = sign(tr(j).data).*abs(tr(j).data).^(1/4);
                    end
                end
            end
        end
        
        if para.flag.snr == 1
            % calculate signal to noise ratio
            for j = 1:para.nl
                tr(j).snr = 0;
                data_signal = interp1(tr(j).time,tr(j).data,para.signalwin(1):tr(j).delta:para.signalwin(2),'linear',0);
                data_noise = interp1(tr(j).time,tr(j).data,para.noisewin(1):tr(j).delta:para.noisewin(2),'linear',0);
                if std(data_noise) > 0
                    tr(j).snr = std(data_signal)/std(data_noise);
                end
            end
        end
        
        % sort traces
        if para.flag.sort == 1
            para.offset = [];
            if strcmpi(para.sort_type,'dist')
                for j = 1:para.nl,   tr(j).offset = tr(j).dist; para.offset(j) = tr(j).offset; end
                para.ylabel_name = 'Distance (^o)';
            elseif strcmpi(para.sort_type,'az')
                for j = 1:para.nl,   tr(j).offset = tr(j).az; para.offset(j) = tr(j).offset; end
                para.ylabel_name = 'Azimuth (^o)';
            elseif strcmpi(para.sort_type,'baz')
                for j = 1:para.nl,   tr(j).offset = tr(j).baz; para.offset(j) = tr(j).offset; end
                para.ylabel_name = 'Back azimuth (^o)';            
            elseif strcmpi(para.sort_type,'snr')
                for j = 1:para.nl,   tr(j).offset = tr(j).snr; para.offset(j) = tr(j).offset; end
                para.ylabel_name = 'Snr';
            elseif strcmpi(para.sort_type,'ccmean')
                for j = 1:para.nl,   tr(j).offset = tr(j).ccmean; para.offset(j) = tr(j).offset; end
                para.ylabel_name = 'CC coefficient';
            elseif strcmpi(para.sort_type,'snr0')
                for j = 1:para.nl,   tr(j).offset = tr(j).snr0; para.offset(j) = tr(j).offset; end
                para.ylabel_name = 'Snr predefined';
            elseif strcmpi(para.sort_type,'xcoeff0')
                for j = 1:para.nl,   tr(j).offset = tr(j).xcoeff0; para.offset(j) = tr(j).offset; end
                para.ylabel_name = 'Xcoeff predefined';
            elseif strcmpi(para.sort_type,'rayp')
                for j = 1:para.nl,   tr(j).offset = tr(j).rayp; para.offset(j) = tr(j).offset; end
                para.ylabel_name = 'Ray para. (s/km)';
            elseif strcmpi(para.sort_type,'stla')
                for j = 1:para.nl,   tr(j).offset = tr(j).headers.stla; para.offset(j) = tr(j).offset; end
                para.ylabel_name = 'Station lat. (^o)';
            elseif strcmpi(para.sort_type,'stlo')
                for j = 1:para.nl,   tr(j).offset = tr(j).headers.stlo; para.offset(j) = tr(j).offset; end
                para.ylabel_name = 'Station lon. (^o)';
            elseif strcmpi(para.sort_type,'nstnm')
                [c,indtmp] = sort({tr.nstnm});
                for j = 1:para.nl,   tr(indtmp(j)).offset = j; para.offset(indtmp(j)) = tr(indtmp(j)).offset; end
                para.ylabel_name = 'Station name';    
            elseif strcmpi(para.sort_type,'tshift')
                for j = 1:para.nl,   tr(j).offset = tr(j).tshift; para.offset(j) = tr(j).offset; end
                para.ylabel_name = 'Time shift (s)';
            elseif strcmpi(para.sort_type,'evla')
                for j = 1:para.nl,   tr(j).offset = tr(j).headers.evla; para.offset(j) = tr(j).offset; end
                para.ylabel_name = 'Event lat. (^o)';
            elseif strcmpi(para.sort_type,'evlo')
                for j = 1:para.nl,   tr(j).offset = tr(j).headers.evlo; para.offset(j) = tr(j).offset; end
                para.ylabel_name = 'Event lon. (^o)';
            elseif strcmpi(para.sort_type,'evdp')
                for j = 1:para.nl,   tr(j).offset = tr(j).headers.evdp; para.offset(j) = tr(j).offset; end
                para.ylabel_name = 'Event depth (km)';
            elseif strcmpi(para.sort_type,'mag')
                for j = 1:para.nl,   tr(j).offset = tr(j).headers.mag; para.offset(j) = tr(j).offset; end
                para.ylabel_name = 'Magnitude';
            else
                fprintf('No sort type: %s ; Change to dist sort!\n', para.sort_type);
                for j = 1:para.nl,   tr(j).offset = tr(j).dist;  end
                para.ylabel_name = 'Distance (^o)';
            end
            [para.offset,indx] = sort(para.offset,'ascend');
            tr = tr(indx);
            para.ylabel_name_backup = para.ylabel_name; % set ylabelname to 'Num' if evenly distributed
        end
        
    end

    function Pick_callback_replot (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        
        handle.seis = [];        
        % whether even plot or not
        if para.even_switch ~= 0
            para.offset = 1:para.nl;
            para.ylabel_name = 'Num';
        else
            for j = 1:para.nl, para.offset(j) = tr(j).offset; end
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
                stnm_tmp{max(indj)-j+1} = [tr(j).netwk,'.',tr(j).stnm];
            elseif strcmpi(para.listbox_list{indtmp},'stnm')
                stnm_tmp{max(indj)-j+1} = tr(j).stnm;
            elseif strcmpi(para.listbox_list{indtmp},'fname')
                stnm_tmp{max(indj)-j+1} = tr(j).filename;
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
            tr(j).time = tr(j).time - tr(j).dtshift;
            tr(j).dtshift = 0; % reset dtshift
        end
        
        % calculate the normalization factor
        doff = ( max(para.offset(indj)) - min(para.offset(indj)) ) / length(indj) ;
        if doff == 0
            doff = 1;       
        end
        
        amp_range = [];
        for j = indj
            tmp = interp1(tr(j).time, tr(j).data, para.normwin(1):tr(j).delta:para.normwin(end),'linear',0);
            amp_range(j-j1+1) = max(tmp) - min(tmp);
            if amp_range(j-j1+1) == 0
                tr(j).visible = 0;
                tr(j).A0 = 0;
            else
                tr(j).A0 = doff/amp_range(j-j1+1);
            end
            tr(j).range = amp_range(j-j1+1);
        end
        if strcmpi(para.norm_type,'all')
            for j = indj
                tr(j).A0 = doff/median(amp_range(find(amp_range))) ; % median normalization
            end
        elseif strcmpi(para.norm_type,'each')
        end
        
        % plot results
        for kk = 1:length(para.phase_mark) % reset phase mark flag
            para.phase_mark(kk).imark=1;
        end
        
        fprintf('Plotting ...\n');
        xlim_tmpL = para.x_lim(1);
        xlim_tmpR = para.x_lim(2);
        ht = [];
        hp = [];
        ntmp = 0;
        for j = indj            
            time_tmp = reshape(min(para.x_lim):tr(j).delta:max(para.x_lim),[],1);
            data_tmp = interp1(tr(j).time, tr(j).data*tr(j).polarity*tr(j).A0*para.scale, time_tmp ,'linear',0);
            
            if strcmpi(para.plot_type,'trace')
                handle.seis{j} = plot( handle.hax, time_tmp, para.offset(j) + data_tmp, 'color', para.color_show,'linewidth', para.linewidth_show);
            else
%                 handle.seis{j} = single_wig4( time_tmp, para.offset(j) + data_tmp);
                handle.seis{j} = single_wig7( time_tmp, data_tmp, para.offset(j));
                set(handle.seis{j}(1),'Facecolor',para.color_wig_up,'Edgecolor','none','Linewidth',para.linewidth_show);
                set(handle.seis{j}(2),'Facecolor',para.color_wig_dn,'Edgecolor','none','Linewidth',para.linewidth_show);
            end
            
            if tr(j).visible == 0
                set(handle.seis{j},'visible','off');
                list_entries{j2-j+1}=[];
            end
            
            % plot theoretical phase arrival time
            if para.theo_switch == 1 && tr(j).visible == 1 % plot theoretical arrival time
                hold on;
                plot(handle.hax, -tr(j).tshift, para.offset(j), 'color',para.color_theo,'Marker',para.marker_theo,'Markersize',para.msize_theo);
            end
            
            % mark phases
            if para.phase_show == 1 && ~isempty(para.phase_mark) && tr(j).visible == 1
%                 tt_ref = tr(j).tt;
                tt_ref = interp1db(tr(j).dist,para.phase_ref.d1,para.phase_ref.t1);
                for kk = 1:length(para.phase_mark)
                    tt_tmp = interp1db(tr(j).dist,para.phase_mark(kk).d1,para.phase_mark(kk).t1);
                    if ~isnan(tt_tmp) % no such phase for this epi-center distance
                        if (tt_tmp-tt_ref > xlim_tmpL) && (tt_tmp-tt_ref < xlim_tmpR) % within the xlim window
                            hold on;
                            plot(handle.hax,[tt_tmp-tt_ref tt_tmp-tt_ref], [para.offset(j)-doff/2 para.offset(j)+doff/2],'color',para.phase_mark(kk).color,'Linewidth',para.linewidth_show);
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
                        str = [str,'  Snr=',num2str(tr(j).snr,'%.2f')]; 
                    elseif strcmpi(para.text_para(kk),'snr0')
                        str = [str,'  Snr0=',num2str(tr(j).snr0,'%.2f')]; 
                    elseif strcmpi(para.text_para(kk),'ccmean')
                        str = [str,'  CCmean=',num2str(tr(j).ccmean,'%.2f')]; 
                    elseif strcmpi(para.text_para(kk),'xcoeff0')
                        str = [str,'  Xcoeff0=',num2str(tr(j).xcoeff0,'%.2f')]; 
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

    function Pick_callback_vmodel (h,dummy)
        
        if ~isfield(para,'nevent')
            return;
        end
        
        index_vmodel = get(handle.h_vmodel_list,'Value');
        para.mod = para.vmodel_list{index_vmodel};
        para.em = set_vmodel_v2(para.mod);
        para.em = refinemodel(para.em, para.thmax);
        % avoid same depth
        ind = find(diff(para.em.z)<1e-6);
        para.em.z(ind+1) = para.em.z(ind) + 1e-6;
        
        Pick_callback_markphase (h, dummy);
    end
        
        
    function Pick_callback_intederi (h, dummy)
        
        if ~isfield(para,'nevent')
            return;
        end
        
        index_intederi = get(handle.h_intederi_list,'Value');
        para.intederi_type = para.intederi_list{index_intederi};
        
        para.flag.cut = 1;
        para.flag.filter = 1;
        para.flag.sort = 0;
        para.flag.snr = 1;
        Pick_callback_preprocess (h, dummy);
        Pick_callback_replot (h, dummy);
        
    end

    function Pick_callback_choosephase (h, dummy)
        
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
                    if xdep_temp >= 0 && xdep_temp < para.em.z_cmb
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
        para.phasefile = [para.listname,'_',para.phase,para.phasefileapp];
                
        if ~isfield(para,'nevent')
            return;
        end
        Pick_callback_iniplot (h, dummy);
    end

    function Pick_callback_markphase (h,dummy)
              
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
                    
                    % calculate first arrival time if there are
                    % triplication
                    [ rayp, d1, t1 ] = y_firstarrival_interp( rayp, d1, t1 );
                    
                    % in case d1 larger than 180
                    d1 = rem(d1,360);
                    ind_major = find(d1>180);
                    d1(ind_major) = 360-d1(ind_major);
                    
                    para.phase_mark(kk).t1 = t1;
                    para.phase_mark(kk).d1 = d1;
                end
                para.phase_mark(kk).name = phaselist_tmp{kk};
                para.phase_mark(kk).evdp = para.evdp;
                para.phase_mark(kk).color = para.colorpool{mod(kk-1,length(para.colorpool))+1};
                para.phase_mark(kk).imark = 1; % to text phase name
            end
            
            % reference phase
            [rayp,taup,Xp] = phase_taup(para.phase, para.evdp, para.np, para.em, para.xdep);
            t1 = taup + rayp.* Xp;
            d1 = Xp*para.r2d;
            % calculate first arrival time if there are
            % triplication
            [ rayp, d1, t1 ] = y_firstarrival_interp( rayp, d1, t1 );            
            d1 = rem(d1,360);
            
            para.phase_ref.t1 = t1;
            para.phase_ref.d1 = d1;
            
        end
        Pick_callback_replot (h,dummy)
    end

    function Pick_callback_sort (h, dummy)
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
            Pick_callback_preprocess (h, dummy);
            Pick_callback_replot (h, dummy);
            set(handle.h_listbox,'Value',[]);
        end
    end

    function Pick_callback_plotype (h, dummy)
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
        Pick_callback_replot (h,dummy)
    end

    function Pick_callback_norm (h, dummy)
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
            Pick_callback_replot (h, dummy);
        end
    end

    function Pick_callback_tracenumber (h, dummy)
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
        Pick_callback_replot (h, dummy);
    end

    function Pick_callback_filter (h, dummy)
                
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
        Pick_callback_preprocess (h, dummy);
        Pick_callback_replot (h, dummy);
    end

    function Pick_callback_ampup (h, dummy)
        uicontrol(handle.h_hot);
        para.scale = para.scale * 1.25;
        Pick_callback_replot (h, dummy);
    end

    function Pick_callback_ampdown (h, dummy)
        uicontrol(handle.h_hot);
        para.scale = para.scale * 0.8;
        Pick_callback_replot (h, dummy);
    end

    function Pick_callback_timeup (h, dummy)
        
        uicontrol(handle.h_hot);
        para.x_lim = para.x_lim*0.8;
        Pick_callback_replot (h,dummy);
    end

    function Pick_callback_timedown (h, dummy)
        
        uicontrol(handle.h_hot);
        para.x_lim = para.x_lim*1.25;
        Pick_callback_replot (h,dummy);
    end

    function Pick_callback_theoplot (h, dummy)
        
        uicontrol(handle.h_hot);
        para.theo_switch = get(handle.theoplot_button,'Value');
        Pick_callback_replot (h,dummy)
        fprintf('Plot theoretical phase arrival time\n');
    end

    function Pick_callback_xyswitch (h,dummy)
        
        uicontrol(handle.h_hot);
        para.xy_switch = get(handle.xy_button,'Value');
        Pick_callback_replot (h,dummy);
        fprintf('X<->Y axis reverse!\n');
    end

    function Pick_callback_even (h,dummy)
        
        uicontrol(handle.h_hot);
        para.even_switch = get(handle.even_button,'Value');         
        fprintf('Evenly/Unevenly distributed!\n')
        Pick_callback_replot (h, dummy);
    end

    function Pick_callback_polarity (h,dummy)
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        fprintf('Polarity change!\n')
        for j = 1:para.nl
            tr(j).polarity = -1*tr(j).polarity;
        end
        Pick_callback_replot (h,dummy);
    end

    function Pick_callback_delta (h,dummy)
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
                    Pick_callback_preprocess (h,dummy)
                    Pick_callback_replot (h,dummy)
                else
                    fprintf('Please check Nyquist frequency! It should be large enough!\n');
                end
            else
                fprintf('Please check filter width!\n');
            end
        end
        
    end

    function Pick_callback_textpara(h,dummy)
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
        Pick_callback_replot (h,dummy);        
    end


%% window panel functions
    function Pick_callback_window (h, dummy)
        
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
            Pick_callback_preprocess (h, dummy);
            Pick_callback_replot (h, dummy);
        else
            fprintf('Please check time window!\n')
        end
    end


%% pick panel functions
    function Pick_callback_picktt (h, dummy) 
        
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

    function Pick_callback_align (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
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
                tr(j).dtshift = x0(1);
                tr(j).tshift = tr(j).tshift + tr(j).dtshift;
            end
            plot(handle.hax, x0, y0, 'ro');
        end
        pause (.3);
        Pick_callback_replot (h, dummy);
        
        para.xpick = [];
        para.ypick = [];
    end

    function Pick_callback_autopeak( h, dummy )
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe') || isempty(tr)
            return;
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
                    tr(kk).dtshift = autopeak_wintime(indt);
                    tr(kk).tshift = tr(kk).tshift + tr(kk).dtshift;
                end
            end
        else % autopeak for selected traces
            for kk = 1:length(j)
                if tr(j(kk)).visible == 1
                    datawin = interp1(tr(j(kk)).time,tr(j(kk)).data*tr(j(kk)).A0*tr(j(kk)).polarity,autopeak_wintime,'linear',0);
                    [c,indt] = max(datawin);
                    tr(j(kk)).dtshift = autopeak_wintime(indt);
                    tr(j(kk)).tshift = tr(j(kk)).tshift + tr(j(kk)).dtshift;
                end
            end
        end
        
        fprintf('Auto peak finished!\n');
        Pick_callback_replot (h,dummy);
        
        
    end

    function Pick_callback_autopeakloop( h,dummy )
        
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
            Pick_callback_autopeak(h,dummy);
            Pick_callback_save(h,dummy);
            Pick_callback_nextevent (h, dummy);
            if para.ievent == event_tmp
                break;
            end
        end
        
        set(handle.h_peakloop,'Value',0);
    end

    function Pick_callback_gpick ( h,dummy)
        
        if ~isfield(para,'iframe')
            return;
        end
        [x1,y1,but1] = myginput(1,'crosshair');
        
        j1 = (para.iframe -1) * para.n_per_frame +1;
        j2 = j1 + para.n_per_frame -1;
        j2 = min( j2, para.nl);
        
        [c,index_selected] = min(abs(para.offset(j1:j2)-y1));
        index_selected = j2-j1-index_selected+2;
        
        for k = j1:j2
            if length(handle.seis{k}) == 1
                set( handle.seis{k} , 'color',para.color_show,'linewidth',para.linewidth_show);
            else
                set( handle.seis{k}(1) , 'Facecolor',para.color_wig_up,'edgecolor','none','linewidth',para.linewidth_show);
                set( handle.seis{k}(2) , 'Facecolor',para.color_wig_dn,'edgecolor','none','linewidth',para.linewidth_show);
            end
        end
        
        j = j2 - index_selected + 1; % reverse the list
        for k = 1:length(j)
            if length(handle.seis{j(k)}) == 1
                set( handle.seis{j(k)} , 'color',para.color_selected,'linewidth',para.linewidth_selected);
            else
                set( handle.seis{j(k)}(1) , 'edgecolor',para.color_selected,'linewidth',para.linewidth_selected);
                set( handle.seis{j(k)}(2) , 'edgecolor',para.color_selected,'linewidth',para.linewidth_selected);
            end
        end
            
        set(handle.h_listbox,'Value',index_selected);        
        uicontrol(handle.h_listbox)
    end

%% Multi panel functions
    function Pick_callback_xcorr( h, dummy )
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
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
        
%         [datawin,lags,ccmean] = multi_cc_ref_polarity(datawin,xcorr_wintime',[para.xcorr_win(1),para.xcorr_win(end)],para.xcorr_tlag);
%         [datawin,lags,ccmean] = multi_cc(datawin,xcorr_wintime',[para.xcorr_win(1),para.xcorr_win(end)],para.xcorr_tlag);
        [datawin,lags,ccmean] = multi_cc_ref(datawin,xcorr_wintime',[para.xcorr_win(1),para.xcorr_win(end)],para.xcorr_tlag);
        for kk = 1:k
            tr(tmpind(kk)).dtshift = - lags(kk)*para.delta;
            tr(tmpind(kk)).tshift = tr(tmpind(kk)).tshift + tr(tmpind(kk)).dtshift;
            tr(tmpind(kk)).ccmean = ccmean(kk);
        end
        fprintf('Multi-channel cross correlation finished!\n');
        Pick_callback_replot (h,dummy);
%         delete(hmsg);
    end


    function Pick_callback_xcorrloop( h,dummy )
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            set(handle.h_xcorrloop,'Value',0);
            return;
        end
        % loop for automatic pick peaks        
        para.n_per_frame = 1000;
        set(handle.h_ntrace_num,'String',num2str(para.n_per_frame));
        
        while 1
            xcorrlooptmp = get(handle.h_xcorrloop,'Value');
            if ~xcorrlooptmp
                break;
            end
            event_tmp = para.ievent;
            Pick_callback_xcorr(h,dummy);
            Pick_callback_save(h,dummy);
            Pick_callback_nextevent (h, dummy);
            if para.ievent == event_tmp
                break;
            end
        end
        
        set(handle.h_xcorrloop,'Value',0);
    end


    function Pick_callback_pca (h,dummy)
        
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
        
        pcalist = [para.listname,'_PCA'];
        pcalist_phase = [para.listname,'_PCA_',para.phase,para.phasefileapp];
        
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
        
        outmeanfile = ['SAC_',para.listname,'_',para.phase,'_PCA'];
        newhd = inewsachd;
        newhd.delta = para.delta;
        newhd.b = para.pca_win(1);
        newhd.e = para.pca_win(end);
        newhd.npts = length(pca_wintime);
        newhd.iftype = 1;
        newhd.nvhdr = 6;
        imksac( newhd, mean(datawin_pc,2), fullfile(para.events{para.ievent},outmeanfile))
        
        if pca_show_tmp == 1
            figure('name','PCA','NumberTitle','off');
            data_mean_tmp = mean(datawin_pc,2);
            % normalize
            data_mean_tmp = data_mean_tmp/(max(data_mean_tmp)-min(data_mean_tmp));
            plot(pca_wintime,data_mean_tmp,'k');
            legend('Mean Pca Trace');
            xlabel('Time (s)');
            ylabel('Mean Amp.');
        end
        
        fprintf('PCA done. Type: %s, %s\n',para.pca_type1,para.pca_type2);
        
    end

    function Pick_callback_stacking (h,dummy)
        
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
        
        pcalist = [para.listname,'_STACK'];
        pcalist_phase = [para.listname,'_STACK_',para.phase,para.phasefileapp];
        
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
        
        outmeanfile = ['SAC_',para.listname,'_',para.phase,'_STACK'];
        newhd = inewsachd;
        newhd.delta = para.delta;
        newhd.b = para.pca_win(1);
        newhd.e = para.pca_win(end);
        newhd.npts = length(pca_wintime);
        newhd.iftype = 1;
        newhd.nvhdr = 6;
        imksac( newhd, mean(datawin_pc,2), fullfile(para.events{para.ievent},outmeanfile))
        
        if pca_show_tmp == 1
            figure('name','Stacking','NumberTitle','off');
            data_mean_tmp = mean(datawin_pc,2);
            % normalize
            data_mean_tmp = data_mean_tmp/(max(data_mean_tmp)-min(data_mean_tmp));
            plot(pca_wintime,data_mean_tmp,'k');
            xlim([min(pca_wintime) max(pca_wintime)]);
            legend('Stacked Trace');
            xlabel('Time (s)');
            ylabel('Mean Amp.');
        end
        
        fprintf('Stacking done. Type: %s, %s\n',para.pca_type1,para.pca_type2);
        
    end


%% I/O panel functions
    function Pick_callback_load_evlist(h,dummy)
        
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
            Pick_callback_iniplot(h,dummy)
        end
    end

    function Pick_callback_load_evlist_2(h,dummy)
        
        uicontrol(handle.h_hot);
        para.evlistname = get(handle.h_evlist,'String');
        set(handle.h_evlist,'String', para.evlistname);
        para.evlist = fullfile(para.evpathname,para.evlistname);
        para.events = [];
        
        Pick_callback_iniplot(h,dummy)
    end

    function Pick_callback_load_listname (h, dummy)
        
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
                para.listname = templist;
                for k = 1:length(para.phaselist) % whether it is a phasefile
                    phasefiletail = ['_',para.phaselist{k},para.phasefileapp];
                    ltail = length(phasefiletail);
                    if length(templist)>=ltail && strcmp(templist(end-ltail+1:end),phasefiletail) % in case read in phase file
                        para.listname = templist(1:end-ltail);
                        para.phase = para.phaselist{k};
                        set(handle.h_phase_list,'Value',k);
                        break;
                    end
                end
                
                para.phasefile = [para.listname,'_',para.phase,para.phasefileapp];
                set(handle.h_listname,'String', para.listname);
                para.ievent = tempev(1);            % change event number
                Pick_callback_iniplot(h,dummy)
            end
        end
        uicontrol(handle.h_hot)
    end

    function Pick_callback_load_listname_2 (h, dummy)
        
        uicontrol(handle.h_hot);
        para.listname = get(handle.h_listname,'String');
        for k = 1:length(para.phaselist) % whether it is a phasefile
            phasefiletail = ['_',para.phaselist{k},para.phasefileapp];
            ltail = length(phasefiletail);
            if length(para.listname)>=ltail && strcmp(para.listname(end-ltail+1:end),phasefiletail) % in case read in phase file
                para.listname = para.listname(1:end-ltail);
                para.phase = para.phaselist{k};
                set(handle.h_phase_list,'Value',k);
                break;
            end
        end
        
        para.phasefile = [para.listname,'_',para.phase,para.phasefileapp];
        if ~isfield(para,'ievent')
            return;
        end
        Pick_callback_iniplot(h,dummy)
    end

    function Pick_callback_del_event (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'ievent')
            return;
        end
        fprintf('Delete Event: %s \n',para.events{para.ievent});
        fid2 = fopen(fullfile(para.events{para.ievent},para.phasefile),'w');
        fclose(fid2);
        Pick_callback_nextevent (h,dummy)
    end

    function Pick_callback_reset_event (h, dummy)
        uicontrol(handle.h_hot);
        if ~isfield(para,'ievent')
            return;
        end
        if exist(fullfile(para.events{para.ievent},para.phasefile),'file')
            delete(fullfile(para.events{para.ievent},para.phasefile));
        end
        fprintf('Reset Event: %s\n',para.events{para.ievent});
        Pick_callback_iniplot (h, dummy);
    end

    function Pick_callback_save (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'ievent')
            return;
        end
        fid2 = fopen(fullfile(para.events{para.ievent},para.phasefile),'w');
%         fprintf(fid2,'#filename theo_tt tshift obs_tt polarity stnm netwk rayp stla stlo stel evla evlo evdp dist az baz\n');
        fprintf(fid2,'#filename theo_tt tshift obs_tt polarity stnm netwk rayp stla stlo stel evla evlo evdp dist az baz snr0 xcoeff0\n');
        for j=1 : para.nl
            if tr(j).visible == 1
%                 fprintf(fid2,'%s %f %f %f %d %s %s %f %f %f %f %f %f %f %f %f %f\n',tr(j).filename, tr(j).tt, tr(j).tshift, tr(j).tt+tr(j).tshift, tr(j).polarity,tr(j).stnm,tr(j).netwk, tr(j).rayp, tr(j).headers.stla, tr(j).headers.stlo, tr(j).headers.stel, tr(j).headers.evla, tr(j).headers.evlo, tr(j).headers.evdp, tr(j).dist, tr(j).az, tr(j).baz);
                fprintf(fid2,'%s %f %f %f %d %s %s %f %f %f %f %f %f %f %f %f %f %f %f\n',tr(j).filename, tr(j).tt, tr(j).tshift, tr(j).tt+tr(j).tshift, tr(j).polarity,tr(j).stnm,tr(j).netwk, tr(j).rayp, tr(j).headers.stla, tr(j).headers.stlo, tr(j).headers.stel, tr(j).headers.evla, tr(j).headers.evlo, tr(j).headers.evdp, tr(j).dist, tr(j).az, tr(j).baz, tr(j).snr0, tr(j).xcoeff0);
            end
        end
        fclose(fid2);
        fprintf('Save Event: %s\nPhase time shift saved to file %s\n',para.events{para.ievent},para.phasefile);
        
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

    function Pick_callback_savefig (h, dummy)
        
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
        
        print(handle.f1,'-r300','-fillpage','-dpdf',fullfile(para.events{para.ievent},[figname_base,num2str(nnum,'%02d'),'.pdf']));
        fprintf('Save figure to %s\n',fullfile(para.events{para.ievent},[figname_base,num2str(nnum,'%02d'),'.pdf']));
        
    end

    function Pick_callback_copyphasefile (h,dummy)
        
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
        
        listname_new = [para.listname,apptext];
        phasefile_new = [para.listname,apptext,'_',para.phase,'.txt'];
        
        fprintf('Generate new listname: %s\n',listname_new);
        fprintf('Generate new phasefile: %s\n',phasefile_new);
        
        if length(j) < 1 % copy the entire phasefile
            copyfile(fullfile(para.events{para.ievent},para.listname),fullfile(para.events{para.ievent},listname_new));
            if exist(fullfile(para.events{para.ievent},para.phasefile),'file')
                copyfile(fullfile(para.events{para.ievent},para.phasefile),fullfile(para.events{para.ievent},phasefile_new));
            end
            return;
        end
        
        fid1 = fopen(fullfile(para.events{para.ievent},listname_new),'w');
        fid2 = fopen(fullfile(para.events{para.ievent},phasefile_new),'w');
        %         fprintf(fid1,'#filename\n');
%         fprintf(fid2,'#filename theo_tt tshift obs_tt polarity stnm netwk rayp stla stlo stel evla evlo evdp dist az baz\n');
        fprintf(fid2,'#filename theo_tt tshift obs_tt polarity stnm netwk rayp stla stlo stel evla evlo evdp dist az baz snr0 xcoeff0\n');
        for kk = 1:length(j)
            if tr(j(kk)).visible == 1
                fprintf(fid1,'%s\n',tr(j(kk)).filename);
%                 fprintf(fid2,'%s %f %f %f %d %s %s %f %f %f %f %f %f %f %f %f %f\n',tr(j(kk)).filename, tr(j(kk)).tt, tr(j(kk)).tshift, tr(j(kk)).tt+tr(j(kk)).tshift, tr(j(kk)).polarity,tr(j(kk)).stnm,tr(j(kk)).netwk, tr(j(kk)).rayp, tr(j(kk)).headers.stla, tr(j(kk)).headers.stlo, tr(j(kk)).headers.stel, tr(j(kk)).headers.evla, tr(j(kk)).headers.evlo, tr(j(kk)).headers.evdp, tr(j(kk)).dist, tr(j(kk)).az, tr(j(kk)).baz);
                fprintf(fid2,'%s %f %f %f %d %s %s %f %f %f %f %f %f %f %f %f %f %f %f\n',tr(j(kk)).filename, tr(j(kk)).tt, tr(j(kk)).tshift, tr(j(kk)).tt+tr(j(kk)).tshift, tr(j(kk)).polarity,tr(j(kk)).stnm,tr(j(kk)).netwk, tr(j(kk)).rayp, tr(j(kk)).headers.stla, tr(j(kk)).headers.stlo, tr(j(kk)).headers.stel, tr(j(kk)).headers.evla, tr(j(kk)).headers.evlo, tr(j(kk)).headers.evdp, tr(j(kk)).dist, tr(j(kk)).az, tr(j(kk)).baz, tr(j(kk)).snr0, tr(j(kk)).xcoeff0);
            end
        end
        fclose(fid1);
        fclose(fid2);
    end


%% Events & frames functions
    function Pick_callback_nextpage (h, dummy)
        
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
        Pick_callback_replot (h, dummy);
    end

    function Pick_callback_lastpage (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        para.iframe = para.nframes;
        set(handle.h_listbox,'Value',[]);
        Pick_callback_replot (h, dummy);
    end

    function Pick_callback_firstpage (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        para.iframe = 1;
        set(handle.h_listbox,'Value',[]);
        Pick_callback_replot (h, dummy);
    end

    function Pick_callback_prepage (h, dummy)
        
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
        Pick_callback_replot (h, dummy);
    end

    function Pick_callback_preevent (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'nevent')
            return;
        end
        if para.ievent ~= 1
            [ind, flag_file] = find_event_list_phase(para.ievent-1, para.events, para.listname, para.phasefile,'backward');
        else
            [ind, flag_file] = find_event_list_phase(para.ievent, para.events, para.listname, para.phasefile,'backward');
        end
        
        if isempty(ind)
            %             fprintf('No previous event found! Go to the first event\n');
            para.ievent = 1;
            Pick_callback_firstevent (h, dummy)
        else
            para.ievent = ind;
            Pick_callback_iniplot (h, dummy)
        end
    end

    function Pick_callback_nextevent (h, dummy)
               
        uicontrol(handle.h_hot); 
        if ~isfield(para,'nevent')
            return;
        end
        if para.ievent ~= para.nevent
            [ind, flag_file] = find_event_list_phase(para.ievent+1, para.events, para.listname, para.phasefile,'forward');
        else
            [ind, flag_file] = find_event_list_phase(para.ievent, para.events, para.listname, para.phasefile,'forward');
        end
        
        if isempty(ind)
            %             fprintf('No next event found! Go to the last event\n');
            para.ievent = para.nevent;
            Pick_callback_lastevent (h, dummy)
        else
            para.ievent = ind;
            Pick_callback_iniplot (h, dummy)
        end
    end

    function Pick_callback_lastevent (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'nevent')
            return;
        end        
        para.ievent = para.nevent;
        [ind, flag_file] = find_event_list_phase(para.ievent, para.events, para.listname, para.phasefile,'backward');
        if isempty(ind)
            %             fprintf('\nNo event found!\n');
            set(handle.hax,'Visible','off');
            return;
        else
            para.ievent = ind;
        end
        Pick_callback_iniplot (h, dummy)
    end

    function Pick_callback_firstevent (h, dummy)
        
        if ~isfield(para,'nevent')
            return;
        end
        para.ievent = 1;
        [ind, flag_file] = find_event_list_phase(para.ievent, para.events, para.listname, para.phasefile,'forward');
        if isempty(ind)
            %             fprintf('\nNo event found!\n');
            set(handle.hax,'Visible','off');
            return;
        else
            para.ievent = ind;
        end
        Pick_callback_iniplot (h, dummy)
    end

    function Pick_callback_ievent (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'nevent')
            set(handle.h_ievent,'String','0');
            return;
        end
        para.ievent = floor(str2num(get(handle.h_ievent,'String')));
        Pick_callback_iniplot (h, dummy);
    end

    function Pick_callback_iframe (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            set(handle.h_iframe,'String','0');
            return;
        end
        para.iframe = floor(str2num(get(handle.h_iframe,'String')));
        Pick_callback_replot (h, dummy)
    end

    function Pick_callback_delframe (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        list_entries = get(handle.h_listbox,'String');
        j1 = (para.iframe -1) * para.n_per_frame +1;
        j2 = j1 + para.n_per_frame -1;
        j2 = min( j2, para.nl);
        
        j = j1:j2;
        for kk = 1: length(j)
            set( handle.seis{j(kk)} , 'visible','off');
            tr(j(kk)).visible = 0;
            list_entries{kk}=[];
        end
        
        set(handle.h_listbox, 'String', list_entries);
        para.iframe = para.iframe + 1;
        if para.iframe > para.nframes,
            para.iframe = para.nframes;
        end
        Pick_callback_replot (h, dummy);
        
    end


%% Listbox and others functions
    function Pick_callback_listbox (h, dummy)
               
        if ~isfield(para,'iframe')
            return;
        end
        
        %         list_entries = get(h_listbox,'String');
        index_selected = get(handle.h_listbox,'Value');
        j1 = (para.iframe -1) * para.n_per_frame +1;
        j2 = j1 + para.n_per_frame -1;
        j2 = min( j2, para.nl);
        %         j = j1 -1 + index_selected;
        j = j2 - index_selected + 1; % reverse the list
        for k = j1:j2
            if length(handle.seis{k}) == 1
                set( handle.seis{k} , 'color',para.color_show,'linewidth',para.linewidth_show);
            else
                set( handle.seis{k}(1) , 'Facecolor',para.color_wig_up,'edgecolor','none','linewidth',para.linewidth_show);
                set( handle.seis{k}(2) , 'Facecolor',para.color_wig_dn,'edgecolor','none','linewidth',para.linewidth_show);
            end
        end
        for k = 1:length(j)
            if length(handle.seis{j(k)}) == 1
                set( handle.seis{j(k)} , 'color',para.color_selected,'linewidth',para.linewidth_selected);
            else
                set( handle.seis{j(k)}(1) , 'edgecolor',para.color_selected,'linewidth',para.linewidth_selected);
                set( handle.seis{j(k)}(2) , 'edgecolor',para.color_selected,'linewidth',para.linewidth_selected);
            end
        end
    end

    function Pick_short_cut_listbox ( src, evnt)
                
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
                set( handle.seis{j(kk)} , 'visible','off');
                tr(j(kk)).visible = 0;
                fprintf('Delete station %s\n',[tr(j(kk)).netwk,'.',tr(j(kk)).stnm]);
                list_entries{index_selected(kk)}=[];
            end
            set(handle.h_listbox, 'String', list_entries);
            set(handle.h_listbox, 'Value',index_selected);
            %     return;
        elseif strcmp (k, 'f')
            Pick_callback_flip (src, evnt)
        elseif strcmp (k, 'escape')
            uicontrol(handle.h_hot);
            set(handle.h_listbox,'Value',[]);
        elseif strcmp (k, 'alt') %|| (~isempty(evnt.Modifier) && ( strcmpi(k,'0') && strcmpi(evnt.Modifier{:},'command')))
            uicontrol(handle.h_hot);
        else
            if ~isempty(evnt.Modifier) && (strcmp(evnt.Modifier{:},'control') || strcmp(evnt.Modifier{:},'command')) && strcmp (k, 'leftarrow')
                for kk = 1:length(j)
                    tr(j(kk)).dtshift = tr(j(kk)).dtshift + tr(j(kk)).delta;
                    tr(j(kk)).tshift = tr(j(kk)).tshift + tr(j(kk)).dtshift;
                end
            elseif ~isempty(evnt.Modifier) && (strcmp(evnt.Modifier{:},'control') || strcmp(evnt.Modifier{:},'command')) && strcmp (k, 'rightarrow')
                for kk = 1:length(j)
                    tr(j(kk)).dtshift = tr(j(kk)).dtshift - tr(j(kk)).delta;
                    tr(j(kk)).tshift = tr(j(kk)).tshift + tr(j(kk)).dtshift;
                end
            elseif ~isempty(evnt.Modifier) && strcmp(evnt.Modifier{:},'shift') && strcmp (k, 'leftarrow')
                for kk = 1:length(j)
                    tr(j(kk)).dtshift = tr(j(kk)).dtshift + 100*tr(j(kk)).delta;
                    tr(j(kk)).tshift = tr(j(kk)).tshift + tr(j(kk)).dtshift;
                end
            elseif ~isempty(evnt.Modifier) && strcmp(evnt.Modifier{:},'shift') && strcmp (k, 'rightarrow')
                for kk = 1:length(j)
                    tr(j(kk)).dtshift = tr(j(kk)).dtshift - 100*tr(j(kk)).delta;
                    tr(j(kk)).tshift = tr(j(kk)).tshift + tr(j(kk)).dtshift;
                end
                
            elseif isempty(evnt.Modifier) && strcmp (k, 'leftarrow')
                for kk = 1:length(j)
                    tr(j(kk)).dtshift = tr(j(kk)).dtshift + 10*tr(j(kk)).delta;
                    tr(j(kk)).tshift = tr(j(kk)).tshift + tr(j(kk)).dtshift;
                end
            elseif isempty(evnt.Modifier) && strcmp (k, 'rightarrow')
                for kk = 1:length(j)
                    tr(j(kk)).dtshift = tr(j(kk)).dtshift - 10*tr(j(kk)).delta;
                    tr(j(kk)).tshift = tr(j(kk)).tshift + tr(j(kk)).dtshift;
                end
            else
                return;
            end
            Pick_callback_replot
            uicontrol(handle.h_listbox)
        end
        Pick_callback_listbox (src, evnt)
    end

    function Pick_callback_deltrace (h, dummy)
        
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
            set( handle.seis{j(kk)} , 'visible','off');
            tr(j(kk)).visible = 0;
            fprintf('Delete station %s\n',[tr(j(kk)).netwk,'.',tr(j(kk)).stnm]);
            list_entries{index_selected(kk)}=[];
        end
        
        set(handle.h_listbox, 'String', list_entries);
        uicontrol(handle.h_hot);
    end

    function Pick_callback_showtrace (h, dummy)
        
        uicontrol(handle.h_hot);
        if ~isfield(para,'iframe')
            return;
        end
        list_entries = get(handle.h_listbox,'String');
        index_selected = get(handle.h_listbox,'Value');
        j1 = (para.iframe -1) * para.n_per_frame +1;
        j2 = j1 + para.n_per_frame -1;
        j2 = min( j2, para.nl);
        
        %         j = j1 -1 + index_selected;
        j = j2 - index_selected + 1;
        indtmp = get(handle.h_listbox_list,'Value');
        for kk = 1: length(j)
            set( handle.seis{j(kk)} , 'visible','on');%,'linewidth',2);
            tr(j(kk)).visible = 1;
            
            if strcmpi(para.listbox_list{indtmp},'nstnm')
                list_entries{index_selected(kk)} = [tr(j(kk)).netwk,'.',tr(j(kk)).stnm];
            elseif strcmpi(para.listbox_list{indtmp},'stnm')
                list_entries{index_selected(kk)} = tr(j(kk)).stnm;
            elseif strcmpi(para.listbox_list{indtmp},'fname')
                list_entries{index_selected(kk)} = tr(j(kk)).filename;
            end
        end
        
        set(handle.h_listbox, 'String', list_entries);
        uicontrol(handle.h_hot);
    end

    function Pick_callback_flip (h,dummy)
        
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
            tr(j(kk)).polarity = -1*tr(j(kk)).polarity;
        end
        Pick_callback_replot(h,dummy)
        set(handle.h_listbox, 'Value',index_selected);
        uicontrol(handle.h_listbox)
    end


%% Hot keys
    function Pick_short_cut(src, evnt)
        
        uicontrol(handle.h_hot);        
        if strcmpi(evnt.Key,'i')
            Pick_callback_iniplot(src,evnt)
        elseif strcmpi(evnt.Key,'b') %|| strcmpi(evnt.Key,'backspace')
            Pick_callback_preevent(src,evnt)
        elseif strcmpi(evnt.Key,'n') %|| strcmpi(evnt.Key,'space')
            Pick_callback_nextevent(src,evnt)
        elseif strcmpi(evnt.Key,'comma')
            Pick_callback_prepage(src,evnt)
        elseif strcmpi(evnt.Key,'period')
            Pick_callback_nextpage(src,evnt)
        elseif strcmpi(evnt.Key,'s')
            Pick_callback_save(src,evnt)
        elseif ~isempty(evnt.Modifier) && strcmp(evnt.Modifier{:},'control') && strcmpi(evnt.Key,'d')
            Pick_callback_del_event(src,evnt)
        elseif strcmpi(evnt.Key,'r')
            Pick_callback_reset_event(src,evnt)
        elseif strcmpi(evnt.Key,'p') || strcmpi(evnt.Key,'t')
            Pick_callback_picktt(src,evnt)
        elseif strcmpi(evnt.Key,'a')
            Pick_callback_align(src,evnt)
        elseif strcmpi(evnt.Key,'x')
            Pick_callback_xcorr(src,evnt)
        elseif strcmpi(evnt.Key,'c')
            Pick_callback_pca(src,evnt)
        elseif strcmpi(evnt.Key,'k')
            Pick_callback_stacking(src,evnt)
        elseif strcmpi(evnt.Key,'equal')
            Pick_callback_ampup(src,evnt)
        elseif strcmpi(evnt.Key,'hyphen')
            Pick_callback_ampdown(src,evnt)
        elseif strcmpi(evnt.Key,'leftbracket')
            Pick_callback_timeup(src,evnt)
        elseif strcmpi(evnt.Key,'rightbracket')
            Pick_callback_timedown(src,evnt)
        elseif strcmpi(evnt.Key,'alt') || (~isempty(evnt.Modifier) && ( strcmpi(evnt.Key,'0') && strcmpi(evnt.Modifier{:},'command')))
            uicontrol(handle.h_listbox)
        elseif strcmpi(evnt.Key,'f')
            Pick_callback_polarity(src,evnt)
        elseif strcmpi(evnt.Key,'e')            
            if get(handle.even_button,'Value') == 1
                set(handle.even_button,'Value',0);
            else
                set(handle.even_button,'Value',1);
            end
            Pick_callback_even(src,evnt)
        elseif strcmpi(evnt.Key,'w')
            Pick_callback_autopeak(src,evnt)
        elseif strcmpi(evnt.Key,'g')
            Pick_callback_gpick(src,evnt)
        else
        end
    end

end
