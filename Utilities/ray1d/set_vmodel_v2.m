function em = set_vmodel_v2 ( modelname )
% % 
% %
% % function em = set_vmodel ( modelname )
% % 
% % modelname can be 'iasp91', 'prem' or 'ak135' 
% %
% % OUTPUT: 
% %
% % em is a  structure which has 
% % em.vp[] = vp; 
% % em.vs[] = vs; 
% % em.rho[] = rho; 
% % em.z[] = z; 
% % em.sp_fine[] = (re - z)./ vp; 
% % em.ss_fine[] = (re - z)./vs; 
% % em.re = max(z);
% % em.z_cmb =get_cmb (); 
% % em.z_660 =get_660 (); 
% % em.z_iob = get_iob (); 
% % author: yingcai zheng 
% % modified by Chunquan Yu

filename = which('set_vmodel_v2');
currentdir = fileparts(filename);
vmodeldir = fullfile(currentdir,'vmodels');

[z,vp,vs,rho,qp,qs] = textread(fullfile(vmodeldir,[modelname,'.txt']),'%f %f %f %f %f %f','commentstyle','shell'); 
nqp = length(qp);
nz = length(z);
if nqp < nz
    qp(nqp+1:nz) = 0;
    qs(nqp+1:nz) = 0;
end

% if strcmpi(modelname, 'prem')
%     [z,vp,vs,rho,qp,qs] = textread(fullfile(vmodeldir,'prem.txt'),'%f %f %f %f %f %f','commentstyle','shell'); 
% elseif strcmpi(modelname, 'prem_no220_400')
%     [z,vp,vs,rho,qp,qs] = textread(fullfile(vmodeldir,'prem_no220_400.txt'),'%f %f %f %f %f %f','commentstyle','shell');   
% elseif strcmpi(modelname, 'iasp91')
%     [z,vp,vs,rho] = textread(fullfile(vmodeldir,'iasp91.txt'),'%f %f %f %f','commentstyle','shell');  
% elseif strcmpi(modelname, 'ak135')
%     [z,vp,vs,rho] = textread(fullfile(vmodeldir,'ak135.txt'),'%f %f %f %f','commentstyle','shell');  
% elseif strcmpi(modelname,'TX2011_ref_ocean')
%     [z,vp,vs,rho] = textread(fullfile(vmodeldir,'TX2011_ref_ocean.txt'),'%f %f %f %f','commentstyle','shell');  
% elseif strcmpi(modelname,'TX2011_ref_ocean_smooth')
%     [z,vp,vs,rho] = textread(fullfile(vmodeldir,'TX2011_ref_ocean_smooth.txt'),'%f %f %f %f','commentstyle','shell');  
% elseif strcmpi(modelname,'TX2011_ref_ocean_smooth30')
%     [z,vp,vs,rho] = textread(fullfile(vmodeldir,'TX2011_ref_ocean_smooth30.txt'),'%f %f %f %f','commentstyle','shell');  
% elseif strcmpi(modelname,'TNA_SNA_average_ocean')
%     [z,vp,vs,rho] = textread(fullfile(vmodeldir,'TNA_SNA_average_ocean.txt'),'%f %f %f %f','commentstyle','shell');  
% elseif strcmpi(modelname, 'Tibet1')
%     [z,vp,vs,rho] = textread(fullfile(vmodeldir,'Tibet1.txt'),'%f %f %f %f','commentstyle','shell');  
% else
%     disp ( 'not a sensible model ') ;
% end
% 
% if ~exist('qp','var')
%     qp = zeros(size(z));
%     qs = qp;
% end

re = max (z); 
if abs(re-6371)>50
    re = 6371;
end
NL = length(z);

% set some parameters
moho_sep_vs = 4.1;
em.vp = vp; 
em.vs = vs; 
em.rho = rho; 
em.z = z; 
em.qp = qp;
em.qs = qs;
em.sp_fine = (re - z)./ vp; 
em.ss_fine = (re - z)./vs; 
em.re = re;
em.z_cmb =get_cmb (); 
em.z_660 =get_660 (); 
em.z_iob = get_iob (); 
em.z_moho = get_moho ();
 
% !//--------------------------------------------------------------
    function z_660 =  get_660 ()
        z_660 = 660;
        for j =1: NL-1
            zj1 = z(j) ;
            zj2 = z(j+1);
            if ( abs (zj1-zj2) < 1.e-3 && abs(zj1 - 660.) < 20. ) ,
                z_660 = zj1;
                return;
            end
        end
    end %subroutine get_660
% !//--------------------------------------------------------------
    function z_iob = get_iob()
        z_iob = 5150;
        for j =1: NL-1
            zj1 = z(j);
            zj2 = z(j+1);
            if (abs (zj1-zj2) < 1.e-3 && vs(j) < 1.0e-6 && vs(j+1) > 1.) ,
                z_iob = z(j+1);
                return;
            end
        end
    end %subroutine get_iob
% !//--------------------------------------------------------------
    function z_cmb = get_cmb ()
        z_cmb = 2891;
        if max(em.z) < z_cmb
            z_cmb = max(em.z);
            return;
        end
        for j =1: NL
            if ( abs( vs(j) ) < 1.0e-6) ,
                z_cmb = z(j) ;
                return ;
            end
        end
    end %subroutine get_cmb
% !//--------------------------------------------------------------
    function z_moho = get_moho ()
        z_moho = 35;
        for j = 1:NL-1
            zj1 = z(j);
            zj2 = z(j+1);
            if (abs (zj1-zj2) < 1.e-3 && vs(j) < moho_sep_vs && vs(j+1) > moho_sep_vs) ,
                z_moho = zj1;
                return ;
            end
        end
    end
end
