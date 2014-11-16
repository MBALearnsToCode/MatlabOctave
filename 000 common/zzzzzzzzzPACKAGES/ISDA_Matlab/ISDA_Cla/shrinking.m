function [set_A,max_i]=shrinking(alpha,YE,tol,C,set_A)
ind_vio= find((alpha(set_A)<C)&(YE(set_A)<tol));
ind_vio2=find((alpha(set_A)>0)&(YE(set_A)>tol));
sv_ind= find(alpha(set_A)>0);
set_A= union(set_A(ind_vio),[set_A(ind_vio2) set_A(sv_ind)]);
ind_vio= find((alpha(set_A)<C)&(YE(set_A)<tol));
ind_vio2=find((alpha(set_A)>0)&(YE(set_A)>tol));
[max_YE max_i]=max(abs(YE(set_A([ind_vio;ind_vio2]))));
to_vio=[ind_vio;ind_vio2];
max_i=to_vio(max_i);
length(set_A)