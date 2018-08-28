function [V_naught]= blsmeshng(E,alpha,r,T,S,style)
sigma=alpha;
[call,put]=blsprice(S,E,r,T,sigma);
bls_result=[call;put];
V_naught=bls_result(style,1);
