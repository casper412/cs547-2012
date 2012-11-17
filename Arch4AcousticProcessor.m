classdef Arch4AcousticProcessor < Neuron
    
    % Memory assicatied to this architecture
    % This is what must be saved and loaded
    properties
        weights = zeros(1,1);
        centers = zeros(1,1);
        centerCount = Sim.OUT_EAR_BAND_COUNT * 3;
        totalError = zeros(10000,1);
        learnCount = 1;
    end
       
    methods
       function obj = Arch4AcousticProcessor() 
           obj = obj@Neuron();
           obj.weights = rand(1, obj.centerCount);
           obj.centers = rand(obj.centerCount,Sim.OUT_EAR_BAND_COUNT);
       end
       
       % Called to make decisions
       function features = apply(this, sound)
         features = zeros(4,1);
         a = zeros(1, this.centerCount);
         for i = 1:this.centerCount
             a(i) = this.phi(this.centers(i), sound);
         end
         
         features(1) = this.delta(a);
       end
       
       % Learn at each time step 
       function learn(this, stomach, sound)
         eta = 0.1;
         % Compute the error
         if(stomach > 0.01)
           notfood = 0.9;
         elseif(stomach > -0.01) 
           notfood = 0.4;
         else 
           notfood = 0.1;
         end

         activation = this.apply(sound);
         activation = activation(1); % Strip out first feature
         e = notfood - activation;

         % Compute output of the RBF
         rbfOut = zeros(1, this.centerCount);
         for i = 1:this.centerCount
             rbfOut(i) = this.phi(this.centers(i), sound);
         end
         
         % Compute delta in weight for linear neuron       
         cw = times(eta * e, rbfOut); 
         
         this.weights = plus(this.weights, cw);
         this.totalError(this.learnCount) = this.totalError(this.learnCount) + e^2;
         % Next learning event
         this.learnCount = this.learnCount + 1;
         if(this.learnCount > 10000)
             this.learnCount = 1;
         end
       end
       
       % Activation function on the RBF network
       function ret = phi(this, center, x)
           delta = center - x;
           dist = norm(delta);
           mu = this.centerCount;
           dmax = Sim.OUT_EAR_BAND_COUNT;
           mult = -mu / dmax;
           ret = exp(dist * mult);
       end
       
       % Deleta neuron
       function ret = delta(this, a)
         activation = sum(a .* this.weights);
         ret = 1. / (1. + exp(-activation));
       end
    end
end