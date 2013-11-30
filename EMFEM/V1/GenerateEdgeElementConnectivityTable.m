function ElementEdgeConnectivityTable = ...
    GenerateEdgeElementConnectivityTable(...
    SharedElementEdges,...
    TNEL,NBE)

ElementEdgeConnectivityTable = zeros(TNEL,NBE);

for el = 1:TNEL
    [ElementEdges,~] = find(SharedElementEdges(:,el)==1);
    ElementEdgeConnectivityTable(el,:)=ElementEdges';
end
