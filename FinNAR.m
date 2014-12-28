% Sfin= load('interp_returns.txt');
Sfin(:,22);

[M11,N11]=size(Sfin(:,22));
k=Sfin(2:M11,22);
[M11,N11]=size(k);
k1=zeros(floor(M11/5),1);

for i= 1:floor(M11/5)
k1(i,1)= sum(k(5*i:-1:5*i-4,1))/5;
end

SM=k1;

[M,N]= size(SM);

train=0.7;
test=0.3;

S=SM(1:floor(0.7*M));
S1=SM(floor(0.7*M)+1:M);

targetSeries = tonndata(S,false,false);
testseries = tonndata(S1,false,false);


% Create a Nonlinear Autoregressive Network
% feedbackDelays = 1:4;
% hiddenLayerSize = 10;
feedbackDelays = 1:50;
hiddenLayerSize = 2;

net = narnet(feedbackDelays,hiddenLayerSize);

% Prepare the Data for Training and Simulation
% The function PREPARETS prepares timeseries data for a particular network,
% shifting time by the minimum amount to fill input states and layer states.
% Using PREPARETS allows you to keep your original time series data unchanged, while
% easily customizing it for networks with differing numbers of delays, with
% open loop or closed loop feedback modes.
[inputs,inputStates,layerStates,targets] = preparets(net,{},{},targetSeries);
[tests,inputStates1,layerStates1,targets1] = preparets(net,{},{},testseries);



% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;


% Train the Network
[net,tr] = train(net,inputs,targets,inputStates,layerStates);

% Test the Network
outputs = net(inputs,inputStates,layerStates);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs);


outputs1 = net(tests,inputStates1,layerStates1);

% View the Network
view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
figure, plotresponse(targets,outputs);
figure, plotresponse(tests,outputs1);
%figure, ploterrcorr(errors)
%figure, plotinerrcorr(inputs,errors)

% Closed Loop Network
% Use this network to do multi-step prediction.
% The function CLOSELOOP replaces the feedback input with a direct
% connection from the outout layer.
netc = closeloop(net);
[xc,xic,aic,tc] = preparets(netc,{},{},targetSeries);
yc = netc(xc,xic,aic);
perfc = perform(net,tc,yc);

% Early Prediction Network
% For some applications it helps to get the prediction a timestep early.
% The original network returns predicted y(t+1) at the same time it is given y(t+1).
% For some applications such as decision making, it would help to have predicted
% y(t+1) once y(t) is available, but before the actual y(t+1) occurs.
% The network can be made to return its output a timestep early by removing one delay
% so that its minimal tap delay is now 0 instead of 1.  The new network returns the
% same outputs as the original network, but outputs are shifted left one timestep.
output11 = sim(net,tests);


nets = removedelay(net);
[xs,xis,ais,ts] = preparets(nets,{},{},targetSeries);
ys = nets(xs,xis,ais);
closedLoopPerformance = perform(net,tc,yc) ;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


error1 = gsubtract(tests,outputs1);
[a,b]=size(error1);
MSE=sum(cell2mat(error1).^2)/b;

mmse= (var(cell2mat(error1)))/var(cell2mat(outputs1));
