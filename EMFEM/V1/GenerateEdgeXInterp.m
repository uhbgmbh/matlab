function [Ax,r] = GenerateEdgeXInterp(EdgesX,h)
% This generates the interpolation of the x-axis edge elements using the
% basic bilinear shape functions evaluated in the parametric space.
B = EdgesX;
s = -1:h:1;
r = s;
t = s;
[S,T] = meshgrid(s,t);
N1X = 0.25*(1-S).*(1-T);
N2X = 0.25*(1+S).*(1-T);
N3X = 0.25*(1-S).*(1+T);
N4X = 0.25*(1+S).*(1+T);
Bxslice = B(1)*N1X+B(2)*N2X+B(3)*N3X+B(4)*N4X;
L = length(s);
Ax = zeros(L,L,L);
for i = 1:L
    % rearranges for correct visualization
    Ax(i,1:L,1:L)=repmat(Bxslice(1:L,i)',L,1);  
end