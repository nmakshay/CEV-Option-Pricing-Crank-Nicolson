clear all; close all; 
pkg load financial;
pkg load io;
tic;
S=100;
r=0.04;
alpha=0.3;
style=2;
q=0.02;
beta=1;
Strikes=S*[0.8:0.04:1.2];
Time=[0:0.05:0.5];
T=0.5;
implied_volatility=zeros(11,11);
price_vector=zeros(11,11);
for i=1:1:11
     for j=1:1:11
         if i==11
            price_vector(i,j)=Strikes(1,j)-S;
         else
         [price,V]=priceoption(Strikes(1,j),alpha,beta,r,(T-Time(1,i)),S,style,1,0,2);
         
         price_vector(i,j)=price;
        end
     end
end


for i=1:1:11
     for j=1:1:11
     E=Strikes(1,j);
     tom=Time(1,i);
     v=price_vector(i,j);
     volatility = blsimpv(S,E,r,tom, v,10,q,1e-6,false);
     implied_volatility(i,j)=volatility;
     end
end
mesh(Time,Strikes,implied_volatility);
ylabel('Strike Price'), xlabel('Time to Maturity'), zlabel('Implied Volatility')
toc;