function [SharedNodes] = GenerateSharedNodesArray(NelX,NelY,NelZ,...
    BrickElementConnectivityTable)
%{
NelX = 3;
NelY = NelX;
NelZ = NelX;
%}
NNX = NelX+1;
NNY = NNX;
NNZ = NNX;
TNN = NNX*NNY*NNZ;
nel = NelX*NelY*NelZ;
SharedNodes = zeros(TNN,nel);
BECT = BrickElementConnectivityTable; %shorter name
for el = 1:nel
    indices = BECT(el,:);
    SharedNodes(el,indices) = 1;
end
    