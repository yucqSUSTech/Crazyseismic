function [ ] = imksac( sachd, sacdata, sacfile )
% usage: imksac( sachd, sacdata, sacfile )
% imksac generates a binary sac file 'sacfile' from 'sachd' and 'sacdata'. 
% sachd is a structure of the sac header which can be generated from an 
% exist sac file by irdsac or created by inewsachd(need some change 
% before used for imksac, e.g. delta must be set)
% author: taokai@pku.edu.cn (any suggestion is appreciated)



%%
%    Default byte-order
%    endian  = 'big'  big-endian byte order (e.g., UNIX)
%            = 'lil'  little-endian byte order (e.g., LINUX)

endian = 'lil';

if strcmp(endian,'big')
    fid = fopen(sacfile,'w','ieee-be'); 
elseif strcmp(endian,'lil')
    fid = fopen(sacfile,'w','ieee-le'); 
end

%% define empty sac head
h = zeros(302,1);
h(1:110) = -12345*ones(110,1);
h(106) = 1; % leven is set to true

%% read in sachd

% check the sachd
if sachd.leven ~= 1
    warning('sachd.leven(equidistant sampling) is not set to 1, changed to 1 !');
    sachd.leven = 1;
end
if sachd.delta == -12345
    error('sachd.delta is not set!');
end
if length(sacdata) ~= sachd.npts
    warning('sachd.npts is not set, changed to the length of sacdata!');
    sachd.npts = length(sacdata);
end
% if sachd.b == -12345
%     warning('sachd.b is not set, changed to 0 !');
%     sachd.b = 0;
% end
ending_time = sachd.b+(sachd.npts-1)*sachd.delta;
if sachd.b ~= -12345 && ~(abs(sachd.e-ending_time) < sachd.delta)
    warning('sachd.e is not correctly set, changed accordingly!');
    sachd.e = ending_time;
end
if sachd.iftype ~= 1 % time series file
    warning('sachd.iftype is set to 1!');
    sachd.iftype = 1;
end
if sachd.nvhdr ~= 6 % version number
    warning('sachd.nvhdr is set to 6!');
    sachd.nvhdr = 6;
end
if (sachd.evla ~= -12345 && sachd.evlo ~= -12345 && sachd.stla ~= -12345 && sachd.stlo ~= -12345)
    [sachd.gcarc, sachd.az] = distance(sachd.evla,sachd.evlo,sachd.stla,sachd.stlo);
    sachd.baz = azimuth(sachd.stla,sachd.stlo,sachd.evla,sachd.evlo);
    sachd.dist = sachd.gcarc * 111.195;
%     [ sachd.gcarc, sachd.az, sachd.baz ] = edist(sachd.evla,sachd.evlo,sachd.stla,sachd.stlo);
%     sachd.dist = sachd.gcarc * 111.195;
%     
%     [sachd.dist, sachd.az, sachd.baz, sachd.gcarc] = ical(sachd.stla,sachd.stlo,sachd.evla,sachd.evlo);
end

