function [Bx,By,Bz,Ax,Ay,Az,r,s,t,R,S,T] = PlotEdgeProcessing(Edges,InterpSpacing)
% This returns the interpolated magnetic vector potential and magnetic flux
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

% Take the curl of the MVP to solve for the magnetic flux
[curlx,curly,curlz,cav] = curl(R,S,T,Ax,Ay,Az);

Bx = curlx; By = curly; Bz = curlz;