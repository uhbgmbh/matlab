function L =  SymJouLift(chord,eps,Qinf,alpha,rho)
%NumCoord = 100;
%theta = (2*pi/(NumCoord+1):2*pi/(NumCoord+1):2*pi-2*pi/(NumCoord+1))';
C = 4*chord/(3+2*eps+1/(1+2*eps));
a = C/4*(1+eps);
%ThicknessRatio = eps*1.299;
beta = 0;
%mu = -eps*C/4;
%f = mu+a*exp(1i*theta);
%W_f = 2*1i*Qinf*(sin(alpha+beta)-sin(alpha-theta)).*exp(-1i*theta);
%W_Y = W_f./(1-C^2./(16*f.^2));
%usymjou = -real(W_Y);
%wsymjou = imag(W_Y);
%Cp = 1-(usymjou.^2+wsymjou.^2)./Qinf^2;
Gamma = 4*pi*a*Qinf*sin(alpha+beta);
L = rho*Qinf*Gamma;