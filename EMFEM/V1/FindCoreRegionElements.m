function [CoreElements] = FindCoreRegionElements(...
    MeshDensityDoubler,...
    MeshScaler,...
    NelX,...
    NelL)
%{
  This program finds the internal core region elements for this particular
  problem domain.
%}
    % Old Nodal Global XYZ Coordinates Algorithm 
    %{
    
        A = GlobalNodeMatrix;
        L = LowerBound; U = UpperBound;
        [I1,~]=find(A(:,1)>=L&A(:,1)<=U);
        [I2,~]=find(A(I1,2)>=L&A(I1,2)<=U);
        [I3,~]=find(A(I2,3)>=L&A(I2,3)<=U);
        indices = I1(I2(I3));
    %}
    
    % Direct Element-Based Algorithm - Problem Specific (not really
    % general)
    
    doubler = MeshDensityDoubler;
    h = MeshScaler;
    if MeshDensityDoubler == 0
        CoreElements = [5,14,23];
    else % For doubler >= 1      
        Start = NelL/2; % Find Element at top right half of domain
        Start2 = Start - h; % Track to the first core region element 
                            %    encountered from the right
        % Find the first core region row of elements
        CenterRow = Start2:-1:(Start2-h+1); 
        % Initialize XY slice of core region to contain all XY layer
        % elements
        CenterLayer = zeros(h,h);
        
        % Add first row of core region elements to the XY slice
        CenterLayer(1,:)=CenterRow;
        
        % add rows above the first row
        for i = 1:1:h/2
            CenterLayer(i+1,:)=CenterRow + i*NelX;
        end
        
        % add rows below the first row
        for j = 1:1:h/2-1;
            CenterLayer(end-(j-1),:)=CenterRow-j*NelX;
        end
        
        % add up all XY layer slices of elements across the Z axis
        TotalCore = zeros(h,h,NelX);
        TotalCore(:,:,1) = CenterLayer;
        for k = 2:NelX
            TotalCore(:,:,k)= CenterLayer+(k-1)*NelL;
        end
        CoreElements = TotalCore(:);
    end

end