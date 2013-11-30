%function PlotEdgeElementsTest(Edges,InterpSpacing)
Edges = [1 5 20 1 1 20 5 1 1 20 5 1];
EdgesX = Edges(1:4);
EdgesY = Edges(5:8);
EdgesZ = Edges(9:12);
h = 0.25;
[Ax,r] = GenerateEdgeXInterp(EdgesX,h);
[Ay,s] = GenerateEdgeYInterp(EdgesY,h);
[Az,t] = GenerateEdgeZInterp(EdgesZ,h);
[R,S,T] = meshgrid(r,s,t);
quiver3(R,S,T,Ax,Ay,Az);
xlabel('X - Coordinate');
ylabel('Y - Coordinate');
zlabel('Z - Coordinate');