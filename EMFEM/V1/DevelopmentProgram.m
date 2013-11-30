% Magnetostatics Development Program

% Problem Physics
mu_FreeSpace = 1.2566e-6;       % Permeability of Free Space
mu_iron = 5.0e-3;               % Permeability of Iron    
mur_FreeSpace = 1;              % Relative Permeability of Free Space
mur_iron = mu_iron/mu_FreeSpace;% Relative Permeability of Iron
nu_FreeSpace = 1/mu_FreeSpace;  % Reluctivity of Free Space
nu_iron = 1/mu_iron;            % Reluctivity of Iron
J = 10e7;                       % Current density, A/m^2

% Problem Geometry
GlobalLx = 0.12;        % Length of x-domain, meters
GlobalLy = 0.12;        % Length of y-domain, meters
GlobalLz = 0.12;        % Length of z-domain, meters
CoreLB = 0.04;          % Core Region Lower Bound
CoreUB = 0.08;          % Core Region Upper Bound

% Problem Mesh
MeshDensityDoubler = 0; %
MeshScaler = 2^MeshDensityDoubler;
                        % must increase by doubling to match the mesh
                        % ie: 3,6,12,24,48,96,192,384
                        % ie: 1,2,4,8,16,32 for meshscaler, change the
                        % exponent by 1, ie: 0, 1, 2, 3
                        
NelX = 3*MeshScaler;    % Number of Elements in the X direction
NelY = 3*MeshScaler;    % Number of Elements in the Y direction
NelZ = 3*MeshScaler;    % Number of Elements in the Z direction
NelL = NelX*NelY;       % Number of elements per XY-layer
TNEL = NelX*NelY*NelZ;  % Total number of elements
NNX = NelX+1;           % Number of nodes in the X direction  
NNY = NNX;              % Number of nodes in the Y direction
NNZ = NNX;              % Number of nodes in the Z direction    
NNL = NNX*NNY;          % Number of nodes per XY-layer
TNN = NNX*NNY*NNZ;      % Total number of nodes

% Edge Elements
NBE = 12; % Number of brick edges
% Total number of unique edges
TNEdge = 12 + 8*(NelX-1)*2+5*(NelX-1).^2 +...
    (NelZ-1)*(8+ 5*(NelX-1)*2+3*(NelX-1).^2);    

% Element Dimensions
Lx = GlobalLx/NelX;     % X length of an element
Ly = GlobalLy/NelY;     % Y length of an element
Lz = GlobalLz/NelZ;     % Z length of an element

% Generate Global Node Numbering (GNN)
disp('Generating Global Node Numbering (GNN)');
tic;
GlobalNodeNumbering = GenerateGlobalNodeNumbering(...
    GlobalLx,Lx,...
    GlobalLy,Ly,...
    GlobalLz,Lz,...
    NelZ,NNL);
toc;

% Display Nodes 
%(**AVOID WHEN MeshDensityDoubler >=1**)
%{
disp('Displaying Nodes');
tic;
DisplayNodes(GlobalNodeNumbering);
toc;
pause;
close;
%}

% Generate Brick Connectivity Table
disp('Generating Brick Element Connectivity Table');
tic;
BrickElementConnectivityTable =...
    GenerateBrickElementConnectivityTable(...
    NNL,NelZ,...
    NNX,NelY);
toc;

% Display elements to check numbering 
% (**AVOID WHEN MeshDensityDoubler >=1**)
%{
disp('Displaying Elements');
tic;
DisplayElements(...
    BrickElementConnectivityTable,...
    GlobalNodeNumbering,...
    TNEL);
toc;
pause;
close;
%}

% Generates a listing of edges shared by each element
% 1)Rows correspond to edges
% 2)Columns correspond to elements
% 3)When the edge is shared, a 1 is inserted in the corresponding array
disp('Generating Shared Element Edges and EdgeNodesTable');
tic;
[SharedElementEdges,EdgeNodesTable] = GenerateSharedElementEdges(...
    BrickElementConnectivityTable,...
    TNEL,TNEdge,NBE);
toc;
% sum(SharedElementEdges,1) % Should show 12 for each element
% sum(SharedElementEdges,2) % Should show max of 4, this shows how many
% elements share the particular edge

% Generates the global edge numbers corresponding to the element.  Edges 
% are not ordered in the correct local numbering that matches the brick 
% stiffness matrix.  The following method corrects the ordering.
disp('Generating Element Edge Connectivity Table');
tic;
ElementEdgeConnectivityTable = GenerateEdgeElementConnectivityTable(...
    SharedElementEdges,...
    TNEL,NBE);
toc;

