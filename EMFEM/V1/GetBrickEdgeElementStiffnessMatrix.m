function ElementStiffnessMatrix =  GetBrickEdgeElementStiffnessMatrix(...
    Lx,Ly,Lz,nu)
%{
    Assumes isotropic material constants
%}

K1 = [2 -2 1 -1;...
      -2 2 -1 1;...
      1 -1 2 -2;...
      -1 1 -2 2];

K2 = [2 1 -2 -1;...
      1 2 -1 -1;...
      -2 -1 2 1;...
      -1 -2 1 2];
  
K3 = [2 1 -2 -1;...
      -2 -1 2 1;...
      1 2 -1 -2;...
      -1 -2 1 2];

Exx = Lx*Lz/6/Ly*K1 + Lx*Ly/6/Lz*K2;
Eyy = Lx*Ly/6/Lz*K1 + Ly*Lz/6/Lx*K2;
Ezz = Ly*Lz/6/Lx*K1 + Lx*Lz/6/Ly*K2;
Exy = -Lz/6*K3;
Ezx = -Ly/6*K3;
Eyz = -Lx/6*K3;
Eyx = Exy';
Exz = Ezx';
Ezy = Eyz';

ElementStiffnessMatrix = nu*[Exx Exy Exz; Eyx Eyy Eyz; Ezx Ezy Ezz];

      
