Sfin= load('interp_returns.txt');
Sfin(:,22);

[M11,N11]=size(Sfin(:,22));
k=Sfin(2:M11,22);
[M11,N11]=size(k);
k1=zeros(floor(M11/5),1);

for i= 1:floor(M11/5)
k1(i,1)= sum(k(5*i:-1:5*i-4,1))/5;
end

S=k1;

[M,N]=size(S);
K=One(M,N);
S1= S(1:floor(M/2));
m=(S'*K)/M;
S=S-m*K;
Nt=floor(M/2)+1;


% 
% %K=u, X=S1
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
% 
mm=2:20;
figure,plot(mm,MSE_test(mm))
 title('test');
figure,plot(mm,MSE_real(mm))
 title('training')
 figure,stem(S) ,title('training')
 figure,stem(S11),title('predicted')
%  
% %  S=S+m*K;
% %  mean=zeros(115,1);
% %  
% %  S11=S11+30;
% S1=S1+m*K;
%  mm1=1:M
%  figure, plot(mm1,S(mm1),mm1,S11(mm1)),title('training vs predicted');
%  
%  S12= S11(1:M);
%  
%  
%  mmse=(var(S-S12))/(var(S));


mm1=floor(0.7*M):M;
 figure, plot(mm1,S(mm1),mm1,S11(mm1)),title('training vs predicted');
 
 S12= S11(1:M);
 
 
 mmse=(var(S((0.7*M):M)-S12((0.7*M):M)))/(var(S((0.7*M):M)));




