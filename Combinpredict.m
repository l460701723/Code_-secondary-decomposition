function [y,f_y,Dstat,MAPE,RMSE,MASE] = Combinpredict(model,data)
switch model
    case 'EMD'
        end_train = floor(0.8*length(data));
        
        decomp_type = 'EMD'; 
        data_sample = data;
        [Comp] = tm_decomposition_method(decomp_type,data_sample);
        [MAPE,RMSE,Dstat,MASE,Sum_t_all,f_Sum_t_all] = emd_family_forecast(Comp,data_sample,'BP');
       
        y = Sum_t_all;
        f_y = f_Sum_t_all;
        
    case 'VMD'
        end_train = floor(0.8*length(data));
        
        decomp_type = 'VMD'; 
        data_sample = data;
        [Comp] = tm_decomposition_method(decomp_type,data_sample);
        [MAPE,RMSE,Dstat,MASE,Sum_t_all,f_Sum_t_all] = emd_family_forecast(Comp,data_sample,'BP');
       
        y = Sum_t_all;
        f_y = f_Sum_t_all;
        
        
    case 'Int'
        data_sample = data;
        decomp_type = 'EMD'; 
        [Comp] = tm_decomposition_method(decomp_type,data_sample);
        % 
        comp = Comp';
        [m,n] = size(Comp);
        s = zeros(n,1);
        for i = 1:n
            s(i) = SampEn(comp(i,:),2,0.2*std(comp(i,:)));
        end
        % 
        [m,n] = size(Comp);
        SE_trend= zeros(m,1);
        SE_low = zeros(m,1);
        SE_high = zeros(m,1);
        SE_trend = SE_trend + Comp(:,end);
        SE_low = SE_low + Comp(:,end-1);
        for i = 1:1:n-2
            SE_high = SE_high + Comp(:,i);
        end
        % 
        decomp_type = 'VMD'; 
        [high_Comp] = tm_decomposition_method(decomp_type,SE_high);
        new_data = [high_Comp,SE_low,SE_trend];%
        %  add
        MAPE_all = [];
        RMSE_all = [];
        Dstat_all = [];
        [MAPE,RMSE,Dstat,MASE,Sum_t_all,f_Sum_t_all] = emd_family_forecast(new_data,data_sample,'BP');
        y = Sum_t_all;
        f_y = f_Sum_t_all;

end