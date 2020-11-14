function jd = juliandate( varargin ) 
%  JULIANDATE Calculate Julian date.
%   JD = JULIANDATE( V ) converts one or more date vectors V into Julian date
%   JD.  Input V can be an M-by-6 or M-by-3 matrix containing M full or
%   partial date vectors, respectively.  JULIANDATE returns a column vector
%   of M Julian dates which are the number of days and fractions since noon
%   Universal Time on January 1, 4713 BCE.
%   
%   A date vector contains six elements, specifying year, month, day, hour,
%   minute, and second. A partial date vector has three elements, specifying
%   year, month, and day.  Each element of V must be a positive double
%   precision number.
%   
%   JD = JULIANDATE(S,F) converts one or more date strings S to Julian date
%   JD using format string F. S can be a character array where each
%   row corresponds to one date string, or one dimensional cell array of
%   strings.  JULIANDATE returns a column vector of M Julian dates, where M is
%   the number of strings in S.
%   
%   All of the date strings in S must have the same format F, which must be
%   composed of date format symbols according to DATESTR help. Formats with
%   'Q' are not accepted by JULIANDATE. 
%   
%   Certain formats may not contain enough information to compute a date
%   number.  In those cases, hours, minutes, and seconds default to 0, days
%   default to 1, months default to January, and years default to the
%   current year. Date strings with two character years are interpreted to
%   be within the 100 years centered around the current year.
%      
%   JD = JULIANDATE(Y,MO,D) and JD = JULIANDATE([Y,MO,D]) return the Julian
%   date for corresponding elements of the Y,MO,D (year,month,day)
%   arrays. Y, MO, and D must be arrays of the same size (or any can be a
%	scalar).
%   
%   JD = JULIANDATE(Y,MO,D,H,MI,S) and JD = JULIANDATE([Y,MO,D,H,MI,S]) 
%   return the Julian dates for corresponding elements of the Y,MO,D,H,MI,S
%   (year,month,day,hour,minute,second) arrays.  The six arguments must be
%   arrays of the same size (or any can be a scalar).
%   
%   Limitations: 
%   This function is valid for all common era (CE) dates in the Gregorian
%   calendar.
%
%   The calculation of Julian date does not take into account leap seconds.
%
%   Examples:
%
%   Calculate Julian date for May 24, 2005:
%	   jd = juliandate('24-May-2005','dd-mmm-yyyy')
%   
%   Calculate Julian date for December 19, 2006:
%	   jd = juliandate(2006,12,19)
%   
%   Calculate Julian date for October 10, 2004 at 12:21:00 pm:
%	   jd = juliandate(2004,10,10,12,21,0)
%   
%   See also DECYEAR, LEAPYEAR, MJULIANDATE.

%   Copyright 2000-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2010/03/01 05:16:23 $


[year month day hour min sec] = datevec(datenum(varargin{:}));

for k = length(month):-1:1
    if ( month(k) <= 2 ) % January & February
        year(k)  = year(k) - 1.0;
        month(k) = month(k) + 12.0;
    end
end

jd = floor( 365.25*(year + 4716.0)) + floor( 30.6001*( month + 1.0)) + 2.0 - ...
    floor( year/100.0 ) + floor( floor( year/100.0 )/4.0 ) + day - 1524.5 + ...
    (hour + min/60 + sec/3600)/24;


