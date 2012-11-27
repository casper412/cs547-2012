function [timeHist, totEatHist, eatTypeBar, errPlot]=plotHelper(stats, totalError, archNum)
%   [timeHist, totEatHist, eatTypeBar, errPlot]=plotHelper(stats, totalError, archNum)
%   Creates {histogram of time steps for each run, histogram of total objects eaten 
%   a stacked bar plot of the type of objects eaten, and a
%   total error plot] that can be used only for artificial neural network
%   evaluation plots. 
%   Input (stats) is expected to be the stats output from the typical object we've
%   used.  archNum is an integer specifying which architecture number will
%   be specified in the plot headers.

            timeHist=figure; %histogram of life spans
                       hist(stats(:,4))%/size(stats,1)
                       title({sprintf('Histogram of Life Span for Architecture %d\nin total time steps',archNum)},...
                            'FontName','Times New Roman', 'FontSize', 18, ...
                           'FontWeight', 'bold', 'Color', [0 0 0]);
                       xlabel({sprintf('Time Steps\n\nAverage life span = %1.1f (timesteps) STD = %1.1f\nMin Lifespan = %d, Max Lifespan = %d',mean(stats(:,4)),std(stats(:,4)),min(stats(:,4)),max(stats(:,4)))},...
                           'FontName', 'Times New Roman', 'FontSize', 16, ...
                        'FontWeight', 'bold');
                       ylabel('Occurrences ', 'FontName', 'Times New Roman', 'FontSize', 16, ...
                           'FontWeight', 'bold', 'FontAngle', 'normal');
            a=stats(:, 1:3);
            totaleats=sum(sum(a));
             totEatHist=figure; %histogram of objects eaten
                       hist(sum(stats(:,1:3),2))
                       title({sprintf('Histogram of Total Objects Eaten for Architecture %d',archNum)},...
                            'FontName','Times New Roman', 'FontSize', 18, ...
                           'FontWeight', 'bold', 'Color', [0 0 0]);
                       xlabel({sprintf('Number of Objects\n\nAverage total objects eaten = %1.1f, STD=%1.1f\nAverage food objects = %1.1f, STD = %1.1f\nAverage poison objects = %1.1f, STD = %1.1f\nAverage neutral objects = %1.1f, STD=%1.1f',mean(mean(stats(:,1:3))), std(mean(stats(:,1:3))), mean(stats(:,1)),std(stats(:,1)), mean(stats(:,2)),std(stats(:,2)),mean(stats(:,3)), std(stats(:,3)))}, 'FontName', 'Times New Roman', 'FontSize', 16, ...
                        'FontWeight', 'bold');
                       ylabel('Occurrences ', 'FontName', 'Times New Roman', 'FontSize', 16, ...
                           'FontWeight', 'bold', 'FontAngle', 'normal');
%                        h = findobj(gca,'Type','patch');
%                             set(h,'FaceColor','r','EdgeColor','w')
%                        legend('food', 'poison', 'neutral')
                 
                       

                        % Double check that I have my columns right
                        neutral = sum(stats(:,3));
                        food = sum(stats(:,1));
                        poison = sum(stats(:,2));
                        
                        Y=[neutral food poison];
                        Y(2,:) = 0; 

                        % Create a stacked bar chart using the bar function
                  eatTypeBar=figure
                        bar( Y,0.5,'stack');
                        ax = axis; ax(2) = 1.6;
                        axis(ax)

                        % Add title and axis labels
                       title({sprintf('Bar Graph of Type Objects Eaten for Architecture %d',archNum)},...
                            'FontName','Times New Roman', 'FontSize', 18, ...
                           'FontWeight', 'bold', 'Color', [0 0 0]);
                       xlabel({sprintf('Architecture %d\nTotal objects eaten=%d\nFood=%d, Poison=%d, Neutral=%d',archNum, sum(sum(Y)),Y(1,2), Y(1,3),Y(1,1))}, 'FontName', 'Times New Roman', 'FontSize', 16, ...
                        'FontWeight', 'bold');
                       ylabel('Total Objects', 'FontName', 'Times New Roman', 'FontSize', 16, ...
                           'FontWeight', 'bold', 'FontAngle', 'normal');

                        % Add a legend
                        legend('Neutral', 'Food', 'Poison');
                        
                errPlot=figure;
                        plot(totalError,'-b','linewidth', 1.0)
                        xlabel({sprintf('objects eaten\n\nTotal runs = %1d, Total objects eaten = %1d',size(stats,1),length(totalError))}, 'FontName', 'Times New Roman', 'FontSize', 16, ...
                        'FontWeight', 'bold');
                        axis([0, length(totalError)+2, 0, 1.1*max(totalError)])
                        ylabel('total error', 'FontName', 'Times New Roman', 'FontSize', 16, ...
                           'FontWeight', 'bold', 'FontAngle', 'normal');
                        title({sprintf('Total Error per object eaten for Architecture %d',archNum)},...
                            'FontName','Times New Roman', 'FontSize', 18, ...
                           'FontWeight', 'bold', 'Color', [0 0 0]);

end

