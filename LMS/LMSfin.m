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
% Divides training and test into two equal halves
% Linear Autoregression

%Preprocessing

clc;
clear all;
% S = load('sunspots.dat');

A= load('findata.txt');
[M11,N11]=size(A);


for company = 1 :N11

S=A(:,company);


[M,N]=size(S);
K= One(M,N);
S1= S(1:M);
m=(S1'*K)/M;
S1= S1-m*K;
S= S-m*K;
Nt=floor(M/2)+1;


p = 15;
u= 0.2; 
a(p,:) = rand(1,p)-0.5;
%a=zeros(1,p);
%Hayes function
K1= convm(S1,10);
[M1,N1]=size(K1);

X=S;

TrainRatio = 0.7;
TrainLen = round(TrainRatio*M);
Xtrain = X(1:TrainLen,:);
Xtest = X(TrainLen+1:M,:);


for k=p+1:M;
  E(k)= S(k)-(a(k-1,:)*S(k-p:k-1));  
  a(k,:)= a(k-1,:) + (u*E(k)*S(k-p:k-1)')/(norm(S(k-p:k-1)).^2);
 S11(k)=(a(k-1,:)*S(k-p:k-1));
 end;
 
 
% Forecasting for the past values using weights one step behind the newer
% predicted values.
for k=TrainLen+1:M+1;
 S11(k)=(a(k-1,:)*S(k-p:k-1));
 end;

 
%  figure,stem(S) ,title('training');
%  figure,stem(S11),title('predicted');
%  

Output= S11(TrainLen+1:M);
 
% % % % [as,bs]=size(S11)
%  mm1=TrainLen+1:M;
%  figure, plot(mm1,Xtest(mm1-TrainLen),mm1,S11(mm1)),title('training vs predicted');

 Nmse(company)=(var(Output-Xtest'))/(var(Xtest));
 
end