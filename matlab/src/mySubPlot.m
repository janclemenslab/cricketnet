function varargout = mySubPlot(X,Y,x,y)
%modified subplot
%USAGE:
%  h = mySubPlot(X,Y,x,y)
%  h = mySubPlot(XYn)   % builtin
%  h = mySubPlot(X,Y,n) % builtin
%
%ARGS:
%  X - number of columns
%  Y - number of rows
%  x - current column
%  y - current row
%  n - subplot
%RETURNS
%  h - handle to the axis created

%created 07/08/08 Jan
%modified 17/10/13 Jan - also callable like the builtin subplot

if nargin==1   
   h = subplot(X);
elseif nargin==3
   h = subplot(X,Y,x);
elseif nargin==4
   h = subplot(X, Y, (x-1)*Y + y);
else
   error('wrong number of arguments %d - needs to be 1, 3 or 4', nargin);
end
if nargout>0
    varargout{1} = h;
end
