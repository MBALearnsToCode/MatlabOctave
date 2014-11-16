function [YE]=recompute_gradient(YE,alpha,set_A,n,x,y,k,dim,s)
sv_set=find(alpha>0);
non_set_A=setdiff([1:n],set_A);
sv_size=length(sv_set);
non_q=length(non_set_A);
YE(non_set_A)=0;
xsquare=sum(x.^2,2);
Kij=zeros(n,1);
for(i=1:sv_size)
ind_i=sv_set(i);
xy=x(ind_i,:)*x';
disti=ones(length(non_set_A),1)*xsquare(ind_i)-2*xy(non_set_A)'+xsquare(non_set_A);
disti=exp(-0.5*disti/s^2)+1/k;
Kij(non_set_A)=disti;
YE(non_set_A)=YE(non_set_A)+y(ind_i)*alpha(ind_i)*Kij(non_set_A);
end;
% for(j=1:non_q)
% ind_j=non_set_A(j);
% YE(ind_j)= YE(ind_j)*y(ind_j);
% YE(ind_j)=YE(ind_j)-1;
% end;
YE(non_set_A)=YE(non_set_A).*y(non_set_A);
YE(non_set_A)=YE(non_set_A)-1;
disp('here');