% read real header variables
%---------------------------------------------------------------------------

         h(1)     =    sachd.delta    ;
         h(2)               =    sachd.depmin   ;
         h(3)               =    sachd.depmax   ;
        h(4)                =    sachd.scale    ;
         h(5)               =    sachd.odelta   ;
    h(6)                    =    sachd.b        ;
    h(7)                    =    sachd.e        ;
    h(8)                    =    sachd.o        ;
    h(9)                    =    sachd.a        ;
     h(11)                  =    sachd.t0       ;
     h(12)                  =    sachd.t1       ;
     h(13)                  =    sachd.t2       ;
     h(14)                  =    sachd.t3       ;
     h(15)                  =    sachd.t4       ;
     h(16)                  =    sachd.t5       ;
     h(17)                  =    sachd.t6       ;
     h(18)                  =    sachd.t7       ;
     h(19)                  =    sachd.t8       ;
     h(20)                  =    sachd.t9       ;
    h(21)                   =    sachd.f        ;
        h(22)               =    sachd.resp0    ;
        h(23)               =    sachd.resp1    ;
        h(24)               =    sachd.resp2    ;
        h(25)               =    sachd.resp3    ;
        h(26)               =    sachd.resp4    ;
        h(27)               =    sachd.resp5    ;
        h(28)               =    sachd.resp6    ;
        h(29)               =    sachd.resp7    ;
        h(30)               =    sachd.resp8    ;
        h(31)               =    sachd.resp9    ;
       h(32)                =    sachd.stla     ;
       h(33)                =    sachd.stlo     ;
       h(34)                =    sachd.stel     ;
       h(35)                =    sachd.stdp     ;
       h(36)                =    sachd.evla     ;
       h(37)                =    sachd.evlo     ;
       h(38)                =    sachd.evel     ;
       h(39)                =    sachd.evdp     ;
      h(40)                 =    sachd.mag      ;
        h(41)               =    sachd.user0    ;
        h(42)               =    sachd.user1    ;
        h(43)               =    sachd.user2    ;
        h(44)               =    sachd.user3    ;
        h(45)               =    sachd.user4    ;
        h(46)               =    sachd.user5    ;
        h(47)               =    sachd.user6    ;
        h(48)               =    sachd.user7    ;
        h(49)               =    sachd.user8    ;
        h(50)               =    sachd.user9    ;
       h(51)                =    sachd.dist     ;
     h(52)                  =    sachd.az       ;
      h(53)                 =    sachd.baz      ;
        h(54)               =    sachd.gcarc    ;
         h(57)              =    sachd.depmen   ;
        h(58)               =    sachd.cmpaz    ;
         h(59)              =    sachd.cmpinc   ;
           h(60)            =    sachd.xminimum ;
           h(61)            =    sachd.xmaximum ;
           h(62)            =    sachd.yminimum ;
           h(63)            =    sachd.ymaximum ;

% read integer header variables
%---------------------------------------------------------------------------
          h(71)         = sachd.nzyear  ;
          h(72)         = sachd.nzjday  ;
          h(73)         = sachd.nzhour  ;
         	h(74)          = sachd.nzmin   ;
         	h(75)          = sachd.nzsec   ;
          h(76)         = sachd.nzmsec  ;
         	h(77)          = sachd.nvhdr   ;
         	h(78)          = sachd.norid   ;
         	h(79)          = sachd.nevid   ;
        	h(80)           = sachd.npts    ;
         	h(82)          = sachd.nwfid   ;
          h(83)         = sachd.nxsize  ;
          h(84)         = sachd.nysize  ;
          h(86)         = sachd.iftype  ;
        	h(87)           = sachd.idep    ;
          h(88)         = sachd.iztype  ;
         	h(90)          = sachd.iinst   ;
          h(91)         = sachd.istreg  ;
          h(92)         = sachd.ievreg  ;
          h(93)         = sachd.ievtyp  ;
         	h(94)          = sachd.iqual   ;
          h(95)         = sachd.isynth  ;
          h(96)        = sachd.imagtyp ;
          h(97)        = sachd.imagsrc ;

%read logical header variables
%---------------------------------------------------------------------------
          h(106)           =   sachd.leven ; 
          h(107)           =  sachd.lpspol ;
          h(108)           =  sachd.lovrok ;
          h(109)           =  sachd.lcalda ;

