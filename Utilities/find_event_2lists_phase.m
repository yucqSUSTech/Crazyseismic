function [ varargout ] = find_event_2lists_phase( varargin )
%FIND_EVENT_LIST_PHASE Summary of this function goes here
%   Detailed explanation goes here

% find the event location
% example:
% find the index of nearest existed event with non-empty file list
% ind = find_event_list_phase( ievent, events,listz, listr, phasefilez, phasefiler, 'backward')
% ievent: the index of the reference event;
% events: a cell contains the path of all events
% listname: file list
% phasefile: phase file 
% (if phasefile not exist, read listname, else phasefile)
% backward: backward search; three options: 'forward','backward','exact'; default is 'exact'



varargout = {[],[],[]};
if nargin < 4
    fprintf('Number of input arguments less than 3!\n')
    return;
elseif nargin == 4
    ievent = varargin{1};
    events = varargin{2};
    listz = varargin{3};
    listr = varargin{4};
    phasefilez = [];
    phasefiler = [];
    search_type = 'exact';
elseif nargin == 5
    ievent = varargin{1};
    events = varargin{2};
    listz = varargin{3};
    listr = varargin{4}; 
    phasefilez = [];
    phasefiler = [];
    search_type = varargin{5};  
elseif nargin == 6
    ievent = varargin{1};
    events = varargin{2};
    listz = varargin{3};
    listr = varargin{4};
    phasefilez = varargin{5};
    phasefiler = varargin{6};
    search_type = 'exact';
else
    ievent = varargin{1};
    events = varargin{2};
    listz = varargin{3};
    listr = varargin{4};
    phasefilez = varargin{5};
    phasefiler = varargin{6};
    search_type = varargin{7};
end

if ~isnumeric(ievent)
    fprintf('First parameter should be a number\n');
    return;
end

nevent = length(events);
% if ievent out of bound
if  ievent > nevent || ievent < 1
    fprintf('Event index exceeds the total event number!\n');
    return;
end

