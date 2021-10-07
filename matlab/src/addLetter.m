function addLetter(h, label)
%addLetter(h, label)
%   puts 'label' onto the upper left corner of axis 'h')
%
if nargin==1
   label = h;
   h = gca;
end

a = get(get(h,'YLabel'),'Position');
b = get(get(h,'Title'),'Position');
text(a(1), b(2),label, ...
   'VerticalAlignment','bottom',...
   'HorizontalAlignment','right',...
   'FontSize',14,...
   'FontWeight','bold');