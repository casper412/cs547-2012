%% Architecture 8
classdef Arch8 < Neuron

    % Memory assicatied to this architecture
    % This is what must be saved and loaded
    properties
        acoustic0 = Arch4AcousticProcessor;
        touch0    = SimpleTouchProcessor;
        eye0      = Arch8VisionProcessor;
        motor     = Arch8MotorControl;
        decision  = Arch8Decision;
    end

    methods
       function obj = Arch8()
           obj = obj@Neuron();
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