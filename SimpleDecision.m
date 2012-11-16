classdef SimpleDecision < Neuron
    
    properties(Constant = true)
        OUT_MOVE_LEFT  = 1;
        OUT_MOVE_RIGHT = 2;
        OUT_EAT        = 3;
    end
    
    % Memory assicatied to this architecture
    % This is what must be saved and loaded
    properties
        weights = zeros(1,1);
    end
       
    methods
       function obj = SimpleDecision() 
           obj = obj@Neuron();
           obj.weights = transpose(rand(Sim.OUT_EYE_END - Sim.OUT_EYE_INDEX + 2, 1));
       end
       
       % Called to make decisions
       function decisionOut = apply(this, acousticFeature0, acousticFeature1, somaFeature0, visualFeature0)
         
         decisionOut = zeros(1,5);
         %if or(visualFeature0(Arch2VisionProcessor.OUT_FOOD_LEFT) > 0.35, visualFeature0(Arch2VisionProcessor.OUT_FOOD_RIGHT) > 0.35)
         %  decisionOut(this.OUT_MOVE_LEFT)  = visualFeature0(Arch2VisionProcessor.OUT_FOOD_LEFT); %TODO: Make a constant
         %  decisionOut(this.OUT_MOVE_RIGHT) = visualFeature0(Arch2VisionProcessor.OUT_FOOD_RIGHT);%TODO: Make a constant
         %else
           decisionOut(this.OUT_MOVE_LEFT)  = visualFeature0(Arch2VisionProcessor.OUT_LEFT); %TODO: Make a constant
           decisionOut(this.OUT_MOVE_RIGHT) = visualFeature0(Arch2VisionProcessor.OUT_RIGHT);%TODO: Make a constant
         %end
         decisionOut(this.OUT_EAT) = somaFeature0(SimpleTouchProcessor.OUT_MOUTH) * visualFeature0(Arch2VisionProcessor.OUT_FOOD);
       end
       
       % Learn at each time step 
       function learn(this, stomach, acousticFeature0, acousticFeature1, somaFeature0, visualFeature0)
           
       end
    end
end