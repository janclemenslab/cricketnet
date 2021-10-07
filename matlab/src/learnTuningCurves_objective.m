function [totalError, tuning, bestOutput, p, allCells] = learnTuningCurves_objective(GAparam, objFunParam)
inputStim = objFunParam.inputStim;
lastBestError = -inf;
bestOutput = [];
rescaleParam = @(x, xl, xu) (2.^x- 0.5)/1.5 * (xu-xl) + xl;

for ind = 1:size(GAparam,1)
   % load defaults
   p = objFunParam.p0;
   
   % set parameters
   for pa = 1:size(objFunParam.tb,1)
      if objFunParam.tb.parameterScales(pa) || objFunParam.tb.parameterDurations(pa) || objFunParam.tb.parameterSymm(pa)
         p.(objFunParam.tb.parameterNames{pa}) = rescaleParam(GAparam(ind,pa), objFunParam.tb.parameterLB(pa), objFunParam.tb.parameterUB(pa)); % probably wanna log dist this
      end
      if objFunParam.tb.parameterShifts(pa)
         p.(objFunParam.tb.parameterNames{pa}) = rescaleParam(GAparam(ind,pa), objFunParam.tb.parameterLB(pa), objFunParam.tb.parameterUB(pa)); % probably wanna log dist this
      end
   end
   % RUN the model
   eval(['model_' objFunParam.modelDate '_structure()'])
   
   %%
   % fix scale:
   %   if scaleInvarant==1 scale traces
   %   compute tuning curves (and corresponding error) from scaled traces
   %   compute traces error from scaled traces
   allCells = {an1, ln2, ln5, ln3, ln3_sub, ln4};
   % DO NOT USE THESE:
   output = [nansum(an1.output); nansum(ln2.output); nansum(limit(ln5.output,0,inf)); nansum(ln3.output); nansum(ln4.output)]';
   output = output./objFunParam.cper;
   % get model error
   tuning(:,:,ind) = output;
   
   %%
   if isfield(objFunParam, 'LN5_fit_pos_only') && objFunParam.LN5_fit_pos_only==1
      objFunParam.output_traces(:,:,2) = limit(objFunParam.output_traces(:,:,2), 0, inf);
      ln5_pred = limit(ln5.output,0,inf);
   else
      ln5_pred = ln5.output;
   end
   
   X = objFunParam.output_traces(:,:,objFunParam.cellsToUse);
   X = reshape(X, size(X,1), size(X,2), length(objFunParam.cellsToUse));
   Y = cat(3, ln2.output, ln5_pred, ln3.output, ln4.output);
   Y = Y(:,:,objFunParam.cellsToUse);
   Y = reshape(Y, size(Y,1), size(Y,2), length(objFunParam.cellsToUse));
%    for cel = 1:size(X,3)
%       Yscale(cel) = nanmean(nanstd(Y(:,:,cel)))*nanmean(nanstd(X(:,:,cel)));
%    end
   if isfield(objFunParam, 'scaleInvariant') && objFunParam.scaleInvariant==1
      for cel = 1:size(X,3)
         Y(:,:,cel) = Y(:,:,cel)./nanmean(nanstd(Y(:,:,cel)))*nanmean(nanstd(X(:,:,cel)));
         if all(isnan(Y(:,:,cel)))
            Y(:,:,cel) = randn(size(Y(:,:,cel)))*10000000;
         end
      end
   end
   
   if isfield(objFunParam, 'LN5_ignoreLastOffset') == 0
      for sti = 1:size(objFunParam.inputStim,2)
         lastIdx(sti) = find(objFunParam.inputStim(:,sti)'>0, 1, 'last');
         X(lastIdx(sti)+30:end,sti) = X(lastIdx(sti)+30:end,sti)/20;
         Y(lastIdx(sti)+30:end,sti) = Y(lastIdx(sti)+30:end,sti)/20;
      end
   end
   thisErrorTraces = squeeze(nanmean(nanmean((X - Y).^2, 1), 2))';
   
   %% compare tuning curves
   x = objFunParam.output(:, objFunParam.cellsToUse);
   y = output(:, objFunParam.cellsToUse);
   
   % scale invariant
   if isfield(objFunParam, 'scaleInvariant') && objFunParam.scaleInvariant==1
      y = y.*nanmean(x./y);
      if all(isnan(y))
         y = rand(size(x))*10000;
      end
   end
   % mean abs error
   thisErrorTuning = nansum(abs(x - y));
   if isfield(objFunParam, 'fitTraces')
      switch objFunParam.fitTraces
         case 0 % tuning only
            thisError = thisErrorTuning;
         case 1 % traces only
            thisError = thisErrorTraces;
         case 2 % traces and tuning
            thisError = thisErrorTuning + thisErrorTraces*objFunParam.fitTracesWeight;
      end
   end
   
   thisError = bsxfun(@times, thisError, 1./max(objFunParam.output(:, objFunParam.cellsToUse)));
   thisError = bsxfun(@times, thisError, objFunParam.cellWeight);
   totalError(ind) = 1-nanmean(thisError);
   if totalError(ind)>=lastBestError
      bestOutput = {an1.output, ln2.output, ln5.output, ln3.output, ln4.output};
      lastBestError = totalError(ind);
   end
end
%%
if objFunParam.PLOT
   best = bsxfun(@times, tuning(:,:,argmax(totalError)), 1./max(objFunParam.output));
   out = bsxfun(@times, objFunParam.output, 1./max(objFunParam.output));
   best = best(:,objFunParam.cellsToUse);
   out = out(:,objFunParam.cellsToUse);
   if isfield(objFunParam, 'scaleInvariant') && objFunParam.scaleInvariant==1
      best = best.*nanmean(out./best);
   end
   
   subplot(131)
   plot([out(:), best(:)])
%    set(gca, 'YLim', [0 max(max([out(:), best(:)]))])
   legend({'data', 'best'})
   
   subplot(2,3,2:3)
   imagesc(objFunParam.output_traces(1:500,1:end,objFunParam.MODE)')
   vline(20:35:200, 'g')
   colorbar()
   
   subplot(2,3,5:6)
   if objFunParam.MODE==3 && isfield(objFunParam, 'LN5_fit_pos_only') && objFunParam.LN5_fit_pos_only==1
      imagesc(limit(bestOutput{objFunParam.MODE}(1:500,1:end)', 0, inf))
   else
      imagesc(bestOutput{objFunParam.MODE}(1:500,1:end)')
   end
   vline(20:35:200,'g')
   colorbar()
   drawnow
end
