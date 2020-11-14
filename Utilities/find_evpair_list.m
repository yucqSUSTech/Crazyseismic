function [ varargout ] = find_evpair_list( varargin )

% find the event pair location
% example:
% ind = find_evpair_list( ievent, events, 'backward')
% ievent: the index of the reference event pair;
% events: a cell contains the path of all event pairs
% backward: backward search; three options: 'forward','backward','exact'; default is 'exact'

varargout = {[]};
if nargin < 2
    fprintf('Number of input arguments less than 2!\n')
    return;
elseif nargin == 2
    ievent = varargin{1};
    events = varargin{2};
    search_type = 'exact';
else
    ievent = varargin{1};
    events = varargin{2};
    search_type = varargin{3};    
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
        if exist(events{ind},'file') 
            [ ev, st ] = y_rdfile_evpair( events{ind} );
            if length(find(strcmpi({st.isgood},'y'))) >= 1
                varargout{1} = ind;
                return;
            end
        end
        ind = ind + 1;
    end

elseif strcmpi(search_type,'backward') % backward search
    if ievent == 1
        fprintf('This is the first event!\n');
    end
    while ind >= 1
      if exist(events{ind},'file')
          [ ev, st ] = y_rdfile_evpair( events{ind} );
          if length(find(strcmpi({st.isgood},'y'))) >= 1
              varargout{1} = ind;
              return;
          end
      end
      ind = ind - 1;
    end
elseif strcmpi(search_type,'exact') % exact the specified event
    if exist(events{ind},'file')
        [ ev, st ] = y_rdfile_evpair( events{ind} );
        if length(find(strcmpi({st.isgood},'y'))) >= 1
            varargout{1} = ind;
            return;
        end
    end
else
    fprintf('Search type must be: forward, backward, or exact\n');
end

end

