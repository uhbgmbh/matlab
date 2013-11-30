function BrickElementConnectivityTable =...
    GenerateBrickElementConnectivityTable(...
    NNL,NelZ,...
    NNX,NelY)
    
% Version 1 of Development Code (Prefunction)
%{
NelX = 3;
NelY = NelX;
NelZ = NelX;
NNX = NelX+1;
NNY = NNX;
NNZ = NNX;
TNN = NNX*NNY*NNZ;
RelevantTNN = NNX*NNY*NelZ;
NNL = NNX*NNY;
A = 1:1:(NelX+1)*(NelY+1)*(NelZ);
A = A';
%}

% Define all nodes that will be used to create the connectivity table
RelevantTNN = NNL*NelZ;                 
A = 1:1:RelevantTNN;
A = A';
indicesToRemove = NNX:NNX:RelevantTNN;
B = NNX*NelY+1:NNL:RelevantTNN;
indicesToRemove = [indicesToRemove, B, B+1, B+2];
A(indicesToRemove) = [];
%size(A) = number of elements
ECT = [A, A+1];         % First two local nodes (Z1)
ECT = [ECT,ECT+NNX];    % Next two local nodes in the XY plane (Z1) 
Swap1 = ECT(:,3);       % Swap ordering to make it consistent
Swap2 = ECT(:,4);
ECT(:,3) = Swap2;
ECT(:,4) = Swap1;
ECT = [ECT,ECT+NNL];    % Next four local nodes in the next XY plane(Z2)
BrickElementConnectivityTable = ECT;
