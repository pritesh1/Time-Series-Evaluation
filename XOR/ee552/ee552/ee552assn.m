%author : niranjan yardi
% assignment nno 4
clc;
clear all;
n=20;
mu1 = [0 0 0];
mu2= [1 5 -3 ];
mu3= [0 0 0];
mu(:,:,1)=mu1;
mu(:,:,2)=mu2;
mu(:,:,3)=mu3;
sigma1 = [3 0 0;0 5 0;0 0 2 ];
sigma2=[1 0 0; 0 4 1;0 1 6];
sigma3= 10*eye(3);
r1 = mvnrnd(mu1,sigma1,n);
r2 = mvnrnd(mu2,sigma2,n);
r3 = mvnrnd(mu3,sigma3,n);
r(:,:,1)=r1;
r(:,:,2)=r2;
r(:,:,3)=r3;
%estimating the means from the data
for i=1:3
  mean1(i)=sum(r1(:,i))/n;
end
for i=1:3
  mean2(i)=sum(r2(:,i))/n;
end
for i=1:3
  mean3(i)=sum(r3(:,i))/n;
end
%estimating the covariances
var1=zeros(3,3);
var2=zeros(3,3);
var3=zeros(3,3);
for i=1:n
  var1=((r1(i,:)-mean1)'*(r1(i,:)-mean1)+var1 );
end
var1=var1/n;
for i=1:n
  var2=((r2(i,:)-mean2)'*(r2(i,:)-mean2)+var2 );
end
var2=var2/n;
for i=1:n
   
  var3=((r3(i,:)-mean3)'*(r3(i,:)-mean3)+var3 );
   
end
var3=var3/n;


% %calculating sigma for total distribution
 for i=1:n
   vart=((r3(i,:)-mu3)'*(r3(i,:)-mu3)+var3 );
 end

 
 a12=cov(r1',r2');
 a13=cov(r1,r3);
 a23=cov(r2,r3);
 sigmat= [a12(1,:) a13(1,2); a12(2,:) a23(1,2); a13(1,2),a23(1,2),a13(2,2)]/60;
 
 
 %calculating the sigmai(a)
  l=5;
   error= zeros(1,l+1);  
   a=0;
  for k=1:l  
      a=a+1/l;
 sigmai1= ((1-a)*n*sigma1 + a*3*n*sigmat)/((1-a)*n+a*3*n);
  sigmai2= ((1-a)*n*sigma2 + a*3*n*sigmat)/((1-a)*n+a*3*n); 
  sigmai3= ((1-a)*n*sigma3 + a*3*n*sigmat)/((1-a)*n+a*3*n);
 sigmaf(:,:,1)=sigmai1;
  sigmaf(:,:,2)=sigmai2;
   sigmaf(:,:,3)=sigmai3;
   
   for i=1:3
       for j=1:n
               g1(i,j) = ((r(j,:,i)-mu(:,:,1))* sigmaf(:,:,1)' *(r(j,:,i)-mu(:,:,1))') -log(abs( det( sigmaf(:,:,1))));
               g2(i,j) = ((r(j,:,i)-mu(:,:,2))* sigmaf(:,:,2)' *(r(j,:,i)-mu(:,:,2))') -log(abs( det( sigmaf(:,:,2))));
               g3(i,j) = ((r(j,:,i)-mu(:,:,3))* sigmaf(:,:,3)' *(r(j,:,i)-mu(:,:,3))') -log(abs( det( sigmaf(:,:,3))));
       
       if( i==1 && (g1(i,j)<g2(i,j)  || g1(i,j)<g3(i,j)) )
            error(k)=error(k)+1;
            
       end
       if( i==2 && (g2(i,j)<g1(i,j)  || g2(i,j)<g3(i,j)) )
            error(k)=error(k)+1;
            
       end
       if( i==3 && (g3(i,j)<g2(i,j)  || g3(i,j)<g1(i,j)) )
            error(k)=error(k)+1;
            
       end
   end
   
   end
   
   end
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
