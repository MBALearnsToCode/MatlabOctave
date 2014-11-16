function [alpha, bias] = ISDA_R(n,x,Y,s,C,ep,k)
dim = size(x,2)
tol = 1e-12 	
iter = 0;
alphaup = zeros(n,1); 
alphadown = zeros(n,1);
Eu=-Y+ep; Eum=Eu;
El=ep+Y;  Elm=El;
bufdel_alph=zeros(n,1);
set_A=[1:n];
omega=1;
stopping=1e-4*ep;
h=100;
xsquare=sum(x.^2,2);
Kij=zeros(n,1);
while(1)
if(h==0)
h=100;
[set_A, max_Eu]=shrinking_reg(alphaup,alphadown,Eu,El,tol,C,set_A);
if(max_Eu<stopping)
    sv_ind=find((alphaup-alphadown)~=0);
    if(length(find(bufdel_alph(sv_ind)~=0))==length(sv_ind))
    [Eu, El]=recompute_gradientreg(Eu,El,alphaup,alphadown,set_A,n,x,Y,k,dim,s,ep);
    Eum=Eu; Elm=El; bufdel_alph=zeros(n,1);
else
    [Eu,El]=update_grad_reg(Eu, El, Eum,Elm,set_A,n,x,Y,k,dim,s,bufdel_alph);
    Eum=Eu;Elm=El;bufdel_alph=zeros(n,1);    
end
set_A=[1:n];
end
[set_A, max_Eu]=shrinking_reg(alphaup,alphadown,Eu,El,tol,C,set_A);
if(max_Eu<stopping) break; end
end
h=h-1;
u_vio=find((alphaup(set_A)>0)&(Eu(set_A)>tol));  
u_vio=union(u_vio,find((alphaup(set_A)<C)&(Eu(set_A)<tol)));    
l_vio=find((alphadown(set_A)>0)&(El(set_A)>tol));  
l_vio=union(l_vio,find((alphadown(set_A)<C)&(El(set_A)<tol)));  
[max_Eu max_iu]=max(abs(Eu(set_A(u_vio))));
[max_El max_il]=max(abs(El(set_A(l_vio))));
if(isempty(max_Eu)) max_Eu=0; end; if(isempty(max_El)) max_El=0; end;
if(max_El>max_Eu)
max_il=l_vio(max_il); max_il=set_A(max_il);
max_Eu=max_El
xy=x(max_il,:)*x';
disti=ones(length(set_A),1)*xsquare(max_il)-2*xy(set_A)'+xsquare(set_A);
disti=exp(-0.5*disti/s^2);
Kij(set_A)=disti;
alpha_old =alphadown(max_il);
alphadown(max_il)=alphadown(max_il)-omega*El(max_il)/(Kij(max_il));
alphadown(max_il) = min(max(alphadown(max_il),0), C);    
del_alp=-(alphadown(max_il)-alpha_old);
bufdel_alph(max_il)=bufdel_alph(max_il)+del_alp;
Eu(set_A)=Eu(set_A)+del_alp*Kij(set_A);
El(set_A)=El(set_A)-del_alp*Kij(set_A);
else
max_Eu
max_iu=u_vio(max_iu); max_iu=set_A(max_iu);
xy=x(max_iu,:)*x';
disti=ones(length(set_A),1)*xsquare(max_iu)-2*xy(set_A)'+xsquare(set_A);
disti=exp(-0.5*disti/s^2);
Kij(set_A)=disti;
alpha_old =alphaup(max_iu);
alphaup(max_iu)=alphaup(max_iu)-omega*Eu(max_iu)/(Kij(max_iu));
alphaup(max_iu) = min(max(alphaup(max_iu),0), C);    
del_alp=(alphaup(max_iu)-alpha_old);
bufdel_alph(max_iu)=bufdel_alph(max_iu)+del_alp;
Eu(set_A)=Eu(set_A)+del_alp*Kij(set_A);
El(set_A)=El(set_A)-del_alp*Kij(set_A);    
end
end%while
bias= sum((alphaup-alphadown))*1/k;
%[(alphaup-alphadown) Eu El f' Y]
Number_of_Iteration_cycles = iter
alpha =[alphaup;alphadown];