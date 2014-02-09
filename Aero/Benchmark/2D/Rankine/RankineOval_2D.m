% Rankine Oval Test Script (2D Flow Visualization)
%  - benchmark for panel code validation
% Lawrence Stratton
% 1/28/2014
Source = [-5,0];                        % Source location (x,z)    
Sink = Source; Sink(1) = -1*Sink(1);    % Symmetric sink location (-x,z)
Sigma = 5;                              % Source Strength
x_o = Sink(1);                          % foci distance

hVec = 1.0;                 % Vector length scaling
hAxis = 3.0;                % Axes scaling
axisMax = max(max(Sink));   % Max axes length
NumVec = 20;                % Number of display vectors

% Source Display Vectors
Usrc = (cos(0:2*pi/NumVec:2*pi))';
Wsrc = (sin(0:2*pi/NumVec:2*pi))';
Xsrc = ones(size(Usrc)).*Source(1);
Zsrc = ones(size(Wsrc)).*Source(2);

% Sink Display Vectors
Usnk = -(cos(0:2*pi/NumVec:2*pi))'*hVec;
Wsnk = -(sin(0:2*pi/NumVec:2*pi))'*hVec;
Xsnk = ones(size(Usnk)).*Sink(1)+hVec.*(cos(0:2*pi/NumVec:2*pi))';
Zsnk = ones(size(Wsnk)).*Sink(2)+hVec.*(sin(0:2*pi/NumVec:2*pi))';

% Freestream Display Vectors
Uinf = ones(NumVec+1,1)*hVec;
Winf = zeros(NumVec+1,1);
Xinf = (-hAxis*axisMax+1)*ones(NumVec+1,1);
Zinf = ((-hAxis*axisMax)*0.5:(hAxis*axisMax)/NumVec:0.5*(hAxis*axisMax))';

% Evaluation Point
xLoc1 = 0.75; zLoc1 = 1.0;
dx1 = xLoc1 - Source(1); dz1 = zLoc1 - Source(2); 
dx2 = xLoc1 - Sink(1); dz2 = zLoc1 - Sink(2); 

% Streamline Calcs
[xRange,zRange] = meshgrid(...
    (-hAxis*axisMax:0.5:hAxis*axisMax)',...
    (-hAxis*axisMax:0.5:hAxis*axisMax)');
Contours = RankineStreamFunc(xRange,zRange,Uinf(1),Sigma,x_o);

% Velocity Calcs
[Uf,Wf,~,~] = RankineVel(xRange,zRange,Uinf(1),Sigma,x_o);

% Stagnation Streamline
StagnationPoint = sqrt(Sigma*x_o/(pi*Uinf(1))+x_o^2);
xStag = [(-hAxis*axisMax:0.1:-StagnationPoint)';...
        (-StagnationPoint:0.1:StagnationPoint)';...
        (StagnationPoint:0.1:hAxis*axisMax)'];
zStagUpper = zeros(size(xStag));
zStagLower = zeros(size(xStag));
for i = 1:length(xStag)
    zStagUpper(i)...
        = fzero(@(z) RankineStreamFunc(xStag(i),z,Uinf(1),Sigma,x_o),3);
    zStagLower(i)...
        = fzero(@(z) RankineStreamFunc(xStag(i),z,Uinf(1),Sigma,x_o),-3);
end

% Cp calcs along the upper and lower stagnation streamlines
[~,~,~,CpUpper] = RankineVel(xStag,zStagUpper,Uinf(1),Sigma,x_o);
[~,~,~,CpLower] = RankineVel(xStag,zStagLower,Uinf(1),Sigma,x_o);

%%
% Plotting
hold on;
hsrc = quiver(Xsrc,Zsrc,hVec*Usrc,hVec*Wsrc,0,'b');    % Source Vectors
hsnk = quiver(Xsnk,Zsnk,Usnk,Wsnk,'r');                % Sink Vectors
hinf = quiver(Xinf,Zinf,Uinf,Winf,0,'k');              % Freestream Vectors
%hrsrc = quiver(Source(1),Source(2),dx1,dz1,0,'m');  % Radius 1
%hrsnk = quiver(Sink(1),Sink(2),dx2,dz2,0,'g');      % Radius 2
plot(Source(1),Source(2),'bo');                 % Source Location
plot(Sink(1),Sink(2),'ro');                     % Sink Location
quiver(xRange,zRange,Uf,Wf,'c');                % Velocity vector field
% Stagnation points
hstag = plot([-StagnationPoint; StagnationPoint],[0;0],'g^','LineWidth',2);
% Stagnation Streamline
hstagstrm = plot(xStag,zStagUpper,'k','LineWidth',1.5);
plot(xStag,zStagLower,'k','LineWidth',1.5);

axis square;
axis([-hAxis*axisMax hAxis*axisMax -hAxis*axisMax hAxis*axisMax]);
title('Rankine Oval');
legend(...
    [hsrc hsnk hinf hstag hstagstrm],... %hrsrc hrsnk],...
    {'Point Source','Point Sink','Freestream',...
    'Stagnation Points','Stagnation Streamline'},...
    'Location','EastOutside');%'Radius1','Radius2'});

NewFig1 = figure;
[csContour,hContour] = contourf(Contours,20);    % Plot Streamlines
colorbar;
clabel(csContour,hContour);
title('Streamlines');

NewFig2 = figure; 
plot(xStag,CpUpper,'k-.');
hold on;
plot(xStag,CpLower,'k^');
legend('Cp Upper',...
    'Cp Lower',...
    'Location','EastOutside');

NewFig3 = figure; 
plot(xStag,1-CpUpper,'k-.');
hold on;
plot(xStag,1-CpLower,'k^');
legend('q / U_i_n_f Upper',...
    'q / U_i_n_f Lower',...
    'Location','EastOutside');


%%
clear