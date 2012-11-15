clear
close all
s = Sim;
blah = Arch2;
runs=1;
[stats, output] = s.doSim(blah,1);
arch='architecture2'
%touchwaits=blah.learn;  save blah.weights and just run doSim without
%blah=Arch2.
eyeweights=blah.eye0
%earwaits=blah.weights;
saveflag=1;

if saveflag
      statsFile = sprintf('weights\%s_stats_%d-%d.mat',arch, runs,now);
      save('statsFile', 'stats')
      
      outputFile = sprintf('weights\%s_output_%d-%d.mat',arch, runs,now);
      save('outputFile', 'output')

      eyeweightFile = sprintf('weights\%s_weights_%d-%d.mat', arch, runs,now);
      save(eyeweightFile, 'eyeweights')
      
end

  

            figure;
                        plot(blah.totEr,'-b','linewidth', 1.0)
                        xlabel({sprintf('objects eaten\n total runs = %1d, objects eaten = %1d',runs,length(blah.totEr))}, 'FontName', 'Cambria', 'FontSize', 16, ...
                        'FontWeight', 'bold');
                        ylabel('total error', 'FontName', 'Cambria', 'FontSize', 16, ...
                           'FontWeight', 'bold', 'FontAngle', 'normal');
                        title({sprintf('Total Error per object eaten for %s\ncontrolling for soma',arch)},...
                            'FontName','Cambria', 'FontSize', 18, ...
                           'FontWeight', 'bold', 'Color', [0 0 0]);

            figure;
                        plot(erENG,'-b','linewidth', 1.0)
                        xlabel({sprintf('objects eaten\n total runs = %1d, objects eaten = %1d',runs,length(blah.totEr))}, 'FontName', 'Cambria', 'FontSize', 16, ...
                        'FontWeight', 'bold');
                        ylabel('Error Energy', 'FontName', 'Cambria', 'FontSize', 16, ...
                           'FontWeight', 'bold', 'FontAngle', 'normal');
                        title({sprintf('Total Error^2 per object eaten for %s\ncontrolling for soma',arch)},...
                            'FontName','Cambria', 'FontSize', 18, ...
                           'FontWeight', 'bold', 'Color', [0 0 0]);

