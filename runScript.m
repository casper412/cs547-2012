clear
close all
s = Sim;
archDescription='7'; % This is what is appended to the word Architecture in the title.
blah = Arch7;
runs=35;
[arch7_stats, arch7_output] = s.doSim(blah,runs,1);

stats=arch7_stats;
output=arch7_output;
% save
% 
% %speed is output(:,2),  xposition is output(:,6), yposition is output(:,7)
% 
% 
[timeHist, totEatHist, eatTypeBar, distHist]=plotHelper(stats, output, archDescription); 

%stats are food, poison, neutral
arch7_lifestats(1,1)=min(stats(:,4));
arch7_lifestats(1,2)=mean(stats(:,4));
arch7_lifestats(1,3)=max(stats(:,4));
arch7_lifestats(1,4)=std(stats(:,4));

arch7_foodstats(1,1)=min(sum(stats(:,1:3),2));
arch7_foodstats(1,2)=mean(sum(stats(:,1:3),2));
arch7_foodstats(1,3)=max(sum(stats(:,1:3),2));
arch7_foodstats(1,4)=std(sum(stats(:,1:3),2));

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
arch7_diststats(1,1)=min(distPerOb);
arch7_diststats(1,2)=mean(distPerOb);
arch7_diststats(1,3)=max(distPerOb);
arch7_diststats(1,4)=std(distPerOb);

save('arch7_workspace')

% rowHeads={'Arch0', 'arch7', 'arch7', 'arch7', 'Arch4', 'Arch5', 'Arch6', 'Arch'};
% colHeads={'min', 'mean', 'max', 'STD'};
% lifeData=100*rand(8,4);
% topic='Life Span';
% 
% tabl=gentable(lifeData, topic, rowHeads, colHeads)