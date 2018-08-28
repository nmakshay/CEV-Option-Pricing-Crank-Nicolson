%graphics_toolkit('fltk');
alpha=20;beta=2;r=0.04;T=1;S=100;luf=1;q=0.02;Nx=3000;Nt=50;style=2; discretization=2;E=100;
[V_naught,U]= priceoption(E,alpha,beta,r,T,S,style,luf,q,discretization);
Nx1=round(Nx*0.175);		
Nx2=round(Nx*0.475);
Nx3=Nx-(Nx1+Nx2);
h=(0.8*S)/Nx1;
a= (0.4*S)/(Nx2*h);
L= (Nx3*h)+(1.2*S);
k = T/Nt; 

Stock=[0:h:(Nx1*h) ((Nx1*h)+(a*h)):(a*h):((Nx2*a*h)+(Nx1*h)) ((Nx1*h)+(((Nx2*a)+1)*h)):h:L];
mesh([0:k:T],Stock,U)
xlabel('T-t'), ylabel('S'), zlabel('Put Value')
title('Put Option-Non Uniform')
%print("Figure6.pdf")