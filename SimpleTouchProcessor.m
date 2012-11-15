classdef SimpleTouchProcessor < Neuron
    
    % Memory assicatied to this architecture
    % This is what must be saved and loaded
    properties
        weights = zeros(1,1);
    end
       
    methods
       function obj = SimpleTouchProcessor() 
           obj = obj@Neuron();
           %obj.weights = transpose(rand(Sim.OUT_EYE_END - Sim.OUT_EYE_INDEX + 2, 1));
       end
       
       % Called to make decisions
       function features = apply(this, touch)
         features = zeros(4,1);
       end
       
       % Learn at each time step 
       function learn(this, stomach, touch)
           
       end
    end
end