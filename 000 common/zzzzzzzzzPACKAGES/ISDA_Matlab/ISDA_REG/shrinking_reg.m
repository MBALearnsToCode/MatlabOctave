function [set_A, max_Eu]=shrinking_reg(alphaup,alphadown,Eu,El,tol,C,set_A)
u_vio=find((alphaup(set_A)>0)&(Eu(set_A)>tol));  
u_vio=union(u_vio,find((alphaup(set_A)<C)&(Eu(set_A)<tol)));    
l_vio=find((alphadown(set_A)>0)&(El(set_A)>tol));  
l_vio=union(l_vio,find((alphadown(set_A)<C)&(El(set_A)<tol)));
[max_Eu max_iu]=max(abs(Eu(set_A(u_vio))));
[max_El max_il]=max(abs(El(set_A(l_vio))));
if(isempty(max_Eu)) max_Eu=0; end
if(isempty(max_El)) max_El=0; end
if(max_El>max_Eu) max_Eu=max_El; end
sv_ind=find((alphaup(set_A)-alphadown(set_A))~=0)
set_A=union(set_A(u_vio),union(set_A(l_vio),set_A(sv_ind)));

