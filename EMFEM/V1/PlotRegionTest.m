% Plot Region 1 Test

%[Bx,By,Bz,Ax,Ay,Az,r,s,t,R,S,T] = PlotEdgeElements(Edges,InterpSpacing)
%{
Elements = [5 14 23];
Need:
1) The elements that correspond to the region - CoreElements
2) The edges that correspond to each element in the region -
CorrectedLocalOrdering
3) The nodes that correspond to the edges
4) The interpolation value to interpolate between the x, y, z values
5) For each element
    a) Need to find max x, max y, max z from the nodes
    b) Need to find min x, min y, min z from the nodes
    c) Need to interpolate the edges and solve for MVP and Flux
    d) Use the permeability of the region to calculate the Magnetic Field
    Intensity
    e) Calculate the energy in the element
    f) Plot the interpolation

Return Array Containing Data:
1) R1Ax,R1Ay,R1Az,R1Bx,R1By,R1Bz,R1Hx,R1Hy,R1Hz,R1Energy
R1Ax = zeros(1:NumElements,size(Bx))
R1Ax(1,:,:,:) = The magnetic vector potential in the x direction for
    element 1 in Region 1. All other field variables are exactly the same.
R1Energy(1) = Magnetic field energy in element 1 in region 1

%}
%===============================
% Run Development Program First
%===============================

NumRegionElements = length(Region2Elements(:,1));
InterpDiv = 3;
InterpSpacing = 2/InterpDiv;    % This is divided by two because the 
                                % parametric domain is from -1 to 1
% mu_iron is already given
RegionMu = mu_iron;
Volume = Lx*Ly*Lz;
StorSize = floor(2/InterpSpacing)+1;    % Storage size for all fields
R1Ax = zeros(StorSize,StorSize,StorSize,NumRegionElements);
R1Ay = zeros(StorSize,StorSize,StorSize,NumRegionElements);
R1Az = zeros(StorSize,StorSize,StorSize,NumRegionElements);
R1Bx = zeros(StorSize,StorSize,StorSize,NumRegionElements);
R1By = zeros(StorSize,StorSize,StorSize,NumRegionElements);
R1Bz = zeros(StorSize,StorSize,StorSize,NumRegionElements);
R1Hx = zeros(StorSize,StorSize,StorSize,NumRegionElements);
R1Hy = zeros(StorSize,StorSize,StorSize,NumRegionElements);
R1Hz = zeros(StorSize,StorSize,StorSize,NumRegionElements);
R1Energy = zeros(NumRegionElements,1);

% Solve for all values, then plot all values
for el = 1:NumRegionElements
    Edges = Region2Elements(el,:);
    [Bx,By,Bz,Ax,Ay,Az,~,~,~,~,~,~] = ...
        PlotEdgeProcessing(MVP(Edges),InterpSpacing);
    R1Ax(:,:,:,el) = Ax;
    R1Ay(:,:,:,el) = Ay;
    R1Az(:,:,:,el) = Az;
    R1Bx(:,:,:,el) = Bx;
    R1By(:,:,:,el) = By;
    R1Bz(:,:,:,el) = Bz;
    Hx = RegionMu*Bx;
    Hy = RegionMu*By;
    Hz = RegionMu*Bz;
    R1Hx(:,:,:,el) = Hx;
    R1Hy(:,:,:,el) = Hy;
    R1Hz(:,:,:,el) = Hz;
    R1Energy(el,1) = 1/2*Volume*sum(sum(sum(Bx.*Hx+By.*Hy+Bz.*Hz)));
end

% Plot Magnetic Vector Potential
%{
hold on;
for el = 1:NumRegionElements
    ElementEdgeNodesXYZ = GetElementEdgeNodesXYZ(el,...     
        Region2Elements,...
        EdgeNodesTable,...
        GlobalNodeNumbering);
    MaxCoord = ...
        max([ElementEdgeNodesXYZ(:,1:3);ElementEdgeNodesXYZ(:,4:6)]);
    MinCoord = ...
        min([ElementEdgeNodesXYZ(:,1:3);ElementEdgeNodesXYZ(:,4:6)]);
    LocalXInterp = ...
        MinCoord(1):abs(MaxCoord(1)-MinCoord(1))/InterpDiv:MaxCoord(1);
    LocalYInterp = ...
        MinCoord(2):abs(MaxCoord(2)-MinCoord(2))/InterpDiv:MaxCoord(2);
    LocalZInterp = ...
        MinCoord(3):abs(MaxCoord(3)-MinCoord(3))/InterpDiv:MaxCoord(3);
    [XInterp,YInterp,ZInterp] = ...
        meshgrid(LocalXInterp,LocalYInterp,LocalZInterp);
    quiver3(XInterp,YInterp,ZInterp,...
        R1Ax(:,:,:,el),R1Ay(:,:,:,el),R1Az(:,:,:,el),'b');
end
%}
PlotEdgeField(NumRegionElements,Region2Elements,EdgeNodesTable,...
    GlobalNodeNumbering,InterpDiv,...
    R1Ax,R1Ay,R1Az,...
    'm',...
    'Magnetic Vector Potential',...
    'A');
