% AN1
subplot(1,5,1)
imagesc(ppau, pdur, imgaussian(reshape(sum(an1.output,1), length(ppau), length(pdur)),2))
title('AN1')
dline(), hline(16), vline(16), axis('square') 
xlabel('PDUR')
ylabel('PPAU')
hold on, plot([0, 32], [32 0], 'k')

% LN2
subplot(1,5,2)
imagesc(ppau, pdur, imgaussian(reshape(sum(ln2.output,1), length(ppau), length(pdur)),2))
title('LN2')
dline(), hline(16), vline(16), axis('square') 
hold on, plot([0, 32], [32 0], 'k')

% LN5
subplot(1,5,3)
imagesc(ppau, pdur, imgaussian(reshape(sum(ln5_ln3.output, 1), length(ppau), length(pdur)),2))
title('LN5')
dline(), hline(16), vline(16), axis('square') 
hold on, plot([0, 32], [32 0], 'k')

% LN3
subplot(1,5,4)
imagesc(ppau, pdur, imgaussian(reshape(sum(ln3.output,1), length(ppau), length(pdur)),2))
title('LN3')
dline(), hline(16), vline(16), axis('square') 
hold on, plot([0, 32], [32 0], 'k')

% LN4
subplot(1,5,5)
ppp = reshape(s.ppau, length(ppau), length(pdur));
imagesc(ppau, pdur, imgaussian(reshape(sum(ln4.output,1), length(ppau), length(pdur)),2))
title('LN4')
dline(), hline(16), vline(16), axis('square') 
hold on, plot([0, 32], [32 0], 'k')
hold on, plot([0, 64], [64 0], 'k')

set(gcls, 'LineWidth', 1.0)
axis(gcas, 'tight', 'xy')
set(gcas,'box','off','color','none','TickDir','out', 'XTick', 0:20:80, 'YTick', 0:20:80)
