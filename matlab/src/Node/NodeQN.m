classdef NodeQN < Node
   
   properties
      filter
      nonlinearity
      inputRaw
      input
   end
   
   methods
      function self = NodeLN(filter, nonlinearity)
         self.filter = filter;
         self.nonlinearity = nonlinearity;
      end
      
      function set.input(self, inputRaw)
         self.inputRaw = inputRaw;
         % make quad expansion
         self.input = input;
         self.output = [];
      end
      
      function output = transform(self)
         self.output = mapFun(@conv, self.input, {self.filter});
         self.output = self.nonlinearity(self.output(1:size(self.input,1),:));
         output = self.output;
      end
      
   end
   
end