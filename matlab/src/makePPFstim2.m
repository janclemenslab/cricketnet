function [input, s, ppau, pdur, allStim, paramPau, paramDur] = makePPFstim2(varargin)
% varargin = {};
args = argparse(varargin, {'ppauMax', 'ppauMax', 80; 'pdurMax', 'pdurMax', 80; 'cdur', 'cdur', 200; 'cpau', 'cpau', 200});
Fs = 1000;
dwnSmp = 1;

ppau = [1:args.ppauMax]/dwnSmp;
pdur = [1:args.pdurMax]/dwnSmp;
cpau = args.cpau/dwnSmp;
cdur = args.cdur/dwnSmp;
input = [];
allStim = {};

cnt = 0;
for pau = 1:length(ppau)
   for dur = 1:length(pdur)
      pulse = [ones(1,pdur(dur)), zeros(1,ppau(pau))];
      paramNpul(pau, dur) = floor(cdur/length(pulse));
      chirp = repmat(pulse', paramNpul(pau, dur), 1)';
      
      cnt = cnt+1;
      allStim{cnt} = [zeros(1,50), chirp, zeros(1,cdur + cpau - length(chirp))];
      input(:,pau, dur) = allStim{cnt};
      paramPau(pau, dur) = ppau(pau);
      paramDur(pau, dur) = pdur(dur);
      s.ppau(cnt,1) = ppau(pau);
      s.pdur(cnt,1) = pdur(dur);
      s.npul(cnt,1) = paramNpul(pau, dur);
   end
end
% s.ppau = paramPau(:);
% s.pdur = paramDur(:);
s.pper = s.pdur + s.ppau;
s.pdc =  s.pdur ./ s.pper;

s.cpau = cpau*ones(size(s.ppau));
s.cdur = cdur*ones(size(s.ppau));
s.cper = s.cdur + s.cpau;
s.cdc =  s.cdur ./ s.cper;


% clf
% % plot(allStim{4}, 'o-')
%  
% imagesc(squeeze(input(:,4,:)))
