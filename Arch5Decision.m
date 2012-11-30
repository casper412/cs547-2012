classdef Arch5Decision < Neuron
   
    properties(Constant = true)
        OUT_MOVE_ANGLE = 1; % Overwrite the left value
    end
    
    % Memory assicatied to this architecture
    % This is what must be saved and loaded
    properties
      foodCombine = Linear([1., 1.]);
      foodThresh  = Perceptron(0.02);
      foodWin     = WinnerTakeAll();
      foodMag     = Linear(2.);

      combineOut  = Linear([1., 1., 1.]);
      
      seeFood     = Perceptron(0.25);
      eatCombine  = Linear([1., 1.]);
      eatThresh   = Perceptron(1.40);
      
      % Acoustic
      earThresh   = Perceptron(0.01);
      earAngles   = Linear([90., -90.]);
      capMouth    = Cap(1.);
    end
       
    methods
       function obj = Arch5Decision() 
           obj = obj@Neuron();
       end
       
       % Called to make decisions
       function decisionOut = apply(this, acousticFeature0, acousticFeature1, somaFeature0, visualFeature0)
 
         decisionOut = zeros(1,5);
         
         f = visualFeature0(Arch5VisionProcessor.OUT_FOOD);
         vfa = visualFeature0(Arch5VisionProcessor.OUT_ANGLE);
         ba = visualFeature0(Arch5VisionProcessor.OUT_BRIGHT);
         le = acousticFeature0(1);
         re = acousticFeature1(1);
         
         % this would be 1. or 2. depending on whether 1 eye or 2 is above
         % the threshold
         foodOut   = this.foodMag.apply(f);
         % This whether our ears have enough difference to use them to turn
         % Abs is functionally equivlent to using two neurons and a WTA
         % network
         earOut    = this.earThresh.apply(abs(le - re));
         % Fixed value to fallback to the brightest object if nothing is
         % visible and our ears are equal
         brightOut = 0.2;
         % Food or brightest won?
         dec       = this.foodWin.apply([foodOut, earOut, brightOut]);
         
         % Computes the ear angles in case we need them
         ea = this.earAngles.apply([le, re]);
         
         angle = [vfa, ea, ba] .* dec;
         
         % Turn a specifc angle
         decisionOut(Arch5Decision.OUT_MOVE_ANGLE)  = ...
             this.combineOut.apply(angle);
        
         sf = this.seeFood.apply(visualFeature0(Arch5VisionProcessor.OUT_FOOD));
         om = this.capMouth.apply(somaFeature0(SimpleTouchProcessor.OUT_MOUTH));
         % Range of 0. to 2.
         % 1. means either touched something or see food
         % > 1. means see food and touching something
         ef = this.eatCombine.apply([sf, om]);
         decisionOut(SimpleDecision.OUT_EAT) = this.eatThresh.apply(ef);
         % Wire the eyes directly to whether we perceive food or not
         decisionOut(SimpleDecision.OUT_FOOD) = visualFeature0(Arch5VisionProcessor.OUT_CENTER);
       end
       
       % Learn at each time step 
       function learn(this, stomach, acousticFeature0, acousticFeature1, somaFeature0, visualFeature0)
           
       end
    end
end