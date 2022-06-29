function [pe hist] = pec(y,m,t)

%  Calculate the permutation entropy

%  Input:   y: time series;
%           m: order of permuation entropy
%           t: delay time of permuation entropy, 

% Output: 
%           pe:    permuation entropy
%           hist:  the histogram for the order distribution
ly = length(y);
permlist = perms(1:m);
c(1:length(permlist))=0;
    
 for j=1:ly-t*(m-1)
     [a,iv]=sort(y(j:t:j+t*(m-1)));
     for jj=1:length(permlist)
         if (abs(permlist(jj,:)-iv))==0
             c(jj) = c(jj) + 1 ;
         end
     end
 end
hist = c;
c=c(find(c~=0));
p = c/sum(c);
pe = -sum(p .* log(p));
