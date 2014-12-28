%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab Project 
% 
% Module: linear.m
% 
% Usage: To predict new sample values using linear prediction
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
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Divides training and test into two equal halves
% Linear Autoregression

clc;
clear all;
S = load('sunspots.dat');


% S1 is the training set
[M,N]=size(S);
K=One(M,N);
S1= S(1:floor(M/2));
m=(S'*K)/M;
S=S-m*K;
Nt=floor(M/2)+1;


% 
% %K=u, X=S1
% calculate the correlation 
for i=1:30
k=i-1;
   sumx=0;
   for j=0:floor(M/2)-1-k
   sumx = sumx +S(j+1)*S(j+i);
   end
   r(i)=sumx/floor(M/2);
end
% 
% 
for m=2:20
% m=10;
rr=r(1:m);
rmat= toeplitz(rr);
rxy = r(2:m+1);
a=(inv(rmat))*(rxy');
ap=[1;-a];
S11=conv(S,a);
e=conv(S,ap);
et=e(m+1:floor(M/2));
e2=e(floor(M/2)+1:M);
MSE_test(m)=(e2'*e2)/Nt;
MSE_real(m)=(et'*et)/144-m;
end


% plotting the Mean square error
mm=2:20;
figure,plot(mm,MSE_test(mm))
 title('test');
figure,plot(mm,MSE_real(mm))
 title('training')
 figure,stem(S) ,title('training')
 figure,stem(S11),title('predicted')


% plotting the test set versus the training set
 mm1=floor(0.7*M):M;
figure, plot(mm1,S(mm1),mm1,S11(mm1)),title('training vs predicted');
 
S12= S11(1:M);
Nmse=(var(S((0.7*M):M)-S12((0.7*M):M)))/(var(S((0.7*M):M)))