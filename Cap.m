%% Cap Neuron
%% Caps the input it gets
classdef Cap < Neuron
    
    % Memory assicatied to this neuron
    properties
        threshold = 0.;
    end
       
    methods
       function obj = Cap(val) 
           obj = obj@Neuron();
           obj.threshold = val;
       end
       
       % Called to make decisions
       function output = apply(this, val)
         if val < this.threshold
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