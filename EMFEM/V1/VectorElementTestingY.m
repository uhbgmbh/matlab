% VectorElementTestingY
% This plots the interpolation of the y-axis edge elements.
B = [1 20 5 1];
r = -1:0.5:1;
t = r;
[R,T] = meshgrid(r,t);
N1Y = 0.25*(1-R).*(1-T);
N2Y = 0.25*(1-R).*(1+T);
N3Y = 0.25*(1+R).*(1-T);
N4Y = 0.25*(1+R).*(1+T);
Byslice = B(1)*N1Y+B(2)*N2Y+B(3)*N3Y+B(4)*N4Y;
L = length(r);
By = zeros(L,L,L);
for i = 1:L
    By(1:L,1:L,i)=repmat(Byslice(i,1:L),L,1);
end
[R,S,T] = meshgrid(r,r,r);
quiver3(R,S,T,zeros(size(By)),By,zeros(size(By)));
xlabel('X - Coordinate');
ylabel('Y - Coordinate');
zlabel('Z - Coordinate');