classdef NodeSummate < Node
   % node takes to inputs,
   % summates them and
   % squeezes the product through a nonlinearity
   properties
      nonlinearity
   end
   
   methods
      function self = NodeSummate( varargin )
         % nc = NodeSummate( nonlinearity = NL.identity )
         if nargin==0
            self.nonlinearity = NL.identity;
         else
            self.nonlinearity = varargin{1};
         end
      end
      
      function output = transform( self )
         validateattributes(self.input, {'cell'}, {'numel' 2});
         self.outputLinear = self.input{1} + self.input{2};
         self.output = self.nonlinearity( self.outputLinear );
         output = self.output;
      end
      
      function plot(self)
         subplot(511)
         plot(self.input{1},'r')
         subplot(512)
         plot(self.input{2},'r')
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
