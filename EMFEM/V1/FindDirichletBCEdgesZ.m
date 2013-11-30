function DirichletBCEdges = FindDirichletBCEdgesZ(...
    EdgeNodesTable,...
    GlobalNodeNumbering,...
    TNEdge,...
    GlobalLx,...
    GlobalLy,...
    GlobalLz)
A = EdgeNodesTable;
A = A'; A = A(:);
A = GlobalNodeNumbering(A,:);
A = reshape(A',6,TNEdge);
A = A';
% These are the magnetic vector potential dirichlet boundary conditions
% applicable to this particular problem.

% Find edges along x = 0 plane
DirichletBCEdgesMinX = find(A(:,1)==0&A(:,4)==0);
% Find edges along x = GlobalLx plane
DirichletBCEdgesMaxX = find(A(:,1)==GlobalLx&A(:,4)==GlobalLx);
% Find edges along y = 0 plane
DirichletBCEdgesMinY = find(A(:,2)==0&A(:,5)==0);
% Find edges along y = GlobalLy plane
DirichletBCEdgesMaxY = find(A(:,2)==GlobalLy&A(:,5)==GlobalLy);
% Find edges along z = 0 plane
DirichletBCEdgesMinZ = find(A(:,3)==0&A(:,6)==0);
% Find edges along z = GlobalLz plane
DirichletBCEdgesMaxZ = find(A(:,3)==GlobalLz&A(:,6)==GlobalLz);
DirichletBCEdges = ...
    [DirichletBCEdgesMinX;...
     DirichletBCEdgesMaxX;...
     DirichletBCEdgesMinY;...
     DirichletBCEdgesMaxY;...
     DirichletBCEdgesMinZ;...
     DirichletBCEdgesMaxZ];
% Remove duplicate edges
for i = 1:length(DirichletBCEdges)-1
    if DirichletBCEdges(i)==DirichletBCEdges(i+1)
        DirichletBCEdges(i)=[];
    end
end

DirichletBCEdges = sort(DirichletBCEdges);