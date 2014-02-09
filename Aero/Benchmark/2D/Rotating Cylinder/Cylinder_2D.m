% Rotating Cylinder Test Script (2D Flow Visualization)
%  - benchmark for panel code validation
% Lawrence Stratton
% 1/29/2014

% Problem Parameters

Gamma = 4;                          % Vortex Strength
R = 1;                              % Cylinder radius
Uinf_o = 1;                         % Freestream velocity
CylStreamFunction = @(r,theta) ...  % StreamFunction
    Uinf_o.*sin(theta).*(r-R^2./r)+Gamma/(2*pi).*log(r);

% Graphing Parameters

hAxis = 3.0;    % Axes scaling
axisMax = R;    % Max axes length
NumVec = 20;    % Number of vectors
hVec = 0.25;    % Vector scaling

% Map x,y region
x = -hAxis*R:0.25:hAxis*R;
y = -hAxis*R:0.25:hAxis*R;
[X,Y] = meshgrid(x,y);

% Convert to polar coordinates
r = sqrt(X.^2+Y.^2);
theta = atan2(Y,X);

% Map theta from [-pi,pi] to [0,2pi]
theta(theta < 0) = theta(theta < 0) + 2*pi; 

% Remove points interior to the cylinder and set interior region to 1
index = r <= 1.0;
r(index) = 1;

% Calculate Velocity Field
qr = Uinf_o*cos(theta).*(1-R^2./r.^2);        % Radial velocity
qtheta = -Uinf_o*sin(theta).*(1+R^2./r.^2)- ...
    Gamma./(2*pi.*r);                       % Tangential velocity
q = sqrt(qr.^2+qtheta.^2);                  % Total velocity

% Freestream Display Vectors
Uinf = Uinf_o*ones(NumVec+1,1)*hVec;
Winf = zeros(NumVec+1,1);
Xinf = (-hAxis*axisMax+0.5)*ones(NumVec+1,1);
Zinf = ((-hAxis*axisMax)*0.5:(hAxis*axisMax)/NumVec:0.5*(hAxis*axisMax))';

% Stagnation Streamline
StagnationTheta = asin(-Gamma/(4*pi*R*Uinf_o));
StagnationPointX = R*cos(StagnationTheta);
StagnationPointZ = R*sin(StagnationTheta);
thetaStag = 0:2*pi/20:2*pi;
rStag = R*ones(size(thetaStag));
xStag = rStag.*cos(thetaStag);
zStag = rStag.*sin(thetaStag);

% Cp Calculation
thetaCpUpper = 0:pi/40:pi;
thetaCpLower = 0:-pi/40:-pi;
qThetaStagUpper = -2*Uinf_o*sin(thetaCpUpper)-Gamma/(2*pi*R);
qThetaStagLower = -2*Uinf_o*sin(thetaCpLower)-Gamma/(2*pi*R);
CpUpper = 1 - (qThetaStagUpper./Uinf_o).^2;
CpLower = 1 - (qThetaStagLower./Uinf_o).^2;


%%
% Plotting

% Plot StreamFunction Contours
C = CylStreamFunction(r,theta);
[csContour,hContour] = contourf(C,20);
colorbar;
clabel(csContour,hContour);
title('Streamlines');

% Plot Velocity Field
figure; hold on;
quiver(X,Y,...
    qr.*cos(theta)+qtheta.*-sin(theta),...
    qr.*sin(theta)+qtheta.*cos(theta),...
    'b');
axis square
axis([-hAxis*axisMax hAxis*axisMax -hAxis*axisMax hAxis*axisMax])
% Plot Freestream Vectors
hinf = quiver(Xinf,Zinf,Uinf,Winf,0,'k');   
% Plot Stagnation points
hstag = plot([StagnationPointX;-StagnationPointX],...
             [StagnationPointZ;StagnationPointZ],...
             'ro','LineWidth',2);
% Plot Stagnation Streamline
hstagstrm = plot(xStag,zStag,'k','LineWidth',1.5);
legend(...
    [hinf hstag hstagstrm],...
    {'Freestream',...
    'Stagnation Points',...
    'Stagnation Streamline'});
title('Rotating Cylinder');

% Plot Cp
figure; hold on;
plot(thetaCpUpper*180/pi,CpUpper,'k');
plot(thetaCpUpper*180/pi,CpLower,'k^');
legend('C_p Upper',...
    'C_p Lower',...
    'Location','EastOutside');
title('C_p at locations along Cylinder Surface, Lift Nonzero');
axis([0 180 min(min(CpUpper,CpLower)) max(max(CpUpper,CpLower))]);

% Plot q/Uinf
figure; hold on;
plot(thetaCpUpper*180/pi,1-CpUpper,'k');
plot(thetaCpUpper*180/pi,1-CpLower,'k^');
legend('q / U_i_n_f Upper',...
    'q / U_i_n_f Lower',...
    'Location','EastOutside');
title('(q / U_i_n_f)^2 at locations along Cylinder Surface');
axis([0 180 min(min(1-CpUpper,1-CpLower)) max(max(1-CpUpper,1-CpLower))]);
