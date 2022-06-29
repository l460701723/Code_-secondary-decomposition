function [MASE,MAE_in,MAE_out] = MASE_com(indata,pre,true)
AA= pre;
TT = true;

sum1=0;sum2=0;
[g,k]=size(AA);
if k == 1
    AA = AA';
else
    AA =AA ;
end

[g,k]=size(AA);
for kk=1:k 
    a=abs(AA(kk)-TT(kk));             % MAE_out
    sum1=a+sum1;   
end
MAE_out=sum1/k; 


%º∆À„MAE_in
pre_in = indata(1:end-1);
tru_in = indata(2:end);

[g1,g2]=size(pre_in);
k2 = max([g1,g2]);
for kk=1:k2 
    a=abs(pre_in(kk)-tru_in(kk));             % MAE_in
    sum2=a+sum2;   
end
MAE_in=sum2/k2; 

MASE=MAE_out/MAE_in;
end