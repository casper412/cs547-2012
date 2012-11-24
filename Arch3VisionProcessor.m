% Modifed to consider neutral food-like
classdef Arch3VisionProcessor < Neuron
    
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
       function obj = Arch3VisionProcessor() 
           obj = obj@Neuron();         
           obj.weights = [0., -0.269, 0.8923, 0.2422];
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
           if(sum(rgb(i, :)) > 0.01) 
             x = x / norm(x);
           end
           activation(i) = this.weights * x;
         end
         
         x = [1; center(:)];
         x = x / norm(x);
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
         
         features(Arch2VisionProcessor.OUT_FOOD)       = food;
         features(Arch2VisionProcessor.OUT_LEFT)       = leftOut;
         features(Arch2VisionProcessor.OUT_RIGHT)      = rightOut;
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
           elseif(stomach > -0.01) 
             notfood = 0.4;
           else 
             notfood = 0.1;
           end
           
           % for each eye
           learn = 0;
           for i = 1:31
             x = [0; rgb(i, :)'];
             % Is the eye receiving light?
             if(sum(rgb(i, :)) > 0.01) 
               x = x / norm(x); % Normalize the color channels
               activation = this.weights * x;
             
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