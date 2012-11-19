%% Linear Neuron
%% Sum the input using the weights
classdef Linear < Neuron
    
    % Memory assicatied to this neuron
    properties
        weights = zeros(1,1);
    end
       
    methods
       function obj = Linear(weights) 
           obj = obj@Neuron();
           obj.weights = weights;
       end
       
       % Called to make decisions
       function output = apply(this, vals)
         output = sum(vals .* this.weights);
       end
       
       % Learn at each time step 
       function learn(this, vals)
         % Do nothing
       end
    end
end