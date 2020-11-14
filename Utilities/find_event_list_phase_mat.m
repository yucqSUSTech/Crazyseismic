function [ varargout ] = find_event_list_phase_mat( varargin )
%FIND_EVENT_LIST_PHASE Summary of this function goes here
%   Detailed explanation goes here

% for matlab format data

% find the event location
% example:
% find the index of nearest existed event with non-empty file list
% ind = find_event_list_phase( ievent, events,listname, phasefile, 'backward')
% ievent: the index of the reference event;
% events: a cell contains the path of all events
% listname: file list
% phasefile: phase file 
% (if phasefile not exist, read listname, else phasefile)
% backward: backward search; three options: 'forward','backward','exact'; default is 'exact'



varargout = {[],[]};
if nargin < 3
    fprintf('Number of input arguments less than 3!\n')
    return;
elseif nargin == 3
    ievent = varargin{1};
    events = varargin{2};
    listname = varargin{3};
    phasefile = [];
    search_type = 'exact';
elseif nargin == 4
    ievent = varargin{1};
    events = varargin{2};
    listname = varargin{3};
    phasefile = varargin{4};
    if strcmpi(phasefile,'forward') || strcmpi(phasefile,'backward') || strcmpi(phasefile,'exact')
        search_type = phasefile;
        phasefile = [];
    else
        search_type = 'exact';
    end
else
    ievent = varargin{1};
    events = varargin{2};
    listname = varargin{3};
    phasefile = varargin{4};
    search_type = varargin{5};
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
        [eventpath,bb,cc] = fileparts(events{ind});
        listname_full = [bb,'_',listname];
        phasefile_full = [bb,'_',phasefile];
        if exist(eventpath,'dir')
            if exist(fullfile(eventpath,listname_full),'file')
                if ~exist(fullfile(eventpath,phasefile_full),'file')
                    fid = fopen(fullfile(eventpath,listname_full),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists = C{1}; fclose(fid);
                    if ~isempty(lists)
                        varargout{1} = ind;
                        varargout{2} = 1;
                        return;
                    end
                else
                    fid = fopen(fullfile(eventpath,phasefile_full),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists = C{1}; fclose(fid);
                    if ~isempty(lists)
                        varargout{1} = ind;
                        varargout{2} = 2;
                        return;
                    end
                end                
            end
        end
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
        [eventpath,bb,cc] = fileparts(events{ind});
        listname_full = [bb,'_',listname];
        phasefile_full = [bb,'_',phasefile];
        if exist(eventpath,'dir')
            if exist(fullfile(eventpath,listname_full),'file')
                if ~exist(fullfile(eventpath,phasefile_full),'file')
                    fid = fopen(fullfile(eventpath,listname_full),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists = C{1}; fclose(fid);
                    if ~isempty(lists)
                        varargout{1} = ind;
                        varargout{2} = 1;
                        return;
                    end
                else
                    fid = fopen(fullfile(eventpath,phasefile_full),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists = C{1}; fclose(fid);
                    if ~isempty(lists)
                        varargout{1} = ind;
                        varargout{2} = 2;
                        return;
                    end
                end
            end
        end
        ind = ind - 1;
    end
%     if ind > nevent
%         fprintf('No previous event found!\n');
%     end
elseif strcmpi(search_type,'exact') % exact the specified event
    [eventpath,bb,cc] = fileparts(events{ind});
    listname_full = [bb,'_',listname];
    phasefile_full = [bb,'_',phasefile];
    if exist(eventpath,'dir')
        if exist(fullfile(eventpath,listname_full),'file')
            if ~exist(fullfile(eventpath,phasefile_full),'file')
                fid = fopen(fullfile(eventpath,listname_full),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists = C{1}; fclose(fid);
                if ~isempty(lists)
                    varargout{1} = ind;
                    varargout{2} = 1;
                    return;
                end
            else
                fid = fopen(fullfile(eventpath,phasefile_full),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists = C{1}; fclose(fid);
                if ~isempty(lists)
                    varargout{1} = ind;
                    varargout{2} = 2;
                    return;
                end
            end
        end
    end
else
    fprintf('Search type must be: forward, backward, or exact\n');
end



end

