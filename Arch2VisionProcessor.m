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
        
        % Neuron to compute average output
        avg        = Average();
        %Neuron to cap output to 1.
        cap        = Cap(1.);
    end
       
    methods
       function obj = Arch2VisionProcessor() 
           obj = obj@Neuron(); 
           obj.weights = [0., -0.0269, 0.8923, -0.0422];
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
         % Compute activations of 31 neurons
         % The bias is removed because we know ahead of time
         % that if we seen nothing it couldn't possibly be worthwhile
         activation = zeros(31, 1);
         for i = 1:31
           x = [0; rgb(i, :)'];
           activation(i) = this.weights * x;
         end
         % Center neuron
         x = [1; center(:)];
         food = this.weights * x;
         
         % Agg up food left and right
         leftFoodAgg  = this.avg.apply(activation(1:14));
         rightFoodAgg = this.avg.apply(activation(16:31));
         
         leftFoodOut  =  this.cap.apply(leftFoodAgg);
         rightFoodOut =  this.cap.apply(rightFoodAgg);
         
         % Single neuron on each side to build up the input
         leftAgg  = this.avg.apply(left);
         rightAgg = this.avg.apply(right);
         
         leftOut  =  this.cap.apply(leftAgg);
         rightOut =  this.cap.apply(rightAgg);
         
         features(this.OUT_FOOD)       = food;
         features(this.OUT_LEFT)       = leftOut;
         features(this.OUT_RIGHT)      = rightOut;
         features(this.OUT_FOOD_LEFT)  = leftFoodOut;
         features(this.OUT_FOOD_RIGHT) = rightFoodOut;
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
             x = [0; rgb(i, :)'];
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