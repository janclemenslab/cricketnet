classdef Node < handle
   
   properties
      input
      output
      outputLinear
   end
   
   methods(Abstract)
      transform(self)
   end
   
   methods
      function self = Node()
         self.output = [];
      end
      
      function set.input(self, input)
         self.input = input;
         self.output = [];
      end
      
      % should be a Dependent property, but that doesn't allow caching the
      % output - for speed we make it non-dependent and reset it whenever the
      % antecedents (input, filt, NL) change. May lead to inconsistencies on
      % load
      function output = get.output(self)
         if isempty(self.output)
            self.output = self.transform();
         end
         output = self.output;
      end
      
      function plot(self, varargin)
         
         if nargin==2
            whichStim = varargin{1};
         else
            whichStim = 1:size(self.output, 2);
         end
         
         hold on
         if iscell(self.input)
            for cel = 1:length(self.input)
               plot(self.input{cel}(:,whichStim))
            end
         else
            plot(self.input(:,whichStim))
         end
         plot(self.output(:,whichStim), 'k', 'LineWidth', 1.5);
         hold off
      end
      
      function [Xnl, Ynl] = plotNL(self)
         self.output; % generate output
         Xnl = linspace(min(self.outputLinear(:)), max(self.outputLinear(:)), 100);
         try
            Ynl = self.nonlinearity(Xnl);
         catch % fallback in case node has no explicit nonlinearity
            Ynl = Xnl;
         end
         plot(Xnl, Ynl, 'k')
      end
      
   end
end
