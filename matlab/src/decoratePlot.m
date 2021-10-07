function decoratePlot(pper)
if ~exist('pper','var')
   pper = 32;
end
dline(), vline(pper/2), hline(pper/2), hold on, plot([1 pper], [pper 1], 'k')
