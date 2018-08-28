alpha=20;beta=2;r=0.04;T=1;S=100;luf=1;q=0.02;Nx=3000;Nt=50;style=2; discretization=2;
result=zeros(11,1);
for i=1:1:11
    E=(0.9+(0.02*(i-1)))*S
    [V_naught,U]= priceoption(E,alpha,beta,r,T,S,style,luf,q,discretization);
    result(i,1)=V_naught;
end
x=[0.9:0.02:1.1];
y=result;
plot(x,y,'-r');
title('Price of Put at Various Strikes');
xlabel('Strike Price');
ylabel('Price of Put Option in Dollars');
print("Figure7.png")