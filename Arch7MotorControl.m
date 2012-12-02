% Modified to slow down to eat
classdef Arch7MotorControl < Neuron

    % Memory assicatied to this architecture
    % This is what must be saved and loaded
    properties
      cap = Cap(1.);

      % Food processing
      foodThresh = Perceptron(0.20);
      foodScale  = Linear(0.1);
      energyFlip = Linear(-1.);
      energyTot  = Linear([1., 1.]);
      speedDiv   = Linear(1.0 / 2.5);
      
      
      % Eating
      eatThresh  = Perceptron(0.2);

      % Left / Right
      leftRight  = WinnerTakeAll();
      turn       = Linear([-4.77, 4.43]);
      turnLittle = Linear([-1.33, 1.53]);

      % move straight
      avg        = Average();
      stCap      = Cap(1.);
      stLin      = Linear([1., -1.]);
    end

    methods
       function obj = Arch7MotorControl()
           obj = obj@Neuron();
       end

       % Called to make decisions
       function muscles = apply(this, energy, decisions)
         muscles = zeros(5,1);

         % Move at a rate as the inverse of energy
         % Functionally equivilent to a neuron that inverts its input
         % Slow down when something is in front of us
         % Slow down when we are near food
         foodT = this.foodThresh.apply(decisions(SimpleDecision.OUT_FOOD));
         food = this.foodScale.apply(foodT);
         c = this.cap.apply(energy + food);
         c = this.energyFlip.apply(c);
         t = this.energyTot.apply([1.5, c]);
         s = this.speedDiv.apply(t);
         
         v = this.avg.apply([decisions(SimpleDecision.OUT_MOVE_LEFT), ...
                             decisions(SimpleDecision.OUT_MOVE_RIGHT)]);
         v = this.stCap.apply(v);
         moveStraight = this.stLin.apply([1.4, v]);

         
         % Turning
         lr = ...
           this.leftRight.apply([decisions(SimpleDecision.OUT_MOVE_LEFT), ...
                                 decisions(SimpleDecision.OUT_MOVE_RIGHT)]);
                             
         % Reduce the speed when going straight
         % Use a neuron that multiplies instead of sums
         if(energy + food > 1.0 && this.eatThresh.apply(decisions(SimpleDecision.OUT_EAT)) > 0.5) 
             s = 0;
             muscles(Sim.IN_EAT) = 0;
         else
             if(v > 0.65)
               muscles(Sim.IN_BODY_ANGLE) = this.turnLittle.apply(lr);
               s = 0.05; %8 * (1-decisions(SimpleDecision.OUT_FOOD));
             else
               s = s * moveStraight;% 0.20;
               muscles(Sim.IN_BODY_ANGLE) = this.turn.apply(lr);
             end
             
             muscles(Sim.IN_EAT) = this.eatThresh.apply(decisions(SimpleDecision.OUT_EAT));
         end
         muscles(Sim.IN_SPEED) = s ;%* moveStraight;


         % Wire the decision to eat to the actual mouth
         %muscles(Sim.IN_EAT) = this.eatThresh.apply(decisions(SimpleDecision.OUT_EAT));
       end

    end
end