% Correctly reorder local edges in accordance with Jianming Jin's book to
% match the brick stiffness matrix
disp('Reordering Local Edges Into Correct Correspondence');
tic;
[CorrectedLocalOrdering] = CorrectLocalOrdering(...
    ElementEdgeConnectivityTable,...
    GlobalNodeNumbering,...
    EdgeNodesTable,...
    TNEL);
toc;

% Check Edge Element Local Ordering
disp('Displaying Local Edge Ordering');
tic;
DisplayElementEdgeLocalOrdering(...
    CorrectedLocalOrdering,...
    EdgeNodesTable,...
    GlobalNodeNumbering,...
    1);
toc;
pause;
close;

% Find Core Region Elements
disp('Finding Core Region Elements');
tic;
[CoreElements] = FindCoreRegionElements(...
    MeshDensityDoubler,...
    MeshScaler,...
    NelX,...
    NelL);
toc;

% Test Brick Edge Elements - iron and free space
%{
ElementStiffnessMatrix =  GetBrickEdgeElementStiffnessMatrix(...
    Lx,Ly,Lz,nu_iron)
ElementStiffnessMatrix =  GetBrickEdgeElementStiffnessMatrix(...
    Lx,Ly,Lz,nu_FreeSpace)
%}

% Separate Elements into Iron Core and Free Space Regions
% Region 1 - Iron Core:
Region1Elements = CorrectedLocalOrdering(CoreElements,:);

% Region 2 - Free Space:
Region2Elements = CorrectedLocalOrdering;
% Removes the elements that correspond to the iron core
Region2Elements(CoreElements,:)=[]; 
% Create index for reassembly
Region2ElementsIndex = 1:TNEL;
Region2ElementsIndex(CoreElements)=[];

% Assemble Global Stiffness Matrix
disp('Assembling Global Stiffness Matrices');

% Steps:
% 1) GetRegion1Elements
% 2) Assemble Region 1 Elements
% 3) GetRegion2Elements
% 4) Assemble Region 2 Elements
% 5) Transform to sparse matrices
% 6) Combine sparse matrices

tic;
GlobalStiffnessMatrixRegion1 = AssembleGlobalStiffnessMatrix(...
    TNEdge,...
    nu_FreeSpace,...
    Region1Elements,...
    Lx,Ly,Lz);
toc;
pause;
close;
tic;
GlobalStiffnessMatrixRegion2 = AssembleGlobalStiffnessMatrix(...
    TNEdge,...
    nu_iron,...
    Region2Elements,...
    Lx,Ly,Lz);
toc;
pause;
close;

% Convert to Global Stiffness Matrices to Sparse matrices then add
SparseGSMR1 = sparse(GlobalStiffnessMatrixRegion1);
SparseGSMR2 = sparse(GlobalStiffnessMatrixRegion2);
tic;
SparseGSM = SparseGSMR1+SparseGSMR2;
toc;

% Assemble Global Load Vector
disp('Assembling Global Load Vector');
tic;
GlobalLoadVector = AssembleGlobalLoadVector(...
    Region1Elements,...
    TNEdge,Lx,Ly,Lz,J);
toc;
pause;
close;

% Convert Global Load Vector to a Sparse matrix
tic;
SparseGLV = sparse(GlobalLoadVector);
toc;

% Find Dirichlet BC Edges
disp('Finding Dirichlet BC Edges');
tic;
DirichletBCEdges = FindDirichletBCEdges(...
    EdgeNodesTable,...
    GlobalNodeNumbering,...
    TNEdge,...
    GlobalLx,...
    GlobalLy);
toc;


% Partition Sparse Global Stiffness Matrix
disp('Partitioning');
RemainingIndex=[1:TNEdge]';
RemainingIndex(DirichletBCEdges)=[];
tic;
PartitionedK = SparseGSM;
PartitionedK(DirichletBCEdges,:)=[];
PartitionedK(:,DirichletBCEdges)=[];
toc;

% Partition Sparse Global Load Vector
tic;
PartitionedF = SparseGLV;
PartitionedF(DirichletBCEdges)=[];
toc;

% Solve System
disp('Solving System');
tic;
SolvedMVP = PartitionedK\PartitionedF;  % MVP = Magnetic Vector Potential
toc;

% Reassemble full MVP vector
tic;
MVP = zeros(TNEdge,1);
SolvedMVP = full(SolvedMVP);    % Convert from Sparse to Full matrix
MVP(RemainingIndex) = SolvedMVP;
toc;

%{
Remaining Parts
8)Post-Processing
- Compute MVP
- Compute Flux
- Compute Magnetic Field Intensity
- Compute Magnetic Field Energy
%}