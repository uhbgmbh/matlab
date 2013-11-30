A = GlobalNodeNumbering;
L = 0.04; U = 0.08;
[I1,~]=find(A(:,1)>=L&A(:,1)<=U);
%GlobalNodeNumbering(I1,:)
%pause;
[I2,~]=find(A(I1,2)>=L&A(I1,2)<=U);
GlobalNodeNumbering(I1(I2),:);
%pause;
[I3,~]=find(A(I2,3)>=L&A(I2,3)<=U);
%indices = I1(I2(I3))

doubler = 1;
h = 2^doubler;
NelX = h*3;
NelL = NelX^2;
Start = NelL/2; % for doubler >=1
Start2 = Start - h;
CenterRow = Start2:-1:(Start2-h+1);
CenterLayer = zeros(h,h);
CenterLayer(1,:)=CenterRow;
for i = 1:1:h/2
    CenterLayer(i+1,:)=CenterRow + i*NelX;
end
for j = 1:1:h/2-1;
    CenterLayer(end-(j-1),:)=CenterRow-j*NelX;
end
CenterLayer;
TotalCore = zeros(h,h,NelX);
TotalCore(:,:,1) = CenterLayer;
for k = 2:NelX
    TotalCore(:,:,k)= CenterLayer+(k-1)*NelL;
end
TotalCore
TotalCore(:)
