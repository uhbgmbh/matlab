function ElementEdgeNodesXYZ = GetElementEdgeNodesXYZ(...
    eln,...     % Element Number
    ElementEdgeConnectivityTable,...
    EdgeNodes,...
    GlobalNodeNumbering)
%{
    Returns the global XYZ coordinates of the edge nodes for all edges in
    an element.
    %}

    % Retrieve the element edges associated with the element
    ElementEdges = ElementEdgeConnectivityTable(eln,:);
    % Retrieve the nodes associated with the edges
    ElementEdgeNodes = EdgeNodes(ElementEdges,:);
    % Take the transpose so that columnwise retrieval will match the nodes
    %   with the right edges
    RetrievalShape = ElementEdgeNodes';
    % Form retrieval column
    RetrievalShape = RetrievalShape(:);
    % Retrieve list of XYZ coordinates of the nodes associated with the
    % edges
    ElementEdgeNodesXYZ = GlobalNodeNumbering(RetrievalShape,:);
    % Reshape the matrix so that the first 3 columns correspond to the
    % first node XYZ coordinates and the last 3 columns correspond to the
    % second node XYZ coordinates.
    ElementEdgeNodesXYZ = reshape(ElementEdgeNodesXYZ',6,12);
    ElementEdgeNodesXYZ = ElementEdgeNodesXYZ';