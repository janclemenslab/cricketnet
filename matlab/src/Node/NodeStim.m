classdef NodeStim < Node
   
   methods
      function self = NodeStim(input)
         self.input = input;
      end
      
      function output = transform(self)
         self.output = self.input;
         output = self.output;
      end
   end
   
end