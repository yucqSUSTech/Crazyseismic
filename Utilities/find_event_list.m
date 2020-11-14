function [ varargout ] = find_event_list( varargin )
%FIND_EVENT_LIST_PHASE Summary of this function goes here
%   Detailed explanation goes here

% find the event location
% example:
% find the index of nearest existed event with non-empty file list
% ind = find_event_list( ievent, events,listname, 'backward')
% ievent: the index of the reference event;
% events: a cell contains the path of all events
% listname: file list
% backward: backward search; three options: 'forward','backward','exact'; default is 'exact'

varargout = {[]};
if nargin < 2
    fprintf('Number of input arguments less than 3!\n')
    return;
elseif nargin == 3
    ievent = varargin{1};
    events = varargin{2};
    listname = varargin{3};
    search_type = 'exact';
else
    ievent = varargin{1};
    events = varargin{2};
    listname = varargin{3};
    search_type = varargin{4};    
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
            if exist(fullfile(events{ind},listname),'file')   
                fid = fopen(fullfile(events{ind},listname),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists = C{1}; fclose(fid);     
                if ~isempty(lists)
                    varargout{1} = ind;
                    return;
                end
            end
        end
        ind = ind + 1;
    end

elseif strcmpi(search_type,'backward') % backward search
    if ievent == 1
        fprintf('This is the first event!\n');
    end
    while ind >= 1
      if exist(events{ind},'dir')
            if exist(fullfile(events{ind},listname),'file')
                fid = fopen(fullfile(events{ind},listname),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists = C{1}; fclose(fid); 
                if ~isempty(lists)
                    varargout{1} = ind;
                    varargout{2} = 2;
                    return;
                end              
            end
      end
      ind = ind - 1;
    end
elseif strcmpi(search_type,'exact') % exact the specified event
    if exist(events{ind},'dir')
        if exist(fullfile(events{ind},listname),'file')
            fid = fopen(fullfile(events{ind},listname),'r'); C = textscan(fid,'%s %*[^\n]','CommentStyle','#'); lists = C{1}; fclose(fid);
            if ~isempty(lists)
                varargout{1} = ind;
                return;
            end
        end
    end
else
    fprintf('Search type must be: forward, backward, or exact\n');
end

end

