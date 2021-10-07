function x = relu(x, thres)
% threshold at thres: y = limit(x, thres, inf)-thres;
if nargin==1
   thres = 0;
end
x = limit(x, thres, inf)-thres;
