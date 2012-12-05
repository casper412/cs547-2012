clear
close all
s = Sim;
archDescription='6'; % This is what is appended to the word Architecture in the title.
blah = Arch6;
runs=35;
[arch6_stats, arch6_speed] = s.doSim(blah,runs,0);

stats=arch6_stats;
output=arch6_speed;
% save
% 
% %speed is output(:,2),  xposition is output(:,6), yposition is output(:,7)
% 
% 
[timeHist, totEatHist, eatTypeBar, distHist]=plotHelper(stats, output, archDescription); 

%stats are food, poison, neutral
arch6_lifestats(1,1)=min(stats(:,4));
arch6_lifestats(1,2)=mean(stats(:,4));
arch6_lifestats(1,3)=max(stats(:,4));
arch6_lifestats(1,4)=std(stats(:,4));

arch6_foodstats(1,1)=min(sum(stats(:,1:3),2));
arch6_foodstats(1,2)=mean(sum(stats(:,1:3),2));
arch6_foodstats(1,3)=max(sum(stats(:,1:3),2));
arch6_foodstats(1,4)=std(sum(stats(:,1:3),2));

             for i=1:size(output,3)
                 dist_(i,1)=sum(output(:,1,i))
             end
             
             for i=1:size(output,3)
                 if sum(stats(i,1:3))~=0
                    distPerOb(i,1)=dist_(i)/sum(stats(i,1:3));
                 else
                     distPerOb(i,1)=dist_(i)
                 end
             end
arch6_diststats(1,1)=min(distPerOb);
arch6_diststats(1,2)=mean(distPerOb);
arch6_diststats(1,3)=max(distPerOb);
arch6_diststats(1,4)=std(distPerOb);

save('arch6_workspace')

% rowHeads={'Arch0', 'arch6', 'arch6', 'arch6', 'arch6', 'arch6', 'arch6', 'Arch'};
% colHeads={'min', 'mean', 'max', 'STD'};
% lifeData=100*rand(8,4);
% topic='Life Span';
% 
% tabl=gentable(lifeData, topic, rowHeads, colHeads)