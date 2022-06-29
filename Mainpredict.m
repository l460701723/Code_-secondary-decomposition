function [y,Dstat,MAPE,RMSE,f_y] = Mainpredict( Model,X_train,Y_train,X_test,Y_test,horizon)



Y = [];
f_Y = [];
tr = 10;
n = size(X_train,2);

[X_train,inputps] = mapminmax(X_train);
X_test = mapminmax('apply',X_test,inputps);
[Y_train,outputps] = mapminmax(Y_train);

switch Model
    case 'naive'
        Y_train = mapminmax('reverse',Y_train,outputps);
        YY = [Y_train Y_test];
        jj = max(size(Y_test));
        
        y= YY(end-horizon-jj+1:end-horizon)';
        f_y = YY(end-horizon-jj-9:end-horizon-jj)';
        [Dstat,MAPE,RMSE] = ptest(y,Y_test);
        
    case 'Snaive'
        Y_train = mapminmax('reverse',Y_train,outputps);
        YY = [Y_train Y_test];
        jj = max(size(Y_test));
        
        y= YY(end-12-jj+1:end-12)';
        f_y = YY(end-12-jj-9:end-12-jj)';
        [Dstat,MAPE,RMSE] = ptest(y,Y_test);
        
        
    case 'ES'
        %Y_train = mapminmax('reverse',Y_train,outputps);
        y_pre = [];
        X_train = mapminmax('reverse',X_train,inputps);
        data= X_train(end,1:end-10);
        data2= [X_train(end,end-9:end) Y_test];
        j = max(size(data2));
        for i = 1:1:j
            pre = ESM(data,1);
            y_pre =[y_pre pre];
            data = [data data2(i)];
        end
        
        y = y_pre(11:end)';
        f_y = y_pre(1:10)';
        [Dstat,MAPE,RMSE] = ptest(y,Y_test);
        
%         plot(y)
%         hold on 
%         plot(Y_test)
        
    case 'ELM'
        N = 7;%ceil(n*0.1);
        TF = 'sig';
        TYPE = 0;
        for k = 1:100
            [IW,B,LW,TF,TYPE] = elmtrain(X_train,Y_train,N,TF,TYPE);
            Y_pre_elm = elmpredict(X_test,IW,B,LW,TF,TYPE);
            Y(k,:) = mapminmax('reverse',Y_pre_elm,outputps);
            
            f_Y_pre_elm = elmpredict(X_train(:,n-(tr-1):n),IW,B,LW,TF,TYPE);%预测最后10个训练集
            f_Y(k,:) = mapminmax('reverse',f_Y_pre_elm,outputps);
        end
        y = mean(Y,1);
        f_y = mean(f_Y,1);
    
        %         y = mapminmax('reverse',y,outputps);
        [Dstat,MAPE,RMSE] = ptest(y,Y_test);
        y= y';
        f_y = f_y';
        
        
        
    case 'BP' %试错法
        Hidden_N = 6;
        for k=1:100
            [OutputWeight,Weight,Bias] = RVFLNNtrain(X_train', Y_train', Hidden_N);
            Y_pre_RVFL = RVFLNNtest(X_test',OutputWeight,Weight,Bias);
            Y = [Y Y_pre_RVFL];
            
            cs = X_train(:,n-(tr-1):n);
            f_Y_pre_RVFL = RVFLNNtest(cs',OutputWeight,Weight,Bias);
            f_Y = [f_Y f_Y_pre_RVFL];            
            
        end
        y = mean(Y,2);
        y = mapminmax('reverse',y,outputps);
        [Dstat,MAPE,RMSE] = ptest(y',Y_test);
        
        f_y = mean(f_Y,2);
        f_y = mapminmax('reverse',f_y,outputps);
        

        
    case 'SVR'
        [bestmse,bestc,bestg] = SVMcgForRegress(Y_train',X_train',1,2,-1,0);
        cmd = ['-c ', num2str(bestc), ' -g ', num2str(bestg) , ' -s 3 -p 0.01'];
        model = svmtrain(Y_train',X_train',cmd);
        
        [y,tmse,detesvalue] = svmpredict(Y_test',X_test',model);
        [f_y,tmse,detesvalue] = svmpredict(Y_train(:,n-(tr-1):n)',X_train(:,n-(tr-1):n)',model);
        
        y = y';
        y = mapminmax('reverse',y,outputps);
        y=y';
        
        f_y = f_y';
        f_y = mapminmax('reverse',f_y,outputps); 
        f_y = f_y';
        
        [Dstat,MAPE,RMSE] = ptest(y,Y_test);
        



       
end
end
