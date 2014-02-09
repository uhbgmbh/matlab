% Symmetric Airfoil Lift Curve Test Script
% Lawrence Stratton
% 1/30/2013
alpha = 0:0.25:3;
Qinf = 0:10:150;
chord = 0.25;
eps = 0.1;
rho = 1.225;
L = zeros(length(alpha),length(Qinf));
Cl = zeros(length(alpha),length(Qinf));
figure; hold on;
for i = 1:length(alpha)
    for j = 1:length(Qinf)
        L(i,j) = SymJouLift(chord,eps,Qinf(j),alpha(i),rho);
        Cl(i,j) = L(i,j)/(0.5*rho*Qinf(j)^2*chord);
    end
    %plot(Qinf,L(i,:),'k');
    %plot(Qinf,Cl(i,:),'b');
end
%text(Qinf(end)*ones(size(L(:,1))),L(:,end),num2str(alpha(:)));
%text(Qinf(end)*ones(size(Cl(:,1))),Cl(:,end),num2str(alpha(:)));
figure;

plot(alpha',Cl(:,2))