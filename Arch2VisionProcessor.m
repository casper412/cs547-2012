classdef Arch2VisionProcessor < Neuron
    
    properties (Constant = true)
        OUT_NOTHING = 1;
        OUT_FOOD    = 2;
        OUT_LEFT    = 3;
        OUT_RIGHT   = 4;
        % TODO: More outputs
    end
    
    % Memory assicatied to this architecture
    % This is what must be saved and loaded
    properties
        weights = zeros(1,1);
    end
       
    methods
       function obj = Arch2VisionProcessor() 
           obj = obj@Neuron();
           %obj.weights = transpose(rand(Sim.OUT_EYE_END - Sim.OUT_EYE_INDEX + 2, 1));
       end
       
       % Called to make decisions
       function features = apply(this, vision)
         features = zeros(4,1);
         % Seperate the eyes out
         left   = vision(1:45);
         center = vision(46:48);
         right  = vision(49:93);
         
         % Single neuron on each side to build up the input
         leftAgg  = sum(left);
         rightAgg = sum(right);
         
         leftOut  =  min(1., leftAgg);
         rightOut =  min(1., rightAgg);
         
         features(Arch2VisionProcessor.OUT_LEFT)  = leftOut;
         features(Arch2VisionProcessor.OUT_RIGHT) = rightOut;
       end
       
       % Learn at each time step 
       function learn(this, stomach, vision)
           
       end
       
       function out = sigma(this, v)
           out = 1. / (1. + exp(-v));
       end
       
    end
end