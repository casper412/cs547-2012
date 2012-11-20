%% Architecture 4
classdef Arch4 < Neuron
    
    % Memory assicatied to this architecture
    % This is what must be saved and loaded
    properties
        %weights = zeros(1,1);
        acoustic0 = Arch4AcousticProcessor;
        touch0    = SimpleTouchProcessor;
        eye0      = Arch3VisionProcessor;
        motor     = Arch3MotorControl;
        decision  = Arch4Decision;
    end
       
    methods
       function obj = Arch4() 
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
         
         % Learn about what you see sounds like
         food = eyeout(Arch2VisionProcessor.OUT_FOOD);
         % undo classification
         if(food > 0.7)
             food = 0.1;
         elseif(food > 0.2)
             food = 0.;
         else 
             food = -0.1;
         end
         this.acoustic0.learn(food, ear0);
         this.acoustic0.learn(food, ear1);
         
         decisionout = this.decision.apply(ear0out, ear1out, touch0out, eyeout);
         muscles     = this.motor.apply(energy, decisionout);
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
         this.acoustic0.learn(stomach, ear0);  % Weight sharing
         this.acoustic0.learn(stomach, ear1);
         this.eye0.learn(stomach, eyes);
         this.touch0.learn(stomach, touch);
         
         this.decision.learn(stomach, ear0out, ear1out, touch0out, eyeout); 
       end
    end
end