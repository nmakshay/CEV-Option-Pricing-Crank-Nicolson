function [V_naught,U]= priceoption(E,alpha,beta,r,T,S,style,luf,q,discretization)
pkg load financial;
pkg load io;
Nx=3000;
%%%%%%%%%%%%%%%%%%Uniform Discretization%%%%%%%%%%%%%%%%%%%%%%%%
if discretization==1
 L=4*S;
 h=L/Nx;
 a=1;
 target=S/h;
 target=round(target);
 else 
%%%%%%%%%%%%%%%%%Non-Unifrom Discretization%%%%%%%%%%%%%%%%%%%%%%%%%%
 Nx1=round(Nx*0.175);		
 Nx2=round(Nx*0.475);
 Nx3=Nx-(Nx1+Nx2);
 h=(0.8*S)/Nx1;
 a= (0.4*S)/(Nx2*h);
 L= (Nx3*h)+(1.2*S);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if discretization==2
flag=0;
if S<=(h*Nx1)
   target=S/h;
   target=round(target);
   flag=1;
end
if (S>(h*Nx1))&&(S<((h*Nx1)+(Nx2*a*h)))
   target=Nx1+((S-(Nx1*h))/(a*h));
   target=round(target);
   flag=1;
end
if(flag!=1)
   target=Nx2+Nx1+((S-(Nx2*a*h)-(Nx1*h))/h);
   target=round(target);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Nt = 50;  %Impt
k = T/Nt; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sigma_naught=alpha*(0^(1-beta));
if sigma_naught==inf
   sigma_naught=70;
end
sigma_n=alpha*(L^(1-beta));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%Using the Crank-Nicolson FD Method%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T1 =  diag(ones(Nx-2,1),1) - diag(ones(Nx-2,1),-1);
T2 = -2*eye(Nx-1,Nx-1)  + diag(ones(Nx-2,1),1) + diag(ones(Nx-2,1),-1);
if discretization==2
 T2(Nx1,Nx1)=-(1+a);
 T2(Nx1,Nx1-1)=a;
 T2((Nx2+Nx1),(Nx2+Nx1))=-(1+(1/a)); 
 T2((Nx2+Nx1),(Nx1+Nx2-1))=(1/a);
end
mvec = zeros(1,Nx-1);
if discretization==2
 for i=1:1:Nx-1
    if i<=Nx1
      mvec(1,i)=i;
    end
    if (i>Nx1) && (i<=Nx2+Nx1)
     mvec(1,i)=(((i-Nx1)*a)+(Nx1))/(a);
    end
    if i>Nx2+Nx1 
     mvec(1,i)=(((Nx2)*a)+(Nx1)+((i-(Nx2+Nx1))));
    end
 end
end
if discretization==1
 for i=1:1:Nx-1
     mvec(1,i)=i;
  end
end
D1 = diag(mvec);
D2 = diag(mvec.^2);
if discretization==2
 D2(Nx1,Nx1)=D2(Nx1,Nx1)/(0.5*(1+a));
 D2((Nx2+Nx1),(Nx2+Nx1))=D2((Nx2+Nx1),(Nx2+Nx1))/(0.5*(1+(1/a)));
end
sigma=zeros(1,Nx-1);
if discretization==2
 for i=1:1:Nx-1
    if i<=Nx1
     sigma(1,i)=0.5*k*((alpha*((i*h)^(1-beta)))^2);
    end
    if (i>Nx1) && (i<=(Nx1+Nx2))
     sigma(1,i)=0.5*k*((alpha*(((Nx1*h)+((i-Nx1)*a*h))^(1-beta)))^2);
    end
    if i>(Nx2+Nx1) 
     sigma(1,i)=0.5*k*((alpha*(((Nx1*h)+((Nx2)*a*h)+((i-(Nx1+Nx2))*h))^(1-beta)))^2);
    end
 end   
 else 
  for i=1:1:Nx-1
   sigma(1,i)=0.5*k*((alpha*((i*h)^(1-beta)))^2);
  end
 end

