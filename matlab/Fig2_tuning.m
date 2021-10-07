addpath(genpath('src'))
addpath(genpath('model'))
cc()
objFunParam.modelDate = '20210125_DN_gauss';
disp('running model')
run_model()
%%
data2 = load('dat/compareTuning.mat');
uniCellTypes = {'AN1','LN2','LN5', 'LN3','LN4'};
disp(uniCellTypes)

load('dat/tuningCurveData.mat', 'data', 'files')
%%
fieldNames = fieldnames( data{1}.tuneX );
typLabel = {{'duty cycle' '@PPER=35ms'}, {'pause [ms]' '@PDUR=16ms'}, {'period  [ms]' '@PDC=0.46'}, {'duration [ms]' '@PPAU=16ms'}, {'number of pulses' '@PPER=35ms' }};
letters = {'A','B','C','D','E'};
%%
typCuts = cumsum([0 9 12 13]);

clf
for cel = 1:length(uniCellTypes)
   thisCellIdx = find(contains(files, uniCellTypes{cel}));
   disp(files(thisCellIdx))
   cols = lines(length(thisCellIdx));

   for typ = 1:3
      for idx = 1:length(thisCellIdx)
         % get global norm constant
         c = struct2cell(data{thisCellIdx(idx)}.tuneY);
         cellMax = nanmax(vertcat(c{:}));

         mySubPlot(length(uniCellTypes), 3, cel, typ)
         hold on;
         X = data{thisCellIdx(idx)}.tuneX.(fieldNames{typ});
         Y = data{thisCellIdx(idx)}.tuneY.(fieldNames{typ})/cellMax;
         plot(X, Y, '-', 'Color', 'r', 'LineWidth', 0.75)
         if typ==1
            ylabel({uniCellTypes{cel} 'r/r_{max}'})
         end
         if cel == length(uniCellTypes)
            xlabel(typLabel{typ})
         else
            set(gca, 'XColor', 'none')
         end
      end
      if cel==1
         addLetter( letters{typ} )
      end
      try
         % now add the model predictions
         Yallpred = normalizeMax(prediction_tuning(:,cel));
         Yallresp = normalizeMax(response_tuning(:,cel));
         idx = typCuts(typ)+1:typCuts(typ+1);
         X = data2.X{cel,typ}';

         mySubPlot(length(uniCellTypes), 3, cel, typ)
         hold on
         plot(X, Yallpred(idx)','-k', 'LineWidth', 2);
         plot(X, Yallresp(idx)','or', 'LineWidth', 2);

      catch ME
         disp(ME.getReport())
      end
   end
end

set(gcas, 'YLim', [0 1], 'YTick', 0:1)
clp()

