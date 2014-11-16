function [Eu,El]=update_grad_reg(Eu, El, Eum,Elm,set_A,n,x,y,k,dim,s,delalpha)
set_alp=find(delalpha~=0);
non_set_A=setdiff([1:n],set_A);
non_q=length(non_set_A);
xsquare=sum(x.^2,2);
Kij=zeros(n,1);
for(i=1:length(set_alp))
ind_i=set_alp(i);
xy=x(ind_i,:)*x';
disti=ones(length(non_set_A),1)*xsquare(ind_i)-2*xy(non_set_A)'+xsquare(non_set_A);
disti=exp(-0.5*disti/s^2)+1/k;
Kij(non_set_A)=disti;
Eum(non_set_A)=Eum(non_set_A)+delalpha(ind_i)*Kij(non_set_A);    
Elm(non_set_A)=Elm(non_set_A)-delalpha(ind_i)*Kij(non_set_A);    
end
Eu(non_set_A)=Eum(non_set_A);
El(non_set_A)=Elm(non_set_A);