% Modifed to consider neutral food-like
classdef Arch5VisionProcessor < Neuron
    
    properties(Constant = true)
      OUT_FOOD    = 1;
      OUT_ANGLE   = 2;
      OUT_BRIGHT  = 3;
      OUT_CENTER = 4;
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
        winAct   = WinnerTakeActivation();
        win        = WinnerTakeAll();
        
        foodThresh = Perceptron(0.15);  %this is the level on which the decision is made for food not food.  High value 
        %implies pickier eating.
        anglesVector = [-60., -50., -40., -30., -20., -15., -9., -8., -7.,...
            -6., -5., -4., -3., -2., -1, 0, 1, 2., 3., 4., 5., 6., 7., 8., 9., 15., 20., 30., 40., 50., 60 ];
%         anglesVector = [-15., -14., -13., -12., -11., -10., -9., -8., -7.,...
%              -6., -5., -4., -3., -2., -1, 0, 1, 2., 3., 4., 5., 6., 7., 8., 9., 10., 11., 12., 13., 14., 15 ];
        angles = Linear(0.); 
        cosAngles = zeros(1,1);
    end
       
    methods
       function obj = Arch5VisionProcessor() 
           obj = obj@Neuron();        
           obj.weights = [0., -0.2359, 0.8702, 0.2925];
           obj.angles = Linear(obj.anglesVector); 
           obj.cosAngles = 1%cosd(obj.anglesVector);
       end
       
       % Called to make decisions
       function features = apply(this, vision)
         features = zeros(6,1);
         % Seperate the eyes out

         center = vision(46:48);
         
         % Split eyes into groups
         for i=0:30
           rgb(i + 1, :) = vision(i * 3 + 1 : i * 3 + 3);
         end 
         % Compute activations
         activation = zeros(31, 1);
         intensity   = zeros(31, 1);
        
         for i = 1:31
           x = [0; rgb(i, :)'];
           intensity(i)   = sum(x); % 31 sums of RGB triplets
           if(sum(rgb(i, :)) > 0.01) 
             x = x / norm(x);  %normalize rgb neurons
           end
           activation(i) = this.weights * x;  %here we have all food and not food classifications
         end
         
          x = [1.; center];
          if(sum(rgb(i, :)) > 0.01) 
            x = x / norm(x);
          end
          foodCenter = this.weights * x;
          wintensity = this.win.apply(intensity)';
          brightAng=this.angles.apply(wintensity);

          %%%
          brightFood=activation.*intensity.*this.cosAngles';
          brightest = this.win.apply(brightFood);
          
          foodGuess = zeros(31, 1);
%           for i=1:31
%             foodGuess(i) = this.foodThresh.apply(brightest(i));
%           end
          
          food= this.foodThresh.apply(sum(brightest.*activation));         
          winangle = this.angles.apply(brightest');
%%%
         features(Arch5VisionProcessor.OUT_FOOD)      = food;
         features(Arch5VisionProcessor.OUT_ANGLE)     = winangle;
         features(Arch5VisionProcessor.OUT_BRIGHT)    = brightAng;
         features(Arch5VisionProcessor.OUT_CENTER)   = foodCenter;
       end
       % Turn off learning
       function learn(this, stomach, eyes)
       end
       
       % Learn at each time step 
       function learn2(this, stomach, eyes)
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
               this.totalError(this.learnCount) = this.totalError(this.learnCount) + e^2;  %e^2? what fer?
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