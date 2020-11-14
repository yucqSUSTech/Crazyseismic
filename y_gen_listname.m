function y_gen_listname

% generate a list of events & lists of sac files in each event directory.  
% evlist: a list of events
% listz/listr/listt: lists of z/r/t-component sac files

% Chunquan Yu, 2020/08/01
% yucq@sustech.edu.cn


%% event list
% parent event directory: better to use absolute directory
parentdir = pwd;

% % data demo: P wave
% evdir = fullfile(parentdir,'data_demo/Pwave'); % event directory
% evid = '*'; % event id for searching events, using wildcard
% evlist = fullfile(parentdir,'evlist_demo_Pwave.txt'); % output event list name

% % % data demo: S wave
% evdir = fullfile(parentdir,'data_demo/Swave'); % event directory
% evid = '*'; % event id for searching events, using wildcard
% evlist = fullfile(parentdir,'evlist_demo_Swave.txt'); % output event list name
% 
% data demo: Stations
evdir = fullfile(parentdir,'data_demo/Stations'); % station directory
evid = '*'; % station id for searching stations, using wildcard
evlist = fullfile(parentdir,'stlist_demo_Stations.txt');

%% sacfile list
% id for searching z/r/t-component sac files, using wildcard
saczid = '*.BHZ.*SAC';
sacrid = '*.BHR.*SAC';
sactid = '*.BHT.*SAC';

% output sac file listname
listz = 'list_z';
listr = 'list_r';
listt = 'list_t';


%% Main
events = dir(fullfile(evdir,evid));
nevent = length(events);
fid = fopen(evlist,'w');
for i = 1:nevent
    if strcmp(events(i).name,'.') || strcmp(events(i).name,'..')
        continue;
    end
    fprintf(fid,'%s\n',fullfile(evdir,events(i).name));
        
    if exist('saczid','var')
        sacz = dir(fullfile(evdir,events(i).name,saczid));
        nsacz = length(sacz);
        if nsacz >= 1
            fidz = fopen(fullfile(evdir,events(i).name,listz),'w');
            for j = 1:nsacz
                fprintf(fidz,'%s\n',sacz(j).name);
            end
            fclose(fidz);
        end
    end
    
    if exist('sacrid','var')
        sacr = dir(fullfile(evdir,events(i).name,sacrid));
        nsacr = length(sacr);
        if nsacr >= 1
            fidr = fopen(fullfile(evdir,events(i).name,listr),'w');
            for j = 1:nsacr
                fprintf(fidr,'%s\n',sacr(j).name);
            end
            fclose(fidr);
        end
    end
    
     if exist('sactid','var')
        sact = dir(fullfile(evdir,events(i).name,sactid));
        nsact = length(sact);
        if nsact >= 1
            fidt = fopen(fullfile(evdir,events(i).name,listt),'w');
            for j = 1:nsact
                fprintf(fidt,'%s\n',sact(j).name);
            end
            fclose(fidt);
        end
     end
    
end

fclose(fid);
fprintf('Event list generated!\n');


end
