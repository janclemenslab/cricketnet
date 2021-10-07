function [input, s, ppau, pdur, allStim] = makePPFstim(varargin)

args = argparse(varargin, {'ppauMax', 'ppauMax', 80; 'pdurMax', 'pdurMax', 80; 'cdur', 'cdur', 200; 'cpau', 'cpau', 200});
Fs = 1000;
dwnSmp = 1;

ppau = [1:2:args.ppauMax]/dwnSmp;
pdur = [1:2:args.pdurMax]/dwnSmp;
cpau = args.cpau/dwnSmp;
cdur = args.cdur/dwnSmp;
input = [];
allStim = {};

cnt = 0;
for pau = 1:length(ppau)
   for dur = 1:length(pdur)
      pulse = [ones(1,pdur(dur)), zeros(1,ppau(pau))];
      paramNpul(pau,dur) = floor(cdur/length(pulse));
      chirp = repmat(pulse', paramNpul(pau,dur), 1)';
      
      cnt = cnt+1;
      allStim{cnt} = [zeros(1,50), chirp, zeros(1,cdur + cpau - length(chirp))];
      input(:,pau, dur) = allStim{cnt};
      paramPau(pau, dur) = ppau(pau);
      paramDur(pau, dur) = pdur(dur);
   end
end
s.ppau = paramPau(:);
s.pdur = paramDur(:);
s.npul = paramNpul(:);
s.pper = s.pdur + s.ppau;
s.pdc =  s.pdur ./ s.pper;

s.cpau = cpau*ones(size(s.ppau));
s.cdur = cdur*ones(size(s.ppau));
s.cper = s.pdur + s.ppau;
s.cdc =  s.pdur ./ s.pper;
