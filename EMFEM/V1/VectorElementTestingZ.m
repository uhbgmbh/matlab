% VectorElementTestingZ
% This plots the interpolation of the y-axis edge elements.
B = [1 20 5 1];
r = -1:0.5:1;
s = r;
[R,S] = meshgrid(r,s);
N1Z = 0.25*(1-R).*(1-S);
N2Z = 0.25*(1+R).*(1-S);
N3Z = 0.25*(1-R).*(1+S);
N4Z = 0.25*(1+R).*(1+S);
Bzslice = B(1)*N1Z+B(2)*N2Z+B(3)*N3Z+B(4)*N4Z;
L = length(r);
Bz = zeros(L,L,L);
for i = 1:L
    Bz(1:L,1:L,i)=Bzslice;
end
[R,S,T] = meshgrid(r,r,r);
quiver3(R,S,T,zeros(size(Bz)),zeros(size(Bz)),Bz);
xlabel('X - Coordinate');
ylabel('Y - Coordinate');
zlabel('Z - Coordinate');
