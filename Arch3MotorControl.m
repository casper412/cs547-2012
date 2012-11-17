% Modified to slow down to eat
classdef Arch3MotorControl < Neuron
    
    % Memory assicatied to this architecture
    % This is what must be saved and loaded
    properties
        weights = zeros(1,1);
    end
       
    methods
       function obj = Arch3MotorControl() 
           obj = obj@Neuron();
           %obj.weights = transpose(rand(Sim.OUT_EYE_END - Sim.OUT_EYE_INDEX + 2, 1));
       end
       
       % Called to make decisions
       function muscles = apply(this, energy, decisions)
         muscles = zeros(5,1);
         
         % Move at a rate as the inverse of energy
         % Functionally equivilent to a neuron that inverts its input
         % Slow down when something is in front of us
         % Slow down when we are near food
         food = decisions(SimpleDecision.OUT_FOOD) * 0.1;
         muscles(Sim.IN_SPEED) = (1. - energy + food) / 2.5;
         moveStraight = ...
             1. - decisions(SimpleDecision.OUT_MOVE_LEFT) * decisions(SimpleDecision.OUT_MOVE_RIGHT);
         % Reduce the speed when going straight
         muscles(Sim.IN_SPEED) = muscles(Sim.IN_SPEED) * moveStraight; 
         
         if(decisions(SimpleDecision.OUT_MOVE_LEFT) > decisions(SimpleDecision.OUT_MOVE_RIGHT))
            muscles(Sim.IN_BODY_ANGLE) =  -3.;  % TODO: Make a constant
         elseif(decisions(SimpleDecision.OUT_MOVE_RIGHT) > 0.)
             muscles(Sim.IN_BODY_ANGLE) = 3.; % TODO: Make a constant
         end
         % Wire the decision to eat to the actual mouth
         if(decisions(SimpleDecision.OUT_EAT) > 0.2)
            muscles(Sim.IN_EAT) = 1.;
         else
            muscles(Sim.IN_EAT) = 0.;
         end
       end
       
    end
end