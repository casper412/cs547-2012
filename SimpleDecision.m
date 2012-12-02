% Used in Architecture 2
classdef SimpleDecision < Neuron
    
    properties(Constant = true)
        OUT_MOVE_LEFT  = 1; % Go left - which can conflict with right
        OUT_MOVE_RIGHT = 2; % Go right
        OUT_EAT        = 3; % Order mouth to eat
        OUT_FOOD       = 4; % Thinks food is close by
    end
       
    methods
       function obj = SimpleDecision() 
         obj = obj@Neuron();  
       end
       
       % Called to make decisions
       function decisionOut = apply(this, acousticFeature0, acousticFeature1, somaFeature0, visualFeature0)
         
         decisionOut = zeros(1,5);
         
         % This if block is demonstrated in Arch3Decision
         % The out_food_left / out_food_right are combined
         % A winner take all is done against a constant
         % The winner take all outputs are cross wired to inhibit the other
         % loser which is tied back into the two different turning
         % possibilities.
         
         if or(visualFeature0(Arch2VisionProcessor.OUT_FOOD_LEFT) > 0.5, visualFeature0(Arch2VisionProcessor.OUT_FOOD_RIGHT) > 0.5)
           decisionOut(this.OUT_MOVE_LEFT)  = visualFeature0(Arch2VisionProcessor.OUT_FOOD_LEFT); 
           decisionOut(this.OUT_MOVE_RIGHT) = visualFeature0(Arch2VisionProcessor.OUT_FOOD_RIGHT);
         else
           decisionOut(this.OUT_MOVE_LEFT)  = visualFeature0(Arch2VisionProcessor.OUT_LEFT); 
           decisionOut(this.OUT_MOVE_RIGHT) = visualFeature0(Arch2VisionProcessor.OUT_RIGHT);
         end
         decisionOut(this.OUT_EAT) = somaFeature0(SimpleTouchProcessor.OUT_MOUTH) * visualFeature0(Arch2VisionProcessor.OUT_FOOD);
       end
       
       % Learn at each time step 
       function learn(this, stomach, acousticFeature0, acousticFeature1, somaFeature0, visualFeature0)
           
       end
    end
end