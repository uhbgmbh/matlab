function PlotMagneticVectorPotential(X,Y,Z,Ax,Ay,Az)
quiver3(X,Y,Z,Ax,Ay,Az);
title('Magnetic Vector Potential');
xlabel('X - Coordinate');
ylabel('Y - Coordinate');
zlabel('Z - Coordinate');