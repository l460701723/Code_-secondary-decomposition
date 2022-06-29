function y = ESM(data,h)
[a,b] = size(data);
S=reshape(data,[max(a,b),1]);

alpha=0.3;
beta=0.3;
gamma=0.5;
fc=h;
k=12;

n=length(S);
a(1)=sum(S(1:k))/k;
b(1)=(sum(S(k+1:2*k))-sum(S(1:k)))/k^2;
s=S-a(1);
y=a(1)+b(1)+s(1);

f=zeros(size(S,1),1);
for i=1:n+fc
    if i==length(S)
        S(i+1)=a(end)+b(end)+s(end-k+1);
    end
a(i+1)=alpha*(S(i)-s(i))+(1-alpha)*(a(i)+b(i));
b(i+1)=beta*(a(i+1)-a(i))+(1-beta)*b(i);%Ç÷ÊÆ
s(i+1)=gamma*(S(i)-a(i)-b(i))+(1-gamma)*s(i);%ÖÜÆÚ
y(i+1)=a(i+1)+b(i+1)+s(i+1);
end

y = y(end-fc+1:end);
end


