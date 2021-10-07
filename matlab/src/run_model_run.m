%%
eval(['model_' objFunParam.modelDate '_structure()']);
ln4.output();
prediction_traces = {an1.output, ln2.output, ln5.output, ln3.output, ln4.output};
prediction_tuning = [nansum(an1.output); nansum(ln2.output); nansum(limit(ln5.output, 0, inf)); nansum(ln3.output); nansum(ln4.output)]';

prediction_tuning = prediction_tuning./objFunParam.cper;
try
   response_traces = output_traces;
   response_tuning = allY;
catch ME
%    disp(ME.getReport())
end