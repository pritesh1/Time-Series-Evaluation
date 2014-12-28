% Solve an Autoregression Time-Series Problem with a NAR Neural Network
% Script generated by NTSTOOL
% Created Sun Apr 20 12:58:09 EDT 2014
% This script assumes this variable is defined:


clc;
clear all;
%Preprocessing
 A = load('sunspots.dat');
 
 [M,N]= size(A);
 TrainRatio = 0.7;
TrainLen = round(TrainRatio*M);
S = A(1:TrainLen,:);
S1 = A(TrainLen+1:M,:);

 
 
% S = load('sunspots7.txt');
% S1 = load('sunspots3.txt');

% S = load('monthly7.txt');
% S1 = load('monthly3.txt');

% S = load('financial22_7.txt');
% S1 = load('financial22_3.txt');


[M,N]= size(S);
[M1,N1]= size(S1);



targetSeries = tonndata(S,false,false);
testseries = tonndata(S1,false,false);


% Create a Nonlinear Autoregressive Network
% feedbackDelays = 1:40;
% hiddenLayerSize = 4;
% feedbackDelays = 1:50;
% hiddenLayerSize = 2;
feedbackDelays = 1:10;
hiddenLayerSize = 6;

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
% figure, plotresponse(targets,outputs);
figure, plotresponse(tests,outputs1);
%figure, ploterrcorr(errors)
%figure, plotinerrcorr(inputs,errors)

% Closed Loop Network
% Use this network to do multi-step prediction.
% The function CLOSELOOP replaces the feedback input with a direct
% connection from the outout layer.


% netc = closeloop(net);
% [xc,xic,aic,tc] = preparets(netc,{},{},targetSeries);
% [xc1,xic1,aic1,tc1] = preparets(netc,{},{},testseries);
% yc = netc(xc,xic,aic);
% outputs11 = netc(xc1,xic1,aic1);
% perfc = perform(net,tc,yc);
% figure, plotresponse(tests,outputs11);
% view(netc)

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
% closedLoopPerformance = perform(net,tc,yc) ;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


error1 = gsubtract(tests,outputs1);
[a,b]=size(error1);
MSE=sum(cell2mat(error1).^2)/b;

Nmse= (var(cell2mat(error1)))/var(cell2mat(tests));

