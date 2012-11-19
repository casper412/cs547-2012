%close all
clear all


for shuffle=1;  % Shuffle for the requirements of HW 4.  1 is 0 is ordered, 1 is shuffle on epoch, and 2 is randomize once.
    tic
neurons=[3,3,3,4]; % This is your neural structure first layer is input neurons, 
%last number is output neurons, and there can be 1-3 inner layers.  Any
%number of neurons are possible in each layer for example [10, 24, 3] or
%[3, 16, 50, 47, 5]
maxepochs=100;

%load input data
testset=load('TestingData.txt');
trainset=load('TrainingData.txt');

%shuffling method
if shuffle == 2
    trainset = trainset(randperm(size(trainset,1)),:);
    testset = testset(randperm(size(testset,1)),:);
end

% define your input vectors and your desired value vectors
xtrain=[ones(length(trainset),1),trainset(:,3:4)];
xtest=[ones(length(testset),1),testset(:,3:4)];
dtrain=trainset(:,1);
dtest=testset(:,1);

%% Part B: Plot Data Sets
% data=trainset;  
% if data==testset
%     plottype='Test'
% else
%     plottype='Training'
% end
% 
%                         figure
%                         plot(data(1:200,3),data(1:200,4),'xb')
%                         hold on
%                         plot(data(201:400,3),data(201:400,4),'og','linewidth',1)
%                         hold on
%                         plot(data(401:600,3),data(401:600,4),'*r','linewidth',1)
%                         hold on
%                         plot(data(601:800,3),data(601:800,4),'+k','linewidth',1)
%                         xlabel('x2', 'FontName', 'Cambria', 'FontSize', 16, ...
%                         'FontWeight', 'bold');
%                         ylabel('x1', 'FontName', 'Cambria', 'FontSize', 16, ...
%                            'FontWeight', 'bold', 'FontAngle', 'normal');
%                         title({['Scatter Plot of ',plottype,' Set Data'];['x1 vs. x2']},...
%                             'FontName','Cambria', 'FontSize', 18, ...
%                            'FontWeight', 'bold', 'Color', [0 0 0]);
%                        legend('1','2','3','4')
%% Part C
a=1.7159;  %as recommended on Haykin pg. 179
N=length(testset); %number of data points
momentum=0; %momentum term (doesn't work)
eta=.01; 
convergence_thresh=.001;
stopflag=0; % When stopflag = 5 declare that convergence has occurred

%initialize weights as random matrices for each layer after the input layer
w1 = -1 + (1--1).*rand(neurons(1),neurons(2)); %hidden layer one
w2 = -1 + (1--1).*rand(neurons(2),neurons(3));  %output layer or hidden layer two if >3 layers
if numel(neurons)==4
    w3 = -1 + (1--1).*rand(neurons(3),neurons(4));
elseif numel(neurons)==5
    w3 = -1 + (1--1).*rand(neurons(3),neurons(4));
    w4 = -1 + (1--1).*rand(neurons(4),neurons(5));
end

outlayer=numel(neurons); %figure out which index corresponds to outer layer

%map the desired value from single decimal into 4 binary values.  Then
%limit binary 1's to .9 to reduce error.
dmaptrain=zeros(length(trainset),neurons(end));
dmaptest=zeros(length(testset),neurons(end));
    for j=1:length(trainset)
        dmaptrain(j,dtrain(j))=.9;
    end
    for j=1:length(testset)
        dmaptest(j,dtest(j))=.9;
    end
for epoch=1:maxepochs
    epoch
            for n=1:N

                %forward prop

                                y0=xtrain(n,:);
                                v1=y0*w1;
                                y1=sigmoid(v1);

                                v2=y1*w2;
                                y2=sigmoid(v2);
                                yo=y2;

                                % continue forward prop if there are
                                % additional hidden layers
                                if numel(neurons)==4
                                v3=y2*w3;
                                y3=sigmoid(v3);
                                yo=y3;
                                end
                                
                                if numel(neurons)==5
                                v3=y2*w3;
                                y3=sigmoid(v3);
                                v4=y3*w4;
                                y4=sigmoid(v4);
                                yo=y4;
                                end
                                %for convergence check calculate average error energy of training set
                                %at presentation n.
                                e=dmaptrain(n,:)-yo;
                                er_energy_train(n)=1/4*sum(e.^2);
            %back prop use algoithm correponding to number of layers
            %present.
                for layer=1:outlayer-1        
                        for j=1:neurons(outlayer+1-layer)
                           if layer==1  %layer 1 will correpond to output layer
                               if numel(neurons)==5
                                delta4=e.*sigmoidPrime(a,v4); 
                                wprev4(j)=w4(j);
                                w4(:,j)=w4(:,j)+eta*delta4(j).*y3';
                               elseif numel(neurons)==4
                                delta3=e.*sigmoidPrime(a,v3); 
                                wprev3(j)=w3(j);
                                w3(:,j)=w3(:,j)+eta*delta3(j).*y2';  
                               elseif numel(neurons)==3
                                delta2=e.*sigmoidPrime(a,v2); 
                                wprev2(j)=w2(j);
                                w2(:,j)=w2(:,j)+eta*delta2(j).*y1';
                               else
                                 error('must have 3, 4, or 5 layers')
                               end
                           elseif layer==2 % corresponds to next layer from last
                               if numel(neurons)==5
                                        delta3=(sigmoidPrime(a,v3)).*(delta4*w4');  %third set of weights
                                        w3prev(:,j)=w3(:,j);
                                        w3(:,j)=w3(:,j)+momentum*w3prev(:,j)+eta*delta3(j).*y2';
                               elseif numel(neurons)==4
                                        delta2=(sigmoidPrime(a,v2)).*(delta3*w3');  %third set of weights
                                        w2prev(:,j)=w2(:,j);
                                        w2(:,j)=w2(:,j)+momentum*w2prev(:,j)+eta*delta2(j).*y1';
                               elseif numel(neurons)==3
                                        delta1=(sigmoidPrime(a,v1)).*(delta2*w2');  %third set of weights
                                        w1prev(:,j)=w1(:,j);
                                        w1(:,j)=w1(:,j)+momentum*w1prev(:,j)+eta*delta1(j).*y0';
                               else
                                 error('must have 3, 4, or 5 neurons')
                               end
                           elseif layer==3 %this will only execute if there are more than 3 layers
                                if numel(neurons)==5
                                        delta2=(sigmoidPrime(a,v2)).*(delta3*w3');  %second set of weights
                                        w2prev(:,j)=w2(:,j);
                                        w2(:,j)=w2(:,j)+momentum*w2prev(:,j)+eta*delta2(j).*y1';
                                elseif numel(neurons)==4
                                        delta1=(sigmoidPrime(a,v1)).*(delta2*w2');  %second set of weights
                                        w1prev(:,j)=w1(:,j);
                                        w1(:,j)=w1(:,j)+momentum*w1prev(:,j)+eta*delta1(j).*y0';
                                end
                           elseif layer==4 %this will execute if there are more than 5 layers.
                                delta1=(sigmoidPrime(a,v1)).*(delta2*w2');  %first set of weights
                                w1prev(:,j)=w1(:,j);
                                w1(:,j)=w1(:,j)+momentum*w1prev(:,j)+eta*delta1(j).*y0';
                           end
                        end % end 1: neurons in layer
                end % end back prop layers

                    %Begin test forward pass
                                y0=xtest(n,:);

                                v1=y0*w1;
                                y1=sigmoid(v1);

                                v2=y1*w2;
                                y2=sigmoid(v2);
                                yo=y2;

                                
                                if numel(neurons)==4
                                v3=y2*w3;
                                y3=sigmoid(v3);
                                yo=y3;
                                end
                                
                                if numel(neurons)==5
                                v3=y2*w3;
                                y3=sigmoid(v3);
                                v4=y3*w4;
                                y4=sigmoid(v4);
                                yo=y4;
                                end
                             
                                %calculate average error energy of test set
                                %at presentation n.
                                et=dmaptest(n,:)-yo;
                                er_energy_test(n)=1/4*sum(et.^2);  


            end %end n=1:N
%get generalized performance     
    aver_energy_train(epoch)=1/N*sum(er_energy_train);
    aver_energy_test(epoch)=1/N*sum(er_energy_test);
    
%shuffle presentation order if shuffle preference = 1.
if shuffle == 1
    shuftag='(shuffled ea. epoch)'
    trainset = trainset(randperm(size(trainset,1)),:);
    xtrain=[ones(length(trainset),1),trainset(:,3:4)];
    dtrain=trainset(:,1);
    
    testset = testset(randperm(size(testset,1)),:);
    xtrain=[ones(length(testset),1),testset(:,3:4)];
    dtrain=testset(:,1);
elseif shuffle==0
    shuftag='(sorted)'
elseif shuffle == 2
    shuftag='(randomized once)'
end
runtime=toc  
    %Create Figure tags for results analysis

        if epoch>1;% This means that convergence criteria has to occur for times in a row
                if abs((aver_energy_train(epoch)-aver_energy_train(epoch-1))/aver_energy_train(epoch)) < convergence_thresh
                    stopflag=stopflag+1
                    if stopflag>4
                        converge_tag=[sprintf('Error converged in %d epochs.\n',epoch),...
                            sprintf('Rate of change in ave. e^2 was < %1.3d\n',convergence_thresh),...
                                sprintf('Average Error Energy = %1.2f',aver_energy_train(epoch-1)), sprintf('; Run Time = %1.2f sec.',runtime)];
                        break
                    else
                         %reset stop flag if convergence fails.
                        converge_tag=[sprintf('Error failed to converge in %d epochs.\n',epoch),...
                            sprintf('Rate of change in ave. e^2 was > %1.3d\n',convergence_thresh),...
                                sprintf('Average Error Energy = %1.2g ',aver_energy_train(epoch)), sprintf('Run Time = %1.2s sec.',runtime)];
                    end
                else
                    stopflag=stopflag-1
                end
        end
end


%% Plots

        figlabl_aver=['Average Error Energy per Epoch ',shuftag]


            aver=figure;
                        plot(aver_energy_train,'-xb','linewidth', 1.25)
                        hold on
                        plot(aver_energy_test,'-g', 'linewidth',1.25)
                        xlabel({'epoch number',converge_tag}, 'FontName', 'Cambria', 'FontSize', 16, ...
                        'FontWeight', 'bold');
                        ylabel('error energy', 'FontName', 'Cambria', 'FontSize', 16, ...
                           'FontWeight', 'bold', 'FontAngle', 'normal');
                       if numel(neurons)==3
                        title({(figlabl_aver),strcat(num2str(numel(neurons)-2),' Hidden Layers'),['Eta = ',sprintf('%1.2f',eta),', alpha = ',sprintf('%1.2f',momentum),...
                            ', Neurons = [',sprintf('%1.0f',neurons(1)),',',sprintf('%1.0f',neurons(2)),',',sprintf('%1.0f',neurons(3)),']']},...
                            'FontName','Cambria', 'FontSize', 18, ...
                           'FontWeight', 'bold', 'Color', [0 0 0]);
                       elseif numel(neurons)==4
                            title({(figlabl_aver),strcat(num2str(numel(neurons)-2),' Hidden Layers'),['Eta = ',sprintf('%1.2f',eta),', alpha = ',sprintf('%1.2f',momentum),...
                            ', Neurons = [',sprintf('%1.0f',neurons(1)),',',sprintf('%1.0f',neurons(2)),',',sprintf('%1.0f',neurons(3)),',',sprintf('%1.0f',neurons(4)),']']},...
                            'FontName','Cambria', 'FontSize', 18, ...
                           'FontWeight', 'bold', 'Color', [0 0 0]);
                       else numel(neurons)==5
                            title({(figlabl_aver),strcat(num2str(numel(neurons)-2),' Hidden Layers'),['Eta = ',sprintf('%1.2f',eta),', alpha = ',sprintf('%1.2f',momentum),...
                            ', Neurons = [',sprintf('%1.0f',neurons(1)),',',sprintf('%1.0f',neurons(2)),',',sprintf('%1.0f',neurons(3)),',',sprintf('%1.0f',neurons(4)),',',sprintf('%1.0f',neurons(5)),']']},...
                            'FontName','Cambria', 'FontSize', 18, ...
                           'FontWeight', 'bold', 'Color', [0 0 0]);
                       end
                       legend('train','test','location', 'Northeast')

%clear all

end














%