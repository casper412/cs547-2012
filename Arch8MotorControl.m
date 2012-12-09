% Modified to slow down to eat
classdef Arch8MotorControl < Neuron

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
       function obj = Arch8MotorControl()
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
         c2 = this.energyFlip.apply(c);
         t = this.energyTot.apply([1.5, c2]);
         s = this.speedDiv.apply(t);

         %v = this.avg.apply([decisions(SimpleDecision.OUT_MOVE_LEFT), ...
         %                    decisions(SimpleDecision.OUT_MOVE_RIGHT)]);
         %v = this.stCap.apply(v);
         moveStraight = 1.; %this.stLin.apply([1.4, v]);

         readyToEat = this.eatThresh.apply(decisions(SimpleDecision.OUT_EAT));
         availEnergy = energy + food;

         % Perceptron activating at 2. with inputs of energy, food, and
         % decision to eat
         % inhibits Speed and mouth with a floor at zero
         if(availEnergy > 1.0 && readyToEat > 0.5)
             s = 0;
             muscles(Sim.IN_EAT) = 0;
         else
             % Winner take all between 0.65 constant and v
             % With lateral inhibition to take either a small turn angle or
             % large one and either a fixed slow speed or a large one
            % if(decisions(SimpleDecision.OUT_FOOD) > 0.5 && abs(decisions(Arch5Decision.OUT_MOVE_ANGLE)) < 0.1)
            %   muscles(Sim.IN_BODY_ANGLE) = decisions(Arch5Decision.OUT_MOVE_ANGLE);
            %   s = 0.05;
            % else
               % Reduce the speed when going straight
               % Use a neuron that multiplies instead of sums
               s = s;% * moveStraight;

               muscles(Sim.IN_BODY_ANGLE) = decisions(Arch5Decision.OUT_MOVE_ANGLE);
            % end

             muscles(Sim.IN_EAT) = readyToEat;
         end
         muscles(Sim.IN_SPEED) = s;

         % Wire the decision to eat to the actual mouth
         %muscles(Sim.IN_EAT) = this.eatThresh.apply(decisions(SimpleDecision.OUT_EAT));
       end

    end
end