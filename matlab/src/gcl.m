function all_ha = gcl(varargin)
% get handles to all lines in all subplots, useful for setting the global line width
all_ha = findobj(gca, 'type', 'line', 'tag', '' );
if nargin==0
   return
elseif nargin
   all_ha = all_ha(varargin{1});
end
