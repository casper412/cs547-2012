% This Brain returns no change. Fred will sit and die
%
%
classdef EmptyBrain < Neuron
    
    methods
       function muscles = apply(this, sensors)
         muscles = zeros(5, 1);
         return;
       end
       
       % No learning in architecture 0
       function learn(this, sensors)
         return;
       end
    end
end