sigma=diag(sigma);
sigma_pure=(2/k)*sigma;
F = (1-(r*k))*eye(Nx-1,Nx-1) + (sigma*D2*T2) + (0.5*k*(r-q)*D1*T1);
B = (1+(r*k))*eye(Nx-1,Nx-1) - (sigma*D2*T2) - (0.5*k*(r-q)*D1*T1);
A1 = 0.5*(eye(Nx-1,Nx-1) + F);
A2 = 0.5*(eye(Nx-1,Nx-1) + B);
U = zeros(Nx-1,Nt+1); %This is the matrix for the value of the option sans the edges (S=0 and S=L)%
if style==2
    if discretization==2
    Stock_1=[h:h:(Nx1*h) ((Nx1*h)+(a*h)):(a*h):((Nx2*a*h)+(Nx1*h)) ((Nx1*h)+(((Nx2*a)+1)*h)):h:(L-h)];
    else 
    Stock_1=[h:h:L-h];
    end
  U(:,1) = max(E-Stock_1',0); %Filling in the Value of the Option at Maturity
  else 
   if discretization==2
    Stock_1=[h:h:(Nx1*h) ((Nx1*h)+(a*h)):(a*h):((Nx2*a*h)+(Nx1*h)) ((Nx1*h)+(((Nx2*a)+1)*h)):h:(L-h)];
    else 
    Stock_1=[h:h:L-h];
    end
  U(:,1) = max((Stock_1'-E),0); %Filling in the Value of the Option at Maturity
end
%Fills in the Part in Between according to Equation 25 in the Text; Note that the V_{Nx} and V_{0} for put and call are different (Boundary Conditions)%
if style==2
   for i = 1:Nt
    tau = (i-1)*k;
    p1 = k*(0.5*sigma_pure(1,1) - 0.5*(r-q))*E*exp(-r*(tau));
    q1 = k*(0.5*sigma_pure(1,1) - 0.5*(r-q))*E*exp(-r*(tau+k));
    rhs = A1*U(:,i) + [0.5*(p1+q1); zeros(Nx-2,1)];
    if luf==1
        d=diag(A2);
        n=length(d);
        f=[diag(A2,1);0];
        e=[0;diag(A2,-1)];
        [lower,upper]=TriDiLU(d,e,f);
        y=LBidiSol(lower,rhs);
        X=UBidiSol(upper,f,y);
        else
        X = A2\rhs;
     end
    U(:,i+1) = X;
   end
 else
   for i = 1:Nt
     tau = (i-1)*k;
     p_n = 0.5*k*(D1(Nx-1,Nx-1))*(((sigma_pure(Nx-1,Nx-1))*(D1(Nx-1,Nx-1)))+(r-q))*L;
     q_n = 0.5*k*(D1(Nx-1,Nx-1))*(((sigma_pure(Nx-1,Nx-1))*(D1(Nx-1,Nx-1)))+(r-q))*L;
     rhs = A1*U(:,i) + [zeros(Nx-2,1);0.5*(p_n+q_n)];
     if luf==1
        d=diag(A2);
        n=length(d);
        f=[diag(A2,1);0];
        e=[0;diag(A2,-1)];
        [lower,upper]=TriDiLU(d,e,f);
        y=LBidiSol(lower,rhs);
        X=UBidiSol(upper,f,y);
        else
        X = A2\rhs;
      end
      U(:,i+1) = X;
    end
end
%To fill in the edges where S=0 and S=L%
if style==2
   bca = E*exp(-r*[0:k:T]);
   bcb = zeros(1,Nt+1);
   U = [bca;U;bcb];
   else
   bca = zeros(1,Nt+1);
   bcb = L*ones(1,Nt+1);
   U = [bca;U;bcb];
end
V_naught=U(target+1,Nt+1);
