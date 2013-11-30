function [Ay,s] = GenerateEdgeYInterp(EdgesY,h)
% This generates the interpolation of the y-axis edge elements.
B = EdgesY;
r = -1:h:1;
s = r;
t = r;
[R,T] = meshgrid(r,t);
N1Y = 0.25*(1-R).*(1-T);
N2Y = 0.25*(1-R).*(1+T);
N3Y = 0.25*(1+R).*(1-T);
N4Y = 0.25*(1+R).*(1+T);
Byslice = B(1)*N1Y+B(2)*N2Y+B(3)*N3Y+B(4)*N4Y;
L = length(r);
Ay = zeros(L,L,L);
for i = 1:L
    Ay(1:L,1:L,i)=repmat(Byslice(i,1:L),L,1);
end