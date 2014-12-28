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