classdef runSim
    
    properties
        basePath = '';
    end
    
    methods
        % Called first to load the jar
        function init(this)
          javaaddpath(strcat(this.basePath, '/FlatWorld.jar'));
        end
        % Return a frame which has the simulation object
        function out = loadGfx(this)
            file = strcat(this.basePath, 'input/WorldObjects.dat');
            out = gfx.MainFrame(file, false);
            return;
        end
        % Return a simulation object (no thread and no gfx)
        function out = loadSim(this)
            sim = control.FlatWorldMatlab
            file = strcat(this.basePath, 'input/WorldObjects.dat');
            out = sim.loadSim(file);
            return;
        end

    end
end

