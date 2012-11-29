function [timeHist, totEatHist, eatTypeBar, distHist]=plotHelper(stats, output, archDescription)
%   [timeHist, totEatHist, eatTypeBar, errPlot]=plotHelper(stats, totalError, archDescription)
%   Creates {histogram of time steps for each run, histogram of total objects eaten 
%   a stacked bar plot of the type of objects eaten, and a
%   total error plot] that can be used only for artificial neural network
%   evaluation plots. 
%   Input (stats) is expected to be the stats output from the typical object we've
%   used.  

%   archDescription is a string that is appended to the word "architecture" 
%   be specified in the plot headers.  For example archDescription= '5
%   (spread eyes)'  will result in a plot that says Architecture 5 (spread
%   eyes).

            timeHist=figure; %histogram of life spans
                       hist(stats(:,4))%/size(stats,1)
                       title({sprintf('Histogram of Life Span in total time steps\nArchitecture %s ',archDescription)},...
                            'FontName','Times New Roman', 'FontSize', 18, ...
                           'FontWeight', 'bold', 'Color', [0 0 0]);
                       xlabel({sprintf('Time Steps\n\nAverage life span = %1.1f (timesteps) STD = %1.1f\nMin Lifespan = %d, Max Lifespan = %d',mean(stats(:,4)),std(stats(:,4)),min(stats(:,4)),max(stats(:,4)))},...
                           'FontName', 'Times New Roman', 'FontSize', 16, ...
                        'FontWeight', 'bold');
                       ylabel('Occurrences ', 'FontName', 'Times New Roman', 'FontSize', 16, ...
                           'FontWeight', 'bold', 'FontAngle', 'normal');
                      
                       
                       
                       for i=1:size(stats,1)
                            a(i)=sum(stats(i, 1:3));
                       end
                     ;
                       totEatHist=figure; %histogram of objects eaten
                       hist(a)
                       title({sprintf('Histogram of Total Objects Eaten\nArchitecture %s',archDescription)},...
                           'FontName','Times New Roman', 'FontSize', 18, ...
                           'FontWeight', 'bold', 'Color', [0 0 0]);
                       xlabel({sprintf('Number of Objects\n\nAverage total objects eaten = %1.1f, STD=%1.1f\nAverage food objects = %1.1f, STD = %1.1f\nAverage poison objects = %1.1f, STD = %1.1f\nAverage neutral objects = %1.1f, STD=%1.1f',mean(a), std(a), mean(stats(:,1)),std(stats(:,1)), mean(stats(:,2)),std(stats(:,2)),mean(stats(:,3)), std(stats(:,3)))}, 'FontName', 'Times New Roman', 'FontSize', 16, ...
                           'FontWeight', 'bold');
                       ylabel('Occurrences ', 'FontName', 'Times New Roman', 'FontSize', 16, ...
                           'FontWeight', 'bold', 'FontAngle', 'normal');

                 
                       

                        % Double check that I have my columns right
%                         neutral = sum(stats(:,3));
%                         food = sum(stats(:,1));
%                         poison = sum(stats(:,2));
                        neutral = (stats(:,3));
                        food = (stats(:,1));
                        poison = (stats(:,2));
                        
                        Y=[neutral food poison];
                        Y(2,:) = 0; 

                        % Create a stacked bar chart using the bar function
                  eatTypeBar=figure
%                         bar( Y,0.5,'stack');
%                         ax = axis; ax(2) = 1.6;
%                         axis(ax)
                       bar(Y,'stack')
                        % Add title and axis labels
                       title({sprintf('Bar Graph of Type Objects Eaten\n for Architecture %s',archDescription)},...
                            'FontName','Times New Roman', 'FontSize', 18, ...
                           'FontWeight', 'bold', 'Color', [0 0 0]);
                       xlabel({sprintf('Run Number\nTotal objects eaten=%d\nFood=%d, Poison=%d, Neutral=%d',sum(sum(Y)),sum(Y(:,2)), sum(Y(:,3)),sum(Y(:,1)))}, 'FontName', 'Times New Roman', 'FontSize', 16, ...
                        'FontWeight', 'bold');
                       ylabel('Total Objects', 'FontName', 'Times New Roman', 'FontSize', 16, ...
                           'FontWeight', 'bold', 'FontAngle', 'normal');

                        % Add a legend
                        legend('Neutral', 'Food', 'Poison');
                        
%                 errPlot=figure;
%                         plot(totalError,'-b','linewidth', 1.0)
%                         xlabel({sprintf('objects eaten\n\nTotal runs = %1d, Total objects eaten = %1d',size(stats,1),length(totalError))}, 'FontName', 'Times New Roman', 'FontSize', 16, ...
%                         'FontWeight', 'bold');
%                         axis([0, length(totalError)+2, 0, 1.1*max(totalError)])
%                         ylabel('total error', 'FontName', 'Times New Roman', 'FontSize', 16, ...
%                            'FontWeight', 'bold', 'FontAngle', 'normal');
%                         title({sprintf('Total Error per object eaten for Architecture %d',archDescription)},...
%                             'FontName','Times New Roman', 'FontSize', 18, ...
%                            'FontWeight', 'bold', 'Color', [0 0 0]);

             for i=1:size(output,3)
                 dist_(i)=sum(output(:,2,i))
             end
             for i=1:size(output,3)
                 distPerOb(i)=sum(output(:,2,i))/sum(stats(i,1:3));
             end

             distHist=figure; %histogram of distance traveled

                       hist(dist_)
                       title({sprintf('Histogram of Total Distance Traveled\nArchitecture %s',archDescription)},...
                            'FontName','Times New Roman', 'FontSize', 18, ...
                           'FontWeight', 'bold', 'Color', [0 0 0]);
                       xlabel({sprintf('Number of Objects\n\nAverage total distance = %1.1f, STD=%1.1f\nAve. dist. per object eaten = %1.1f, STD = %1.1f',mean(dist_), std(dist_), mean(distPerOb),std(distPerOb))}, 'FontName', 'Times New Roman', 'FontSize', 16, ...
                        'FontWeight', 'bold');
                       ylabel('Occurrences ', 'FontName', 'Times New Roman', 'FontSize', 16, ...
                           'FontWeight', 'bold', 'FontAngle', 'normal');

end

