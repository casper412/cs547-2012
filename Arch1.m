classdef Arch1 < Neuron
    
    % Memory assicatied to this architecture
    % This is what must be saved and loaded
    properties
        weights = zeros(1,1);
        classifications = zeros(1,2);
    end
       
    methods
       function obj = Arch1() 
           obj = obj@Neuron();
           obj.weights = transpose(rand(Sim.OUT_EYE_END - Sim.OUT_EYE_INDEX + 2, 1));
       end
       
       % Called to make decisions
       function muscles = apply(this, sensors)
         muscles = zeros(5,1);
         % Move at a fixed speed
         muscles(Sim.IN_SPEED) = 0.1;
         % Hard wire the touch center on the mouth to eating
         % This is functionallty equivilent to a perceptron
         if(sensors(Sim.OUT_SOMA_MOUTH) > 0.5)
            muscles(Sim.IN_EAT) = 1.;
         end
       end
       
       % Learn at each time step 
       % In this case, learn what objects look like up close
       function learn(this, sensors)
           % inits
           eta = 0.1;
           % Get the visual sensors
           eyes = sensors(Sim.OUT_EYE_INDEX:Sim.OUT_EYE_END);
           % I drank what?
           stomach = sensors(Sim.OUT_DELTA_ENERGY);
           
           % Add bias
           eyes = cat(1, 1., eyes);
           
           %Activation of linear neuron
           activation = this.weights * eyes;
           
           % Compute the error
           if(stomach > 0.01) 
             notfood = 0.9;
           else 
             notfood = 0.1;
           end
           e = notfood - activation;
           
           %Compute delta in weight for linear neuron       
           cw = times(eta * e, eyes); 
           cw = transpose(cw);
           this.weights = plus(this.weights, cw);
           
           nactivation = this.weights * eyes; 
           if(nactivation > 0.0) 
             nnotfood = 0.9;
           else 
             nnotfood = 0.1;
           end
           a = size(this.classifications);
           v = a(1) + 1;
           this.classifications(v, :) = [notfood, nnotfood];
       end
    end
end