classdef Neuron
    
   methods(Abstract = true)
       muscles = apply(this, sensors);
       learn(this, sensors);
   end
   
end
