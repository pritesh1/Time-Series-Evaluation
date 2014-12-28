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



% for company = 1 :N11
for company = 1 :N11
    
for p= 5:15    
S=A(:,company);


[M,N]=size(S);
K=One(M,N);
m=(S'*K)/M;
S=S-m*K;


%%%%%% Prediction order  
% p=10;
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


%%%%%%%%%%%%%%%%%%%%  Training the sets  %%%%%%%%%%%%%%%%%%%%%%%
net = newff(Xtrain, ytrain,[3]);
net.divideParam.trainRatio = 0.8;
net.divideParam.valRatio = 0.2;
net.divideParam.testRatio = 0;
[net,tr] = train(net,Xtrain,ytrain);


%%%%%%%%%%% testing the set  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

output = sim(net,Xtest);

% % % % % % % % % % % % % % % % % % % % % % % % % % 


[M4,N4] = size((output)') ;

% k1=(output)';
% k=zero1(M,N);
% k(p+1:M,:)=k1(1:M-p);
% 
% mm1=1:M
% %figure, plot(mm1,S(mm1),mm1,k(mm1)),title('training vs predicted');
% 

% % [a,b]=size(output)
% % mm1=1:b
% figure, plot(mm1,ytest(mm1),mm1,(output(mm1))),title('ytest vs output');
% figure, plot(ytest)
% plot(output)
% Normalized mean square error

Nmse(p,company)=(var(ytest-output))/(var(ytest));

end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%   weights just for fun  %%%%%%%%%%%%%%%%%%%%%%
% Iw = cell2mat(net.IW);
% inpbias = cell2mat(net.b(1));
% outpbias = cell2mat(net.b(2));
% Lowerweights = cell2mat(net.Lw);


