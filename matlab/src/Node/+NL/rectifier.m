function x = rectifier(x, varargin)
% threshold at 0: y = limit(x+c(1), c(1)=0, c(2)=inf);
if nargin==1
   c = [0 inf];
else
   c = varargin{1};
end
x = limit(x, c(1), c(2));
