% Vortex Panel Test Code
clear all
tic;
load NACA0012.mat;
c = 1;  % chord
Qinf = 1;
alphainf = 0;
%X = [ 2 4 6 4 2]';              % Airfoil coordinates and vortex locations
%Z = [ 0 2 0 -2 0]';
% Airfoil Point Coordinates
X = c*[NACA0012X;NACA0012X([end-1:-1:1])];
Z = c*[NACA0012Y;-NACA0012Y([end-1:-1:1])];
% Collocation points
Xc = (X+X([2:end 1]))/2; Xc(end)=[];        
Zc = (Z+Z([2:end 1]))/2; Zc(end)=[];
dx = diff(X);
dz = diff(Z);
ds = sqrt(dx.*dx+dz.*dz);
theta = atan2(dz,dx);
% Global Coordinate System Origin
xg = 0; yg = 0; zg = 0;         
N = length(X);  % Number of Vortex Strength Unknowns
Np = N-1;       % Number of panels / number of collocation points
a = zeros(N,N);    % Influence Coefficient Matrix
A = zeros(2*Np,1);
RHS = zeros(N,1);
for i = 1:Np
    for j = 1:Np
        gamma0 = 1; gamma1 = 1;     % Vortex strengths used to find aij coefs
        [U,W,Ua,Ub,Wa,Wb,VN1,VN2] = ...
        VOR2DL(gamma0,gamma1,Xc(i),Zc(i),X(j),Z(j),X(j+1),Z(j+1),xg,zg);
        A(2*j-1) = VN1;
        A(2*j) = VN2;
    end
    a(i,1) = A(1); a(i,end) = A(end); A(1) = []; A(end) = [];
    A = reshape(A,N-2,2); A = sum(A,2);
    a(i,2:end-1) = A';
    RHS(i,1) = GetFreeStreamNormalRHS(...
        X(i),Z(i),X(i+1),Z(i+1),Qinf,alphainf);
end
% Kutta Condition
a(end,1) = 1; a(end,end) = 1;
toc;
