E=100;alpha=0.3;beta=1;r=0.03;T=1;S=100;luf=1;q=0;Nx=3000;Nt=50;
 Nx1=round(Nx*0.175);		
 Nx2=round(Nx*0.475);
 Nx3=Nx-(Nx1+Nx2);
global count=1
for i=1:1:2
   for j=1:1:2
       style=i;
       discretization=j;
       [V_naught,U,BLS]= priceoption(E,alpha,beta,r,T,S,style,luf,q,discretization)
       if j==1 && i==1
       call_U=U
       call_U_bls=BLS
       end
       if j==1 && i==2
       put_U=U
       put_U_bls=BLS
       end
       if j==2 && i==1
       call_NU=U
       call_NU_bls=BLS
       end
       if j==2 && i==2
       put_NU=U
       put_NU_bls=BLS
       end
   
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%Plot it Out%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k=T/Nt;

figure(1)
Nx1=round(Nx*0.175);		
Nx2=round(Nx*0.475);
Nx3=Nx-(Nx1+Nx2);
h=(0.8*S)/Nx1;
a= (0.4*S)/(Nx2*h);
L= (Nx3*h)+(1.2*S);
Stock=[0:h:(Nx1*h) ((Nx1*h)+(a*h)):(a*h):((Nx2*a*h)+(Nx1*h)) ((Nx1*h)+(((Nx2*a)+1)*h)):h:L];
subplot(2,2,1)
mesh([0:k:T],Stock,call_NU)
xlabel('T-t'), ylabel('S'), zlabel('Call Value')
title('Call Option-Non Uniform')

subplot(2,2,2)
mesh([0:k:T],Stock,put_NU)
xlabel('T-t'), ylabel('S'), zlabel('Put Value')
title('Put Option-Non Uniform')



L=4*S;
h=L/Nx;
a=1;
Stock=[0:h:L];
subplot(2,2,3)
mesh([0:k:T],Stock ,call_U)
xlabel('T-t'), ylabel('S'), zlabel('Call Value')
title('Call Option- Uniform')
 
subplot(2,2,4)
mesh([0:k:T], Stock,put_U)
xlabel('T-t'), ylabel('S'), zlabel('Put Value')
title('Put Option- Uniform')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%Plot it Out%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2)
Nx1=round(Nx*0.175);		
Nx2=round(Nx*0.475);
Nx3=Nx-(Nx1+Nx2);
h=(0.8*S)/Nx1;
a= (0.4*S)/(Nx2*h);
L= (Nx3*h)+(1.2*S);
Stock=[0:h:(Nx1*h) ((Nx1*h)+(a*h)):(a*h):((Nx2*a*h)+(Nx1*h)) ((Nx1*h)+(((Nx2*a)+1)*h)):h:L];
subplot(2,2,1)
mesh([0:k:T],Stock,call_NU_bls)
xlabel('T-t'), ylabel('S'), zlabel('Call Value')
title('BLS-Call Option-Non Uniform')
   
subplot(2,2,2)
mesh([0:k:T],Stock,put_NU_bls)
xlabel('T-t'), ylabel('S'), zlabel('Put Value')
title('BLS-Put Option-Non Uniform')

L=4*S;
h=L/Nx;
a=1;
Stock=[0:h:L];
subplot(2,2,3)
mesh([0:k:T], Stock,call_U_bls)
xlabel('T-t'), ylabel('S'), zlabel('Call Value')
title('BLS-Call Option- Uniform')
%print("Figure4.png")
 
subplot(2,2,4)
mesh([0:k:T], Stock,put_U_bls)
xlabel('T-t'), ylabel('S'), zlabel('Put Value')
title('BLS-Put Option- Uniform')
%print("Figure5.png")