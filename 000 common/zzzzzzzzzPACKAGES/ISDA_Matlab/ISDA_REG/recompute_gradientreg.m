function [Eu,El]=recompute_gradientreg(Eu,El,alphaup,alphadown,set_A,n,x,y,k,dim,s,ep)
sv_set=find((alphaup-alphadown)~=0);
non_set_A=setdiff([1:n],set_A);
sv_size=length(sv_set);
non_q=length(non_set_A);
Eu(non_set_A)=0;
El(non_set_A)=0;
xsquare=sum(x.^2,2);
Kij=zeros(n,1);
for(i=1:sv_size)
ind_i=sv_set(i);
xy=x(ind_i,:)*x';
disti=ones(length(non_set_A),1)*xsquare(ind_i)-2*xy(non_set_A)'+xsquare(non_set_A);
disti=exp(-0.5*disti/s^2);
Kij(non_set_A)=disti;
Eu(non_set_A)=Eu(non_set_A)+(alphaup(ind_i)-alphadown(ind_i))*Kij(non_set_A);
end;
El(non_set_A)=Eu(non_set_A);
for(j=1:non_q)
ind_j=non_set_A(j);
Eu(ind_j)= Eu(ind_j)-y(ind_j)+ep;
El(ind_j)=ep+y(ind_j)-El(ind_j)
end;