%{
title('Magnetic Vector Potential');
xlabel('X - Coordinate');
ylabel('Y - Coordinate');
zlabel('Z - Coordinate');
pause;
close;
%}

% Plot Magnetic Flux
%{
hold on;
for el = 1:NumRegionElements
    ElementEdgeNodesXYZ = GetElementEdgeNodesXYZ(el,...     
        Region2Elements,...
        EdgeNodesTable,...
        GlobalNodeNumbering);
    MaxCoord = ...
        max([ElementEdgeNodesXYZ(:,1:3);ElementEdgeNodesXYZ(:,4:6)]);
    MinCoord = ...
        min([ElementEdgeNodesXYZ(:,1:3);ElementEdgeNodesXYZ(:,4:6)]);
    LocalXInterp = ...
        MinCoord(1):abs(MaxCoord(1)-MinCoord(1))/InterpDiv:MaxCoord(1);
    LocalYInterp = ...
        MinCoord(2):abs(MaxCoord(2)-MinCoord(2))/InterpDiv:MaxCoord(2);
    LocalZInterp = ...
        MinCoord(3):abs(MaxCoord(3)-MinCoord(3))/InterpDiv:MaxCoord(3);
    [XInterp,YInterp,ZInterp] = ...
        meshgrid(LocalXInterp,LocalYInterp,LocalZInterp);
    quiver3(XInterp,YInterp,ZInterp,...
        R1Bx(:,:,:,el),R1By(:,:,:,el),R1Bz(:,:,:,el),'b');
end
%}
PlotEdgeField(NumRegionElements,Region2Elements,EdgeNodesTable,...
    GlobalNodeNumbering,InterpDiv,...
    R1Bx,R1By,R1Bz,...
    'm',...
    'Magnetic Flux',...
    'B');
%{
title('Magnetic Flux');
xlabel('X - Coordinate');
ylabel('Y - Coordinate');
zlabel('Z - Coordinate');
pause;
close;
%}
    
% Plot Magnetic Field Intensity
%{
hold on;
for el = 1:NumRegionElements
    ElementEdgeNodesXYZ = GetElementEdgeNodesXYZ(el,...     
        Region2Elements,...
        EdgeNodesTable,...
        GlobalNodeNumbering);
    MaxCoord = ...
        max([ElementEdgeNodesXYZ(:,1:3);ElementEdgeNodesXYZ(:,4:6)]);
    MinCoord = ...
        min([ElementEdgeNodesXYZ(:,1:3);ElementEdgeNodesXYZ(:,4:6)]);
    LocalXInterp = ...
        MinCoord(1):abs(MaxCoord(1)-MinCoord(1))/InterpDiv:MaxCoord(1);
    LocalYInterp = ...
        MinCoord(2):abs(MaxCoord(2)-MinCoord(2))/InterpDiv:MaxCoord(2);
    LocalZInterp = ...
        MinCoord(3):abs(MaxCoord(3)-MinCoord(3))/InterpDiv:MaxCoord(3);
    [XInterp,YInterp,ZInterp] = ...
        meshgrid(LocalXInterp,LocalYInterp,LocalZInterp);
    quiver3(XInterp,YInterp,ZInterp,...
        R1Hx(:,:,:,el),R1Hy(:,:,:,el),R1Hz(:,:,:,el),'b');
end
%}
PlotEdgeField(NumRegionElements,Region2Elements,EdgeNodesTable,...
    GlobalNodeNumbering,InterpDiv,...
    R1Hx,R1Hy,R1Hz,...
    'm',...
    'Magnetic Field Intensity',...
    'H');
%{
title('Magnetic Field Intensity');
xlabel('X - Coordinate');
ylabel('Y - Coordinate');
zlabel('Z - Coordinate');
pause;
close;
%}    