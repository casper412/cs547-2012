classdef Arch3Decision < Neuron
   
    % Memory assicatied to this architecture
    % This is what must be saved and loaded
    properties
      foodCombine = Linear([1., 1.]);
      foodThresh  = Perceptron(0.35);
      foodWin     = WinnerTakeAll();
      % Suppress one input
      suppress    = Linear([-10., 1.]);
      
      % Prohibit negative values
      filter      = Max(0.); 
      combineOut  = Linear([1., 1.]);
      
      seeFood     = Perceptron(0.20);
      eatCombine  = Linear([1., 1.]);
      eatThresh   = Perceptron(1.4);
      
      capMouth    = Cap(1.);
    end
       
    methods
       function obj = Arch3Decision() 
           obj = obj@Neuron();
           
       end
       
       % Called to make decisions
       function decisionOut = apply(this, acousticFeature0, acousticFeature1, somaFeature0, visualFeature0)
         
         decisionOut = zeros(1,5);
         lf = this.foodThresh.apply(visualFeature0(Arch2VisionProcessor.OUT_FOOD_LEFT));
         rf = this.foodThresh.apply(visualFeature0(Arch2VisionProcessor.OUT_FOOD_RIGHT));
         lf2 = visualFeature0(Arch2VisionProcessor.OUT_FOOD_LEFT);
         rf2 = visualFeature0(Arch2VisionProcessor.OUT_FOOD_RIGHT);
         l  = visualFeature0(Arch2VisionProcessor.OUT_LEFT);
         r  = visualFeature0(Arch2VisionProcessor.OUT_RIGHT);
         % this would be 1. or 2. depending on whether 1 eye or 2 is above
         % the threshold
         foodOut   = this.foodCombine.apply([lf, rf]);
         brightOut = 0.5;
         % Food or brightest won?
         dec       = this.foodWin.apply([foodOut, brightOut]);
         
         % Crosswire to suppress the other when one is active
         lfn = this.suppress.apply([dec(2), lf2]);
         ln  = this.suppress.apply([dec(1), l]);
         % Zero out negatives
         lfn = this.filter.apply(lfn);
         ln  = this.filter.apply(ln);
         
         % Crosswire to suppress the other when one is active
         rfn = this.suppress.apply([dec(2), rf2]);
         rn  = this.suppress.apply([dec(1), r]);
         % Zero out negatives
         rfn = this.filter.apply(rfn);
         rn  = this.filter.apply(rn);
        
         % Turn left or right?
         decisionOut(SimpleDecision.OUT_MOVE_LEFT)  = ...
            this.combineOut.apply([lfn, ln]);
         decisionOut(SimpleDecision.OUT_MOVE_RIGHT)  = ...
            this.combineOut.apply([rfn, rn]);
        
         sf = this.seeFood.apply(visualFeature0(Arch2VisionProcessor.OUT_FOOD));
         om = this.capMouth.apply(somaFeature0(SimpleTouchProcessor.OUT_MOUTH));
         
         % Range of 0. to 2.
         % 1. means either touched something or see food
         % > 1. means see food and touching something
         ef = this.eatCombine.apply([sf, om]);
         decisionOut(SimpleDecision.OUT_EAT) = this.eatThresh.apply(ef);
         
         % Wire the eyes directly to whether we perceive food or not
         decisionOut(SimpleDecision.OUT_FOOD) = visualFeature0(Arch2VisionProcessor.OUT_FOOD);
       end
       
       % Learn at each time step 
       function learn(this, stomach, acousticFeature0, acousticFeature1, somaFeature0, visualFeature0)
           
       end
    end
end