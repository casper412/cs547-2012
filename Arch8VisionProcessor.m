% Modifed to consider neutral food-like
classdef Arch8VisionProcessor < Neuron

    % Memory assicatied to this architecture
    % This is what must be saved and loaded
    properties
      weights    = zeros(1,1);
      cweights    = zeros(1,1);
      totalError = zeros(10000,1);
      learnCount = 1;

      %Neuron to cap output to 1.
      cap        = Cap(1.);
      win        = WinnerTakeAll();
      %this is the level on which the decision is made for food not food.  High value
      %implies pickier eating.
      foodThresh = Perceptron(0.15);

      anglesVector = [-60., -50., -40., -30., -20., -15., -9., -8., -7.,...
            -6., -5., -4., -3., -2., -1, 0, 1, 2., 3., 4., 5., 6., 7., 8., 9., 15., 20., 30., 40., 50., 60 ];
%     anglesVector = [-15., -14., -13., -12., -11., -10., -9., -8., -7.,...
%              -6., -5., -4., -3., -2., -1, 0, 1, 2., 3., 4., 5., 6., 7., 8., 9., 10., 11., 12., 13., 14., 15 ];
      angles = Linear(0.);
      focus = [1., 1., 1., 1.1, 1.1, 1.1, 1.4, 1.4, 1.4,...
            1.5, 1.5, 1.5, 1.75, 1.75, 1.75, 2., ...
            1.75, 1.75, 1.75, 1.5, 1.5, 1.5, 1.4, 1.4, 1.4, 1.1, 1.1, 1.1, 1., 1., 1.];
    end

    methods
       function obj = Arch8VisionProcessor()
           obj = obj@Neuron();
           obj.weights = [0., -0.2359, 0.8702, 0.0925];
           obj.cweights = [0., -0.2359, 0.8702, 0.6925];           
           obj.angles = Linear(obj.anglesVector);
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
           %here we have all food and not food classifications
           activation(i) = this.weights * x;
         end
         % Handle center classification special
         x = [0.; center];
         if(sum(rgb(i, :)) > 0.01)
           x = x / norm(x);
         end
         foodCenter = this.cweights * x;

         % Brightest angle
         wintensity = this.win.apply(intensity .* this.focus')';
         brightAng  = this.angles.apply(wintensity);
         brightValid= this.cap.apply(sum(intensity));

         % Brightest food
         brightFood=activation .* activation .* intensity; %% .* this.focus';
         brightest = this.win.apply(brightFood);

         food = this.foodThresh.apply(sum(brightest .* activation));
         winangle = this.angles.apply(brightest');

         % Copy values to output
         features(Arch5VisionProcessor.OUT_FOOD)        = food;
         features(Arch5VisionProcessor.OUT_ANGLE)       = winangle;
         features(Arch5VisionProcessor.OUT_BRIGHT)      = brightValid;
         features(Arch5VisionProcessor.OUT_BRIGHT_ANGLE)= brightAng;
         features(Arch5VisionProcessor.OUT_CENTER)      = foodCenter;
       end

       % Turn off learning
       function learn(this, stomach, eyes)
       end
    end
end