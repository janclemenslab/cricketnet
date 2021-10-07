addpath(genpath('src'))
cc()
objFunParam.modelDate = '20210125_DN_gauss';
run_model()
data = load('dat/compareTuning.mat');

%%
ymax =  [25 19 135 28 22];

cels = size(response_traces, 3);
stimSets = {[22:25 27:31], 10:21, 1:9};
stimSetNames = {'pper', 'ppau','pdc'};

for stiset = 1:length(stimSets)
   stiAll = stimSets{stiset};
   figure('NumberTitle', 'off', 'Name', stimSetNames{stiset})
   clf
   for sti = 1:length(stiAll)
      T = (1:350) + 1.2*(sti-1)*350;
      subplot(cels+1, 1, 1)
      hold on
      area(T, inputStim(1:350, stiAll(sti)), 'FaceColor', 'k')
      axis('tight')
      set(gca, 'YLim', [0 3])
      scalebar(100, 2, 100, '100 ms', 10)
      for cel = 1:cels
         pred = prediction_traces{cel}(1:350, stiAll(sti));
         resp = response_traces(1:350, stiAll(sti), cel);
         
         subplot(cels+1, 1, cel+1)
         hold on
         plot(T, pred,'k');
         plot(T, resp,'r');
         axis('tight')
         set(gca, 'YLim', [min(min(response_traces(1:350, stiAll, cel))) ymax(cel)])
         set(gca, 'YTick', [0 1 10 100])

      end
   end
   set(gcas, 'XColor', 'none')
   clp()
   set(gcls, 'LineWidth',1)
end
