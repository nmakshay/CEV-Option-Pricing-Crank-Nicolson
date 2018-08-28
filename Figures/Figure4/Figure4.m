S=500;
Nx=25;
Nx1=round(Nx*0.175);		
Nx2=round(Nx*0.475);
Nx3=Nx-(Nx1+Nx2);
h=(0.8*S)/Nx1;
a= (0.4*S)/(Nx2*h);
L= (Nx3*h)+(1.2*S);

Stock=[0:h:(Nx1*h) ((Nx1*h)+(a*h)):(a*h):((Nx2*a*h)+(Nx1*h)) ((Nx1*h)+(((Nx2*a)+1)*h)):h:L];
Stock=Stock';
plot ([0:1:Nx],Stock,'b-o');
title('Discretization Pattern')
xlabel('Steps');
ylabel('Stock Price');
