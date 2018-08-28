function [V_naught,U]= blsmesh(E,alpha,r,T,S,style,Nx1,Nx2,Nx3,Nx,discretization,Nt,L,h,a,k,target)
pkg load financial;
pkg load io;
sigma=alpha;
BLS=zeros(Nx-1,Nt+1);
if discretization==1
   clear Nx1 Nx2 Nx3
end
if style==2
   if discretization==2
    Stock_1=[h:h:(Nx1*h) ((Nx1*h)+(a*h)):(a*h):((Nx2*a*h)+(Nx1*h)) ((Nx1*h)+(((Nx2*a)+1)*h)):h:(L-h)];
   else
    Stock_1=[h:h:L-h]
   end
   BLS(:,1) = max(E-Stock_1',0); %Filling in the Value of the Option at Maturity
  else 
   if discretization==2
    Stock_1=[h:h:(Nx1*h) ((Nx1*h)+(a*h)):(a*h):((Nx2*a*h)+(Nx1*h)) ((Nx1*h)+(((Nx2*a)+1)*h)):h:(L-h)];
   else
    Stock_1=[h:h:L-h]
   end
   BLS(:,1) = max(Stock_1'-E,0); %Filling in the Value of the Option at Maturity
end


if discretization==2
  for i=1:1:(Nx-1)
    for j=1:1:Nt
        if i<=Nx1
        [call,put]=blsprice((i*h),E,r,((j)*k),sigma);
        bls_result=[call;put];
        BLS(i,j+1)=bls_result(style,1);
        clear bls_result call put;
        end
        if i>Nx1 && i<=(Nx2+Nx1)
        [call,put]=blsprice(((Nx1*h)+((i-Nx1)*(a*h))),E,r,((j)*k),sigma);
        bls_result=[call;put];
        BLS(i,j+1)=bls_result(style,1);
        clear bls_result call put;
        end
        if i>Nx1+Nx2        
        [call,put]=blsprice(((Nx1*h)+((i-(Nx2+Nx1))*h)+(Nx2*a*h)),E,r,(((j)*k)),sigma);
        bls_result=[call;put];
        BLS(i,j+1)=bls_result(style,1);
        clear bls_result call put;
        end
   end
 end  
end  

if discretization==1
 for i=1:1:(Nx-1)
    for j=1:1:Nt
        [call,put]=blsprice((i*h),E,r,(j*k),sigma);
        bls_result=[call;put];
        BLS(i,j+1)=bls_result(style,1);
        clear bls_result call put;
    end
 end
end  

if style==2
   bca = E*exp(-r*[0:k:T]);
   bcb = zeros(1,Nt+1);
   U = [bca;BLS;bcb];
   else
   bca = zeros(1,Nt+1);
   bcb = L*ones(1,Nt+1);
   U = [bca;BLS;bcb];
end
V_naught=U(target+1,Nt+1);
