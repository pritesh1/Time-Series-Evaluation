%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab Project 
% 
% Module:NAR time series module
% 
% Usage: To predict new sample values using Least mean square method.
% 
% Purpose: Take an input sequence of data and load it according to time
% steps across rows. 
% 
% Input:Sunspots and Financial monthly data.
% 
% Output= Nmse , S12 
%      
% Flow Chart:
% 1.)Data processing
% 2.)Linear Autoregression
% 3.)Scaling
% 4.)Prediction
% 5.)Performance and mean square error
% 
% Authors Pritesh Rajesh Kanani
%         
% 
% Date- 04/31/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Solve an Autoregression Time-Series Problem with a NAR Neural Network
% Script generated by NTSTOOL
% Created Sun Apr 20 12:58:09 EDT 2014
% This script assumes this variable is defined:


clc;
clear all;
%Preprocessing
%  A = load('sunspots.dat');
 A11= load('findata.txt');
[M11,N11]=size(A11);
 

% uncomment below for  all companies display
% for company = 1:NN1   
for company = 1:10
A=A11(:,22);

[MM,NN]= size(A);
TrainRatio = 0.7;
TrainLen = round(TrainRatio*MM);
S = A(1:TrainLen,:);
S1 = A(TrainLen+1:MM,:);


[M,N]= size(S);
[M1,N1]= size(S1);



targetSeries = tonndata(A,false,false);
% testseries = tonndata(S1,false,false);
% Create a Nonlinear Autoregressive Network
% feedbackDelays = 1:40;
% hiddenLayerSize = 4;
% feedbackDelays = 1:50;
% hiddenLayerSize = 2;
for k=5:15
feedbackDelays = 1:k;
hiddenLayerSize = 6;

net = narnet(feedbackDelays,hiddenLayerSize);

% Prepare the Data for Training and Simulation
% The function PREPARETS prepares timeseries data for a particular network,
% shifting time by the minimum amount to fill input states and layer states.
% Using PREPARETS allows you to keep your original time series data unchanged, while
% easily customizing it for networks with differing numbers of delays, with
% open loop or closed loop feedback modes.
[inputs,inputStates,layerStates,targets] = preparets(net,{},{},targetSeries);
% [tests,inputStates1,layerStates1,targets1] = preparets(net,{},{},testseries);



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


% No testing needed as we remain adaptive.
% outputs1 = net(tests,inputStates1,layerStates1);

% View the Network
% view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
% figure, plotresponse(targets,outputs);
%figure, plotresponse(tests,outputs1);
%figure, ploterrcorr(errors)
%figure, plotinerrcorr(inputs,errors)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


error1 = gsubtract(targets,outputs);
[a,b]=size(error1);
MSE=sum(cell2mat(error1).^2)/b;

XX=cell2mat(error1);
XXX=cell2mat(targets);

Nmse(k,company)= (var(XX(:,TrainLen+1:MM-k)))/(var(XXX(:,TrainLen+1:MM-k,:)));

% Nmse1= (var(XX))/(var(XXX));

end
end