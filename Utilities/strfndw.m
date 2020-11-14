function [idx] = strfndw(array, expStr)
%% STRFNDW
%   Wild card selection from cell array of strings. It allows the use of 
%   wildcards '*' and '?' and returns only the matching element indexes of the cell 
%   array.
%
%   The '*' wildcard stands for any number (including zero) of characters.
%   The '?' wildcard stands for a single character.
%
%   Usage:
%       IDX = STRCMPW(ARRAY, EXPSTR) returns the index array, IDX,
%       containing the index number to the elements of ARRAY satisfying the
%       search criteria in EXPSTR
%
%   Example:
%       A = {'Hello world!'; 'Goodbye world!'; 'Goodbye everyone'};
%       idx = strcmpw(A, '*world!');
%
%    ans = [1;2]
%
%   Adapted for command line use from the WILDSEL GUI developed by
%   Richard Stephens (ristephens@theiet.org) v1.2 2007/03/01
%
% Revision History
%   1.00.[EO]2009.06.24 Converted to non-gui function from WILDSEL

regStr = ['^',strrep(strrep(expStr,'?','.'),'*','.{0,}'),'$'];
starts = regexpi(array, regStr);
iMatch = ~cellfun(@isempty, starts);
idx = find(iMatch);

