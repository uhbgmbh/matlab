% SplitEdgesIntoXYZEdges
TNXEdge = NelX*NNY*NNZ;
TNYEdge = NelY*NNX*NNZ;
TNZEdge = NelZ*NNX*NNY;
EdgesX = zeros(TNXEdge,1);
EdgesY = zeros(TNYEdge,1);
EdgesZ = zeros(TNZEdge,1);
AnchorXEdges = zeros(TNXEdge,1);
AnchorYEdges = zeros(TNYEdge,1);
AnchorZEdges = zeros(TNZEdge,1);
XCounter = 0;
YCounter = 0;
ZCounter = 0;
for edge = 1:TNEdge
    if ((EdgeNodesTable(edge,1)+1)==EdgeNodesTable(edge,2))
        XCounter = XCounter + 1;
        EdgesX(XCounter,1)=edge;
        AnchorCheck = ...
            min(GlobalNodeNumbering(EdgeNodesTable(edge,:),:));
        AnchorXEdges(XCounter,1) = AnchorCheck(1);
    elseif ((EdgeNodesTable(edge,1)+NNL)==EdgeNodesTable(edge,2))
        ZCounter = ZCounter + 1;
        EdgesZ(ZCounter,1)=edge;
        AnchorCheck = ...
            min(GlobalNodeNumbering(EdgeNodesTable(edge,:),:));
        AnchorZEdges(ZCounter,1) = AnchorCheck(3);
    else
        YCounter = YCounter + 1;
        EdgesY(YCounter,1)=edge;
        AnchorCheck = ...
            min(GlobalNodeNumbering(EdgeNodesTable(edge,:),:));
        AnchorYEdges(YCounter,1) = AnchorCheck(2);
    end
end

% How to plot the anchors and vectors correctly for coneplot???


        
        