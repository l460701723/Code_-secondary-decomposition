function [MAPE,RMSE, Dstat,MASE,Sum_t_all,f_Sum_t_all] = emd_family(Comp,data_sample,model)

timf = Comp;
[row col] = size(timf);
interval = 1;
start_train = 1;
lag = 4;
end_train = floor(0.8*length(timf));
sum_t = 0;
y_test = 0;
Dstat = [];
MAPE = [];
RMSE = [];
MASE = [];
Sum_t_all = [];
f_Sum_t_all = [];
%%
for horizon = 1:1:6
    sum_t = 0;
    f_sum_t =0;
    y_test = 0;
    f_y_test =0;
    for i = 1:1:col
        data_T = timf(:,i);
        [x_Ttrain,y_Ttrain,x_Ttest,y_Ttest] = transfer(data_T,lag,horizon,1,1,end_train);
        Model = model;
        [y_T,~,~,~,f_y_T] = Mainpredict(Model,x_Ttrain,y_Ttrain,x_Ttest,y_Ttest);
        sum_t = sum_t + y_T;
        y_test = y_Ttest+y_test;    
        f_sum_t = f_sum_t + f_y_T;
       % f_y_test = f_y_Ttest+f_y_test; 
    end
    [m1,n1] = size(sum_t);
    if m1 ==1
        sum_t = sum_t';
        f_sum_t = f_sum_t';
    else
    end
    Sum_t_all = [Sum_t_all sum_t];
    f_Sum_t_all = [f_Sum_t_all f_sum_t];
    [Evaluation(1,1),Evaluation(1,2),Evaluation(1,3)] = ptest(sum_t',data_sample(end_train+1:end)');%ELM-·ÖºÅ£¬rvfl+
    [Evaluation(1,4),~,~] = MASE_com(data_sample(1:end_train),sum_t,data_sample(end_train+1:end));
    
    Dstat = [Dstat Evaluation(1,1)];
    MAPE = [MAPE Evaluation(1,2)];
    RMSE = [RMSE Evaluation(1,3)];
    MASE = [MASE Evaluation(1,4)];
end
