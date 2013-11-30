function [CorrectedLocalOrdering] = ...
    CorrectLocalOrdering(...
    ElementEdgeConnectivityTable,...
    GlobalNodeNumbering,...
    EdgeNodesTable,...
    TNEL)

CorrectedLocalOrdering = zeros(TNEL,12);

for el = 1:TNEL
    
    % Get the edges for the element, 1 x 8 matrix 
    ElementEdges = ElementEdgeConnectivityTable(el,:);
    
    % Get the global coordinates corresponding to each node
    ElementEdgeNodesXYZ = GetElementEdgeNodesXYZ(...
        el,...     % Element Number
        ElementEdgeConnectivityTable,...
        EdgeNodesTable,...
        GlobalNodeNumbering);
    
    % Initialize the new sorted matrices
    SortedOrder = zeros(12,1);
    SortedOrderNodes = zeros(12,6);

    % Reset the sort/index counters
    SortX = 0;
    SortY = 0;
    SortZ = 0;
    
    % Sort the edges into X, Y, Z groups
    for edge = 1:12
        % Find Z-Axis Edge Elements
        if (ElementEdgeNodesXYZ(edge,3)~=ElementEdgeNodesXYZ(edge,6))&&...
           (ElementEdgeNodesXYZ(edge,2)==ElementEdgeNodesXYZ(edge,5))&&...
           (ElementEdgeNodesXYZ(edge,1)==ElementEdgeNodesXYZ(edge,4))
            SortZ = SortZ + 1;
            SortedOrder(8+SortZ) = ElementEdges(edge);
            SortedOrderNodes(8+SortZ,:) = ElementEdgeNodesXYZ(edge,:);
        % Find Y-Axis Edge Elements    
        elseif ElementEdgeNodesXYZ(edge,2)~=ElementEdgeNodesXYZ(edge,5)
            SortY = SortY + 1;
            SortedOrder(4+SortY) = ElementEdges(edge);
            SortedOrderNodes(4+SortY,:) = ElementEdgeNodesXYZ(edge,:);
         % Remaining must be X-Axis Edge Elements
        else
            SortX = SortX + 1;
            SortedOrder(SortX) = ElementEdges(edge);
            SortedOrderNodes(SortX,:) = ElementEdgeNodesXYZ(edge,:);
        end
    end
    
    % All edges should be sorted into respective XYZ groups
    % Don't forget to reset sorting counters for the next element

    % Initialize the new correctly ordered matrices
    CorrectOrder = zeros(12,1);
    CorrectOrderNodes = zeros(12,6);

    % Sort the edge elements based on Jianming Jin's book ordering, which
    % corresponds to the brick element stiffness matrix

    [CorrectOrder(1:4,:),CorrectOrderNodes(1:4,:)] = OrderSort(3,2,...
        SortedOrder(1:4,1),SortedOrderNodes(1:4,:));
    [CorrectOrder(5:8,:),CorrectOrderNodes(5:8,:)] = OrderSort(1,3,...
        SortedOrder(5:8,1),SortedOrderNodes(5:8,:));
    [CorrectOrder(9:12,:),CorrectOrderNodes(9:12,:)] = OrderSort(2,1,...
        SortedOrder(9:12,1),SortedOrderNodes(9:12,:));
    
    % Return to row vector form and replace existing
    CorrectOrder = CorrectOrder';
    CorrectedLocalOrdering(el,:)=CorrectOrder;
end



    