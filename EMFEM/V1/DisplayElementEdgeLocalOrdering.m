function DisplayElementEdgeLocalOrdering(...
    CorrectedLocalOrdering,...
    EdgeNodesTable,...
    GlobalNodeNumbering,...
    eln)
Edges = CorrectedLocalOrdering(eln,:);
EdgeNodesXYZ = EdgeNodesTable(Edges,:);
EdgeNodesXYZ = EdgeNodesXYZ';
A = GlobalNodeNumbering(EdgeNodesXYZ(:),:);
A = reshape(A,2,36);
line(A(:,1:12),A(:,13:24),A(:,25:36),'Color','k');
for edge = 1:12
    % Gets XYZ coordinates of nodes associated with the edge
    GlobalEdge = Edges(eln,edge);
    EdgeNodes = EdgeNodesTable(GlobalEdge,:);
    EdgeNodesXYZ = GlobalNodeNumbering(EdgeNodes,:);
    X = EdgeNodesXYZ(:,1);
    Y = EdgeNodesXYZ(:,2);
    Z = EdgeNodesXYZ(:,3);
    text(...
        mean(X),...             % Places text at the average x location
        mean(Y),...             % Places text at the average y location
        mean(Z),...             % Places text at the average z location
        num2str(edge),...
        'EdgeColor',[0 0 0],...
        'FontWeight','bold');
end
xlabel('x');
ylabel('y');
zlabel('z');
title('Order based on Jianming Jin''s Brick Element Local Order');
view([-1 -1 1.2]);