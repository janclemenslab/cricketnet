cc()
addpath(genpath('src'))
objFunParam.modelDate = '20210125_DN_gauss';
disp('running model')
run_model()
%%
data2 = load('dat/compareTuning.mat');
load('dat/Kostas_all')
cellTypes = {p.cellType};
%
uniCellTypes = unique(cellTypes);
order = [1 3 6 2 4 5 ];[2 5 3 1 4];
uniCellTypes = uniCellTypes(order);
uniCellTypes = {'AN1','LN2','LN5','LN3 (BLC3)','LN4'}
disp(uniCellTypes)
%%

Fs = 20000;
ds = matFileDataStore('dat/tuning/*.mat');
data_full = ds.readall();
%%
data = {};
for ii = 1:length(data_full)
   try
      data{ii}.tuneX = data_full{ii}.tuneX; 
      data{ii}.tuneY = data_full{ii}.tuneY; 
      data{ii}.file = ds.Files{ii}; 
   catch
      data{ii}.tuneX = 0; 
      data{ii}.tuneY = 0;
      data{ii}.file = ds.Files{ii}; 
   end
end
files = ds.Files;
save('dat/tuningCurveData.mat', 'data', 'files')
% load('dat/tuningCurveData.mat', 'data', 'files')
%%
fieldNames = fieldnames( data{1}.tuneX );
typLabel = {{'duty cycle' '@PPER=35ms'}, {'pause [ms]' '@PDUR=16ms'}, {'period  [ms]' '@PDC=0.46'}, {'duration [ms]' '@PPAU=16ms'}, {'number of pulses' '@PPER=35ms' }};
letters = {'A','B','C','D','E'};
%%
typCuts = cumsum([0 9 12 13]);
modelCell = [1 2 3 4 4 5];
tb = [];

clf
for cel = 1:length(uniCellTypes)
%    thisCellIdx = find(uniCellTypeIdx==cel);
   thisCellIdx = find(contains(ds.Files, uniCellTypes{cel}));
   disp(ds.Files(thisCellIdx))
   cols = lines(length(thisCellIdx));
      
   for typ = 1:3%length(fieldNames)
      for idx = 1:length(thisCellIdx)
         % get global norm constant
         c = struct2cell(data{thisCellIdx(idx)}.tuneY);
         cellMax = nanmax(vertcat(c{:}));
         
         mySubPlot(length(uniCellTypes), 3, cel, typ)
         hold on;
         X = data{thisCellIdx(idx)}.tuneX.(fieldNames{typ});
         Y = data{thisCellIdx(idx)}.tuneY.(fieldNames{typ})/cellMax;
%          plot(X, Y, '-', 'Color', cols(idx,:), 'LineWidth', 0.75)
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
         Yallpred = normalizeMax(prediction_tuning(:,modelCell(cel)));
         Yall = normalizeMax(response_tuning(:,modelCell(cel)));
         idx = typCuts(typ)+1:typCuts(typ+1);
         X = data2.X{modelCell(cel),typ}';
         mySubPlot(length(uniCellTypes), 3, cel, typ)
         hold on
         plot(X, Yallpred(idx)','-k', 'LineWidth', 2);
         plot(X, Yall(idx)','or', 'LineWidth', 2);

      catch ME
         disp(ME.getReport())
      end
   end
end

set(gcas, 'YLim', [0 1], 'YTick', 0:1)
clp()

