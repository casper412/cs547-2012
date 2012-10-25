classdef Arch1 < Neuron
    
    methods
       function muscles = apply(this, sensors)
         muscles = zeros(5,1);
         muscles(Sim.IN_SPEED) = 0.1;
         %if(sensors(12) > 0.5)
         %   muscles(Sim.IN_EAT) = 1.;
         %end
       end
       
       % Learn what objects look like up close
       function learn(this, sensors)
       end
    end
end