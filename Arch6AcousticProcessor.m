classdef Arch6AcousticProcessor < Neuron
    
    % Memory assicatied to this architecture
    % This is what must be saved and loaded
    properties
      sum = Linear([1., 1., 1., 1., 1., 1., 1., 1., 1., 1.]);
    end
       
    methods
       function obj = Arch6AcousticProcessor() 
           obj = obj@Neuron();
       end
       
       % Called to make decisions
       function features = apply(this, sound)
         features = zeros(4,1);
         
         features(1) = this.sum.apply(sound');
       end
       
       % Learn at each time step 
       function learn(this, stomach, sound)
         % Do nothing
       end
       
    end
end