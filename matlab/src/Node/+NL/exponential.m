function x = exponential(x,varargin)
% exponential: y = exp(c(1)*x) + c(2);
% x = exponential(x, [c(1)=1, c(2)=0])
if nargin==1
   c = [1 0];
else
   c = varargin{1};
end

x = exp(c(1).*x) + c(2);