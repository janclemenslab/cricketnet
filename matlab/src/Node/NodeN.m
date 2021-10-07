classdef NodeN < Node
   % linear-nonlinear type node 
   properties
      nonlinearity
   end
   
   methods
      function self = NodeN(nonlinearity)
         assert( strcmp(class( nonlinearity ), {'function_handle'}), 'NONLINEARITY must be a function handle')
         self.nonlinearity = nonlinearity;
      end
      
      function output = transform(self)
         self.output = self.nonlinearity(self.input);
         output = self.output;
      end
      
   end
   
end