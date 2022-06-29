
function [Comp] = decomp(decomp_type,data_sample)
% decomp_type is the 11 decomposition method in the field of tourism;
% data_sample is the inputs;

switch decomp_type
    case 'EMD';
        Comp = [];
        [imf,residual] = emd(data_sample);
        Comp = [imf,residual];
        
    
        
    case 'VMD'  %
        Comp = [];
        T = length(data_sample);
        fs = 1/T;
        alpha = 2*T;        % moderate bandwidth constraint 
        tau = 0;            % noise-tolerance (no strict fidelity enforcement)
        K = 4;              % 5 modes 
        DC = 0;             % no DC part imposed
        init = 1;           % initialize omegas uniformly
        tol = 1e-7;
        [u, u_hat, omega] = VMD(data_sample, alpha, tau, K, DC, init, tol);
        u_test = sum(u);
        Comp = u'; %
        
        
    
        
        
end
end