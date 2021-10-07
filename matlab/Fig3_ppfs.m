addpath(genpath('src'))
cc()
addpath(genpath('model'))
cellNames = {'AN1', 'LN2', 'LN5', 'LN3', 'LN4'}';
%% make PPF stims
[input, s, ppau, pdur, allStim, paramPau, paramDur] = makePPFstim2('ppauMax', 80,'cdur', 140, 'cpau', 200);

allLen = cellfun(@length, allStim);
inputStim = nan(ceil(max(allLen))+1, length(allLen));
for sti = 1:length(allLen)
   tmp = allStim{sti}(50:end);
   inputStim(1:length(tmp),sti) = tmp;
end

objFunParam.modelDate = '20210125_DN_gauss';
objFunParam.cper = s.cper;

eval(['model_' objFunParam.modelDate '_parameters()']);
run_model_run()
%%
% prediction = prediction_tuning;
cels = size(prediction_tuning, 2);
clf
colormap(parula)
for cel = 1:cels
   mySubPlot(1, cels, 1, cel)
   plotPPF([s.pdur, s.ppau], prediction_tuning(:,cel));

   dline()
   set(hline(15), 'LineStyle', '--')
   vline(15)
   hold on
   plot([0 30], [30 0], 'k')
   title(cellNames{cel})
   if cel==1
      xlabel('pulse duration [ms]')
      ylabel('pulse pause [ms]')
   end
end

axis(gcas, 'square', 'xy')
set(gcas, 'XLim', [0 80], 'XTick', 0:20:80,...
          'YLim', [0 80], 'YTick', 0:20:80)

clp()
