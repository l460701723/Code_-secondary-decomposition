% bpnet for oil prediction
function [y_BP]=bpnet(X_train,Y_train,X_test,outputps)
% X_train:    n*m    x for training set
% Y_train:    1*m    y for training set
% X_test:     n*h    x for testing set
% pred1       m*1    prediction results of training set
% pred2       h*1    prediction results of testing set
% net = feedforwardnet(10);
net = feedforwardnet(7); %
%net.trainParam.epochs = 3000;
net.trainParam.epochs = 300;%1000
net.trainParam.lr = 0.001;%学习率
net.trainParam.mc = 0.6;%动量因子
net.trainParam.showWindow = false; 
net.trainParam.showCommandLine = false; %不显示训练窗口

pred2=[];
for k=1:1:3
    % 训练网络100份
    net = train(net,X_train,Y_train);
    % 仿真测试

end
pred_2 = net(X_test);
pred2 = mapminmax('reverse',pred_2,outputps);
y_BP = pred2;
%pred2(k,:) = mapminmax('reverse',pred_2,outputps);
%y_BP = mean(pred2);
end