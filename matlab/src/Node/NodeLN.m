classdef NodeLN < Node
   % linear-nonlinear type node 
   properties
      filter
      nonlinearity
   end
   
   methods
      function self = NodeLN(filter, nonlinearity)
         assert( strcmp(class( nonlinearity ), {'function_handle'}), 'NONLINEARITY must be a function handle')
         self.filter = filter;
         self.nonlinearity = nonlinearity;
      end
      
      function output = transform(self)
         try
            self.outputLinear = mapFun(@conv, self.input, {self.filter});
         catch
            self.outputLinear = self.input;
         end
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
         plot(reshape(self.outputLinear(1:size(self.output,1),:), 1, []),'k')
         mySubPlot(5,5,4,1)
         plot(reshape(self.outputLinear(1:size(self.output,1),:), 1, []), self.output(:),'.k')
         subplot(515)
         plot(self.output(:),'b')
         axis(gcas, 'tight')
      end
   end
   
end