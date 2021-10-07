function x = sigmoidal(x,c) 
% Sigmoidal: y = c(4) + c(3)./(1 + exp( -c(1)*(x - c(2))))
%(Boltzmann), see <a href="matlab: web('https://en.wikipedia.org/wiki/Logistic_function')">wikipedia</a>
%
% inputs:
%  if numel(c)==4 - x can be any size
%  otherwise, c should be 4 x N and x should by NumberOfSamples x N (one set of parameters
%  c(i, 1:4) per column in x (x(:,i)))

if numel(c)==4% single parameter set
   x = c(4) + c(3)./(1 + exp( -c(1).*(x - c(2))));
else
   x = bsxfun(@minus, x, c(2,:));
   x = bsxfun(@times, x, -c(1,:));
   x = bsxfun(@times, 1./(1 + exp(x)), c(3,:) );
   x = bsxfun(@plus,  x, c(4,:) );
end
