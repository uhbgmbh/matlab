function CurrentLoadVector = GenerateCurrentLoadVector(Lx,Ly,Lz,J)
CurrentLoadVector = zeros(12,1);
CurrentLoadVector(9:12,1)=ones(4,1);
CurrentLoadVector = CurrentLoadVector*Lx*Ly*Lz*J/4;