ind = ievent;
if strcmpi(search_type,'forward') % forward search
    if ievent == nevent
        fprintf('This is the last event!\n');
    end

    while ind <= nevent
        if exist(events{ind},'dir')
            if exist(fullfile(events{ind},listz),'file') && exist(fullfile(events{ind},listr),'file')
                if ~exist(fullfile(events{ind},phasefilez),'file') && ~exist(fullfile(events{ind},phasefiler),'file')
                    fid = fopen(fullfile(events{ind},listz),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_z = C{1};fclose(fid);
                    fid = fopen(fullfile(events{ind},listr),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_r = C{1};fclose(fid);
                    if ~isempty(lists_z) && ~isempty(lists_r)
                        varargout{1} = ind;
                        varargout{2} = 1;
                        varargout{3} = 1;
                        return;
                    end
                elseif exist(fullfile(events{ind},phasefilez),'file') && ~exist(fullfile(events{ind},phasefiler),'file')
                    fid = fopen(fullfile(events{ind},phasefilez),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_z = C{1};fclose(fid);
                    fid = fopen(fullfile(events{ind},listr),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_r = C{1};fclose(fid);
                    if ~isempty(lists_z) && ~isempty(lists_r)
                        varargout{1} = ind;
                        varargout{2} = 2;
                        varargout{3} = 1;
                        return;
                    end
                elseif ~exist(fullfile(events{ind},phasefilez),'file') && exist(fullfile(events{ind},phasefiler),'file')
                    fid = fopen(fullfile(events{ind},listz),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_z = C{1};fclose(fid);
                    fid = fopen(fullfile(events{ind},phasefiler),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_r = C{1};fclose(fid);
                    if ~isempty(lists_z) && ~isempty(lists_r)
                        varargout{1} = ind;
                        varargout{2} = 1;
                        varargout{3} = 2;
                        return;
                    end
                else
                    fid = fopen(fullfile(events{ind},phasefilez),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_z = C{1};fclose(fid);
                    fid = fopen(fullfile(events{ind},phasefiler),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_r = C{1};fclose(fid);
                    if ~isempty(lists_z) && ~isempty(lists_r)
                        varargout{1} = ind;
                        varargout{2} = 2;
                        varargout{3} = 2;
                        return;
                    end
                end                
            end
        end
%         fprintf('No data found in %s. Go to next event!\n',events{ind});
        ind = ind + 1;
    end
%     if ind > nevent
%         fprintf('No next event found!\n');
%     end
elseif strcmpi(search_type,'backward') % backward search
    if ievent == 1
        fprintf('This is the first event!\n');
    end
    while ind >= 1
        if exist(events{ind},'dir')
            if exist(fullfile(events{ind},listz),'file') && exist(fullfile(events{ind},listr),'file')
                if ~exist(fullfile(events{ind},phasefilez),'file') && ~exist(fullfile(events{ind},phasefiler),'file')
                    fid = fopen(fullfile(events{ind},listz),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_z = C{1};fclose(fid);
                    fid = fopen(fullfile(events{ind},listr),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_r = C{1};fclose(fid);
                    if ~isempty(lists_z) && ~isempty(lists_r)
                        varargout{1} = ind;
                        varargout{2} = 1;
                        varargout{3} = 1;
                        return;
                    end
                elseif exist(fullfile(events{ind},phasefilez),'file') && ~exist(fullfile(events{ind},phasefiler),'file')
                    fid = fopen(fullfile(events{ind},phasefilez),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_z = C{1};fclose(fid);
                    fid = fopen(fullfile(events{ind},listr),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_r = C{1};fclose(fid);
                    if ~isempty(lists_z) && ~isempty(lists_r)
                        varargout{1} = ind;
                        varargout{2} = 2;
                        varargout{3} = 1;
                        return;
                    end
                elseif ~exist(fullfile(events{ind},phasefilez),'file') && exist(fullfile(events{ind},phasefiler),'file')
                    fid = fopen(fullfile(events{ind},listz),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_z = C{1};fclose(fid);
                    fid = fopen(fullfile(events{ind},phasefiler),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_r = C{1};fclose(fid);
                    if ~isempty(lists_z) && ~isempty(lists_r)
                        varargout{1} = ind;
                        varargout{2} = 1;
                        varargout{3} = 2;
                        return;
                    end
                else
                    fid = fopen(fullfile(events{ind},phasefilez),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_z = C{1};fclose(fid);
                    fid = fopen(fullfile(events{ind},phasefiler),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_r = C{1};fclose(fid);
                    if ~isempty(lists_z) && ~isempty(lists_r)
                        varargout{1} = ind;
                        varargout{2} = 2;
                        varargout{3} = 2;
                        return;
                    end
                end                
            end
        end      
%         fprintf('No data found in %s. Go to previous event!\n',events{ind});
        ind = ind - 1;
    end
%     if ind > nevent
%         fprintf('No previous event found!\n');
%     end
elseif strcmpi(search_type,'exact') % exact the specified event
    if exist(events{ind},'dir')
        if exist(fullfile(events{ind},listz),'file') && exist(fullfile(events{ind},listr),'file')
            if ~exist(fullfile(events{ind},phasefilez),'file') && ~exist(fullfile(events{ind},phasefiler),'file')
                fid = fopen(fullfile(events{ind},listz),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_z = C{1};fclose(fid);
                fid = fopen(fullfile(events{ind},listr),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_r = C{1};fclose(fid);
                if ~isempty(lists_z) && ~isempty(lists_r)
                    varargout{1} = ind;
                    varargout{2} = 1;
                    varargout{3} = 1;
                    return;
                end
            elseif exist(fullfile(events{ind},phasefilez),'file') && ~exist(fullfile(events{ind},phasefiler),'file')
                fid = fopen(fullfile(events{ind},phasefilez),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_z = C{1};fclose(fid);
                fid = fopen(fullfile(events{ind},listr),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_r = C{1};fclose(fid);
                if ~isempty(lists_z) && ~isempty(lists_r)
                    varargout{1} = ind;
                    varargout{2} = 2;
                    varargout{3} = 1;
                    return;
                end
            elseif ~exist(fullfile(events{ind},phasefilez),'file') && exist(fullfile(events{ind},phasefiler),'file')
                fid = fopen(fullfile(events{ind},listz),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_z = C{1};fclose(fid);
                fid = fopen(fullfile(events{ind},phasefiler),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_r = C{1};fclose(fid);
                if ~isempty(lists_z) && ~isempty(lists_r)
                    varargout{1} = ind;
                    varargout{2} = 1;
                    varargout{3} = 2;
                    return;
                end
            else
                fid = fopen(fullfile(events{ind},phasefilez),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_z = C{1};fclose(fid);
                fid = fopen(fullfile(events{ind},phasefiler),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists_r = C{1};fclose(fid);
                if ~isempty(lists_z) && ~isempty(lists_r)
                    varargout{1} = ind;
                    varargout{2} = 2;
                    varargout{3} = 2;
                    return;
                end
            end
        end
    end
else
    fprintf('Search type must be: forward, backward, or exact\n');
end



end

