function EdgeIndicatorMatrix = GenerateEdgeIndicatorMatrix(...
    BrickElementConnectivityTable,...
    TNEL)
BECT = BrickElementConnectivityTable;
NBE = 12;       % Number of brick edges
NEdge = TNEL*NBE; % 12 edges per brick element
EdgeIndicatorMatrix = zeros(NEdge,3);

% Create pattern for each brick element with respect to the local nodes
BrickEdges = [1 2;4 3;5 6;8 7;...   % X Edges
              1 4;2 3;5 8;6 7;...   % Y Edges
              1 5;2 6;3 7;4 8];     % Z Edges      
          
EdgeElementIndexer = 1:NBE;          % Used to easily increment index

A = zeros(12,2); % matrix predefined to save time

for el = 1:TNEL
    % Get element connectivity
    ElementConnectivity = BECT(el,:);    
    %Increment by 12 edges
    CurrentIndex = EdgeElementIndexer+(el-1)*NBE;   
    % Create the right shape 
    A = ElementConnectivity(BrickEdges);
    % Sort the nodes to ascending order
    A = sort(A,2,'ascend');     
    % Calculate the indicator values for each edge
    EdgeIndicatorMatrix(CurrentIndex,1)=...
        A(:,1).*log(A(:,2))+A(:,2).*log(A(:,1));
    % Assign Nodes
    EdgeIndicatorMatrix(CurrentIndex,2:3) = A;
    % Assign Element Label
    EdgeIndicatorMatrix(CurrentIndex,4) = el;
end

EdgeIndicatorMatrix = sortrows(EdgeIndicatorMatrix,1);