%Preprocessing

clc;
clear all;
S = load('sunspots.dat');
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

% for k=p+1:TrainLen;
%   E(k)= S(k)-(a(k-1,:)*S(k-p:k-1));  
%   a(k,:)= a(k-1,:) + (u*E(k)*S(k-p:k-1)')/(norm(S(k-p:k-1)).^2);
% %   S11(k)=(a(k-1,:)*S(k-p:k-1));
%  end;
%  
% for k=TrainLen+1:M;
%  S11(k)=(a(TrainLen,:)*S(k-p:k-1));
%  end;

for k=p+1:M;
  E(k)= S(k)-(a(k-1,:)*S(k-p:k-1));  
  a(k,:)= a(k-1,:) + (u*E(k)*S(k-p:k-1)')/(norm(S(k-p:k-1)).^2);
%   S11(k)=(a(k-1,:)*S(k-p:k-1));
 end;
 
for k=TrainLen+1:M;
 S11(k)=(a(k,:)*S(k-p:k-1));
 end;


 
 figure,stem(S) ,title('training');
 figure,stem(S11),title('predicted');
 

Output= S11(TrainLen+1:M);
 
 [a,b]=size(S11)
 mm1=TrainLen+1:M;
 figure, plot(mm1,Xtest(mm1-TrainLen),mm1,S11(mm1)),title('training vs predicted');

 
 
  mmse=(var(Output-Xtest'))/(var(Xtest));






