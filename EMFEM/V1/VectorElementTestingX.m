% VectorElementTestingX
% This plots the interpolation of the x-axis edge elements.
B = [1 5 20 1];
s = -1:0.5:1;
t = s;
[S,T] = meshgrid(s,t);
N1X = 0.25*(1-S).*(1-T);
N2X = 0.25*(1+S).*(1-T);
N3X = 0.25*(1-S).*(1+T);
N4X = 0.25*(1+S).*(1+T);
Bxslice = B(1)*N1X+B(2)*N2X+B(3)*N3X+B(4)*N4X;
L = length(s);
Bx = zeros(L,L,L);
for i = 1:L
    Bx(i,1:L,1:L)=repmat(Bxslice(1:L,i)',L,1);
end
[R,S,T] = meshgrid(s,s,s);
quiver3(R,S,T,Bx,zeros(size(Bx)),zeros(size(Bx)));
xlabel('X - Coordinate');
ylabel('Y - Coordinate');
zlabel('Z - Coordinate');