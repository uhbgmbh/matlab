function DirichletBCEdges = FindDirichletBCEdges(...
    EdgeNodesTable,...
    GlobalNodeNumbering,...
    TNEdge,...
    GlobalLx,...
    GlobalLy)
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
DirichletBCEdges = ...
    [DirichletBCEdgesMinX;...
     DirichletBCEdgesMaxX;...
     DirichletBCEdgesMinY;...
     DirichletBCEdgesMaxY];

% Remove duplicate edges
for i = 1:length(DirichletBCEdges)-1
    if DirichletBCEdges(i)==DirichletBCEdges(i+1)
        DirichletBCEdges(i)=[];
    end
end

DirichletBCEdges = sort(DirichletBCEdges);