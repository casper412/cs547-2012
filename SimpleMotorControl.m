classdef SimpleMotorControl < Neuron
    
    % Memory assicatied to this architecture
    % This is what must be saved and loaded
    properties
        weights = zeros(1,1);
        
        % Linear neuron to invert its input
        speed = Linear([1./2.5, -1./2.5]);
        % Neuron for eating anything you touch
        mouth = Perceptron(0.5);
        % Control left or right
        dirMax = WinnerTakeAll();
        dir    = Linear([-4., .4]);
    end
       
    methods
       function obj = SimpleMotorControl() 
           obj = obj@Neuron();
           %obj.weights = transpose(rand(Sim.OUT_EYE_END - Sim.OUT_EYE_INDEX + 2, 1));
       end
       
       % Called to make decisions
       function muscles = apply(this, energy, decisions)
         muscles = zeros(5,1);
         
         % Invert the speed and decrease as a function of energy
         muscles(Sim.IN_SPEED) = this.speed.apply([1., energy]);
         % Take the max direction and do that
         vals = this.dirMax.apply([decisions(1) decisions(2)]);
         muscles(Sim.IN_BODY_ANGLE) = this.dir.apply(vals);

         % Wire the decision to eat to the actual mouth
         muscles(Sim.IN_EAT) = this.mouth.apply(decisions(SimpleDecision.OUT_EAT));
       end
       
    end
end