%clear
%close all
s = Sim;
blah = Arch2;
runs=1;
[stats, output] = s.doSim(blah,1);
arch='architecture 2'
%touchwaits=blah.learn;  save blah.weights and just run doSim without
%blah=Arch2.
%eyeweights=blah.eye0
%earwaits=blah.weights;
saveflag=1;

if saveflag
      statsFile = sprintf('weights\%s_stats_%d-%d.mat',arch, runs,now);
      save('statsFile', 'stats')
      
      outputFile = sprintf('weights\%s_output_%d-%d.mat',arch, runs,now);
      save('outputFile', 'output')

%       eyeweightFile = sprintf('weights\%s_weights_%d-%d.mat', arch, runs,now);
%       save(eyeweightFile, 'eyeweights')
      
end

  
            figure; %histogram of life spans
                       hist(stats(:,4))
                       title({sprintf('Histogram of Life Span for %s\nin total time steps',arch)},...
                            'FontName','Cambria', 'FontSize', 18, ...
                           'FontWeight', 'bold', 'Color', [0 0 0]);
                       xlabel({sprintf('Time Steps\n\nAverage life span = %1.1f time steps',mean(stats(:,4)))}, 'FontName', 'Cambria', 'FontSize', 16, ...
                        'FontWeight', 'bold');
                       ylabel('total error', 'FontName', 'Cambria', 'FontSize', 16, ...
                           'FontWeight', 'bold', 'FontAngle', 'normal');

             figure; %histogram of objects eaten
                       hist(stats(:,1:3))
                       title({sprintf('Histogram of Objects Eaten for %s\nin total time steps',arch)},...
                            'FontName','Cambria', 'FontSize', 18, ...
                           'FontWeight', 'bold', 'Color', [0 0 0]);
                       xlabel({sprintf('Number of Objects\n\nAverage food objects = %1.1f\nAverage poison objects = %1.1f\nAverage neutral objects = %1.1f',mean(stats(:,3)),mean(stats(:,2)),mean(stats(:,1)))}, 'FontName', 'Cambria', 'FontSize', 16, ...
                        'FontWeight', 'bold');
                       ylabel('total error', 'FontName', 'Cambria', 'FontSize', 16, ...
                           'FontWeight', 'bold', 'FontAngle', 'normal');
%                        h = findobj(gca,'Type','patch');
%                             set(h,'FaceColor','r','EdgeColor','w')
                       legend('food', 'poison', 'neutral')
                       
            figure;
                        plot(blah.totEr,'-b','linewidth', 1.0)
                        xlabel({sprintf('objects eaten\n total runs = %1d, objects eaten = %1d',runs,length(blah.totEr))}, 'FontName', 'Cambria', 'FontSize', 16, ...
                        'FontWeight', 'bold');
                        ylabel('total error', 'FontName', 'Cambria', 'FontSize', 16, ...
                           'FontWeight', 'bold', 'FontAngle', 'normal');
                        title({sprintf('Total Error per object eaten for %s\ncontrolling for soma',arch)},...
                            'FontName','Cambria', 'FontSize', 18, ...
                           'FontWeight', 'bold', 'Color', [0 0 0]);



