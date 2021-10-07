classdef NodeDivNorm < Node
   % linear-nonlinear type node 
   properties
      filter
      nonlinearity
      normSignal
      weight
      offset
   end
   
   methods
      function self = NodeDivNorm(filter, nonlinearity, weight, offset)
         assert( strcmp(class( nonlinearity ), {'function_handle'}), 'NONLINEARITY must be a function handle')
         self.filter = filter;
         self.weight = weight;
         if exist('offset','var')
            self.offset = offset;
         else
            self.offset = 1;
         end
         self.nonlinearity = nonlinearity;
      end
      
      function output = transform(self)
         self.normSignal = abs(mapFun(@conv, self.input, {self.filter, 'full'}));
         self.outputLinear = self.input./(self.offset + self.weight*self.normSignal(1:size(self.input,1),:));
         self.output = self.nonlinearity(self.outputLinear(1:size(self.input,1),:));
         output = self.output;
      end
      
      function plot(self)
         subplot(511)
         plot(self.input(:),'r')
         mySubPlot(5,5,2,1)
         plot(self.filter,'k')
         axis('tight')
         hline(0)
         subplot(513)
         plot(reshape(self.normSignal(1:size(self.output,1),:), 1, []),'Color', [0 0.7 0])
         mySubPlot(5,5,4,1)
         plot(reshape(self.outputLinear(1:size(self.output,1),:), 1, []), self.output(:),'.k')
         subplot(515)
         plot(self.output(:),'b')
         axis(gcas, 'tight')
      end
      
   end
   
end