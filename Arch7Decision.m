classdef Arch7Decision < Neuron
   
    % Memory assicatied to this architecture
    % This is what must be saved and loaded
    properties
      foodCombine = Linear([1., 1.]);
      foodThresh  = Perceptron(0.02);
      foodWin     = WinnerTakeAll();
      foodMag     = Linear(2.);
      % Suppress one input
      suppress    = Linear([-10., -10., 1.]);
      
      % Prohibit negative values
      filter      = Max(0.); 
      combineOut  = Linear([1., 1., 1.]);
      
      seeFood     = Perceptron(0.28);
      eatCombine  = Linear([1., 1.]);
      eatThresh   = Perceptron(1.40);
      
      % Acoustic
      earThresh   = Perceptron(0.02);
      
      capMouth    = Cap(1.);
    end
       
    methods
       function obj = Arch7Decision() 
           obj = obj@Neuron();
       end
       
       % Called to make decisions
       function decisionOut = apply(this, acousticFeature0, acousticFeature1, somaFeature0, visualFeature0)
 
         decisionOut = zeros(1,5);
         lf  = this.foodThresh.apply(visualFeature0(Arch2VisionProcessor.OUT_FOOD_LEFT));
         rf  = this.foodThresh.apply(visualFeature0(Arch2VisionProcessor.OUT_FOOD_RIGHT));
         lf2 = visualFeature0(Arch2VisionProcessor.OUT_FOOD_LEFT);
         rf2 = visualFeature0(Arch2VisionProcessor.OUT_FOOD_RIGHT);
         l  = visualFeature0(Arch2VisionProcessor.OUT_LEFT);
         r  = visualFeature0(Arch2VisionProcessor.OUT_RIGHT);
         le = acousticFeature1(1);
         re = acousticFeature0(1);
         
         % this would be 1. or 2. depending on whether 1 eye or 2 is above
         % the threshold
         foodOut   = this.foodMag.apply(this.foodCombine.apply([lf, rf]));
         % Abs is functionally equivlent to using two neurons and a WTA
         % network
         earOut    = this.earThresh.apply(abs(acousticFeature0(1) - acousticFeature1(1)));
         brightOut = 0.5;
         % Food or brightest won?
         dec       = this.foodWin.apply([foodOut, earOut, brightOut]);
         
         % Left
         % Crosswire to suppress the others when one is active
         lfn = this.suppress.apply([dec(3), dec(2), lf2]);
         len = this.suppress.apply([dec(3), dec(1), le]);
         ln  = this.suppress.apply([dec(2), dec(1), l]);
         % Zero out negatives
         lfn = this.filter.apply(lfn);
         len = this.filter.apply(len);
         ln  = this.filter.apply(ln);
         
         % Right
         % Crosswire to suppress the others when one is active
         rfn = this.suppress.apply([dec(3), dec(2), rf2]);
         ren = this.suppress.apply([dec(3), dec(1), re]);
         rn  = this.suppress.apply([dec(2), dec(1), r]);
         % Zero out negatives
         rfn = this.filter.apply(rfn);
         ren = this.filter.apply(ren);
         rn  = this.filter.apply(rn);

         % Turn left or right?
         decisionOut(SimpleDecision.OUT_MOVE_LEFT)  = ...
            this.combineOut.apply([lfn, len, ln]);
         decisionOut(SimpleDecision.OUT_MOVE_RIGHT)  = ...
            this.combineOut.apply([rfn, ren, rn]);
        
         sf = this.seeFood.apply(visualFeature0(Arch2VisionProcessor.OUT_FOOD));
         om = this.capMouth.apply(somaFeature0(SimpleTouchProcessor.OUT_MOUTH));
         % Range of 0. to 2.
         % 1. means either touched something or see food
         % > 1. means see food and touching something
         ef = this.eatCombine.apply([sf, om]);
         decisionOut(SimpleDecision.OUT_EAT) = this.eatThresh.apply(ef);
         % Wire the eyes directly to whether we perceive food or not
         decisionOut(SimpleDecision.OUT_FOOD) = visualFeature0(Arch2VisionProcessor.OUT_FOOD);
         
         % DEBUG
         %disp([decisionOut(SimpleDecision.OUT_FOOD), decisionOut(SimpleDecision.OUT_EAT), sf, ...
         %    somaFeature0(SimpleTouchProcessor.OUT_MOUTH), om]);
       end
       
       % Learn at each time step 
       function learn(this, stomach, acousticFeature0, acousticFeature1, somaFeature0, visualFeature0)
         % Do nothing
       end
    end
end