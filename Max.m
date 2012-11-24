%% Cap Neuron on the lower side
%% Maximize the input it gets
classdef Max < Neuron
    
    % Memory assicatied to this neuron
    properties
        threshold = 0.;
    end
       
    methods
       function obj = Max(val) 
           obj = obj@Neuron();
           obj.threshold = val;
       end
       
       % Called to make decisions
       function output = apply(this, val)
         if val > this.threshold
           output = val;
         else
           output = this.threshold;
         end
       end
       
       % Learn at each time step 
       function learn(this, vals)
         % Do nothing
       end
    end
end