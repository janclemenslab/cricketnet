classdef NodeSynapse < Node
   
   properties
      delay
      weight
   end
   
   methods
      function self = NodeSynapse(delay, weight)
         validateattributes(delay,  {'double'}, {'finite', 'nonnan', 'nonnegative', 'numel' 1});
         validateattributes(weight, {'double'}, {'finite', 'nonnan', 'numel' 1});
         self.delay = delay;
         self.weight = weight;
      end
      
      function output = transform(self)
         T = 1:size(self.input,1);
         % self.output = padarray(self.input, [self.delay, 0], 'pre');       % delay <- interpolate instead of padding to allow non-integer delay values
         self.output = interp1(T, self.input,T-self.delay, 'linear', 'extrap');
         self.output = self.weight * self.output(1:size(self.input,1),:);  % weight
         self.outputLinear = self.output;
         output = self.output;
      end
      
      function plot(self)
         subplot(211)
         plot(self.input(:),'r')
%          subplot(212)
         hold on
         plot(self.output(:),'b')
         axis(gcas, 'tight')
      end

      
   end
   
end