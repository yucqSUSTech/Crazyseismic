function [ varargout ] = find_event_list_phase( varargin )
%FIND_EVENT_LIST_PHASE Summary of this function goes here
%   Detailed explanation goes here

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
        if exist(events{ind},'dir')
            if ~exist(fullfile(events{ind},phasefile),'file')
                if exist(fullfile(events{ind},listname),'file')
                    fid = fopen(fullfile(events{ind},listname),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists = C{1}; fclose(fid);
                    if ~isempty(lists)
                        varargout{1} = ind;
                        varargout{2} = 1;
                        return;
                    end
                end
            else
                fid = fopen(fullfile(events{ind},phasefile),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists = C{1}; fclose(fid);
                if ~isempty(lists)
                    varargout{1} = ind;
                    varargout{2} = 2;
                    return;
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
            if ~exist(fullfile(events{ind},phasefile),'file')
                if exist(fullfile(events{ind},listname),'file')
                    fid = fopen(fullfile(events{ind},listname),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists = C{1}; fclose(fid);
                    if ~isempty(lists)
                        varargout{1} = ind;
                        varargout{2} = 1;
                        return;
                    end
                end
            else
                fid = fopen(fullfile(events{ind},phasefile),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists = C{1}; fclose(fid);
                if ~isempty(lists)
                    varargout{1} = ind;
                    varargout{2} = 2;
                    return;
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
        if ~exist(fullfile(events{ind},phasefile),'file')
            if exist(fullfile(events{ind},listname),'file')
                fid = fopen(fullfile(events{ind},listname),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists = C{1}; fclose(fid);
                if ~isempty(lists)
                    varargout{1} = ind;
                    varargout{2} = 1;
                    return;
                end
            end
        else
            fid = fopen(fullfile(events{ind},phasefile),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists = C{1};  fclose(fid);
            if ~isempty(lists)
                varargout{1} = ind;
                varargout{2} = 2;
                return;
            end
        end
    end
else
    fprintf('Search type must be: forward, backward, or exact\n');
end



end

