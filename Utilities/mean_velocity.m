function [ avp, avs ] = mean_velocity( model )

% calulate mean velocity from input model

vp = model(1:end-1,1);
ldep = model(1:end-1,3);
lth = [ldep(1);diff(ldep)];
poi = model(1:end-1,4);

[vp,vs,poi] = y_vpvspoi(vp, poi,'vppoi');

% calculate mean velocity, method 1: sum(vp.*lth) is constant
avp = sum(vp.*lth)/ldep(end);
avs = sum(vs.*lth)/ldep(end);
% % calculate mean velocity, method 2: sum(lth./vp) is constant
% avp = ldep(end)/sum(lth./vp);
% avs = ldep(end)/sum(lth./vs);


end

