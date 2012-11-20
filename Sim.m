classdef Sim
    
    properties (Constant = true)
      OUT_ALIVE = 1;
      % Actuator
      OUT_SPEED = 2;
      OUT_ROTATE = 3;
      OUT_BODY_ANGLE = 4;
      OUT_HEAD_ANGLE = 5;
      OUT_CHARGE = 6;
      
      % Do not use
      OUT_X = 7;
      OUT_Y = 8;
      OUT_ABS_BODY_ANGLE = 9;
      OUT_ABS_HEAD_ANGLE = 10;
      
      % Soma
      OUT_SOMA_MOUTH     = 12;
      OUT_SOMA_INDEX     = 12;
      OUT_SOMA_END       = 19; 
      OUT_SOMA_COUNT     = 8;
      OUT_COLLISION_FLAG = 20;
      
      % Acoustic
      OUT_EAR_MAG_0      = 21;
      OUT_EAR_MAG_1      = 22;
      OUT_EAR_0_INDEX    = 24;
      OUT_EAR_0_END      = 33;
      OUT_EAR_1_INDEX    = 34;
      OUT_EAR_1_END      = 43;
      OUT_EAR_BAND_COUNT = 10; 
      
      % Vision
      OUT_EYE_INDEX      = 44;
      OUT_EYE_END        = 136;
      OUT_EYE_BANDS      = 3;
      
      OUT_DELTA_ENERGY = 23;
      
      % Change bot
      IN_SPEED = 1;
      IN_ROTATE = 2;
      IN_BODY_ANGLE = 3;
      IN_HEAD_ANGLE = 4;
      IN_EAT = 5;
      
    end
    
    methods
        
        function [stats, outputs] = doSim(this, n, runs, graphic)
            r = runSim
            r.init
            
            if graphic == 1
              frame = r.loadGfx();
              world = frame.getSimulation().getWorld();
            else
              simulation = r.loadSim();
              world = simulation.getWorld();
            end
            outputSize = 136;
            %Initialize the outut
            outputs = zeros(1,outputSize,runs);
            stats = zeros(runs, 4);
           
            
            % Loop a few times
            for i = 1:runs
                output = zeros(outputSize, 1);
                output(this.OUT_DELTA_ENERGY) = -10000;
                outputs(1, :, i) = transpose(output);
                
                % Run the simulation
                for time = 1:200000
                  input = n.apply(output);
                  
                  % Eat in MatLab to capture result
                  deltaEnergy = -10000;
                  if(input(this.IN_EAT) > 0.5) 
                      deltaEnergy = world.eatSomething();
                      input(this.IN_EAT) = 0.;
                  end
                  
                  % Learn something new
                  if(deltaEnergy > -1000)
                    output(this.OUT_DELTA_ENERGY) = deltaEnergy;
                    n.learn(output); % Update weights because we eat something
                    
                    if(deltaEnergy > 0.001)
                        stats(i, 1) = stats(i, 1) + 1; % Count good eaten
                    elseif(deltaEnergy < -0.001)
                        stats(i, 2) = stats(i, 2) + 1; % Count bad eaten
                    else
                        stats(i, 3) = stats(i, 3) + 1; % Count neutral eaten
                    end
                  end
                  
                  % Simulate the next time step
                  output = world.runMatlab(time, input);
   
                  output(this.OUT_DELTA_ENERGY) = deltaEnergy;
                  % Save everything that happened
                  outputs(time + 1, :, i) = transpose(output); 
                  
                  % Alive or Dead after time step
                  if(output(this.OUT_ALIVE) > 0.5)
                      % Alive
                      
                  else
                      % Dead
                      stats(i, 4) = time; % How long did we live
                      world.restoreMatlab(time);
                      break;
                  end
                end
                disp(i);
            end
            
            % Shutdown the graphics
            if graphic ==1
                frame.dispose();
                frame.getConsoleFrame().dispose();
            end
            
        end
        
    end
end