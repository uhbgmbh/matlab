function [MoreX,MoreZ,N] = AddPoints(X,Z,NumPoints)
F = zeros(length(X)-1,NumPoints+2);
for i = 1:length(X)-1
    F(i,:)=X(i):(X(i+1)-X(i))/(NumPoints+1):X(i+1);
end
MoreX = zeros(length(X)+NumPoints*(length(X)-1),1);
MoreX(1) = F(1);
F(:,1) = [];
F = F';
MoreX(2:end,1) = F(:);
MoreZ = interp1(X,Z,MoreX,'spline');
N = length(MoreX);