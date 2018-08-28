clear all ; close all;
pkg load miscellaneous;
alpha=0.3;beta=1;r=0.03;T=1;style=1;luf=1;q=0;

for j=1:1:2
 if j==1
  S=4;
  E=4;
  result=zeros(21,11);
  else
  S=100;
  E=100;
  result=zeros(21,11);
 end
 for i=1:1:21
    %Uniform
    discretization=1;
    Nx=2000+((i-1)*50);
    Nx1=0;Nx2=0;Nx3=0;
    [V_naught,Error,timerval_cnm,blsprice]=Table1(E,alpha,beta,r,T,S,style,luf,q,discretization,Nx1,Nx2,Nx3,Nx);
    result(i,1)=Nx;
    result(i,2)=V_naught;
    result(i,3)=Error;
    result(i,4)=timerval_cnm;
    %Non-Uniform
    discretization=2;
    Nx1=200+((i-1)*5);
    Nx2=465+((i-1)*25);
    Nx3=335+((i-1)*20);
    Nx=Nx1+Nx2+Nx3;
    [V_naught,Error,timerval_cnm,blsprice]=Table1(E,alpha,beta,r,T,S,style,luf,q,discretization,Nx1,Nx2,Nx3,Nx);
    result(i,5)=Nx1;
    result(i,6)=Nx2;
    result(i,7)=Nx3;
    result(i,8)=V_naught;
    result(i,9)=Error;
    result(i,10)=timerval_cnm;
    result(i,11)=blsprice;
 end
 if j==1
  result_1=result
  else
  result_2=result
 end
end

x=[2000:50:3000];
y1=result_1(:,11);
y2=result_1(:,2);
y3=result_1(:,8);

y12=result_2(:,11);
y22=result_2(:,2);
y32=result_2(:,8);

subplot(2,1,1)
plot(x,y1,'-r',x,y2,'b--',x,y3,'k-.');
axis([2000 3000]);
title('Price Derived from Different Approaches - S=K=4');
xlabel('$N_{x}$');
ylabel('Price in Dollars');

subplot(2,1,2)
plot(x,y12,'-r',x,y22,'b--',x,y32,'k-.');
axis([2000 3000]);
title('Price Derived from Different Approaches - S=K=100');
xlabel('$N_{x}$');
legend('True Price', 'Unifrom Crank Nicolson Estimate','Non-Unifrom Crank Nicolson Estimate','location','southoutside')
