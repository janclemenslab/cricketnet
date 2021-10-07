classdef NodeMultiply < Node
   % node takes to inputs,
   % multiplies them and
   % squeezes the product through a nonlinearity
   % this mimics a coincidence detector
   properties
      nonlinearity
   end
   
   methods
      function self = NodeMultiply( varargin )
         % nc = NodeCorrelate( nonlinearity = NL.identity )
         if nargin==0
            self.nonlinearity = NL.identity;
         else
            self.nonlinearity = varargin{1};
         end
      end
      
      function output = transform( self )
         validateattributes(self.input, {'cell'}, {'numel' 2});
         self.outputLinear = self.input{1}.*self.input{2};
         self.output = self.nonlinearity( self.outputLinear );
         output = self.output;
      end
      
   end
   
end
