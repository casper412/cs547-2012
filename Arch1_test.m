clear all
s = Sim;
blah = Arch1;
[stats output] = s.doSim(blah);

eyes=output(:,(end-92:end),1);  %eyes start on index 42

d=output(:,23,1);
    

%% User Inputs and Initial Conditions
d=data(:,3);
w_initial=[0 0 0];
w0=w_initial;
x=[ones(length(x1),1),x1,x2];
eta0=.01;
eta=eta0;
w1=0;
maxepochs=449;
weights_ord(1,:)=w0;
threshold=.85;
convergence_thresh=1.001;
eperror(1)=0;

%% LMS Neuron
for epoch=1:maxepochs;
    e0=0;
    for n=1:length(x1); % run neuron for each row (n) of data.
              [e(n) ,w1]=LMS(w0,x(n,:),d(n),eta); %call the LMS neuron
              w0=w1; %input w0 reinitialized to current w1.
              e0=e(n); %update error for convergence criteria
    end
    eperror(epoch+1)=sum(e); %publish the final error 
    delta_error=(eperror(epoch)-eperror(epoch+1)^2)/eperror(epoch); % compute delta error for convergence criteria
    weights_ord(epoch+1,:)=w1;
                 if delta_error < convergence_thresh && epoch ~=1;
                    converge_ord=[(sprintf('error converged in %d epochs.  (delta error)^2/error was < %1.3d\n',epoch,convergence_thresh)),...
                        sprintf('sum(RMS error) = %g', eperror(epoch+1))];
                 %break
                 else
                    converge_ord=[sprintf('error failed to converge in %1.1d epochs. Final error = %1.3d\n',...
                        epoch, eperror(epoch)),sprintf('(delta error)^2/error = %g', delta_error)];
                end
end

%% Plots and Results
theo=w1*x';
if rand==0
        figlabl_weights='LMS evolution of weight values per Epoch (ordered)';
elseif rand==1
        figlabl_weights='LMS evolution of weight values per Epoch (randomized)'
else rand==2
        figlabl_weights='LMS evolution of weight values per Epoch (randomized 2)'
end

            weightimage=figure;
                        plot(weights_ord(:,1),'-b','linewidth', 2)
                        hold on
                        plot(weights_ord(:,2),'-g', 'linewidth',2)
                        hold on
                        plot(weights_ord(:,3), '-r', 'linewidth',2)
                        axis([1, epoch+1, min(min(weights_ord))-1, max(max(weights_ord))+1])
                        xlabel({'epoch number',converge_ord}, 'FontName', 'Cambria', 'FontSize', 12, ...
                        'FontWeight', 'bold');
                        ylabel('weight values', 'FontName', 'Cambria', 'FontSize', 12, ...
                           'FontWeight', 'bold', 'FontAngle', 'normal');
                        title({(figlabl_weights),['Eta = ',sprintf('%1.2f',eta0),', w0 = [',num2str(w_initial),'] w=[',num2str(weights_ord(epoch+1,:)),']']},...
                            'FontName','Cambria', 'FontSize', 14, ...
                           'FontWeight', 'bold', 'Color', [0 0 0]);
                       legend('w0','w1','w2')
                       
if rand==0
        figlabl_or='sum(LMS Error) after each Epoch (ordered)';
elseif rand==1
        figlabl_or='sum(LMS Error) after each Epoch (randomized)'
else rand==2
        figlabl_or='sum(LMS Error) after each Epoch (randomized 2)'
end
                       

                  errorimage=figure;
                        plot(eperror(2:end),'-b','linewidth', 2)
                        xlabel('epoch number', 'FontName', 'Cambria', 'FontSize', 14, ...
                             'FontWeight', 'bold');
                        ylabel('error', 'FontName', 'Cambria', 'FontSize', 14, ...
                             'FontWeight', 'bold', 'FontAngle', 'normal');
                         title({(figlabl_or),['Eta = ',sprintf('%1.2f',eta0),', w0 = [',num2str(w_initial),'] w=[',num2str(w1),']'],...
                             (converge_ord)}, 'FontName','Cambria', 'FontSize', 14, ...
                             'FontWeight', 'bold', 'Color', [0 0 0]);
%                        legend('ordered data','randomized data')

if rand==0
        figlabl_perf='Performance of LMS Algorithm vs. Desired Value (ordered)';
elseif rand==1
        figlabl_perf='Performance of LMS Algorithm vs. Desired Value (randomized)'
else rand==2
        figlabl_perf='Performance of LMS Algorithm vs. Desired Value (randomized 2)'
end


            perfimage=figure;
                        plot(theo,'-xr','linewidth', 2)
                        hold on
                        plot(d,'-ob', 'linewidth',1.0)
                        axis([1, n, -1.5, 1.5])
                        xlabel({'Data Index',converge_ord}, 'FontName', 'Cambria', 'FontSize', 12, ...
                        'FontWeight', 'bold');
                        ylabel('Result Value', 'FontName', 'Cambria', 'FontSize', 12, ...
                           'FontWeight', 'bold', 'FontAngle', 'normal');
                        title({(figlabl_perf),['Eta = ',sprintf('%1.2f',eta0),', w0 = [',num2str(w_initial),'] w=[',num2str(weights_ord(epoch+1,:)),']']}, 'FontName','Cambria', 'FontSize', 14, ...
                           'FontWeight', 'bold', 'Color', [0 0 0]);
                       legend('LMS','Actual','Location','East')

