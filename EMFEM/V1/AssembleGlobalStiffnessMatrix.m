function GlobalStiffnessMatrix = AssembleGlobalStiffnessMatrix(...
    TNEdge,nu,RegionElements,Lx,Ly,Lz)
GlobalStiffnessMatrix = zeros(TNEdge,TNEdge);
ElementStiffnessMatrix =  GetBrickEdgeElementStiffnessMatrix(...
    Lx,Ly,Lz,nu);
for el = 1:length(RegionElements(:,1))
    % Get the global edges that correspond to the local element edges
    ElementEdges = RegionElements(el,:);
    
    % Add the contributions from the element to the global stiffness matrix
    % We can do this because the brick element has a constant stiffness
    % matrix.
    
    % Might need to reduce storage and binary operations by using Sparse
    % matrices.
    GlobalStiffnessMatrix(ElementEdges,ElementEdges)=...
        GlobalStiffnessMatrix(ElementEdges,ElementEdges)+...
        ElementStiffnessMatrix;
end
spy(GlobalStiffnessMatrix );