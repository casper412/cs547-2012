%% Average Neuron
%% Averages the input it gets
classdef Average < Neuron
    
    % Memory assicatied to this neuron
    properties
    end
       
    methods
       function obj = Average() 
           obj = obj@Neuron();
       end
       
       % Called to make decisions
       function output = apply(this, vals)
         s = size(vals);
         output = sum(vals) / s(1);
       end
       
       % Learn at each time step 
       function learn(this, vals)
         % Do nothing
       end
    end
end