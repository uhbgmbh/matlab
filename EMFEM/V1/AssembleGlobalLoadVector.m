function GlobalLoadVector = AssembleGlobalLoadVector(...
    RegionElements,...
    TNEdge,Lx,Ly,Lz,J)
% Initialize Global Load Vector
GlobalLoadVector = zeros(TNEdge,1);
% Generate current load vector
CurrentLoadVector = GenerateCurrentLoadVector(Lx,Ly,Lz,J);
for el = 1:length(RegionElements(:,1))
    ElementEdges = RegionElements(el,:);
    GlobalLoadVector(ElementEdges,1) = GlobalLoadVector(ElementEdges,1) +...
        CurrentLoadVector;
end
spy(GlobalLoadVector);
