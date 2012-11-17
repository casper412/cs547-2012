classdef Arch3Decision < Neuron
   
    % Memory assicatied to this architecture
    % This is what must be saved and loaded
    properties
        weights = zeros(1,1);
    end
       
    methods
       function obj = Arch3Decision() 
           obj = obj@Neuron();
           obj.weights = transpose(rand(Sim.OUT_EYE_END - Sim.OUT_EYE_INDEX + 2, 1));
       end
       
       % Called to make decisions
       function decisionOut = apply(this, acousticFeature0, acousticFeature1, somaFeature0, visualFeature0)
         
         decisionOut = zeros(1,5);
         %disp(visualFeature0);
         if or(visualFeature0(Arch2VisionProcessor.OUT_FOOD_LEFT) > 0.35, visualFeature0(Arch2VisionProcessor.OUT_FOOD_RIGHT) > 0.35)
           decisionOut(SimpleDecision.OUT_MOVE_LEFT)  = ...
               visualFeature0(Arch2VisionProcessor.OUT_FOOD_LEFT); 
           decisionOut(SimpleDecision.OUT_MOVE_RIGHT) = ...
               visualFeature0(Arch2VisionProcessor.OUT_FOOD_RIGHT);
         else
           decisionOut(SimpleDecision.OUT_MOVE_LEFT)  = ...
               visualFeature0(Arch2VisionProcessor.OUT_LEFT); 
           decisionOut(SimpleDecision.OUT_MOVE_RIGHT) = ...
               visualFeature0(Arch2VisionProcessor.OUT_RIGHT);
         end
         decisionOut(SimpleDecision.OUT_EAT) = ...
            somaFeature0(SimpleTouchProcessor.OUT_MOUTH) * ...
            visualFeature0(Arch2VisionProcessor.OUT_FOOD);
         decisionOut(SimpleDecision.OUT_FOOD) = visualFeature0(Arch2VisionProcessor.OUT_FOOD);
       end
       
       % Learn at each time step 
       function learn(this, stomach, acousticFeature0, acousticFeature1, somaFeature0, visualFeature0)
           
       end
    end
end