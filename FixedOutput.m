%% Fixed Output Neuron
classdef FixedOutput < Neuron
    
    % Memory assicatied to this neuron
    properties
        output = 0.;
    end
       
    methods
       function obj = FixedOutput(val) 
           obj = obj@Neuron();
           obj.output = val;
       end
       
       % Called to make decisions
       function output = apply(this, val)
         output = this.output;
       end
       
       % Learn at each time step 
       function learn(this, sensors)
         % Do nothing
       end
    end
end