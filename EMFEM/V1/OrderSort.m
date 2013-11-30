function  [Ordered,OrderedNodes] = OrderSort(SortRow1,SortRow2,...
    SortedOrderSubset,SortedOrderNodesSubset)

A = [SortedOrderNodesSubset,SortedOrderSubset];
A = sortrows(A,SortRow1);
A12 = sortrows(A(1:2,:),SortRow2);
A34 = sortrows(A(3:4,:),SortRow2);
OrderedNodes(1:2,:) = A12(:,1:6);
Ordered(1:2,:) = A12(:,7);
OrderedNodes(3:4,:) = A34(:,1:6);
Ordered(3:4,:) = A34(:,7);