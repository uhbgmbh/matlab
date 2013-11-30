function [Bx,By,Bz,Ax,Ay,Az,r,s,t,R,S,T] = PlotEdgeElements(Edges,InterpSpacing)
% This plots the interpolated magnetic vector potential and magnetic flux
% density for a given element.

% Obtain coordinate edges
EdgesX = Edges(1:4);        % X edges
EdgesY = Edges(5:8);        % Y edges
EdgesZ = Edges(9:12);       % Z edges

% Rename interpolation spacing for cleaner code
h = InterpSpacing;

[Ax,r] = GenerateEdgeXInterp(EdgesX,h);     % Interpolate X Edges
[Ay,s] = GenerateEdgeYInterp(EdgesY,h);     % Interpolate Y Edges
[Az,t] = GenerateEdgeZInterp(EdgesZ,h);     % Interpolate Z Edges

% Create grid
[R,S,T] = meshgrid(r,s,t);

% Plot Magnetic Vector Potential 
quiver3(R,S,T,Ax,Ay,Az);
title('Magnetic Vector Potential');
xlabel('X - Coordinate');
ylabel('Y - Coordinate');
zlabel('Z - Coordinate');
pause;
close;

% Take the curl of the MVP to solve for the magnetic flux
[curlx,curly,curlz,cav] = curl(R,S,T,Ax,Ay,Az);

% Plot Magnetic Flux
quiver3(R,S,T,curlx,curly,curlz);
title('Magnetic Flux Density');
xlabel('X - Coordinate');
ylabel('Y - Coordinate');
zlabel('Z - Coordinate');
Bx = curlx; By = curly; Bz = curlz;