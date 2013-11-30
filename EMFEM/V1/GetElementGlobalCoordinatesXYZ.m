function ElementNodeXYZ = GetElementGlobalCoordinatesXYZ(...
    eln,...
    BrickElementConnectivityTable,...
    GlobalNodeNumbering...
    )
%{
    Returns the global coordinates of the nodes associated with the
    argument element (eln)
    
    eln - Element Number
%}
A = BrickElementConnectivityTable(eln,:);
ElementNodeXYZ = GlobalNodeNumbering(A,:);


