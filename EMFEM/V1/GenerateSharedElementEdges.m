function [SharedElementEdges,EdgeNodesTable] = GenerateSharedElementEdges(...
    BrickElementConnectivityTable,...
    TNEL,TNEdge,NBE)
NEdge = TNEL*NBE; % 12 edges per brick element
% Create Edge Element Connectivity Table

% Step 1: Create Indicator Matrix
EdgeIndicatorMatrix = GenerateEdgeIndicatorMatrix(...
    BrickElementConnectivityTable,...
    TNEL);

% Step 2: Create Edge Element Connectivity
SharedElementEdges = zeros(TNEdge,TNEL);
EdgeNodesTable = zeros(TNEdge,2); % 2 nodes per edge
% Initialize First Edge and Assign first Node pair
SharedElementEdges(1,EdgeIndicatorMatrix(1,4))=1;
CurrentEdge = 1;
EdgeNodesTable(1,:)=EdgeIndicatorMatrix(1,2:3);
for edge = 2:NEdge
    % Check to see if the current indicator is equal to the previous
    if EdgeIndicatorMatrix(edge,1)==EdgeIndicatorMatrix(edge-1,1)
        % if equal add the edge to the list of shared edges for the current
        % edge
        SharedElementEdges(CurrentEdge,EdgeIndicatorMatrix(edge,4))=1;
    else
        % if not equal, increment the CurrentEdge and start assigning
        %   it to the next edge
        CurrentEdge = CurrentEdge + 1;
        SharedElementEdges(CurrentEdge,EdgeIndicatorMatrix(edge,4))=1;
        EdgeNodesTable(CurrentEdge,:) = EdgeIndicatorMatrix(edge,2:3);
    end
end
%spy(SharedElementEdges);