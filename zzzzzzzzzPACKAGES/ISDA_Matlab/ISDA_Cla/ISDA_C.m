function [alpha,bias] = ISDA_C(n,x,Y,s,C)		
YE=ones(n,1)*-1; %(*\scriptsize\%YE=$y_iE_i$*)
dim = size(x,2);
max_YE=inf;
q=n; %(*\scriptsize \% n is size of training data*)
iter=0;
iter_pre=0;
h=10
set_A=[1:n];
change=0;
alpha=zeros(n,1);
tol=1e-12;
stopping=1e-6;
omega=1;
k=10;
xsquare=sum(x.^2,2);
Kij=zeros(n,1);
buf_dealp=zeros(n,1);
YEm=YE;
while (1)
 iter = iter +1;
 alphaold=alpha;
 max_i=1;
 max_YE=0;
 %shrinking
 if(h==0)
 h=100; %(*\perfo*)
 [set_A,max_i]=shrinking(alpha,YE,tol,C,set_A);
 if(abs(YE(set_A(max_i)))<stopping)
 sv_ind=find(alpha>0);
  if(length(find(buf_dealp(sv_ind)~=0))==length(sv_ind))
 [YE]=recompute_gradient(YE,alpha,set_A,n,x,Y,k,dim,s);   
 YEm=YE; buf_dealp=zeros(n,1);  
 else 
 [YE]=update_grad(YE, YEm,alpha,set_A,n,x,Y,k,dim,s,buf_dealp);    
 YEm=YE; buf_dealp=zeros(n,1);       
 end
 set_A=[1:n];    
 end%if inn
 [set_A,max_i]=shrinking(alpha,YE,tol,C,set_A); 
 if(abs(YE(set_A(max_i)))<stopping) break;end%if
 end
 ind_vio= find((alpha(set_A)<C)&(YE(set_A)<0)); %(*\scriptsize\%\label{alg:kkt_cl}*)
 ind_vio2=find((alpha(set_A)>0)&(YE(set_A)>tol));
 to_vio=[ind_vio;ind_vio2];
 [max_YE max_i]=max(abs(YE(set_A([ind_vio;ind_vio2]))));
 max_i=to_vio(max_i);max_i=set_A(max_i);
 xy=x(max_i,:)*x';
 disti=ones(length(set_A),1)*xsquare(max_i)-2*xy(set_A)'+xsquare(set_A);
 Kij(set_A)=exp(-0.5*disti/s^2)+1/k;
 alphaold=alpha(max_i);
 alpha(max_i) = alpha(max_i) -omega* YE(max_i)/(Kij(max_i));
 alpha(max_i) = min(max(alpha(max_i)-tol,0), C);
 de_alpha = (alpha(max_i)-alphaold)*Y(max_i);
 buf_dealp(max_i)=buf_dealp(max_i)+de_alpha;
 %updating YE
 YE(set_A)=YE(set_A)+de_alpha*Y(set_A).*Kij(set_A); 
 h=h-1;
 end% of while 
 bias= 1/k*alpha'*Y;