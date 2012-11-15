classdef SimpleMotorControl < Neuron
    
    % Memory assicatied to this architecture
    % This is what must be saved and loaded
    properties
        weights = zeros(1,1);
    end
       
    methods
       function obj = SimpleMotorControl() 
           obj = obj@Neuron();
           %obj.weights = transpose(rand(Sim.OUT_EYE_END - Sim.OUT_EYE_INDEX + 2, 1));
       end
       
       % Called to make decisions
       function muscles = apply(this, energy, decisions)
         muscles = zeros(5,1);
         
         % Move at a fixed speed
         % Functionally equivilent to a neuron that inverts its input
         muscles(Sim.IN_SPEED) = (1. - energy) / 2.5;
         
         if(decisions(1) > decisions(2))
            muscles(Sim.IN_BODY_ANGLE) =  -4.;  % TODO: Make a constant
         elseif(decisions(2) > 0.)
             muscles(Sim.IN_BODY_ANGLE) = 4.; % TODO: Make a constant
         end

       end
       
    end
end