%read character header variables
%---------------------------------------------------------------------------
          h(111:118)           =   istrchoppad(sachd.kstnm  ,8);
          h(119:134)           =   istrchoppad(sachd.kevnm  ,16);
          h(135:142)           =   istrchoppad(sachd.khole  ,8);
       		h(143:150)           =   istrchoppad(sachd.ko  	,8); 
       		h(151:158)           =   istrchoppad(sachd.ka  	,8); 
        	h(159:166)           =   istrchoppad(sachd.kt0  	,8);
          h(167:174)         =     istrchoppad(sachd.kt1    ,8);
          h(175:182)         =     istrchoppad(sachd.kt2    ,8);
          h(183:190)         =     istrchoppad(sachd.kt3    ,8);
          h(191:198)         =     istrchoppad(sachd.kt4    ,8);
          h(199:206)         =     istrchoppad(sachd.kt5    ,8);
          h(207:214)         =     istrchoppad(sachd.kt6    ,8);
          h(215:222)         =     istrchoppad(sachd.kt7    ,8);
          h(223:230)         =     istrchoppad(sachd.kt8    ,8);
          h(231:238)         =     istrchoppad(sachd.kt9    ,8);
          h(239:246)           =   istrchoppad(sachd.kf  	 ,8); 
          h(247:254)            =  istrchoppad(sachd.kuser0 ,8);
          h(255:262)            =  istrchoppad(sachd.kuser1 ,8);
          h(263:270)            =  istrchoppad(sachd.kuser2 ,8);
          h(271:278)            =  istrchoppad(sachd.kcmpnm ,8);
          h(279:286)            =  istrchoppad(sachd.knetwk ,8);
          h(287:294)            =  istrchoppad(sachd.kdatrd ,8);
          h(295:302)           =   istrchoppad(sachd.kinst  ,8);

%% write sac head and amplitude data

% write single precision real header variables:
%---------------------------------------------------------------------------
for i=1:70
  fwrite(fid,h(i),'single');
end

% write single precision integer header variables:
%---------------------------------------------------------------------------
for i=71:105
  fwrite(fid,h(i),'int32');
end

% write logical header variables
%---------------------------------------------------------------------------
for i=106:110
  fwrite(fid,h(i),'int32');
end

% write character header variables
%---------------------------------------------------------------------------
for i=111:302
  fwrite(fid,h(i),'char');
end

% write out amplitudes
%--------------------------------------------------------------------------
fwrite(fid,sacdata,'single');

fclose(fid);

%% nested funcitons
    function [ strout ] = istrchoppad( strin, strlen )
    %STRCHOPPAD Summary of this function goes here
    %   Detailed explanation goes here

    nstrin = length(strin);
    if nstrin < strlen
        strout = strin;    
        strout(nstrin+1:strlen) = 0;
    else
        strout = strin(1:strlen);
    end
    end

%     function [dist, az, baz, gcarc] = ical(stla,stlo,evla,evlo)
%         R_earth = 6371.009; % mean earth's radius(km)
%         radperdeg = pi/180;
%         degperrad = 180/pi;
%         n_st = [cos(stlo*radperdeg), sin(stlo*radperdeg), sin(stla*radperdeg)];
%         n_ev = [cos(evlo*radperdeg), sin(evlo*radperdeg), sin(evla*radperdeg)];
%         n_north = [0 0 1];
%         
%         % calculate epidistance:
%         dist = acos(dot(n_st,n_ev))*R_earth;
%         % calculate great circle arc:
%         gcarc = acos(dot(n_st,n_ev))*degperrad;
%         % calculate azimuth:
%         evrotnorth = cross(n_ev,n_north);
%         evrotst = cross(n_ev,n_st);
%         az_pi = acos(dot(evrotnorth,evrotst));
%         if dot(cross(evrotnorth,n_ev),evrotst)>0
%             az = az_pi*degperrad;
%         else
%             az = (2*pi-az_pi)*degperrad;
%         end
%         % calculate back-azimuth:
%         strotnorth = cross(n_st,n_north);
%         strotev = cross(n_st,n_ev);
%         baz_pi = acos(dot(strotnorth,strotev));
%         if dot(cross(strotnorth,n_st),strotev)>0
%             baz = baz_pi*degperrad;
%         else
%             baz = (2*pi-baz_pi)*degperrad;
%         end
%     end

end
