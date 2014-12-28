%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab Project 
% 
% Module: LMS.m
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
% 2.)Feedforward neural network with backpropagation
% 3.)Scaling
% 4.)Prediction
% 5.)Performance and normalized mean square error
% 
% Authors Pritesh Rajesh Kanani
%         
% 
% Date- 04/31/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create a feedforward backproagation network using newff
% net = newff(PR,[S1 S2...SNl],{TF1 TF2...TFNl})
% Sk is the kth hidden layer 
% TF is the transfer function  default = 'tansig'.
% The data is a time series data . The past p values are fed into the
% multiple layer neural network . The advantage is that any number of
% hidden layers can be chosen 

clc;
clear all;
clf;

% Preprocessing;
% S = load('sunspots.dat');

A= load('findata.txt');
[M11,N11]=size(A);

S=A(:,11);
[M,N]=size(S);


K=One(M,N);
m=(S'*K)/M;
S=S-m*K;
% figure,plot(S);


%%%%%% Prediction order  
p=10;
s11= convm(S,p);
[M1,N1]=size(s11);
s21=s11(:,N1:-1:1);

s12= s11(p:M-1,:)';
% remove the last digit from S1

[M2,N2]=size(s12);

%%%%%%%%%%%%%%%%%%%%% TARGET DATA  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t1=S(p+1:M,:)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X = s12;
TrainRatio = 0.7;
TrainLen = round(TrainRatio*N2);
Xtrain = X(:,1:TrainLen);
Xtest = X(:,TrainLen+1:N2);

y=t1;
ytrain = y(:,1:TrainLen);
ytest = y(:,TrainLen+1:N2);







% %%%%%%%% Training the sets %%%%%%%%%%%%%%%%
%%%% Data is randomply divided %%%%%%%%%%
net = newff(Xtrain, ytrain,[2]);
net.divideParam.trainRatio = 0.7;
net.divideParam.valRatio = 0.15;
net.divideParam.testRatio = 0.15;
[net,tr] = train(net,Xtrain,ytrain);


%%%%%%%%%%% testing the set  %%%%%%%%%%%%%%%%%%%%%%

for i=TrainLen+1:M-p-1
[net,tr] = train(net,X(:,1:i),y(:,1:i));
output(i+1) = sim(net,X(:,i+1));
end



% % % % % % % % % % % % % % % % % % % % % % % % % % 


[M4,N4] = size((output)') ;



[a,b]=size(ytest)
 kk=output(TrainLen+1:TrainLen+b);

mm1=1:b
figure, plot(mm1,ytest(mm1),mm1,(kk(mm1))),title('ytest vs output');
% figure, plot(ytest)
% plot(output)

% Normalized mean square error
Nmse=(var(ytest-kk))/(var(ytest));

%%%%%%%%%%%%%%%%%%%%%%%%%%%   weights just for fun  %%%%%%%%%%%%%%%%%%%%%%
% Iw = cell2mat(net.IW);
% inpbias = cell2mat(net.b(1));
% outpbias = cell2mat(net.b(2));
% Lowerweights = cell2mat(net.Lw);


