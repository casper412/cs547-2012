%% Architecture 2
classdef Arch2 < Neuron
    
    % Memory assicatied to this architecture
    % This is what must be saved and loaded
    properties
        %weights = zeros(1,1);
        acoustic0 = SimpleAcousticProcessor;
        touch0    = SimpleTouchProcessor;
        eye0      = Arch2VisionProcessor;
        motor     = SimpleMotorControl;
        decision  = SimpleDecision;
    end
       
    methods
       function obj = Arch2() 
           obj = obj@Neuron();
           %obj.weights = transpose(rand(Sim.OUT_EYE_END - Sim.OUT_EYE_INDEX + 2, 1));
       end
       
       % Called to make decisions
       function muscles = apply(this, sensors)
         ear0  = sensors(Sim.OUT_EAR_0_INDEX:Sim.OUT_EAR_0_END);
         ear1  = sensors(Sim.OUT_EAR_1_INDEX:Sim.OUT_EAR_1_END);
         eyes  = sensors(Sim.OUT_EYE_INDEX:Sim.OUT_EYE_END);
         touch = sensors(Sim.OUT_SOMA_INDEX:Sim.OUT_SOMA_END);
         energy= sensors(Sim.OUT_CHARGE);
         
         ear0out   = this.acoustic0.apply(ear0);
         ear1out   = this.acoustic0.apply(ear1);
         touch0out = this.touch0.apply(touch);
         eyeout    = this.eye0.apply(eyes);
         
         decisionout = this.decision.apply(ear0out, ear1out, touch0out, eyeout);
         muscles     = this.motor.apply(energy, decisionout);
         
         % Hard wire the touch center on the mouth to eating
         % This is functionally equivilent to a perceptron
         if(sensors(Sim.OUT_SOMA_MOUTH) > 0.5)
            muscles(Sim.IN_EAT) = 1.;
         end
       end
       
       % Learn at each time step 
       % In this case, learn what objects look like up close
       function learn(this, sensors)
         ear0  = sensors(Sim.OUT_EAR_0_INDEX:Sim.OUT_EAR_0_END);
         ear1  = sensors(Sim.OUT_EAR_1_INDEX:Sim.OUT_EAR_1_END);
         eyes  = sensors(Sim.OUT_EYE_INDEX:Sim.OUT_EYE_END);
         touch = sensors(Sim.OUT_SOMA_INDEX:Sim.OUT_SOMA_END);
         stomach = sensors(Sim.OUT_DELTA_ENERGY);
         
         % Need outputs for higher level learning
         ear0out   = this.acoustic0.apply(ear0);
         ear1out   = this.acoustic0.apply(ear1);
         touch0out = this.touch0.apply(touch);
         eyeout    = this.eye0.apply(eyes);
         
         % Tell each subsystem to learn
         this.acoustic0.learn(stomach, ear0);  % Weight sharing?
         this.acoustic0.learn(stomach, ear1);
         this.eye0.learn(stomach, eyes);
         this.touch0.learn(stomach, touch);
         
         this.decision.learn(stomach, ear0out, ear1out, touch0out, eyeout); 
       end
    end
end