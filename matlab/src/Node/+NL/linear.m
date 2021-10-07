function x = linear(x, varargin)
% linear:y = c(1)*x + c(2);
% y = linear(x, [c(1)=1, c(2)=0]);
if nargin==1
   c = [1 0];
else
   c = varargin{1};
end
x = c(1).*x + c(2);