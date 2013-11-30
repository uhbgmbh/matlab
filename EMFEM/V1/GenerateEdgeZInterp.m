function [Az,t] = GenerateEdgeZInterp(EdgesZ,h)
% This generates the interpolation of the z-axis edge elements.
B = EdgesZ;
r = -1:h:1;
s = r;
t = r;
[R,S] = meshgrid(r,s);
N1Z = 0.25*(1-R).*(1-S);
N2Z = 0.25*(1+R).*(1-S);
N3Z = 0.25*(1-R).*(1+S);
N4Z = 0.25*(1+R).*(1+S);
Bzslice = B(1)*N1Z+B(2)*N2Z+B(3)*N3Z+B(4)*N4Z;
L = length(r);
Az = zeros(L,L,L);
for i = 1:L
    Az(1:L,1:L,i)=Bzslice;
end