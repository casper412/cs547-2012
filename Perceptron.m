%% Perceptron Neuron
classdef Perceptron < Neuron
    
    % Memory assicatied to this neuron
    properties
        threshold = 0.;
    end
       
    methods
       function obj = Perceptron(val) 
           obj = obj@Neuron();
           obj.threshold = val;
       end
       
       % Called to make decisions
       function output = apply(this, val)
         if val > this.threshold
             output = 1.;
         else
             output = 0.;
         end
       end
       
       % Learn at each time step 
       function learn(this, sensors)
         % Do nothing
       end
    end
end