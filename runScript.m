clear
close all
s = Sim;
archDescription='5 (wide eyes)';
blah = Arch5;
runs=1;
[stats, output] = s.doSim(blah,runs,1);


% save
% 
% %speed is output(:,2),  xposition is output(:,6), yposition is output(:,7)
% 
% 
[timeHist, totEatHist, eatTypeBar, distHist]=plotHelper(stats, output, archDescription); 

%stats are food, poison, neutral