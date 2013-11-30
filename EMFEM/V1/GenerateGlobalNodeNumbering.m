function GlobalNodeNumbering = GenerateGlobalNodeNumbering(...
    GlobalLx,Lx,...
    GlobalLy,Ly,...
    GlobalLz,Lz,...
    NelZ,NNL)
%{
GlobalLx = 0.12;
GlobalLy = GlobalLx;
GlobalLz = GlobalLx;
NelX = 3;
NelY = NelX;
NelZ = NelX;
NelL = NelX*NelY;   % Number of elements per layer
NNX = NelX+1;
NNY = NNX;
NNZ = NNX;          
NNL = NNX*NNY;      % Number of nodes per layer
Lx = GlobalLx/NelX;
Ly = Lx;
Lz = Lx;
%}
A = 0:Lx:GlobalLx;
B = 0:Ly:GlobalLy;
C = 0:Lz:GlobalLz;
[Y,X] = meshgrid(A,B);
X = X(:); Y = Y(:);
GlobalNodeNumbering = [X,Y];
GlobalNodeNumbering = repmat(GlobalNodeNumbering,NelZ+1,1);
Z = repmat(C,NNL,1);
Z = Z(:);
GlobalNodeNumbering = [GlobalNodeNumbering,Z];
% Visualization
%{
x = GlobalNodeNumbering(:,1);
y = GlobalNodeNumbering(:,2);
z = GlobalNodeNumbering(:,3);
plot3(x,y,z,'.')
%}
