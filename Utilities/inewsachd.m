function [ sachd ] = inewsachd( )
% inewsachd creates an empty structure 'sachd' which is consistent with
% irdsac and can be used by imksac to create your own sac file.
%
% 'sachd' contains the following elements
% -------------------------------------------------------------------------
%delta	stla	evla	data(10) iftype   dist     xminimum             trcLen	
%b      stlo	evlo	label(3) idep     az       xmaximum             scale
%e      stel	evel             iztype   baz      yminimum
%o      stdp	evdp             iinst    gcarc    ymaximum
%a      cmpaz	nzyear           istreg	  norid
%t0     cmpinc	nzjday           ievreg	  nevid
%t1     kstnm	nzhour           ievtyp	  nwfid
%t2     kcmpnm	nzmin            iqual	  nxsize
%t3     knetwk	nzsec            isynth	  nysize
%t4		nzmsec
%t5		kevnm
%t6		mag
%t7		imagtyp
%t8		imagsrc
%t9
%f
%k0
%ka
%kt1
%kt2
%kt3
%kt4
%kt5
%kt6
%kt7
%kt8
%kt9
%kf

%response is a 10-element array, and trcLen is a scalar. 
%
% author: taokai@pku.edu.cn (any suggestion is appreciated)

%% define empty sac head
h = zeros(302,1);
h(1:97) = -12345*ones(97,1);
h(106) = 1; % leven is set to true(equidistant sampling)
h(108) = 1; % lovrok is set to true(overwirte is permitted, added on 3/6/2010)
h(109) = 1; % lcalda is set to true(calculate az,backaz,dist from evla/lo and stla/lo, added on 3/6/2010)
%% write the structured sachd

% read real header variables
%---------------------------------------------------------------------------
sachd.delta = h(1);
sachd.depmin = h(2);
sachd.depmax = h(3);
sachd.scale = h(4);
sachd.odelta = h(5);
sachd.b = h(6);
sachd.e = h(7);
sachd.o = h(8);
sachd.a = h(9);
sachd.t0 = h(11);
sachd.t1 = h(12);
sachd.t2 = h(13);
sachd.t3 = h(14);
sachd.t4 = h(15);
sachd.t5 = h(16);
sachd.t6 = h(17);
sachd.t7 = h(18);
sachd.t8 = h(19);
sachd.t9 = h(20);
sachd.f = h(21);
sachd.resp0 = h(22);
sachd.resp1 = h(23);
sachd.resp2 = h(24);
sachd.resp3 = h(25);
sachd.resp4 = h(26);
sachd.resp5 = h(27);
sachd.resp6 = h(28);
sachd.resp7 = h(29);
sachd.resp8 = h(30);
sachd.resp9 = h(31);
sachd.stla = h(32);
sachd.stlo = h(33);
sachd.stel = h(34);
sachd.stdp = h(35);
sachd.evla = h(36);
sachd.evlo = h(37);
sachd.evel = h(38);
sachd.evdp = h(39);
sachd.mag = h(40);
sachd.user0 = h(41);
sachd.user1 = h(42);
sachd.user2 = h(43);
sachd.user3 = h(44);
sachd.user4 = h(45);
sachd.user5 = h(46);
sachd.user6 = h(47);
sachd.user7 = h(48);
sachd.user8 = h(49);
sachd.user9 = h(50);
sachd.dist = h(51);
sachd.az = h(52);
sachd.baz = h(53);
sachd.gcarc = h(54);
sachd.depmen = h(57);
sachd.cmpaz = h(58);
sachd.cmpinc = h(59);
sachd.xminimum = h(60);
sachd.xmaximum = h(61);
sachd.yminimum = h(62);
sachd.ymaximum = h(63);

% read integer header variables
%---------------------------------------------------------------------------
sachd.nzyear = round(h(71));
sachd.nzjday = round(h(72));
sachd.nzhour = round(h(73));
sachd.nzmin = round(h(74));
sachd.nzsec = round(h(75));
sachd.nzmsec = round(h(76));
sachd.nvhdr = round(h(77));
sachd.norid = round(h(78));
sachd.nevid = round(h(79));
sachd.npts = round(h(80));
sachd.nwfid = round(h(82));
sachd.nxsize = round(h(83));
sachd.nysize = round(h(84));
sachd.iftype = round(h(86));
sachd.idep = round(h(87));
sachd.iztype = round(h(88));
sachd.iinst = round(h(90));
sachd.istreg = round(h(91));
sachd.ievreg = round(h(92));
sachd.ievtyp = round(h(93));
sachd.iqual = round(h(94));
sachd.isynth = round(h(95));
sachd.imagtyp = round(h(96));
sachd.imagsrc = round(h(97));

%read logical header variables
%---------------------------------------------------------------------------
sachd.leven = round(h(106));
sachd.lpspol = round(h(107));
sachd.lovrok = round(h(108));
sachd.lcalda = round(h(109));

%read character header variables
%---------------------------------------------------------------------------
sachd.kstnm = char(h(111:118));
sachd.kevnm = char(h(119:134));
sachd.khole = char(h(135:142));
sachd.ko = char(h(143:150));
sachd.ka = char(h(151:158));
sachd.kt0 = char(h(159:166));
sachd.kt1 = char(h(167:174));
sachd.kt2 = char(h(175:182));
sachd.kt3 = char(h(183:190));
sachd.kt4 = char(h(191:198));
sachd.kt5 = char(h(199:206));
sachd.kt6 = char(h(207:214));
sachd.kt7 = char(h(215:222));
sachd.kt8 = char(h(223:230));
sachd.kt9 = char(h(231:238));
sachd.kf = char(h(239:246));
sachd.kuser0 = char(h(247:254));
sachd.kuser1 = char(h(255:262));
sachd.kuser2 = char(h(263:270));
sachd.kcmpnm = char(h(271:278));
sachd.knetwk = char(h(279:286));
sachd.kdatrd = char(h(287:294));
sachd.kinst = char(h(295:302));

end
