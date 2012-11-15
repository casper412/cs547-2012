% Base class for neurons
classdef Neuron < handle
    
   methods(Abstract = true)
       muscles = apply(this, sensors);
   end
   
end
