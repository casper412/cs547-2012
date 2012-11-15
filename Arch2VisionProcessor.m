classdef Arch2VisionProcessor < Neuron
    
    properties (Constant = true)
        OUT_NOTHING = 1;
        OUT_FOOD    = 2;
        OUT_LEFT    = 3;
        OUT_RIGHT   = 4;
        OUT_FOOD_LEFT    = 5;
        OUT_FOOD_RIGHT   = 6;
        % TODO: More outputs
    end
    
    % Memory assicatied to this architecture
    % This is what must be saved and loaded
    properties
        weights    = zeros(1,1);
        totalError = zeros(10000,1);
        learnCount = 1;
    end
       
    methods
       function obj = Arch2VisionProcessor() 
           obj = obj@Neuron();
           obj.weights = rand(1, 4);
       end
       
       % Called to make decisions
       function features = apply(this, vision)
         features = zeros(6,1);
         % Seperate the eyes out
         left   = vision(1:45);
         center = vision(46:48);
         right  = vision(49:93);
         
         % Split eyes into groups
         for i=0:30
           rgb(i + 1, :) = vision(i * 3 + 1 : i * 3 + 3);
         end 
         % Compute activations
         activation = zeros(31, 1);
         for i = 1:31
           x = [0; rgb(i, :)'];
           activation(i) = this.weights * x;
         end
         
         % Agg up food left and right
         leftFoodAgg  = sum(activation(1:14)) / 15.;
         rightFoodAgg = sum(activation(16:31))  / 15.;
         
         leftFoodOut  =  min(1., leftFoodAgg);
         rightFoodOut =  min(1., rightFoodAgg);
         
         % Single neuron on each side to build up the input
         leftAgg  = sum(left)  / 45.;
         rightAgg = sum(right) / 45.;
         
         leftOut  =  min(1., leftAgg);
         rightOut =  min(1., rightAgg);
         
         features(Arch2VisionProcessor.OUT_LEFT)  = leftOut;
         features(Arch2VisionProcessor.OUT_RIGHT) = rightOut;
         features(Arch2VisionProcessor.OUT_FOOD_LEFT)  = leftFoodOut;
         features(Arch2VisionProcessor.OUT_FOOD_RIGHT) = rightFoodOut;
       end
       
       % Learn at each time step 
       function learn(this, stomach, eyes)
           eta = 0.1;
           
           % Split eyes into groups
           for i=0:30
            rgb(i + 1, :) = eyes(i * 3 + 1 : i * 3 + 3);
           end 
           
           % Compute the error
           if(stomach > 0.01) 
             notfood = 0.9;
           else 
             notfood = 0.1;
           end
           
           % for each eye
           learn = 0;
           for i = 1:31
             x = [1; rgb(i, :)'];
             activation = this.weights * x;
             % Is the eye receiving light?
             if(sum(rgb(i, :)) > 0.01) 
                 e = notfood - activation;

                 % Compute delta in weight for linear neuron       
                 cw = times(eta * e, x); 
                 cw = transpose(cw);
                 this.weights = plus(this.weights, cw);
                 this.totalError(this.learnCount) = this.totalError(this.learnCount) + e^2;
                 learn = learn + 1;
             end
           end
           % Take the average
           this.totalError(this.learnCount) = this.totalError(this.learnCount) / learn;
           % Next learning event
           this.learnCount = this.learnCount + 1;
       end
       
    end
end