% This code is based on the code in Higham (2004)
% The code by Higham (2004) only comptes the value of Put while this code computes both put and call using CN
% This code also inclue non-uniform discretization
% Crank-Nicolson Estimate for a European Call and Put  

clear all; close all;

%%%%%%% Problem and method parameters %%%%%%%
E = input('Please Enter the Strike Price:  '); 
alpha = input('Please Enter the Alpha: ');
beta = input('Please Enter the beta: '); 
r = input('Please Enter the Risk-Free Rate: '); 
q = input('Please Enter the Dividend Yeild (NOTE: r and q must be of the same compunding): ');
T = input('Please Enter the Duration of Option: ');
style= input('Please Enter the Style of the Option: 1:Call or 2:Put ');
S= input('Please Enter the Stock Price: ');
luf= input('Can We Use LU Factorization for Solving the Tri-Diagonal System? 1:Yes or 2:No  ');
discretization=input('Please Choose Type of Discretization 1:Uniform or 2:Non-Uniform:  ')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[p,V]=priceoption(E,alpha,beta,r,T,S,style,luf,q,discretization);
disp('The Price of the Option is :  ');
disp(p);
if beta==1
 [call,put]=blsprice(S,E,r,T,alpha,q);
 bls_result=[call;put];
 error=abs(bls_result(style,1)-p);
 disp ('The Error is :  ')
 disp(error)
end