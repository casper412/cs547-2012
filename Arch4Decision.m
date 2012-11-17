classdef Arch4Decision < Neuron
   
    % Memory assicatied to this architecture
    % This is what must be saved and loaded
    properties
        weights = zeros(1,1);
    end
       
    methods
       function obj = Arch4Decision() 
           obj = obj@Neuron();
           obj.weights = transpose(rand(Sim.OUT_EYE_END - Sim.OUT_EYE_INDEX + 2, 1));
       end
       
       % Called to make decisions
       function decisionOut = apply(this, acousticFeature0, acousticFeature1, somaFeature0, visualFeature0)
         
         decisionOut = zeros(1,5);
         %disp(visualFeature0);
         if or(visualFeature0(Arch2VisionProcessor.OUT_FOOD_LEFT) > 0.01, visualFeature0(Arch2VisionProcessor.OUT_FOOD_RIGHT) > 0.01)
           decisionOut(SimpleDecision.OUT_MOVE_LEFT)  = ...
               visualFeature0(Arch2VisionProcessor.OUT_FOOD_LEFT); 
           decisionOut(SimpleDecision.OUT_MOVE_RIGHT) = ...
               visualFeature0(Arch2VisionProcessor.OUT_FOOD_RIGHT);
         % Brightest combined with where we hear food
         else
           if(abs(acousticFeature0(1) - acousticFeature1(1)) > acousticFeature1(1) * 0.3)
           if(acousticFeature0(1) > acousticFeature1(1))
               decisionOut(SimpleDecision.OUT_MOVE_RIGHT) = 1.;
           else
               decisionOut(SimpleDecision.OUT_MOVE_LEFT) = 1.;
           end
           else
             decisionOut(SimpleDecision.OUT_MOVE_LEFT)  =  ...
               visualFeature0(Arch2VisionProcessor.OUT_LEFT);
             decisionOut(SimpleDecision.OUT_MOVE_RIGHT) = ...
               visualFeature0(Arch2VisionProcessor.OUT_RIGHT);
           end
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