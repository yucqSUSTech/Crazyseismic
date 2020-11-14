function [ phase ] = y_rdfile_phasefile_v2( phasefile )

% read phase file saved from the crazyseismic software
phase = [];
if ~exist(phasefile,'file')
    return;
end
fid = fopen(phasefile,'r');
C = textscan(fid,'%s %f %f %f %f %s %s %f %f %f %f %f %f %f %f %f %f %f %f %*[^\n]','CommentStyle','#','EmptyValue',0);
fclose(fid);

if isempty(C{1})
    phase.filename = [];
    return;
end

phase.filename = C{1}; 
if min(isnan(C{2})) == 1 % not a phasefile but a listname
    return;
end
phase.theo_tt = C{2}; 
phase.tshift = C{3}; 
phase.obs_tt = C{4}; 
phase.polarity = C{5}; 
phase.stnm = C{6}; 
phase.netwk = C{7};
phase.rayp = C{8};

phase.stla = C{9};
phase.stlo = C{10};
phase.stel = C{11};
phase.evla = C{12};
phase.evlo = C{13};
phase.evdp = C{14};
phase.dist = C{15};
phase.az = C{16};
phase.baz = C{17};
phase.snr0 = C{18};
phase.xcoeff0 = C{19};

end

