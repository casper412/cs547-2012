%% Winner Take All Network
%% Take the maximum and make it the output
classdef WinnerTakeAll < Neuron
    
    % Memory assicatied to this neuron
    properties
    end
       
    methods
       function obj = WinnerTakeAll() 
           obj = obj@Neuron();
       end
       
       % Called to make decisions
       function outputs = apply(this, vals)
         s = length(vals);
         max  = -100000.;
         mpos = 0;
         % disp(s);
         for i = 1:s
           if vals(i) > max
             max = vals(i);
             mpos = i;
           end
         end
         % disp(mpos);
         for i = 1:s
           if not(i == mpos)
             vals(i) = 0.;
           else
             vals(i) = 1.;
           end
         end
         outputs = vals;
       end
       
       % Learn at each time step 
       function learn(this, vals)
         % Do nothing
       end
    end
end