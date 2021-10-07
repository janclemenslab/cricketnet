% objFunParam.MODE = 4;

if ~exist('objFunParam', 'var')
%    objFunParam.modelDate = '20210125_DN_gauss';%_LN2sq';
   objFunParam.modelDate = '20180806';%_LN2sq';
end
isPPF = 0;
% stimArgs = {'cdur', 600};
% model_20171013_setup()
load('dat/compareTuning.mat')

for cel = 1:5
   allX(:,cel) = vertcat(X{cel,:});
   allY(:,cel) = vertcat(Y{cel,:});
   allS(:,cel) = vertcat(S(cel,:));
   allCPER(:,cel) =[CPER{cel,:}];
end
allY = bsxfun(@times, normalizeMax(allY')', [3, 3, 6, 70, 0.4]);
allS = [allS{:,1}];
% assemble traces
output_traces_tmp = [];
for cel = 1:5
   cnt = 0;
   for typ = 1:4
      for sti = 1:length(PSTH{cel,typ})
         cnt = cnt+1;
         if cel==3
            tmp = mean(VOLT{cel,typ}{sti},2);
         else
            tmp = smoothdata(mean(PSTH{cel,typ}{sti},2), 'movmean', 100);
         end
         tmp = resample(tmp, 10, 200);
         output_traces_tmp(1:length(tmp), cnt,cel) = tmp;
      end
   end
end
%%
Fs = 20000/1000;
allLen = cellfun(@length, allS);
inputStim = nan(ceil(max(allLen)/Fs)+2, length(allLen));
output_traces = nan(ceil(max(allLen)/Fs)+2, length(allLen),5);
for sti = 1:length(allLen)
   tmp = allS{sti}(1:Fs:end);
   onsets = find(diff(tmp)==1);
   offsets = find(diff(tmp)==-1);
   pulseDuration = median(offsets - onsets);
   newStim = zeros(size(tmp));
   for onset = 1:length(onsets)
      newStim(onsets(onset)+(1:pulseDuration)) = 1;
   end
   inputStim(1:length(newStim),sti) = newStim;
   
   output_traces(1:length(newStim),sti,:) = output_traces_tmp(1:length(newStim),sti,:);
end
%% last stimulus is the only pdur stim - does not belong - remove
allCPER(end,:) = [];
allS(end) = [];
allX(end,:) = [];
allY(end,:) = [];
inputStim(:,end) = [];
output_traces(:,end,:) = [];

%%
objFunParam.inputStim = inputStim; % this maybe
objFunParam.inputParam = allX;
objFunParam.output = allY;
objFunParam.output_traces = output_traces;
objFunParam.cper = allCPER(:,cel);  % this scales the output - needed to properly normalize predictions
% %% load ALL parameters
eval(['model_' objFunParam.modelDate '_parameters()']);
% addpath(genpath('res.param'));
% for cel = 1:4
%    disp(['loading res.param/' cellNames{cel} '.m']);
%    eval([cellNames{cel} '_parameters']);
% end
% p.ln2_nonlinearity_gain = p.ln2_nonlinearity_gain*1.29;
% p.ln2_ln5_gain = p.ln2_ln5_gain/1.29;
% p.ln2_ln4_gain = p.ln2_ln4_gain/1.29;
% p.an1_ln3_gain = p.an1_ln3_gain/1.29;
% p.ln5_nonlinearity_gain = p.ln5_nonlinearity_gain*0.26;
% p.ln5_ln3_gain = p.ln5_ln3_gain/0.26; 
% p.ln3_nonlinearity_gain = p.ln3_nonlinearity_gain* 5;
% p.ln3_ln4_gain= p.ln3_ln4_gain / 5;
% p.ln4_nonlinearity_gain = p.ln4_nonlinearity_gain* 2.3089e-08;
