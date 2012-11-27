clear
close all
s = Sim;
archNum=1
blah = Arch1;
runs=4;
[stats, output] = s.doSim(blah,runs,1);
arch=sprintf('architecture 4 (LMS)');

%save
% this protects from flooding stat files that weren't significant due to me
% forgetting to set the saveflag to 0.
    
% if runs>20 
%     saveflag=1;
% else
%     saveflag=0;
% end
% 
% if saveflag
%       statsFile = sprintf('results/statfiles/%s_stats_%d-%d.mat',arch, runs,now);
%       save('statsFile', 'stats')
%       
%       outputFile = sprintf('results/outputfiles/%s_output_%d-%d.mat',arch, runs,now);
%       save('outputFile', 'output')


%       eyeweightFile = sprintf('weights\%s_weights_%d-%d.mat', arch, runs,now);
%       save(eyeweightFile, 'eyeweights')
      
% end
totalError=[10 9 8 7 6];

[timeHist, totEatHist, eatTypeBar, errPlot]=plotHelper(stats, totalError, archNum); 
%             figure; %histogram of life spans
%                        hist(stats(:,4))
%                        title({sprintf('Histogram of Life Span for %s\nin total time steps',arch)},...
%                             'FontName','Cambria', 'FontSize', 18, ...
%                            'FontWeight', 'bold', 'Color', [0 0 0]);
%                        xlabel({sprintf('Time Steps\n\nAverage life span = %1.1f time steps\nStd. Dev. = %1.1f',mean(stats(:,4)),std(stats(:,4)))}, 'FontName', 'Cambria', 'FontSize', 16, ...
%                         'FontWeight', 'bold');
%                        ylabel('Total Occurrences', 'FontName', 'Cambria', 'FontSize', 16, ...
%                            'FontWeight', 'bold', 'FontAngle', 'normal');
% 
%              figure; %histogram of objects eaten
%                        hist(stats(:,1:3))
%                        title({sprintf('Histogram of Objects Eaten for %s\nin total time steps',arch)},...
%                             'FontName','Cambria', 'FontSize', 18, ...
%                            'FontWeight', 'bold', 'Color', [0 0 0]);
%                        xlabel({sprintf('Number of Objects\n\nAverage food objects = %1.1f\nAverage poison objects = %1.1f\nAverage neutral objects = %1.1f',mean(stats(:,1)),mean(stats(:,2)),mean(stats(:,3)))}, 'FontName', 'Cambria', 'FontSize', 16, ...
%                         'FontWeight', 'bold');
%                        ylabel('Total Occurrences', 'FontName', 'Cambria', 'FontSize', 16, ...
%                            'FontWeight', 'bold', 'FontAngle', 'normal');
% %                        h = findobj(gca,'Type','patch');
% %                             set(h,'FaceColor','r','EdgeColor','w')
%                        legend('food', 'poison', 'neutral')
%                        
%                        figure; %histogram of objects eaten
%                        plot(stats(:,1:3))
%                        title({sprintf('Objects Eaten per life event for %s\nin total time steps',arch)},...
%                             'FontName','Cambria', 'FontSize', 18, ...
%                            'FontWeight', 'bold', 'Color', [0 0 0]);
%                        xlabel({sprintf('Life Event\n\nAverage food objects = %1.1f\nAverage poison objects = %1.1f\nAverage neutral objects = %1.1f',mean(stats(:,1)),mean(stats(:,2)),mean(stats(:,3)))}, 'FontName', 'Cambria', 'FontSize', 16, ...
%                         'FontWeight', 'bold');
%                        ylabel('Total Occurrences', 'FontName', 'Cambria', 'FontSize', 16, ...
%                            'FontWeight', 'bold', 'FontAngle', 'normal');
% %                        h = findobj(gca,'Type','patch');
% %                             set(h,'FaceColor','r','EdgeColor','w')
%                        legend('food', 'poison', 'neutral')
%                        
% %             figure;
% %                         plot(blah.eye0.totalError,'-b','linewidth', 1.0)
% %                         xlabel({sprintf('objects eaten\n\nTotal runs = %1d, Total objects eaten = %1d',runs,length(blah.eye0.totalError))}, 'FontName', 'Cambria', 'FontSize', 16, ...
% %                         'FontWeight', 'bold');
% %                         axis([0, length(blah.eye0.totalError)+2, 0, 1.1*max(blah.eye0.totalError)])
% %                         ylabel('total error', 'FontName', 'Cambria', 'FontSize', 16, ...
% %                            'FontWeight', 'bold', 'FontAngle', 'normal');
% %                         title({sprintf('Total Error per object eaten for %s',arch)},...
% %                             'FontName','Cambria', 'FontSize', 18, ...
% %                            'FontWeight', 'bold', 'Color', [0 0 0]);
% 
% 
% 
