% assignment 5 
%implementing the back propogation algorithm for solving the XOR problem

%intialize the weights by random values
clc;
close all;
clear all;
% ip=[1 1 0 0 ; 1 0 1 0 ];
% t =[0 1 1 0 ];
% inp=[ 1 1 1 1 0  1 1 1 1 0; 1 1 0 0 1  1 0  0 0 0] ;
% ip = [ip ip ip ip ip ip ip]
% t = [t t t t t t t]
%  
%  
% net = newff(ip, t,[2]);
% % net = newff([0 1; 0 1],[2],{'logsig'});
% %minimum and maximum of the first and second layer of input.
% 
% 
% net1 = train(net,ip,t);
% %This learns using backpropagation
% 
% output = sim(net1,inp);
% %
% 
% disp(output);

 s11= load('glass.data');
% 
% 
ip1=s11(:,2:10)';
t1=s11(:,11)';
% net = fitnet(30);

 net = newff(ip1, t1,[4,2]);

[net,tr] = train(net,ip1,t1);
% testX = ip1(:,tr.testInd);
% testT = t1(:,tr.testInd);

% testY = net(testX);

% perf = mse(net,testT,testY);
% nntraintool;
% 
% perf = mse(net,testT,testY);

output = sim(net,ip1);

o11=round(output);

% 
% % %
% % s12= load('P:\courses\New folder\uc irvine\glass\p1.txt');
% % ip2=s12(1:300,1:8)';
% % t2=s12(1:300,9)';
% % net2 = fitnet(40);
% % 
% % ip3= s12(300:746,1:8)';
% % t3=s12(300:746,9)';
% % 
% % [net2,tr] = train(net2,ip2,t2);
% % testX1 = ip2(:,tr.testInd);
% % testT1 = t2(:,tr.testInd);
% % testY1 = net2(testX1);
% % perf = mse(net2,testT1,testY1);
% % nntraintool;
% % 
% % perf = mse(net,testT1,testY1);
% % 
% % output2 = sim(net2,ip2);
% % 
% % o12=round(output2);
% % 
% % output3 = sim(net2,ip3);
% % o13=round(output3);
%     