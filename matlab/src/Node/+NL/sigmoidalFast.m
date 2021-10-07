function x = sigmoidalFast(x,c) 
% Sigmoidal: y = c(4) + c(3)./(1 + abs( -c(1)*(x - c(2))))
% Elliot's fast approx. to the Boltzmann
%
% inputs:
%  if numel(c)==4 - x can be any size
%  otherwise, c should be 4 x N and x should by NumberOfSamples x N (one set of parameters
%  c(i, 1:4) per column in x (x(:,i)))

%%

if numel(c)==4% single parameter set
   x = c(1).*(x - c(2));
   x = c(4) + c(3).*x./(1 + abs( x ));
else
   x = bsxfun(@minus, x, c(2,:));
   x = bsxfun(@times, x, c(1,:));
   x = bsxfun(@times, x./(1 + abs(x)), c(3,:) );
   x = bsxfun(@plus,  x, c(4,:) );
end
x = x.*0.5+0.5;
